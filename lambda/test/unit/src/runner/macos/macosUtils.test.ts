import * as macosUtils from '../../../../../src/runner/macos/macosUtils';
import * as runner from '../../../../../src/runner/runner';
import * as runnerRequest from '../../../../../src/runner/runnerRequest';
import * as logger from '../../../../../src/lib/logger';
import * as monitoring from '../../../../../src/lib/monitoring';
import { RunnerRequest } from '../../../../../src/runner/runnerRequest';
import { AppInstallationLevel, GithubDetails } from '../../../../../src/lib/github';
import { EC2Instance } from '../../../../../src/lib/aws/ec2';
import { MACOS_MAX_ALLOCATION_PERCENTAGE } from '../../../../../src/config';
import 'jest-extended';
import path from 'path';
import { _InstanceType } from '@aws-sdk/client-ec2';

jest.mock('../../../../../src/lib/logger');
jest.mock('../../../../../src/lib/monitoring');
jest.mock('../../../../../src/runner/runner');
jest.mock('../../../../../src/runner/runnerRequest');

const loggerMock = logger as jest.Mocked<typeof logger>;
const monitoringMock = monitoring as jest.Mocked<typeof monitoring>;
const runnerMock = runner as jest.Mocked<typeof runner>;
const runnerRequestMock = runnerRequest as jest.Mocked<typeof runnerRequest>;

describe('macosUtils', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('listMacOsHosts', () => {
        it('should resolve macOS hosts', async () => {
            const params = {
                Filters: [
                    {
                        Name: 'instance-state-name',
                        Values: ['running'],
                    },
                    {
                        Name: 'tag:Os',
                        Values: ['macos'],
                    },
                    {
                        Name: 'tag:State',
                        Values: ['provisioned'],
                    },
                ],
            };

            runnerMock.fetchRunners.mockResolvedValue([] as any);

            await macosUtils.listMacOsHosts();

            expect(runnerMock.fetchRunners).toHaveBeenCalledWith(params, 'eu-west-1');
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Filter macos instances: ${JSON.stringify(params)}`);
        });
    });

    describe('checkQoSUsage', () => {
        it('should resolve true if quota is not reached', async () => {
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com/',
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
                repositoryOwner: '',
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

            const record: any = {};

            const hosts: EC2Instance[] = [
                {
                    InstanceId: 'id1',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id2',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id3',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id4',
                    InstanceType: _InstanceType.mac2_metal,
                },
            ];

            const currentMacOsUsage = Math.floor((hosts.length * 2) / 3);

            monitoringMock.getCurrentMacOsUsage.mockResolvedValue(currentMacOsUsage);

            const nextMacOSUsage = currentMacOsUsage + 1;
            const total = hosts.length * 2;
            const newPercentage = (nextMacOSUsage / total) * 100;

            const result = await macosUtils.checkQoSUsage(hosts, runnerRequest, githubDetails, record);

            expect(monitoringMock.getCurrentMacOsUsage).toHaveBeenCalledWith(githubDetails.repositoryOwner);
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Usage count by ${githubDetails.repositoryOwner} org: ${nextMacOSUsage} out of ${total} VMs = ${newPercentage}%`,
            );
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Usage quota by ${githubDetails.repositoryOwner} org: ${newPercentage}% out of ${MACOS_MAX_ALLOCATION_PERCENTAGE}%`,
            );
            expect(result).toEqual(true);
        });

        it('should reject false if quota is reached', async () => {
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com/',
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

            const record: any = {};

            const hosts: EC2Instance[] = [
                {
                    InstanceId: 'id1',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id2',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id3',
                    InstanceType: _InstanceType.mac2_metal,
                },
                {
                    InstanceId: 'id4',
                    InstanceType: _InstanceType.mac2_metal,
                },
            ];
            const currentMacOsUsage = hosts.length * 2;

            monitoringMock.getCurrentMacOsUsage.mockResolvedValue(currentMacOsUsage);
            runnerRequestMock.requeueRunnerRequestToSQS.mockResolvedValue();

            const nextMacOSUsage = currentMacOsUsage + 1;
            const total = hosts.length * 2;
            const newPercentage = (nextMacOSUsage / total) * 100;

            const result = await macosUtils.checkQoSUsage(hosts, runnerRequest, githubDetails, record);

            expect(monitoringMock.getCurrentMacOsUsage).toHaveBeenCalledWith(githubDetails.repositoryOwner);
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Usage count by ${githubDetails.repositoryOwner} org: ${nextMacOSUsage} out of ${total} VMs = ${newPercentage}%`,
            );
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Usage quota by ${githubDetails.repositoryOwner} org: ${newPercentage}% out of ${MACOS_MAX_ALLOCATION_PERCENTAGE}%`,
            );
            expect(loggerMock.logger.warn).toHaveBeenCalledWith(
                `Org ${githubDetails.repositoryOwner} has reached the maximum macOS VM allocation`,
            );
            expect(result).toEqual(false);
        });
    });
});
