import { MacOSHostVMRequest, scaleUpMacos } from '../../../../../src/runner/macos/macos';
import * as runnerRequest from '../../../../../src/runner/runnerRequest';
import * as macosUtils from '../../../../../src/runner/macos/macosUtils';
import * as ec2 from '../../../../../src/lib/aws/ec2';
import * as github from '../../../../../src/lib/github';
import * as runner from '../../../../../src/runner/runner';
import * as logger from '../../../../../src/lib/logger';
import * as short from 'short-uuid';
import path from 'path';
import got from 'got';
import 'jest-extended';
import { _InstanceType } from '@aws-sdk/client-ec2';

jest.mock('../../../../../src/lib/logger');
jest.mock('../../../../../src/lib/aws/ec2');
jest.mock('../../../../../src/lib/github');
jest.mock('../../../../../src/runner/runner');
jest.mock('../../../../../src/runner/macos/macosUtils');
jest.mock('../../../../../src/runner/runnerRequest');
jest.mock('got');
jest.mock('short-uuid');

const loggerMock = logger as jest.Mocked<typeof logger>;
const ec2Mock = ec2 as jest.Mocked<typeof ec2>;
const githubMock = github as jest.Mocked<typeof github>;
const runnerMock = runner as jest.Mocked<typeof runner>;
const macosUtilsMock = macosUtils as jest.Mocked<typeof macosUtils>;
const gotMock = got as jest.Mocked<typeof got>;
const shortMock = short as jest.Mocked<typeof short>;
const runnerRequestMock = runnerRequest as jest.Mocked<typeof runnerRequest>;

describe('macos', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('scaleUpMacos', () => {
        it('should assign a VM slot to the received request if available', async () => {
            const record: any = {
                body: JSON.stringify({}),
            };
            const runnerEnvVars: any = {};

            const url = new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`);

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
                    url,
                    registrationToken: '',
                    labels: ['cawe-macos-arm64', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const macosHosts: ec2.EC2Instance[] = [
                {
                    InstanceId: 'id1',
                    InstanceType: _InstanceType.mac2_metal,
                },
            ];

            const gotMockedResponse = {
                body: 'dummy body',
            };
            const rnd = 'abcabc';

            githubMock.getGithubRepoUrl.mockReturnValue(url);
            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            macosUtilsMock.listMacOsHosts.mockResolvedValue(macosHosts);
            ec2Mock.validateEC2Instances.mockReturnValue(macosHosts);
            macosUtilsMock.checkQoSUsage.mockResolvedValue(true);
            shortMock.generate.mockReturnValue(rnd as any);
            gotMock.post.mockResolvedValue(gotMockedResponse);

            const request: MacOSHostVMRequest = {
                job_id: `${macosHosts[0].InstanceId}-${rnd.slice(0, 6)}`,
                macos_version: 'sonoma',
                config: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    url: githubDetails.runnerDetails.url.href,
                    labels: githubDetails.runnerDetails.labels,
                    token: githubDetails.runnerDetails.registrationToken,
                    runnerGroup: githubDetails.runnerDetails.runnerGroup,
                },
            };

            await scaleUpMacos(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({
                    record,
                    runnerEnvVars,
                })}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Available hosts: ${JSON.stringify(macosHosts.map((host) => host.InstanceId))}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Attempting with ${macosHosts[0].InstanceId}`);
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Request info: ${JSON.stringify(request)}`);
            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Allocated VM on: ${macosHosts[0].InstanceId} response: ${gotMockedResponse.body}`,
            );
        });

        it('should requeue msg if no macOS hosts are available', async () => {
            const record: any = {
                body: JSON.stringify({}),
            };
            const runnerEnvVars: any = {};

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

            const macosHosts: ec2.EC2Instance[] = [];

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            macosUtilsMock.listMacOsHosts.mockResolvedValue(macosHosts);
            ec2Mock.validateEC2Instances.mockReturnValue(macosHosts);
            runnerRequestMock.requeueRunnerRequestToSQS.mockResolvedValue();

            await scaleUpMacos(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({
                    record,
                    runnerEnvVars,
                })}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Available hosts: ${JSON.stringify(macosHosts.map((host) => host.InstanceId))}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledTimes(1);
            expect(loggerMock.logger.info).toHaveBeenCalledTimes(1);
        });

        it('should requeue msg if usage quota is reached by the org', async () => {
            const record: any = {
                body: JSON.stringify({}),
            };
            const runnerEnvVars: any = {};

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
                    labels: ['cawe-macos-arm64', 'extra1'],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: ['label1'],
                    startedAt: 'date',
                },
            };

            const macosHosts: ec2.EC2Instance[] = [
                {
                    InstanceId: 'id1',
                    InstanceType: _InstanceType.mac2_metal,
                },
            ];

            const gotMockedResponse = {
                body: 'dummy body',
            };
            const rnd = 'abcabc';

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            macosUtilsMock.listMacOsHosts.mockResolvedValue(macosHosts);
            ec2Mock.validateEC2Instances.mockReturnValue(macosHosts);
            macosUtilsMock.checkQoSUsage.mockResolvedValue(false);
            shortMock.generate.mockReturnValue(rnd as any);
            gotMock.post.mockResolvedValue(gotMockedResponse);

            const request: MacOSHostVMRequest = {
                job_id: `${macosHosts[0].InstanceId}-${rnd.slice(0, 6)}`,
                macos_version: 'sonoma',
                config: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    url: githubDetails.runnerDetails.url.href,
                    labels: githubDetails.runnerDetails.labels,
                    token: githubDetails.runnerDetails.registrationToken,
                    runnerGroup: githubDetails.runnerDetails.runnerGroup,
                },
            };

            await scaleUpMacos(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({
                    record,
                    runnerEnvVars,
                })}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Available hosts: ${JSON.stringify(macosHosts.map((host) => host.InstanceId))}`,
            );
            expect(loggerMock.logger.debug).not.toHaveBeenCalledWith(`Attempting with ${macosHosts[0].InstanceId}`);
            expect(loggerMock.logger.debug).not.toHaveBeenCalledWith(`Request info: ${JSON.stringify(request)}`);
            expect(loggerMock.logger.info).not.toHaveBeenCalledWith(
                `Allocated VM on: ${macosHosts[0].InstanceId} response: ${gotMockedResponse.body}`,
            );
        });

        it('should requeue msg if no VM slot is available on any host', async () => {
            const record: any = {
                body: JSON.stringify({}),
            };
            const runnerEnvVars: any = {};

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

            const macosHosts: ec2.EC2Instance[] = [
                {
                    InstanceId: 'id1',
                    InstanceType: _InstanceType.mac2_metal,
                },
            ];

            const gotMockedResponse = {
                body: 'dummy body',
            };
            const gotMockedError = new Error('dummy error');
            const rnd = 'abcabc';

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            macosUtilsMock.listMacOsHosts.mockResolvedValue(macosHosts);
            ec2Mock.validateEC2Instances.mockReturnValue(macosHosts);
            macosUtilsMock.checkQoSUsage.mockResolvedValue(true);
            shortMock.generate.mockReturnValue(rnd as any);
            gotMock.post.mockRejectedValue(gotMockedError);

            const request: MacOSHostVMRequest = {
                job_id: `${macosHosts[0].InstanceId}-${rnd.slice(0, 6)}`,
                macos_version: 'sonoma',
                config: {
                    org: githubDetails.repositoryOwner,
                    repo: githubDetails.repositoryName,
                    url: githubDetails.runnerDetails.url.href,
                    labels: githubDetails.runnerDetails.labels,
                    token: githubDetails.runnerDetails.registrationToken,
                    runnerGroup: githubDetails.runnerDetails.runnerGroup,
                },
            };

            await scaleUpMacos(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({
                    record,
                    runnerEnvVars,
                })}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(
                `Available hosts: ${JSON.stringify(macosHosts.map((host) => host.InstanceId))}`,
            );
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Attempting with ${macosHosts[0].InstanceId}`);
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Request info: ${JSON.stringify(request)}`);
            expect(loggerMock.logger.info).not.toHaveBeenCalledWith(
                `Allocated VM on: ${macosHosts[0].InstanceId} response: ${gotMockedResponse.body}`,
            );

            expect(loggerMock.logger.info).toHaveBeenCalledWith('No allocation available in any host');

            expect(runnerRequestMock.requeueRunnerRequestToSQS).toHaveBeenCalledWith(JSON.parse(record.body), record);
        });
    });
});
