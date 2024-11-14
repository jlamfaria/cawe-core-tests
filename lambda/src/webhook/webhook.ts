import { WorkflowJobEvent, WorkflowRunEvent } from '@octokit/webhooks-types';
import { APIGatewayEvent } from 'aws-lambda';
import { logger } from '../lib/logger';
import { printLogFields } from '../lib/logFields';
import { WebhookEnvVars } from '../lib/env';
import { processGithubWorkflowRunEvent } from './workflowRun';
import { processGithubWorkflowJobEvent } from './workflowJob';
import { parseWebhookHeaders } from './webhookUtils';
import { verifyWebhookSignature } from '../lib/github';
import got from 'got';

export async function processGithubWebhook(event: APIGatewayEvent, webhookEnvVars: WebhookEnvVars) {
    if (!event.body) {
        throw new Error('Received Github event without body');
    }

    const { githubHost, githubEvent, githubSignature, isEnterprise } = parseWebhookHeaders(event.headers);

    await verifyWebhookSignature(webhookEnvVars, githubHost, githubSignature, isEnterprise, event.body);

    if (githubEvent === 'workflow_run') {
        const workflowRunEvent: WorkflowRunEvent = JSON.parse(event.body);

        await processGithubWorkflowRunEvent(webhookEnvVars, githubHost, isEnterprise, workflowRunEvent);
    } else if (githubEvent === 'workflow_job') {
        const workflowJobEvent: WorkflowJobEvent = JSON.parse(event.body);

        const { region, endpointCn } = webhookEnvVars;

        if (region === 'eu-central-1' && workflowJobEvent.workflow_job.labels.some(label => label.endsWith('-cn'))) {
            if (endpointCn) {
                const headers = {
                    'Content-Type': 'application/json',
                    'X-GitHub-Event': event.headers['X-GitHub-Event'],
                    'X-Hub-Signature': event.headers['X-Hub-Signature'],
                    'X-GitHub-Delivery': event.headers['X-GitHub-Delivery'],
                    'X-Hub-Signature-256': event.headers['X-Hub-Signature-256'],
                    'X-GitHub-Hook-Installation-Target-ID': event.headers['X-GitHub-Hook-Installation-Target-ID'],
                    'X-GitHub-Enterprise-Host': event.headers['X-GitHub-Enterprise-Host'],
                };

                logger.info(`Redirecting payload to ${endpointCn} with headers:`, headers);

                try {
                    const response = await got.post(endpointCn, {
                        body: event.body,
                        headers: headers,
                    });

                    logger.info(`Redirected payload to ${endpointCn} successfully. Response status: ${response.statusCode}`);
                } catch (error) {
                    logger.error(`Error redirecting payload to ${endpointCn}:`, error);
                }
            } else {
                logger.error('Endpoint CN is not defined');
            }
        } else {
            await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);
        }
    } else {
        logger.warn('Unknown Github event', printLogFields());
    }
}
