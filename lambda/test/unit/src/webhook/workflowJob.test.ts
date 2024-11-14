import { Environment, WebhookEnvVars } from '../../../../src/lib/env';
import { processGithubWorkflowJobEvent } from '../../../../src/webhook/workflowJob';
import { printLogFields } from '../../../../src/lib/logFields';
import * as utils from '../../../../src/lib/utils';
import * as logger from '../../../../src/lib/logger';
import * as moitoring from '../../../../src/lib/monitoring';
import * as webhookUtils from '../../../../src/webhook/webhookUtils';
import * as runnerRequest from '../../../../src/runner/runnerRequest';
import * as sqs from '../../../../src/lib/aws/sqs';
import 'jest-extended';

jest.mock('../../../../src/lib/utils');
jest.mock('../../../../src/lib/logger');
jest.mock('../../../../src/lib/monitoring');
jest.mock('../../../../src/lib/aws/sqs');
jest.mock('../../../../src/webhook/webhookUtils');
jest.mock('../../../../src/runner/runnerRequest');

const utilsMock = utils as jest.Mocked<typeof utils>;
const loggerMock = logger as jest.Mocked<typeof logger>;
const sqsMock = sqs as jest.Mocked<typeof sqs>;
const monitoringMock = moitoring as jest.Mocked<typeof moitoring>;
const webhookUtilsMock = webhookUtils as jest.Mocked<typeof webhookUtils>;
const runnerRequestMock = runnerRequest as jest.Mocked<typeof runnerRequest>;

describe('workflowJob', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('processGithubWorkflowJobEvent', () => {
        it('should reject if there is no cawe label', async () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                action: 'queued',
                installation: {
                    id: 1,
                },
                workflow_job: {
                    labels: ['a', 'b'],
                },
            };

            monitoringMock.processJobEventMetrics.mockResolvedValue();
            utilsMock.filterCAWElabel.mockReturnValue(undefined as any);

            await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow job event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowJobEvent,
                })}`,
            );

            expect(utilsMock.splitCAWELabel).not.toHaveBeenCalled();
            expect(runnerRequestMock.generateRunnerRequest).not.toHaveBeenCalled();
            expect(webhookUtils.selectDelayBasedOnOS).not.toHaveBeenCalled();
            expect(webhookUtilsMock.selectDelayBasedOnOS).not.toHaveBeenCalled();
            expect(sqsMock.sendSQSMessage).not.toHaveBeenCalled();
            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                "Failed to process Github workflowJobEvent: Event does not contain required 'cawe' label",
                printLogFields(),
            );
        });

        it('should process event if it contains a cawe label for linux', async () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                action: 'queued',
                installation: {
                    id: 1,
                },
                workflow_job: {
                    labels: ['cawe-linux-x64-general-small', 'b'],
                    run_id: 1234,
                    run_attempt: 1,
                },
            };

            const isMacOS = false;
            const queueUrl = 'url_l';
            const runnerRequest: any = {};
            const delay = 1;

            monitoringMock.processJobEventMetrics.mockResolvedValue();
            utilsMock.filterCAWElabel.mockReturnValue(workflowJobEvent.workflow_job.labels[0]);
            utilsMock.splitCAWELabel.mockReturnValue({ os: 'linux', arch: 'x64', purpose: 'general', size: 'small' , githubRunId: '1234', githubRunAttempt: '1' });
            runnerRequestMock.generateRunnerRequest.mockReturnValue(runnerRequest);
            webhookUtilsMock.selectQueueUrlBasedOnOS.mockReturnValue(queueUrl);
            webhookUtilsMock.selectDelayBasedOnOS.mockReturnValue(delay);
            sqsMock.sendSQSMessage.mockResolvedValue();

            await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow job event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowJobEvent,
                })}`,
            );

            expect(utilsMock.filterCAWElabel).toHaveBeenCalledWith(workflowJobEvent.workflow_job.labels);
            expect(utilsMock.splitCAWELabel).toHaveBeenCalledWith(workflowJobEvent.workflow_job.labels[0]);
            expect(runnerRequestMock.generateRunnerRequest).toHaveBeenCalledWith(
                workflowJobEvent,
                githubHost,
                isEnterprise,
            );
            expect(webhookUtilsMock.selectDelayBasedOnOS).toHaveBeenCalledWith(isMacOS);
            expect(sqsMock.sendSQSMessage).toHaveBeenCalledWith(queueUrl, JSON.stringify(runnerRequest), delay);
            expect(loggerMock.logger.warn).not.toHaveBeenCalledWith(
                "Failed to process Github workflowJobEvent: Event does not contain required 'cawe' label",
                printLogFields(),
            );
        });

        it('should process event if it contains a cawe label for macos', async () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {
                action: 'queued',
                installation: {
                    id: 1,
                },
                workflow_job: {
                    labels: ['cawe-macos-arm64', 'b'],
                    run_id: 1234,
                    run_attempt: 1,
                },
            };

            const isMacOS = true;
            const queueUrl = 'url_m';
            const runnerRequest: any = {};
            const delay = 1;

            monitoringMock.processJobEventMetrics.mockResolvedValue();
            utilsMock.filterCAWElabel.mockReturnValue(workflowJobEvent.workflow_job.labels[0]);
            utilsMock.splitCAWELabel.mockReturnValue({ os: 'macos', arch: 'arm64' });
            runnerRequestMock.generateRunnerRequest.mockReturnValue(runnerRequest);
            webhookUtilsMock.selectQueueUrlBasedOnOS.mockReturnValue(queueUrl);
            webhookUtilsMock.selectDelayBasedOnOS.mockReturnValue(delay);
            sqsMock.sendSQSMessage.mockResolvedValue();

            await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow job event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowJobEvent,
                })}`,
            );

            expect(utilsMock.filterCAWElabel).toHaveBeenCalledWith(workflowJobEvent.workflow_job.labels);
            expect(utilsMock.splitCAWELabel).toHaveBeenCalledWith(workflowJobEvent.workflow_job.labels[0]);
            expect(runnerRequestMock.generateRunnerRequest).toHaveBeenCalledWith(
                workflowJobEvent,
                githubHost,
                isEnterprise,
            );
            expect(webhookUtilsMock.selectDelayBasedOnOS).toHaveBeenCalledWith(isMacOS);
            expect(sqsMock.sendSQSMessage).toHaveBeenCalledWith(queueUrl, JSON.stringify(runnerRequest), delay);
            expect(loggerMock.logger.warn).not.toHaveBeenCalledWith(
                "Failed to process Github workflowJobEvent: Event does not contain required 'cawe' label",
                printLogFields(),
            );
        });

        it('should log a warning message if monitoring does reject', async () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const githubHost = 'host';
            const isEnterprise = true;
            const workflowJobEvent: any = {};
            const dummyError = new Error('dummy error');

            monitoringMock.processJobEventMetrics.mockRejectedValue(dummyError);

            await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow job event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowJobEvent,
                })}`,
            );

            expect(loggerMock.logger.error).toHaveBeenCalledWith(dummyError.message);
        });
    });
});
