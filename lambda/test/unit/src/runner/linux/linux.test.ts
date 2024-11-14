import { scaleUpLinux } from '../../../../../src/runner/linux/linux';
import * as logger from '../../../../../src/lib/logger';
import * as github from '../../../../../src/lib/github';
import * as pool from '../../../../../src/runner/linux/pool';
import * as adhoc from '../../../../../src/runner/linux/adhoc';
import * as runnerRequest from '../../../../../src/runner/runnerRequest';
import 'jest-extended';
import path from 'path';

jest.mock('../../../../../src/lib/logger');
jest.mock('../../../../../src/lib/github');
jest.mock('../../../../../src/runner/linux/pool');
jest.mock('../../../../../src/runner/linux/adhoc');
jest.mock('../../../../../src/runner/runnerRequest');

const loggerMock = logger as jest.Mocked<typeof logger>;
const githubMock = github as jest.Mocked<typeof github>;
const poolMock = pool as jest.Mocked<typeof pool>;
const adhocMock = adhoc as jest.Mocked<typeof adhoc>;
const runnerRequestMock = runnerRequest as jest.Mocked<typeof runnerRequest>;

describe('linux', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('scaleUpLinux', () => {
        it("should reject if action is not 'queued'", async () => {
            const record: any = {
                body: JSON.stringify({ action: 'other' }),
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
                    labels: [],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            poolMock.scaleUpLinuxFromPool.mockResolvedValue();

            try {
                await scaleUpLinux(record, runnerEnvVars);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('Event action type is not supported'));
            }

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({ record, runnerEnvVars })}`,
            );
        });

        it('should scale up linux instances from the pool if available', async () => {
            const record: any = {
                body: JSON.stringify({ action: 'queued' }),
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
                    labels: [],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            poolMock.scaleUpLinuxFromPool.mockResolvedValue();

            await scaleUpLinux(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({ record, runnerEnvVars })}`,
            );
        });

        it('should scale up new adhoc linux instances if none is available from the pool', async () => {
            const record: any = {
                body: JSON.stringify({ action: 'queued' }),
            };
            const runnerEnvVars: any = {};

            const githubDetails: github.GithubDetails = {
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
                    installationLevel: github.AppInstallationLevel.ORG,
                    installationAuthToken: '',
                },
                runnerDetails: {
                    url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
                    registrationToken: '',
                    labels: [],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            const dummyError = new Error('dummy error');

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            poolMock.scaleUpLinuxFromPool.mockRejectedValue(dummyError);
            adhocMock.scaleUpLinuxAdHoc.mockResolvedValue();

            await scaleUpLinux(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({ record, runnerEnvVars })}`,
            );
            expect(loggerMock.logger.warn).toHaveBeenCalledWith(dummyError.message);
        });

        it('should requeue runner request if it fails to scale up instances from the pool and adhoc', async () => {
            const record: any = {
                body: JSON.stringify({ action: 'queued' }),
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
                    labels: [],
                    runnerGroup: 'rg',
                },
                workflowDetails: {
                    workflowLabels: [],
                    startedAt: '',
                },
            };

            const dummyErrorPool = new Error('dummy error pool');
            const dummyErrorAdhoc = new Error('dummy error adhoc');

            githubMock.processGithubDetails.mockResolvedValue(githubDetails);
            poolMock.scaleUpLinuxFromPool.mockRejectedValue(dummyErrorPool);
            adhocMock.scaleUpLinuxAdHoc.mockRejectedValue(dummyErrorAdhoc);
            runnerRequestMock.requeueRunnerRequestToSQS.mockResolvedValue();

            await scaleUpLinux(record, runnerEnvVars);

            expect(loggerMock.logger.info).toHaveBeenCalledWith(
                `Processing scale up event: ${JSON.stringify({ record, runnerEnvVars })}`,
            );
            expect(poolMock.scaleUpLinuxFromPool).toHaveBeenCalledWith(
                runnerEnvVars,
                JSON.parse(record.body),
                githubDetails,
            );
            expect(loggerMock.logger.warn).toHaveBeenCalledWith(dummyErrorPool.message);
            expect(adhocMock.scaleUpLinuxAdHoc).toHaveBeenCalledWith(runnerEnvVars, githubDetails);
            expect(loggerMock.logger.warn).toHaveBeenCalledWith(dummyErrorAdhoc.message);
            expect(runnerRequestMock.requeueRunnerRequestToSQS).toHaveBeenCalledWith(JSON.parse(record.body), record);
        });
    });
});
