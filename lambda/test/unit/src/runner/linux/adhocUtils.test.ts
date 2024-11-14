import * as ec2 from '../../../../../src/lib/aws/ec2';
import * as env from '../../../../../src/lib/env';
import * as logger from '../../../../../src/lib/logger';
import * as github from '../../../../../src/lib/github';
import {
    AWS_RESOURCES_MAPPING,
    createAdhocRunnerByLifecyle,
    createFleetRequest,
} from '../../../../../src/runner/linux/adhocUtils';
import path from 'path';
import 'jest-extended';
import { CreateFleetRequest, FleetLaunchTemplateOverridesListRequest } from 'aws-sdk/clients/ec2';
import { RunnerType } from '../../../../../src/runner/runner';

jest.mock('../../../../../src/lib/logger');
jest.mock('../../../../../src/lib/aws/ec2');

const loggerMock = logger as jest.Mocked<typeof logger>;
const ec2Mock = ec2 as jest.Mocked<typeof ec2>;

describe('adhoc', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('createAdhocRunnerByLifecyle', () => {
        it('should resolve the fleet if launchFleet resolves', async () => {
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
                    labels: ['cawe-linux-x64-general-medium', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const lifecycle: ec2.Lifecycle = ec2.Lifecycle.SPOT;
            const fleetMock: AWS.EC2.CreateFleetResult = {
                Instances: [
                    {
                        InstanceIds: ['id1'],
                    },
                ],
            };

            const instances = ['id1', 'id2'];

            ec2Mock.launchFleet.mockResolvedValue(fleetMock as any);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);

            const fleet = await createAdhocRunnerByLifecyle(runnerEnvVars, githubDetails, lifecycle);

            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Attempting ${lifecycle} instance`);
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Create EC2 fleet response: ${JSON.stringify(fleet)}`);
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Created fleet with instance(s): ${JSON.stringify(instances)}`,
            );
            expect(fleet).toEqual(fleetMock);
        });

        it('should reject if launchFleet throws an error', async () => {
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
                    labels: ['cawe-linux-x64-general-medium', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const lifecycle: ec2.Lifecycle = ec2.Lifecycle.SPOT;
            const dummyError = new Error('dummy error');

            ec2Mock.launchFleet.mockRejectedValue(dummyError);

            try {
                await createAdhocRunnerByLifecyle(runnerEnvVars, githubDetails, lifecycle);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(dummyError);
            }

            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Attempting ${lifecycle} instance`);
        });

        it('should reject if AWS returns 0 instances', async () => {
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
                    labels: ['cawe-linux-x64-general-medium', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const lifecycle: ec2.Lifecycle = ec2.Lifecycle.ON_DEMAND;
            const fleetMock: AWS.EC2.CreateFleetResult = {
                Instances: [
                    {
                        InstanceIds: [],
                    },
                ],
            };

            const instances: string[] = [];

            ec2Mock.launchFleet.mockResolvedValue(fleetMock as any);
            ec2Mock.getInstancesListFromFleet.mockReturnValue(instances);

            try {
                await createAdhocRunnerByLifecyle(runnerEnvVars, githubDetails, lifecycle);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('AWS returned a fleet with 0 instances'));
            }

            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Attempting ${lifecycle} instance`);
        });
    });

    describe('createFleetRequest', () => {
        it('should return the configuration if no error is found', async () => {
            const runnerEnvVars: env.RunnerEnvVars = {
                environment: env.Environment.DEV,
                region: 'region',
                subnets: ['subnet-a', 'subnet-b'],
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
                    labels: ['cawe-linux-x64-general-medium', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instanceLifecycle = ec2.Lifecycle.SPOT;
            const linuxTarget = AWS_RESOURCES_MAPPING[githubDetails.runnerDetails.labels[0]];
            const overrides: FleetLaunchTemplateOverridesListRequest = [];

            runnerEnvVars.subnets.forEach((s) => {
                linuxTarget.instanceTypes.forEach((i) => {
                    overrides.push({
                        SubnetId: s,
                        InstanceType: i,
                    });
                });
            });

            const config: CreateFleetRequest = {
                LaunchTemplateConfigs: [
                    {
                        LaunchTemplateSpecification: {
                            LaunchTemplateName: linuxTarget.launchTemplateName,
                            Version: '$Default',
                        },
                        Overrides: overrides,
                    },
                ],
                SpotOptions: {
                    AllocationStrategy: 'capacity-optimized',
                },
                OnDemandOptions: {
                    AllocationStrategy: 'lowest-price',
                },
                TargetCapacitySpecification: {
                    TotalTargetCapacity: 1,
                    DefaultTargetCapacityType: instanceLifecycle,
                },
                TagSpecifications: [
                    {
                        ResourceType: 'instance',
                        Tags: [
                            { Key: 'Type', Value: RunnerType.ADHOC },
                            { Key: 'Owner', Value: githubDetails.repositoryOwner },
                            {
                                Key: 'Name',
                                Value: `adhoc-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                                    githubDetails.repositoryOwner
                                }`,
                            },
                            {
                                Key: 'Workflow_Labels',
                                Value: githubDetails.workflowDetails.workflowLabels.join(',') || '',
                            },
                            { Key: 'Workflow_Started_Time', Value: githubDetails.workflowDetails.startedAt || '' },
                        ],
                    },
                ],
                Type: 'instant',
            };

            const request = createFleetRequest(runnerEnvVars, githubDetails, instanceLifecycle);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Will create a new EC2 fleet based on the configuration: ${JSON.stringify(config)}`,
            );

            expect(request).toEqual(config);
        });

        it('should throw an error if cannot find a match for the requested label', async () => {
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
                    labels: ['cawe-otherOS-x64-general-medium', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const instanceLifecycle = ec2.Lifecycle.SPOT;
            const overrides: FleetLaunchTemplateOverridesListRequest = [];

            const config: CreateFleetRequest = {
                LaunchTemplateConfigs: [
                    {
                        LaunchTemplateSpecification: {
                            LaunchTemplateName: undefined,
                            Version: '$Default',
                        },
                        Overrides: overrides,
                    },
                ],
                SpotOptions: {
                    AllocationStrategy: 'capacity-optimized',
                },
                OnDemandOptions: {
                    AllocationStrategy: 'lowest-price',
                },
                TargetCapacitySpecification: {
                    TotalTargetCapacity: 1,
                    DefaultTargetCapacityType: instanceLifecycle,
                },
                TagSpecifications: [
                    {
                        ResourceType: 'instance',
                        Tags: [
                            { Key: 'Type', Value: RunnerType.ADHOC },
                            { Key: 'Owner', Value: githubDetails.repositoryOwner },
                            {
                                Key: 'Name',
                                Value: `adhoc-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                                    githubDetails.repositoryOwner
                                }`,
                            },
                            {
                                Key: 'Workflow_Labels',
                                Value: githubDetails.workflowDetails.workflowLabels.join(',') || '',
                            },
                            { Key: 'Workflow_Started_Time', Value: githubDetails.workflowDetails.startedAt || '' },
                        ],
                    },
                ],
                Type: 'instant',
            };

            try {
                createFleetRequest(runnerEnvVars, githubDetails, instanceLifecycle);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(
                    new Error(
                        `Unable to find a suitable aws resource configuration with: ${githubDetails.runnerDetails.labels[0]}`,
                    ),
                );
            }

            expect(loggerMock.logger.info).not.toHaveBeenCalledWith(
                `Will create a new EC2 fleet based on the configuration: ${JSON.stringify(config)}`,
            );
        });
    });
});
