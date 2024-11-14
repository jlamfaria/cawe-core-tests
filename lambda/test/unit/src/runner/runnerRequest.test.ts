import * as sqs from '../../../../src/lib/aws/sqs';
import * as logger from '../../../../src/lib/logger';
import * as utils from '../../../../src/lib/utils';
import { RunnerRequest, generateRunnerRequest, requeueRunnerRequestToSQS } from '../../../../src/runner/runnerRequest';
import { WorkflowEvent } from '../../../../src/lib/github';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../../src/lib/utils');
jest.mock('../../../../src/lib/logger');
jest.mock('../../../../src/lib/aws/sqs');

const utilsMock = utils as jest.Mocked<typeof utils>;
const loggerMock = logger as jest.Mocked<typeof logger>;
const sqsMock = sqs as jest.Mocked<typeof sqs>;

describe('runnerRequest', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('generateRunnerRequest', () => {
        it('should throw an error if action is not queued', () => {
            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                action: 'other',
                installation: {
                    id: 1,
                },
            };

            try {
                generateRunnerRequest(workflowJobEvent, githubHost, isEnterprise);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error("Event action is not 'queued'"));
            }
        });

        it('should throw an error if installation id is not defined', () => {
            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                action: 'queued',
            };
            const isMacOS = false;

            try {
                generateRunnerRequest(workflowJobEvent, githubHost, isEnterprise);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('InstallationId not present'));
            }
        });

        it('should return runnerRequest with a ttl', () => {
            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                workflow_job: {
                    name: 'wf_name',
                    id: 123,
                    labels: ['a', 'b'],
                    started_at: new Date(),
                },
                repository: {
                    name: 'repo_name',
                    owner: {
                        login: 'login',
                    },
                },
                action: 'queued',
                installation: {
                    id: 1,
                },
            };

            const ttl = new Date(0);

            utilsMock.getTTL.mockReturnValue(ttl);

            const expectedrunnerRequest: RunnerRequest = {
                id: workflowJobEvent.workflow_job.id,
                action: workflowJobEvent.action,
                repositoryName: workflowJobEvent.repository.name,
                repositoryOwner: workflowJobEvent.repository.owner.login,
                workflowName: workflowJobEvent.workflow_job.name,
                workflowLabels: workflowJobEvent.workflow_job.labels,
                startedAt: workflowJobEvent.workflow_job.started_at,
                installationId: workflowJobEvent.installation.id,
                eventType: WorkflowEvent.WORKFLOW_JOB,
                githubHost,
                isEnterprise,
                ttl,
            };

            const res = generateRunnerRequest(workflowJobEvent, githubHost, isEnterprise);

            expect(res).toEqual(expectedrunnerRequest);
        });
    });

    describe('requeueRunnerRequestToSQS', () => {
        it('should log and resolve undefined if all attemps were exausted', async () => {
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(0),
            };

            const record: any = {};

            const result = await requeueRunnerRequestToSQS(runnerRequest, record);

            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                `TTL has expired. Request will be dropped. RunnerRequest: ${JSON.stringify(runnerRequest)}`,
            );
            expect(loggerMock.logger.warn).not.toHaveBeenCalledWith('Sending event back to the queue');
            expect(sqsMock.sendSQSMessage).not.toHaveBeenCalled();
            expect(result).toEqual(undefined);
        });

        it('should log and call sendSQSMessage if the ttl was not reached yet', async () => {
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const record: any = {};
            const url = 'url';
            const delay = 1;

            sqsMock.sendSQSMessage.mockResolvedValue();
            sqsMock.getQueueUrl.mockResolvedValue(url);
            utilsMock.getTTL.mockReturnValue(new Date(0));
            utilsMock.getSQSDelay.mockReturnValue(delay);

            const result = await requeueRunnerRequestToSQS(runnerRequest, record);

            expect(loggerMock.logger.warn).toHaveBeenCalledWith('Sending runner request back to the SQS queue');
            expect(sqsMock.sendSQSMessage).toHaveBeenCalledWith(url, JSON.stringify(runnerRequest), delay);
            expect(result).toEqual(undefined);
        });
    });
});
