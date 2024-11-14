import { Environment, WebhookEnvVars } from '../../../../src/lib/env';
import { processGithubWorkflowRunEvent } from '../../../../src/webhook/workflowRun';
import * as logger from '../../../../src/lib/logger';
import * as moitoring from '../../../../src/lib/monitoring';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../../src/lib/logger');
jest.mock('../../../../src/lib/monitoring');

const loggerMock = logger as jest.Mocked<typeof logger>;
const monitoringMock = moitoring as jest.Mocked<typeof moitoring>;

describe('workflowRun', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('processGithubWorkflowRunEvent', () => {
        it('should resolve without warnings if monitoring does not reject', async () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const githubHost = 'host';
            const isEnterprise = true;
            const workflowRunEvent: any = {};

            monitoringMock.processRunEventMetrics.mockResolvedValue();

            await processGithubWorkflowRunEvent(webhookEnvVars, githubHost, isEnterprise, workflowRunEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow run event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowRunEvent,
                })}`,
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
            const workflowRunEvent: any = {};
            const dummyError = new Error('dummy error');

            monitoringMock.processRunEventMetrics.mockRejectedValue(dummyError);

            await processGithubWorkflowRunEvent(webhookEnvVars, githubHost, isEnterprise, workflowRunEvent);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing Github workflow run event: ${JSON.stringify({
                    webhookEnvVars,
                    githubHost,
                    isEnterprise,
                    workflowRunEvent,
                })}`,
            );

            expect(loggerMock.logger.warn).toHaveBeenCalledWith(dummyError.message);
        });
    });
});
