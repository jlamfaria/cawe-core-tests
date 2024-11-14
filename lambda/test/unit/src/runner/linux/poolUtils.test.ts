import { GithubDetails, AppInstallationLevel } from '../../../../../src/lib/github';
import { RunnerRequest } from '../../../../../src/runner/runnerRequest';
import { Environment, RunnerEnvVars } from '../../../../../src/lib/env';
import { EC2Instance, Lifecycle } from '../../../../../src/lib/aws/ec2';
import * as ssm from '../../../../../src/lib/aws/ssm';
import * as runner from '../../../../../src/runner/runner';
import * as metadata from '../../../../../src/runner/linux/metadata';
import * as poolUtils from '../../../../../src/runner/linux/poolUtils';
import * as redis from '../../../../../src/lib/redis';
import 'jest-extended';
import path from 'path';
import { _InstanceType } from '@aws-sdk/client-ec2';

jest.mock('../../../../../src/lib/aws/ssm');
jest.mock('../../../../../src/runner/runner');
jest.mock('../../../../../src/runner/linux/metadata');

const ssmMock = ssm as jest.Mocked<typeof ssm>;
const runnerMock = runner as jest.Mocked<typeof runner>;
const metadataMock = metadata as jest.Mocked<typeof metadata>;
const redisMock = redis as jest.Mocked<typeof redis>;

describe('poolUtils', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('popInstanceFromRedis', () => {
        it('', () => {
            expect(true).toEqual(true);
        });
    });

    describe('assignEC2Instance', () => {
        it('should reject if getEC2InstanceById throws an error', async () => {
            const instanceId = 'id1';
            const runnerEnvVars: RunnerEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com/api/v1',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const githubDetails: GithubDetails = {
                apiUrl: new URL('https://example.com/api/v1'),
                githubHost: 'https://example.com/',
                isEnterprise: true,
                repositoryOwner: 'repoOwner',
                repositoryName: '',
                appDetails: {
                    appId: 0,
                    privateKey: '',
                    appAuthToken: '',
                },
                installationDetails: {
                    installationId: 0,
                    installationLevel: AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            const instanceIdMocked = 'id1';
            const instanceMocked = {
                InstanceId: 'id1',
                InstanceType: 'type1',
            };

            const updateTagsMocked = [
                {
                    Key: 'Name',
                    Value: `pool-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                        githubDetails.repositoryOwner
                    }`,
                },
                {
                    Key: 'Owner',
                    Value: githubDetails.repositoryOwner,
                },
                {
                    Key: 'Workflow_Labels',
                    Value: runnerRequest.workflowLabels.join(',') || '',
                },
                {
                    Key: 'Workflow_Started_Time',
                    Value: runnerRequest.startedAt || '',
                },
            ];

            const metadataMocked = {
                aws: {
                    region: runnerEnvVars.region,
                    instanceId: instanceMocked.InstanceId || '',
                    instanceType: instanceMocked.InstanceType || '',
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels[0],
                    url: `${githubDetails.apiUrl.origin}/${githubDetails.repositoryOwner}`,
                },
                timer: '1',
                type: runner.RunnerType.POOL,
            };

            const getEC2InstanceByIdMockedError = new Error('getEC2InstanceByIdError');

            runnerMock.getEC2InstanceById.mockRejectedValue(getEC2InstanceByIdMockedError);

            try {
                await poolUtils.assignEC2Instance(instanceId, runnerEnvVars, runnerRequest, githubDetails);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toStrictEqual(getEC2InstanceByIdMockedError);
            }

            expect(runnerMock.updateTags).not.toHaveBeenCalledWith(instanceIdMocked, updateTagsMocked);
            expect(metadataMock.generateMetadata).not.toHaveBeenCalledWith(
                runnerEnvVars.region,
                instanceMocked,
                githubDetails,
                runner.RunnerType.POOL,
            );
            expect(ssmMock.sendCommand).not.toHaveBeenCalledWith(instanceIdMocked, '/etc/gha/register.sh');
        });

        it('should reject if updateTags throws an error', async () => {
            const instanceId = 'id1';
            const runnerEnvVars: RunnerEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com/api/v1',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const githubDetails: GithubDetails = {
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
                    installationLevel: AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            const instanceIdMocked = 'id1';

            const instanceMocked: EC2Instance = {
                InstanceId: 'id1',
                InstanceType: _InstanceType.a1_metal,
                State: {
                    Name: 'running',
                },
                Tags: [
                    {
                        Key: 'State',
                        Value: 'provisioned',
                    },
                ],
            };

            const updateTagsMocked = [
                {
                    Key: 'Name',
                    Value: `pool-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                        githubDetails.repositoryOwner
                    }`,
                },
                {
                    Key: 'Owner',
                    Value: githubDetails.repositoryOwner,
                },
                {
                    Key: 'Workflow_Labels',
                    Value: runnerRequest.workflowLabels.join(',') || '',
                },
                {
                    Key: 'Workflow_Started_Time',
                    Value: runnerRequest.startedAt || '',
                },
            ];

            const provisionedMetadataMocked: metadata.RunnerMetadata = {
                aws: {
                    env: runnerEnvVars.environment,
                    region: runnerEnvVars.region,
                    instanceId: instanceMocked.InstanceId || '',
                    instanceType: instanceMocked.InstanceType || '',
                    instanceLifecycle: instanceMocked.InstanceLifecycle || Lifecycle.ON_DEMAND,
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels[0],
                    url: `${githubDetails.apiUrl.origin}/${githubDetails.repositoryOwner}`,
                    runnerGroup: 'rg',
                },
                type: runner.RunnerType.POOL,
                state: runner.RunnerState.PROVISIONED,
            };

            const metadataMocked: metadata.RunnerMetadata = {
                aws: {
                    env: runnerEnvVars.environment,
                    region: runnerEnvVars.region,
                    instanceId: instanceMocked.InstanceId || '',
                    instanceType: instanceMocked.InstanceType || '',
                    instanceLifecycle: instanceMocked.InstanceLifecycle || Lifecycle.ON_DEMAND,
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels[0],
                    url: `${githubDetails.apiUrl.origin}/${githubDetails.repositoryOwner}`,
                    runnerGroup: 'rg',
                },
                type: runner.RunnerType.POOL,
                state: runner.RunnerState.REGISTERING,
                timer: runner.RunnerTimer.ORG_IDLE,
            };

            const updateTagsMockedError = new Error('UpdateTagsError');

            runnerMock.getEC2InstanceById.mockResolvedValue(instanceMocked);
            runnerMock.getRunnerMetadataFromRedis.mockResolvedValue(provisionedMetadataMocked);
            runnerMock.updateTags.mockRejectedValue(updateTagsMockedError);
            metadataMock.generateMetadata.mockReturnValue(metadataMocked);

            try {
                await poolUtils.assignEC2Instance(instanceId, runnerEnvVars, runnerRequest, githubDetails);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toStrictEqual(updateTagsMockedError);
            }

            expect(runnerMock.updateTags).toHaveBeenCalledWith(instanceIdMocked, instanceMocked.Tags, updateTagsMocked);
            expect(metadataMock.generateMetadata).not.toHaveBeenCalledWith(
                runnerEnvVars.region,
                instanceMocked,
                githubDetails,
                runner.RunnerType.POOL,
            );
            expect(ssmMock.sendCommand).not.toHaveBeenCalledWith(instanceIdMocked, '/etc/gha/register.sh');
        });

        it('should reject if sendCommand throws an error', async () => {
            const instanceId = 'id1';
            const runnerEnvVars: RunnerEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com/api/v1',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const githubDetails: GithubDetails = {
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
                    installationLevel: AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: ['cawe'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            const instanceIdMocked = 'id1';

            const instanceMocked: EC2Instance = {
                InstanceId: 'id1',
                InstanceType: _InstanceType.a1_metal,
                InstanceLifecycle: 'spot',
                State: {
                    Name: 'running',
                },
                Tags: [
                    {
                        Key: 'State',
                        Value: 'provisioned',
                    },
                ],
            };

            const updateTagsMocked = [
                {
                    Key: 'Name',
                    Value: `pool-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                        githubDetails.repositoryOwner
                    }`,
                },
                {
                    Key: 'Owner',
                    Value: githubDetails.repositoryOwner,
                },
                {
                    Key: 'Workflow_Labels',
                    Value: runnerRequest.workflowLabels.join(',') || '',
                },
                {
                    Key: 'Workflow_Started_Time',
                    Value: runnerRequest.startedAt || '',
                },
            ];

            const provisionedMetadataMocked: metadata.RunnerMetadata = {
                aws: {
                    env: runnerEnvVars.environment,
                    region: runnerEnvVars.region,
                    instanceId: instanceMocked.InstanceId || '',
                    instanceType: instanceMocked.InstanceType || '',
                    instanceLifecycle: instanceMocked.InstanceLifecycle || Lifecycle.ON_DEMAND,
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels[0],
                    url: new URL(
                        `https://${path.join(
                            githubDetails.githubHost,
                            githubDetails.repositoryOwner,
                            githubDetails.repositoryName,
                        )}`,
                    ).href,
                    runnerGroup: 'rg',
                },
                type: runner.RunnerType.POOL,
                state: runner.RunnerState.PROVISIONED,
            };

            const metadataMocked: metadata.RunnerMetadata = {
                aws: {
                    env: runnerEnvVars.environment,
                    region: runnerEnvVars.region,
                    instanceId: instanceMocked.InstanceId || '',
                    instanceType: instanceMocked.InstanceType || '',
                    instanceLifecycle: instanceMocked.InstanceLifecycle || Lifecycle.ON_DEMAND,
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels[0],
                    url: `${githubDetails.apiUrl.origin}/${githubDetails.repositoryOwner}`,
                    runnerGroup: 'rg',
                },
                type: runner.RunnerType.POOL,
                state: runner.RunnerState.REGISTERING,
                timer: runner.RunnerTimer.ORG_IDLE,
            };

            const sendCommandMockedError = new Error('sendCommandError');

            runnerMock.getEC2InstanceById.mockResolvedValue(instanceMocked);
            runnerMock.getRunnerMetadataFromRedis.mockResolvedValue(provisionedMetadataMocked);
            runnerMock.updateTags.mockResolvedValue();
            metadataMock.generateMetadata.mockReturnValue(metadataMocked);
            ssmMock.sendCommand.mockRejectedValue(sendCommandMockedError);

            try {
                await poolUtils.assignEC2Instance(instanceId, runnerEnvVars, runnerRequest, githubDetails);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toStrictEqual(sendCommandMockedError);
            }

            expect(runnerMock.updateTags).toHaveBeenCalledWith(instanceIdMocked, instanceMocked.Tags, updateTagsMocked);
            expect(metadataMock.generateMetadata).toHaveBeenCalledWith(
                runnerEnvVars,
                instanceMocked,
                githubDetails,
                runner.RunnerType.POOL,
                runner.RunnerState.REGISTERING,
                runner.RunnerTimer.ORG_IDLE,
            );
            expect(ssmMock.sendCommand).toHaveBeenCalledWith(instanceIdMocked, '/etc/gha/register.sh');
        });
    });
});
