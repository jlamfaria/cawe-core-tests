import { WorkflowJobEvent } from '@octokit/webhooks-types';
import { WebhookEnvVars } from '../lib/env';
import { logger } from '../lib/logger';
import { processJobEventMetrics } from '../lib/monitoring';
import { filterCAWElabel, splitCAWELabel } from '../lib/utils';
import { sendSQSMessage } from '../lib/aws/sqs';
import { printLogFields } from '../lib/logFields';
import { selectDelayBasedOnOS, selectQueueUrlBasedOnOS } from './webhookUtils';
import { generateRunnerRequest } from '../runner/runnerRequest';

export async function processGithubWorkflowJobEvent(
    webhookEnvVars: WebhookEnvVars,
    githubHost: string,
    isEnterprise: boolean,
    workflowJobEvent: WorkflowJobEvent,
) {
    logger.info(
        `Processing Github workflow job event: ${JSON.stringify({
            webhookEnvVars,
            githubHost,
            isEnterprise,
            workflowJobEvent,
        })}`,
    );

    try {
        await processJobEventMetrics(workflowJobEvent);
    } catch (e) {
        logger.error((e as Error).message);
    }

    try {
        const caweLabel = filterCAWElabel(workflowJobEvent.workflow_job.labels);

        if (!caweLabel) {
            throw new Error("Event does not contain required 'cawe' label");
        }

        const { os , githubRunId } = splitCAWELabel(caweLabel);
        const isMacOS = os === 'macos';
        const runnerRequest = generateRunnerRequest(workflowJobEvent, githubHost, isEnterprise);
        const queueUrl = selectQueueUrlBasedOnOS(webhookEnvVars, isMacOS);
        const delay = selectDelayBasedOnOS(isMacOS);

        if (!queueUrl) {
            throw new Error('Queue URL is undefined');
        }

        await sendSQSMessage(queueUrl, JSON.stringify(runnerRequest), delay);

    } catch (e) {
        logger.error(`Failed to process Github workflowJobEvent: ${(e as Error).message}`, printLogFields());
    }
}
