import * as logger from '../../../src/lib/logger';
import * as logFields from '../../../src/lib/logFields';
import * as http from '../../../src/lib/http';
import * as handler from '../../../src/handler';
import * as webhook from '../../../src/webhook/webhook';
import * as linux from '../../../src/runner/linux/linux';
import * as macos from '../../../src/runner/macos/macos';
import * as env from '../../../src/lib/env';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../src/lib/logger');
jest.mock('../../../src/lib/env');
jest.mock('../../../src/lib/http');
jest.mock('../../../src/webhook/webhook');
jest.mock('../../../src/runner/linux/linux');
jest.mock('../../../src/runner/macos/macos');

const loggerMock = logger as jest.Mocked<typeof logger>;
const envMock = env as jest.Mocked<typeof env>;
const httpMock = http as jest.Mocked<typeof http>;
const webhookMock = webhook as jest.Mocked<typeof webhook>;
const linuxMock = linux as jest.Mocked<typeof linux>;
const macosMock = macos as jest.Mocked<typeof macos>;

describe('handler', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('githubWebhookHandler', () => {
        it('should resolve with 200 status code if no error is thrown by processGithubWebhook', async () => {
            const event: any = {};
            const context: any = {};

            const webhookEnvVars: env.WebhookEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const response: http.IResponse = {
                statusCode: 200,
            };

            loggerMock.addLogEventHandler.mockReturnValue();
            webhookMock.processGithubWebhook.mockResolvedValue();
            envMock.processWebhookEnvVars.mockReturnValue(webhookEnvVars);
            httpMock.response.mockReturnValue(response);

            const res = await handler.githubWebhookHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling Github webhook event',
                logFields.printLogFields(),
            );
            expect(webhookMock.processGithubWebhook).toHaveBeenCalledWith(event, webhookEnvVars);
            expect(httpMock.response).toHaveBeenCalledWith(200, 'Success');
            expect(res).toEqual(response);
        });

        it('should handle the error from processGithubWebhook and reject with 500 status code', async () => {
            const event: any = {};
            const context: any = {};

            const webhookEnvVars: env.WebhookEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const response: http.IResponse = {
                statusCode: 500,
            };

            const dummyError = new Error('dummy error');

            loggerMock.addLogEventHandler.mockReturnValue();
            webhookMock.processGithubWebhook.mockRejectedValue(dummyError);
            envMock.processWebhookEnvVars.mockReturnValue(webhookEnvVars);
            httpMock.response.mockReturnValue(response);

            const res = await handler.githubWebhookHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling Github webhook event',
                logFields.printLogFields(),
            );
            expect(webhookMock.processGithubWebhook).toHaveBeenCalledWith(event, webhookEnvVars);
            expect(httpMock.response).toHaveBeenCalledWith(500, `Error processing webhook: ${dummyError.message}`);
            expect(res).toEqual(response);
            expect(loggerMock.logger.error).toHaveBeenCalledWith(dummyError.message, logFields.printLogFields());
        });
    });

    describe('linuxScalingHandler', () => {
        it('should resolve if scaleUpLinux resolves', async () => {
            const event: any = {
                Records: [{}],
            };
            const context: any = {};

            const runnerEnvVars: env.RunnerEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            loggerMock.addLogEventHandler.mockReturnValue();
            envMock.processRunnerEnvVars.mockReturnValue(runnerEnvVars);
            linuxMock.scaleUpLinux.mockResolvedValue();

            await handler.linuxScalingHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling linux scaling event',
                logFields.printLogFields(),
            );
            expect(linuxMock.scaleUpLinux).toHaveBeenCalledWith(event.Records[0], runnerEnvVars);
        });

        it('should handle the error and log if scaleUpLinux rejects', async () => {
            const event: any = {
                Records: [{}],
            };
            const context: any = {};

            const runnerEnvVars: env.RunnerEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const dummyError = new Error('dummy error');

            loggerMock.addLogEventHandler.mockReturnValue();
            envMock.processRunnerEnvVars.mockReturnValue(runnerEnvVars);
            linuxMock.scaleUpLinux.mockRejectedValue(dummyError);

            await handler.linuxScalingHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling linux scaling event',
                logFields.printLogFields(),
            );
            expect(linuxMock.scaleUpLinux).toHaveBeenCalledWith(event.Records[0], runnerEnvVars);
            expect(loggerMock.logger.error).toHaveBeenCalledWith(dummyError.message, logFields.printLogFields());
        });
    });

    describe('macosScalingHandler', () => {
        it('should resolve if scaleUpMacos resolves', async () => {
            const event: any = {
                Records: [{}],
            };
            const context: any = {};

            const runnerEnvVars: env.RunnerEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            loggerMock.addLogEventHandler.mockReturnValue();
            envMock.processRunnerEnvVars.mockReturnValue(runnerEnvVars);
            macosMock.scaleUpMacos.mockResolvedValue();

            await handler.macosScalingHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling macOS scaling event',
                logFields.printLogFields(),
            );
            expect(macosMock.scaleUpMacos).toHaveBeenCalledWith(event.Records[0], runnerEnvVars);
        });

        it('should handle the error and log if scaleUpMacos rejects', async () => {
            const event: any = {
                Records: [{}],
            };
            const context: any = {};

            const runnerEnvVars: env.RunnerEnvVars = {
                region: 'r',
                environment: env.Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const dummyError = new Error('dummy error');

            loggerMock.addLogEventHandler.mockReturnValue();
            envMock.processRunnerEnvVars.mockReturnValue(runnerEnvVars);
            macosMock.scaleUpMacos.mockRejectedValue(dummyError);

            await handler.macosScalingHandler(event, context);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                'Handling macOS scaling event',
                logFields.printLogFields(),
            );
            expect(macosMock.scaleUpMacos).toHaveBeenCalledWith(event.Records[0], runnerEnvVars);
            expect(loggerMock.logger.error).toHaveBeenCalledWith(dummyError.message, logFields.printLogFields());
        });
    });
});
