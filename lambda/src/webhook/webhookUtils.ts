import { APIGatewayProxyEventHeaders } from 'aws-lambda';
import { GITHUB_COM_ORIGIN } from '../lib/github';
import { WebhookEnvVars } from '../lib/env';
import { getSQSDelay, lowerCaseAllFields } from '../lib/utils';
import { RunnerRequest } from '../runner/runnerRequest';

export function parseWebhookHeaders(headers: APIGatewayProxyEventHeaders) {
    const lowerCaseHealders = lowerCaseAllFields(headers);

    if (!lowerCaseHealders['x-hub-signature']) {
        throw new Error("Github event doesn't have signature. This webhook requires a secret to be configured");
    }

    if (!lowerCaseHealders['x-github-event']) {
        throw new Error("Github event doesn't have an event. This webhook requires an event to be processed");
    }

    const githubHost: string = lowerCaseHealders['x-github-enterprise-host'] ?? new URL(GITHUB_COM_ORIGIN).hostname;
    const githubEvent: string = lowerCaseHealders['x-github-event'];
    const githubSignature: string = lowerCaseHealders['x-hub-signature'];
    const isEnterprise = lowerCaseHealders['x-github-enterprise-host'] ? true : false;

    return {
        githubHost,
        githubEvent,
        githubSignature,
        isEnterprise,
    };
}

export function selectQueueUrlBasedOnOS(webhookEnvVars: WebhookEnvVars, isMacOS: boolean) {
    return isMacOS ? webhookEnvVars.sqsUrlMacos : webhookEnvVars.sqsUrlLinux;
}

export function selectDelayBasedOnOS(isMacOS: boolean) {
    return isMacOS ? getSQSDelay(true) : 0;
}

export function getMessageGroupId(queueUrl: string, webhookEnvVars: WebhookEnvVars, runnerRequest: RunnerRequest) {
    return queueUrl === webhookEnvVars.sqsUrlLinux ? runnerRequest.id.toString() : undefined;
}
