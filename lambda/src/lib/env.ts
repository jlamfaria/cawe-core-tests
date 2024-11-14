export enum Environment {
    DEV = 'dev',
    INT = 'int',
    PRD = 'prd',
}

export interface CommonEnvVars {
    region: string;
    environment: Environment;
}

export interface RunnerEnvVars extends CommonEnvVars {
    subnets: string[];
    runnerGroup?: string;
    githubAppIdName: string;
    githubAppKeyName: string;
    redisUrl?: string;
    redisPort?: string;
}

export interface WebhookEnvVars extends CommonEnvVars {
    sqsUrlLinux: string;
    sqsUrlMacos?: string;
    githubAppSecretName: string;
    endpointCn?: string;
}

export function convertEnvironment(env: string) {
    switch (env) {
        case 'dev':
            return Environment.DEV;
        case 'int':
            return Environment.INT;
        case 'prd':
        default:
            return Environment.PRD;
    }
}

export function getMandatoryEnvVar(varName: string) {
    const value = process.env[varName];

    if (value) {
        return value;
    }

    throw new Error(`Mandatory env variable named: ${varName} is not set`);
}

export function getOptionalEnvVar(varName: string) {
    return process.env[varName];
}

export function processRunnerEnvVars() {
    const runnerEnvVars: RunnerEnvVars = {
        region: getMandatoryEnvVar('AWS_REGION'),
        environment: convertEnvironment(getMandatoryEnvVar('ENVIRONMENT')),
        subnets: getMandatoryEnvVar('SUBNET_IDS').split(','),
        runnerGroup: getOptionalEnvVar('RUNNER_GROUP_NAME'),
        githubAppIdName: getMandatoryEnvVar('GITHUB_APP_ID_NAME'),
        githubAppKeyName: getMandatoryEnvVar('GITHUB_APP_KEY_NAME'),
        redisUrl: getOptionalEnvVar('REDIS_URL'),
        redisPort: getOptionalEnvVar('REDIS_PORT'),
    };

    return runnerEnvVars;
}

export function processWebhookEnvVars() {
    const webhookEnvVars: WebhookEnvVars = {
        region: getMandatoryEnvVar('AWS_REGION'),
        environment: convertEnvironment(getMandatoryEnvVar('ENVIRONMENT')),
        sqsUrlLinux: getMandatoryEnvVar('SQS_URL_LINUX'),
        sqsUrlMacos: getOptionalEnvVar('SQS_URL_MACOS'),
        githubAppSecretName: getMandatoryEnvVar('GITHUB_APP_SECRET_NAME'),
        endpointCn: getOptionalEnvVar('ENDPOINT_CN'), // Add endpointCn
    };

    return webhookEnvVars;
}
