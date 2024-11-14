import { AppAuthOptions, createAppAuth, StrategyOptions } from '@octokit/auth-app';
import { OctokitOptions } from '@octokit/core/dist-types/types';
import { Octokit } from '@octokit/rest';
import { request } from '@octokit/request';
import { Webhooks } from '@octokit/webhooks';
import { getParameterValue } from './aws/ssm';
import { processRunnerEnvVars, RunnerEnvVars, WebhookEnvVars } from './env';
import { logger } from './logger';
import { filterCAWElabel } from './utils';
import { RunnerRequest } from '../runner/runnerRequest';
import got, { OptionsOfTextResponseBody } from 'got';
import path from 'path';

export const GITHUB_COM_ORIGIN = 'https://github.com';

export enum WorkflowEvent {
    WORKFLOW_RUN = 'workflow_run',
    WORKFLOW_JOB = 'workflow_job',
}

export interface InstallationTokenResponse {
    token: string;
    expires_at: Date;
    permissions: {
        organization_self_hosted_runners: string;
        actions: string;
        checks: string;
        contents: string;
        metadata: string;
        vulnerability_alerts: string;
    };
    repository_selection: string;
}

export enum AppInstallationLevel {
    ORG,
    REPO,
}

export enum RunnerRegistrationLevel {
    ORG,
    REPO,
}

export interface AppCredentials {
    appId: number;
    privateKey: string;
}

export interface AppDetails extends AppCredentials {
    appAuthToken: string;
}

export interface InstallationInfo {
    installationId: number;
    installationLevel: AppInstallationLevel;
}

export interface InstallationDetails extends InstallationInfo {
    installationAuthToken: string;
}

export interface RunnerDetails {
    registrationToken: string;
    url: URL;
    runnerGroup: string;
    labels: string[];
}

export interface WorkflowDetails {
    workflowLabels: string[];
    startedAt: string;
}

export interface GithubDetails {
    apiUrl: URL;
    githubHost: string;
    isEnterprise: boolean;
    repositoryOwner: string;
    repositoryName: string;
    appDetails: AppDetails;
    installationDetails: InstallationDetails;
    runnerDetails: RunnerDetails;
    workflowDetails: WorkflowDetails;
}

export function getSSMGithubParameterPath(environment: string, githubApiUrl: URL, parameterName: string) {
    logger.debug(
        `Getting SSM Github parameter path with: ${JSON.stringify({
            environment,
            githubApiUrl,
            parameterName,
        })}`,
    );

    const githubHostCleaned = githubApiUrl.hostname.replace(/\./g, '').replace(/-/g, '');
    const ssmParameterPath = `/gha/runner/${environment}/${githubHostCleaned}/${parameterName}`;

    logger.debug(`SSM Github parameter path: ${ssmParameterPath}`);

    return ssmParameterPath;
}

export async function getGithubAppCredentials(githubApiUrl: URL, runnerEnvVars: RunnerEnvVars) {
    const appIdStr = await getParameterValue(
        getSSMGithubParameterPath(runnerEnvVars.environment, githubApiUrl, runnerEnvVars.githubAppIdName),
    );

    const privateKey = await getParameterValue(
        getSSMGithubParameterPath(runnerEnvVars.environment, githubApiUrl, runnerEnvVars.githubAppKeyName),
    );

    const appCredentials: AppCredentials = {
        appId: Number(appIdStr),
        privateKey,
    };

    logger.debug(`Github app credentials: ${JSON.stringify(appCredentials)}`);

    return appCredentials;
}

export function getGithubApiUrl(githubHost: string, isEnterprise: boolean) {
    const githubApiUrl = isEnterprise ? new URL(`https://${githubHost}/api/v3`) : new URL(`https://api.${githubHost}`);

    logger.debug(`Github API URL: ${githubApiUrl}`);

    return githubApiUrl;
}

export function getGithubOrgUrl(githubHost: string, repositoryOwner: string) {
    const githubOrgUrl = new URL(`https://${path.join(githubHost, repositoryOwner)}`);

    logger.debug(`Github Org URL: ${githubOrgUrl}`);

    return githubOrgUrl;
}

export function getGithubRepoUrl(githubHost: string, repositoryOwner: string, repositoryName: string) {
    const githubOrgUrl = new URL(`https://${path.join(githubHost, repositoryOwner, repositoryName)}`);

    logger.debug(`Github Repo URL: ${githubOrgUrl}`);

    return githubOrgUrl;
}

export function getRunnerGroup() {
    const runnerEnvVars = processRunnerEnvVars();

    return runnerEnvVars.runnerGroup ? runnerEnvVars.runnerGroup : 'Default';
}

export async function createOctoClient(token: string, githubApiUrl: URL, isEnterprise: boolean) {
    const ocktokitOptions: OctokitOptions = {
        auth: token,
    };

    if (isEnterprise) {
        ocktokitOptions.baseUrl = githubApiUrl.href;
        ocktokitOptions.previews = ['antiope'];
    }

    logger.debug(`Creating octokit with options: ${JSON.stringify(ocktokitOptions)}`);

    const client = new Octokit(ocktokitOptions);

    logger.debug('Created Github octokit client successfully');

    return client;
}

export async function generateInstallationToken(
    runnerRequest: RunnerRequest,
    githubApiUrl: URL,
    appDetails: AppDetails,
) {
    try {
        const url = path.join(
            githubApiUrl.href,
            '/app/installations/',
            runnerRequest.installationId.toString(),
            '/access_tokens',
        );

        const options: OptionsOfTextResponseBody = {
            headers: {
                Authorization: `Bearer ${appDetails.appAuthToken}`,
            },
        };

        logger.debug(`Generating Github installation token with: ${JSON.stringify({ url, options })}`);

        const res = await got.post(url, options);
        const installationTokenReponse: InstallationTokenResponse = JSON.parse(res.body);

        logger.debug(`Github installation token Response: ${JSON.stringify(installationTokenReponse)}`);

        return installationTokenReponse;
    } catch (e) {
        throw new Error(`Failed to generate Github app installation token. Error: ${(e as Error).message}`);
    }
}

export async function getAppDetails(appCredentials: AppCredentials, githubApiUrl: URL) {
    const authOptions: StrategyOptions = {
        appId: appCredentials.appId,
        request: request.defaults({ baseUrl: githubApiUrl.href }),
        privateKey: Buffer.from(appCredentials.privateKey, 'base64').toString().replace('/[\\n]/g', '\n'),
    };

    logger.debug(`Creating Gihthub app auth interface with: ${JSON.stringify(authOptions)}`);

    const appAuthInterface = createAppAuth(authOptions);

    logger.debug('Created Github app auth interface successfully');

    const ghAppAuthOptions: AppAuthOptions = { type: 'app' };

    logger.debug(`Creating Github app auth client with options: ${JSON.stringify(ghAppAuthOptions)}`);

    const ghAppAuth = await appAuthInterface(ghAppAuthOptions);

    logger.debug(`Created Github app auth client successfully: ${JSON.stringify(ghAppAuth)}`);

    const appDetails: AppDetails = {
        ...appCredentials,
        appAuthToken: ghAppAuth.token,
    };

    logger.debug(`Github app details: ${JSON.stringify(appDetails)}}`);

    return appDetails;
}

export async function getInstallationInfo(runnerRequest: RunnerRequest, githubApiUrl: URL, appDetails: AppDetails) {
    let installationId: number;
    let installationLevel: AppInstallationLevel;

    const ghAppClient = await createOctoClient(appDetails.appAuthToken, githubApiUrl, runnerRequest.isEnterprise);

    try {
        const res = await ghAppClient.apps.getOrgInstallation({
            org: runnerRequest.repositoryOwner,
        });

        installationId = res.data.id;
        installationLevel = AppInstallationLevel.ORG;
    } catch (e) {
        const res = await ghAppClient.apps.getRepoInstallation({
            owner: runnerRequest.repositoryOwner,
            repo: runnerRequest.repositoryName,
        });

        installationId = res.data.id;
        installationLevel = AppInstallationLevel.REPO;
    }

    const installationInfo: InstallationInfo = {
        installationId,
        installationLevel,
    };

    logger.info(`Github installation info: ${JSON.stringify(installationInfo)}`);

    return installationInfo;
}

export async function getInstallationDetails(
    runnerRequest: RunnerRequest,
    githubApiUrl: URL,
    appDetails: AppDetails,
    installationInfo: InstallationInfo,
) {
    const installationTokenReponse = await generateInstallationToken(runnerRequest, githubApiUrl, appDetails);

    const installationDetails: InstallationDetails = {
        ...installationInfo,
        installationAuthToken: installationTokenReponse.token,
    };

    return installationDetails;
}

export async function verifyWebhookSignature(
    webhookEnvVars: WebhookEnvVars,
    githubHost: string,
    githubSignature: string,
    isEnterprise: boolean,
    body: string,
) {
    const secret = await getParameterValue(
        getSSMGithubParameterPath(
            webhookEnvVars.environment,
            getGithubApiUrl(githubHost, isEnterprise),
            webhookEnvVars.githubAppSecretName,
        ),
    );

    const webhooks = new Webhooks({
        secret: secret,
    });

    const verified = await webhooks.verify(body, githubSignature);

    if (!verified) {
        throw new Error('Unable to verify Github signature');
    }

    logger.info('Github signature verified successfully');
}

export async function generateRunnerToken(
    runnerRequest: RunnerRequest,
    githubApiUrl: URL,
    installationDetails: InstallationDetails,
    registrationLevel?: RunnerRegistrationLevel,
) {
    const ghInstallationClient = await createOctoClient(
        installationDetails.installationAuthToken,
        githubApiUrl,
        runnerRequest.isEnterprise,
    );

    const level = registrationLevel ? registrationLevel : RunnerRegistrationLevel.ORG;

    const registrationTokenResponse =
        level === RunnerRegistrationLevel.ORG
            ? await ghInstallationClient.actions.createRegistrationTokenForOrg({
                  org: runnerRequest.repositoryOwner,
              })
            : await ghInstallationClient.actions.createRegistrationTokenForRepo({
                  owner: runnerRequest.repositoryOwner,
                  repo: runnerRequest.repositoryName,
              });

    logger.debug(`Github runner registration token response: ${JSON.stringify(registrationTokenResponse)}`);

    return registrationTokenResponse.data;
}

export async function processGithubDetails(runnerEnvVars: RunnerEnvVars, runnerRequest: RunnerRequest) {
    logger.debug(
        `Processing Github details with: ${JSON.stringify({
            runnerRequest,
            runnerEnvVars,
        })}`,
    );

    const githubApiUrl = getGithubApiUrl(runnerRequest.githubHost, runnerRequest.isEnterprise);
    const appCredentials = await getGithubAppCredentials(githubApiUrl, runnerEnvVars);
    const appDetails = await getAppDetails(appCredentials, githubApiUrl);
    const installationInfo = await getInstallationInfo(runnerRequest, githubApiUrl, appDetails);

    if (runnerRequest.installationId !== installationInfo.installationId) {
        throw new Error(
            `Github app installation id from runnerRequest doesn't match with installed one in target org: ${JSON.stringify(
                {
                    runnerRequest,
                    installationInfo,
                },
            )}`,
        );
    }

    const installationDetails = await getInstallationDetails(runnerRequest, githubApiUrl, appDetails, installationInfo);

    const registrationTokenResponse = await generateRunnerToken(
        runnerRequest,
        githubApiUrl,
        installationDetails,
        RunnerRegistrationLevel.REPO,
    );

    const caweLabel = filterCAWElabel(runnerRequest.workflowLabels);

    if (!caweLabel) {
        throw new Error("Event does not contain required 'cawe' label");
    }

    const githubDetails: GithubDetails = {
        apiUrl: githubApiUrl,
        githubHost: runnerRequest.githubHost,
        isEnterprise: runnerRequest.isEnterprise,
        repositoryOwner: runnerRequest.repositoryOwner,
        repositoryName: runnerRequest.repositoryName,
        appDetails,
        installationDetails,
        runnerDetails: {
            registrationToken: registrationTokenResponse.token,
            url: getGithubRepoUrl(
                runnerRequest.githubHost,
                runnerRequest.repositoryOwner,
                runnerRequest.repositoryName,
            ),
            runnerGroup: getRunnerGroup(),
            labels: [caweLabel],
        },
        workflowDetails: {
            workflowLabels: runnerRequest.workflowLabels,
            startedAt: runnerRequest.startedAt,
        },
    };

    logger.debug(`Github details: ${JSON.stringify(githubDetails)}`);

    return githubDetails;
}
