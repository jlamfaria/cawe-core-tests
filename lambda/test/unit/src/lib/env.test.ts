import * as env from '../../../../src/lib/env';
import * as sinon from 'sinon';
import 'jest-extended';

describe('env', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('convertEnvironment', () => {
        it('should return dev env if env string refers to dev', () => {
            const e = env.convertEnvironment('dev');

            expect(e).toEqual(env.Environment.DEV);
        });

        it('should return int env if env string refers to int', () => {
            const e = env.convertEnvironment('int');

            expect(e).toEqual(env.Environment.INT);
        });

        it('should return prd env if env string refers to prd', () => {
            const e = env.convertEnvironment('prd');

            expect(e).toEqual(env.Environment.PRD);
        });

        it('should fallback to prod if env is unknown', () => {
            const e = env.convertEnvironment('super');

            expect(e).toEqual(env.Environment.PRD);
        });
    });

    describe('getMandatoryEnvVar', () => {
        it('should return the value from env var based on its the name', () => {
            const envVars = {
                KEY: 'value',
            };

            sandbox.stub(process, 'env').value(envVars);

            const value = env.getMandatoryEnvVar(Object.keys(envVars)[0]);

            expect(value).toEqual(envVars.KEY);
        });

        it('should throw an error if mandatory env var is not set', () => {
            const envVarName = 'KEY';

            try {
                env.getMandatoryEnvVar(envVarName);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error(`Mandatory env variable named: ${envVarName} is not set`));
            }
        });
    });

    describe('getOptionalEnvVar', () => {
        it('should return the value from env var based on its the name', () => {
            const envVars = {
                KEY: 'value',
            };

            sandbox.stub(process, 'env').value(envVars);

            const value = env.getOptionalEnvVar(Object.keys(envVars)[0]);

            expect(value).toEqual(envVars.KEY);
        });
    });

    describe('processRunnerEnvVars', () => {
        it('should return runner env vars object', () => {
            const envVarValues = {
                AWS_REGION: 'region1',
                ENVIRONMENT: 'dev',
                SUBNET_IDS: '1.1.0.0,2.2.0.0',
                GITHUB_APP_ID_NAME: 'app1',
                GITHUB_APP_KEY_NAME: 'key1',
                RUNNER_GROUP_NAME: 'rg1',
                REDIS_URL: 'redis_url',
                REDIS_PORT: 'redis_port',
            };

            sandbox.stub(process, 'env').value(envVarValues);

            const envVars = env.processRunnerEnvVars();

            expect(envVars).toEqual({
                region: envVarValues.AWS_REGION,
                environment: envVarValues.ENVIRONMENT,
                githubAppIdName: envVarValues.GITHUB_APP_ID_NAME,
                githubAppKeyName: envVarValues.GITHUB_APP_KEY_NAME,
                runnerGroup: envVarValues.RUNNER_GROUP_NAME,
                subnets: envVarValues.SUBNET_IDS.split(','),
                redisUrl: envVarValues.REDIS_URL,
                redisPort: envVarValues.REDIS_PORT,
            });
        });
    });

    describe('processWebhookEnvVars', () => {
        it('should return webhook env vars object', () => {
            const envVarValues = {
                AWS_REGION: 'region1',
                ENVIRONMENT: 'dev',
                SQS_URL_LINUX: 'url1',
                SQS_URL_MACOS: 'url2',
                GITHUB_APP_SECRET_NAME: 'secretName',
            };

            sandbox.stub(process, 'env').value(envVarValues);

            const envVars = env.processWebhookEnvVars();

            expect(envVars).toEqual({
                region: envVarValues.AWS_REGION,
                environment: envVarValues.ENVIRONMENT,
                sqsUrlLinux: envVarValues.SQS_URL_LINUX,
                sqsUrlMacos: envVarValues.SQS_URL_MACOS,
                githubAppSecretName: envVarValues.GITHUB_APP_SECRET_NAME,
            });
        });
    });
});
