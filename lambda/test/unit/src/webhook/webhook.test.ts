import { Environment, WebhookEnvVars } from '../../../../src/lib/env';
import { processGithubWebhook } from '../../../../src/webhook/webhook';
import { printLogFields } from '../../../../src/lib/logFields';
import * as webhookUtils from '../../../../src/webhook/webhookUtils';
import * as workflowRun from '../../../../src/webhook/workflowRun';
import * as workflowJob from '../../../../src/webhook/workflowJob';
import * as logger from '../../../../src/lib/logger';
import * as github from '../../../../src/lib/github';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../../src/webhook/webhookUtils');
jest.mock('../../../../src/lib/utils');
jest.mock('../../../../src/lib/aws/ssm');
jest.mock('../../../../src/lib/logger');
jest.mock('../../../../src/lib/github');
jest.mock('../../../../src/webhook/workflowRun');
jest.mock('../../../../src/webhook/workflowJob');

const loggerMock = logger as jest.Mocked<typeof logger>;
const githubMock = github as jest.Mocked<typeof github>;
const webhookUtilsMock = webhookUtils as jest.Mocked<typeof webhookUtils>;
const workflowRunMock = workflowRun as jest.Mocked<typeof workflowRun>;
const workflowJobMock = workflowJob as jest.Mocked<typeof workflowJob>;

describe('webhook', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('processGithubWebhook', () => {
        it('should reject if event.body is not defined', async () => {
            const event: any = {};

            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            try {
                await processGithubWebhook(event, webhookEnvVars);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('Received Github event without body'));
            }
        });

        it('should process workflow run event', async () => {
            const event: any = {
                body: JSON.stringify({ workflow_run: 'event' }),
            };

            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };
            const parseMock: any = {
                githubHost: 'host',
                githubEvent: 'workflow_run',
                githubSignature: 'sig',
                isEnterprise: true,
            };

            webhookUtilsMock.parseWebhookHeaders.mockReturnValue(parseMock);
            githubMock.verifyWebhookSignature.mockResolvedValue();
            workflowRunMock.processGithubWorkflowRunEvent.mockResolvedValue();

            await processGithubWebhook(event, webhookEnvVars);

            expect(workflowRunMock.processGithubWorkflowRunEvent).toHaveBeenCalledWith(
                webhookEnvVars,
                parseMock.githubHost,
                parseMock.isEnterprise,
                JSON.parse(event.body),
            );
        });

        it('should process workflow job event', async () => {
            const event: any = {
                body: JSON.stringify({ workflow_job: 'event' }),
            };

            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };
            const parseMock: any = {
                githubHost: 'host',
                githubEvent: 'workflow_job',
                githubSignature: 'sig',
                isEnterprise: true,
            };

            webhookUtilsMock.parseWebhookHeaders.mockReturnValue(parseMock);
            githubMock.verifyWebhookSignature.mockResolvedValue();
            workflowJobMock.processGithubWorkflowJobEvent.mockResolvedValue();

            await processGithubWebhook(event, webhookEnvVars);

            expect(workflowJobMock.processGithubWorkflowJobEvent).toHaveBeenCalledWith(
                webhookEnvVars,
                parseMock.githubHost,
                parseMock.isEnterprise,
                JSON.parse(event.body),
            );
            expect(workflowRunMock.processGithubWorkflowRunEvent).not.toHaveBeenCalled();
        });

        it('should log a warning message for unknown event type', async () => {
            const event: any = {
                body: JSON.stringify({}),
            };

            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };
            const parseMock: any = {
                githubHost: 'host',
                githubEvent: 'other',
                githubSignature: 'sig',
                isEnterprise: true,
            };

            webhookUtilsMock.parseWebhookHeaders.mockReturnValue(parseMock);

            await processGithubWebhook(event, webhookEnvVars);
            expect(workflowJobMock.processGithubWorkflowJobEvent).not.toHaveBeenCalled();
            expect(workflowRunMock.processGithubWorkflowRunEvent).not.toHaveBeenCalled();
            expect(loggerMock.logger.warn).toHaveBeenCalledWith('Unknown Github event', printLogFields());
        });
    });
});
