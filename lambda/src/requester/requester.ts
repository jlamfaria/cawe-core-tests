import { WorkflowJobEvent, WorkflowRunEvent } from '@octokit/webhooks-types';
import { APIGatewayEvent } from 'aws-lambda';
import { logger } from '../lib/logger';
import { printLogFields } from '../lib/logFields';
import { WebhookEnvVars } from '../lib/env';
import { processGithubWorkflowRunEvent } from '../webhook/workflowRun';
import { processGithubWorkflowJobEvent } from '../webhook/workflowJob';
import { parseRunnerRequestHeaders } from './requesterUtils';

export async function processRunnerRequest(event: APIGatewayEvent, webhookEnvVars: WebhookEnvVars) {
  if (!event.body) {
    throw new Error('Received Github event without body');
  }

  const { githubHost, githubEvent, isEnterprise } = parseRunnerRequestHeaders(event.headers);

  if (githubEvent === 'workflow_job') {
    const workflowJobEvent: WorkflowJobEvent = JSON.parse(event.body);

    await processGithubWorkflowJobEvent(webhookEnvVars, githubHost, isEnterprise, workflowJobEvent);

  } else {
    logger.warn('Unknown Github event', printLogFields());
  }
}
