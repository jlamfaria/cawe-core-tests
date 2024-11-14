import * as ec2 from '../../../../../src/lib/aws/ec2';
import * as env from '../../../../../src/lib/env';
import * as logger from '../../../../../src/lib/logger';
import * as github from '../../../../../src/lib/github';
import * as adhocUtils from '../../../../../src/runner/linux/adhocUtils';
import * as runner from '../../../../../src/runner/runner';
import * as ssm from '../../../../../src/lib/aws/ssm';
import { LIFECYCLES, scaleUpLinuxAdHoc } from '../../../../../src/runner/linux/adhoc';
import 'jest-extended';
import path from 'path';

jest.mock('../../../../../src/lib/logger');
jest.mock('../../../../../src/lib/aws/ec2');
jest.mock('../../../../../src/runner/linux/adhocUtils');
jest.mock('../../../../../src/runner/runner');
jest.mock('../../../../../src/lib/aws/ssm');

const loggerMock = logger as jest.Mocked<typeof logger>;
const ec2Mock = ec2 as jest.Mocked<typeof ec2>;
const adhocUtilsMock = adhocUtils as jest.Mocked<typeof adhocUtils>;
const runnerMock = runner as jest.Mocked<typeof runner>;
const ssmMock = ssm as jest.Mocked<typeof ssm>;

describe('adhoc', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('scaleUpLinuxAdHoc', () => {
        it.skip('should scale up spot adhoc instances', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: [],
                githubAppIdName: '',
                githubAppKeyName: '',
                redisUrl: '',
            };
            const githubDetails: github.GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'owner',
                repositoryName: 'repositoryName',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe-linux-x64-general-small', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instances = ['id1', 'id2'];

            adhocUtilsMock.createAdhocRunnerByLifecyle.mockResolvedValue({} as any);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);
            runnerMock.getEC2InstanceById.mockResolvedValue({} as any);
            runnerMock.setRunnerMetadataToRedis.mockResolvedValue();
            ssmMock.putParameterValue.mockResolvedValue({} as any);

            await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);

            expect(loggerMock.logger.info).toHaveBeenCalledWith('Processing scale up with new new adhoc instance');
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Creating new adhoc runner(s) with: ${JSON.stringify({
                    runnerEnvVars,
                    githubDetails,
                })}`,
            );
            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.SPOT,
            );
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Instances planned to be created by AWS: ${JSON.stringify(instances)}`,
            );
        });

        it('should scale up on-demand adhoc instances', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: [],
                githubAppIdName: '',
                githubAppKeyName: '',
                redisUrl: '',
            };
            const githubDetails: github.GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'owner',
                repositoryName: 'repositoryName',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe-linux-x64-general-small', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instances = ['id1', 'id2'];

            adhocUtilsMock.createAdhocRunnerByLifecyle.mockResolvedValue({} as any);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);
            runnerMock.getEC2InstanceById.mockResolvedValue({} as any);
            runnerMock.setRunnerMetadataToRedis.mockResolvedValue();
            ssmMock.putParameterValue.mockResolvedValue({} as any);

            await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);

            expect(loggerMock.logger.info).toHaveBeenCalledWith('Processing scale up with new new adhoc instance');
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Creating new adhoc runner(s) with: ${JSON.stringify({
                    runnerEnvVars,
                    githubDetails,
                })}`,
            );
            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.ON_DEMAND,
            );
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Instances planned to be created by AWS: ${JSON.stringify(instances)}`,
            );
        });

        it.skip('should scale up on-demand adhoc instances if no spot is available', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: [],
                githubAppIdName: '',
                githubAppKeyName: '',
                redisUrl: '',
            };
            const githubDetails: github.GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'repoOwner',
                repositoryName: 'repoName',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe-macos-arm64', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instances = ['id1', 'id2'];
            const dummyError = new Error('dummy error');

            adhocUtilsMock.createAdhocRunnerByLifecyle.mockRejectedValueOnce(dummyError);
            adhocUtilsMock.createAdhocRunnerByLifecyle.mockResolvedValue({} as any);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);
            runnerMock.getEC2InstanceById.mockResolvedValue({} as any);
            runnerMock.setRunnerMetadataToRedis.mockResolvedValue();
            ssmMock.putParameterValue.mockResolvedValue({} as any);

            await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);

            expect(loggerMock.logger.info).toHaveBeenCalledWith('Processing scale up with new new adhoc instance');
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Creating new adhoc runner(s) with: ${JSON.stringify({
                    runnerEnvVars,
                    githubDetails,
                })}`,
            );
            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.SPOT,
            );

            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                `Failed to launch ${ec2.Lifecycle.SPOT} instance. Error: ${dummyError.message}`,
            );

            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.ON_DEMAND,
            );
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Instances planned to be created by AWS: ${JSON.stringify(instances)}`,
            );
        });

        it('should reject if it fails to scale new instances of on-demand type', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: [],
                githubAppIdName: '',
                githubAppKeyName: '',
                redisUrl: '',
            };
            const githubDetails: github.GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'repoOwner',
                repositoryName: 'repoName',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe-linux-x64-general-small', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instances = ['id1', 'id2'];
            const dummyError = new Error('dummy error');

            adhocUtilsMock.createAdhocRunnerByLifecyle.mockRejectedValue(dummyError);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);
            ssmMock.putParameterValue.mockResolvedValue({} as any);

            try {
                await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(
                    new Error(`Exausted all attempts based on instance lifecycles: ${JSON.stringify(LIFECYCLES)}`),
                );
            }

            expect(loggerMock.logger.info).toHaveBeenCalledWith('Processing scale up with new new adhoc instance');

            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                `Failed to launch ${ec2.Lifecycle.ON_DEMAND} instance. Error: ${dummyError.message}`,
            );

            expect(loggerMock.logger.info).not.toHaveBeenCalledWith(
                `Instances planned to be created by AWS: ${JSON.stringify(instances)}`,
            );
        });

        it.skip('should reject if it fails to scale new instances of both spot and on-demand types', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: [],
                githubAppIdName: '',
                githubAppKeyName: '',
                redisUrl: '',
            };
            const githubDetails: github.GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'repoOwner',
                repositoryName: 'repoName',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe-linux-x64-general-small', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instances = ['id1', 'id2'];
            const dummyError = new Error('dummy error');

            adhocUtilsMock.createAdhocRunnerByLifecyle.mockRejectedValue(dummyError);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);
            ssmMock.putParameterValue.mockResolvedValue({} as any);

            try {
                await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(
                    new Error(`Exausted all attempts based on instance lifecycles: ${JSON.stringify(LIFECYCLES)}`),
                );
            }

            expect(loggerMock.logger.info).toHaveBeenCalledWith('Processing scale up with new new adhoc instance');
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Creating new adhoc runner(s) with: ${JSON.stringify({
                    runnerEnvVars,
                    githubDetails,
                })}`,
            );
            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.SPOT,
            );

            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                `Failed to launch ${ec2.Lifecycle.SPOT} instance. Error: ${dummyError.message}`,
            );

            expect(adhocUtilsMock.createAdhocRunnerByLifecyle).toHaveBeenCalledWith(
                runnerEnvVars,
                githubDetails,
                ec2.Lifecycle.ON_DEMAND,
            );

            expect(loggerMock.logger.error).toHaveBeenCalledWith(
                `Failed to launch ${ec2.Lifecycle.ON_DEMAND} instance. Error: ${dummyError.message}`,
            );

            expect(loggerMock.logger.info).not.toHaveBeenCalledWith(
                `Instances planned to be created by AWS: ${JSON.stringify(instances)}`,
            );
        });
    });
});
