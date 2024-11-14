import { WorkflowRunEvent } from '@octokit/webhooks-types';
import { WebhookEnvVars } from '../lib/env';
import { logger } from '../lib/logger';
import { processRunEventMetrics } from '../lib/monitoring';

export async function processGithubWorkflowRunEvent(
    webhookEnvVars: WebhookEnvVars,
    githubHost: string,
    isEnterprise: boolean,
    workflowRunEvent: WorkflowRunEvent,
) {
    logger.info(
        `Processing Github workflow run event: ${JSON.stringify({
            webhookEnvVars,
            githubHost,
            isEnterprise,
            workflowRunEvent,
        })}`,
    );

    try {
        await processRunEventMetrics(workflowRunEvent);
    } catch (e) {
        logger.warn((e as Error).message);
    }
}
