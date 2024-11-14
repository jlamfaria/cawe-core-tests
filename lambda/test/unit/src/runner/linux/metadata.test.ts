import { RunnerMetadata, generateMetadata } from '../../../../../src/runner/linux/metadata';
import { AppInstallationLevel, GithubDetails } from '../../../../../src/lib/github';
import { RunnerState, RunnerTimer, RunnerType } from '../../../../../src/runner/runner';
import { Environment, RunnerEnvVars } from '../../../../../src/lib/env';
import 'jest-extended';
import path from 'path';
import { _InstanceType, InstanceLifecycleType } from '@aws-sdk/client-ec2';

describe('metadata', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('generateMetadata', () => {
        it('shouuld return the metadata', () => {
            const runnerEnvVars: RunnerEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                subnets: [],
                runnerGroup: 'rg',
                githubAppIdName: 'ghappidname',
                githubAppKeyName: 'ghappidkeyname',
                redisUrl: '',
            };

            const runnerInstance = {
                InstanceId: 'id1',
                InstanceType: _InstanceType.a1_metal,
                InstanceLifecycle: InstanceLifecycleType.spot,
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

            const metadata: RunnerMetadata = {
                aws: {
                    env: runnerEnvVars.environment,
                    region: runnerEnvVars.region,
                    instanceId: runnerInstance.InstanceId || '',
                    instanceType: runnerInstance.InstanceType || '',
                    instanceLifecycle: runnerInstance.InstanceLifecycle,
                    autoScalingGroupName: githubDetails.runnerDetails.labels[0],
                },
                github: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    token: githubDetails.runnerDetails.registrationToken,
                    labels: githubDetails.runnerDetails.labels.join(','),
                    url: githubDetails.runnerDetails.url.href,
                    runnerGroup: 'rg',
                },
                type: RunnerType.POOL,
                state: RunnerState.REGISTERING,
                timer: RunnerTimer.ORG_IDLE,
            };

            const result = generateMetadata(
                runnerEnvVars,
                runnerInstance,
                githubDetails,
                RunnerType.POOL,
                RunnerState.REGISTERING,
                RunnerTimer.ORG_IDLE,
            );

            expect(result).toEqual(metadata);
        });
    });
});
