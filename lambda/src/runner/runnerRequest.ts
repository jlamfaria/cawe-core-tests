import { WorkflowJobEvent } from '@octokit/webhooks-types';
import { WorkflowEvent } from '../lib/github';
import { SQSRecord } from 'aws-lambda';
import { logger } from '../lib/logger';
import { getQueueUrl, sendSQSMessage } from '../lib/aws/sqs';
import { getSQSDelay, getTTL } from '../lib/utils';

export interface RunnerRequest {
    id: number;
    action: string;
    eventType: string;
    repositoryName: string;
    repositoryOwner: string;
    githubHost: string;
    isEnterprise: boolean;
    installationId: number;
    workflowName: string;
    workflowLabels: string[];
    startedAt: string;
    ttl: Date;
}

export function generateRunnerRequest(workflowJobEvent: WorkflowJobEvent, githubHost: string, isEnterprise: boolean) {
    if (workflowJobEvent.action !== 'queued') {
        throw new Error("Event action is not 'queued'");
    }

    if (!workflowJobEvent.installation?.id) {
        throw new Error('InstallationId not present');
    }

    const runnerRequest: RunnerRequest = {
        id: workflowJobEvent.workflow_job.id,
        action: workflowJobEvent.action,
        repositoryName: workflowJobEvent.repository.name,
        repositoryOwner: workflowJobEvent.repository.owner.login,
        workflowName: workflowJobEvent.workflow_job.name,
        workflowLabels: workflowJobEvent.workflow_job.labels,
        startedAt: workflowJobEvent.workflow_job.started_at,
        installationId: workflowJobEvent.installation.id,
        eventType: WorkflowEvent.WORKFLOW_JOB,
        githubHost,
        isEnterprise,
        ttl: getTTL(),
    };

    return runnerRequest;
}

export async function requeueRunnerRequestToSQS(runnerRequest: RunnerRequest, record: SQSRecord) {
    if (Date.now() > new Date(runnerRequest.ttl).getTime()) {
        logger.error(`TTL has expired. Request will be dropped. RunnerRequest: ${JSON.stringify(runnerRequest)}`);

        return;
    }

    logger.warn('Sending runner request back to the SQS queue');

    await sendSQSMessage(await getQueueUrl(record.eventSourceARN), JSON.stringify(runnerRequest), getSQSDelay(false));
}
