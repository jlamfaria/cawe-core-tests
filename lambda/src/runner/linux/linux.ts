import { SQSRecord } from 'aws-lambda';
import { processGithubDetails } from '../../lib/github';
import { logger } from '../../lib/logger';
import { RunnerEnvVars } from '../../lib/env';
import { scaleUpLinuxFromPool } from './pool';
import { scaleUpLinuxAdHoc } from './adhoc';
import { RunnerRequest, requeueRunnerRequestToSQS } from '../runnerRequest';

export async function scaleUpLinux(record: SQSRecord, runnerEnvVars: RunnerEnvVars) {
    logger.info(`Processing scale up event: ${JSON.stringify({ record, runnerEnvVars })}`);

    const runnerRequest: RunnerRequest = JSON.parse(record.body);

    if (runnerRequest.action !== 'queued') {
        throw new Error('Event action type is not supported');
    }

    const githubDetails = await processGithubDetails(runnerEnvVars, runnerRequest);

    try {
        await scaleUpLinuxFromPool(runnerEnvVars, runnerRequest, githubDetails);
    } catch (e) {
        logger.warn((e as Error).message);
        try {
            await scaleUpLinuxAdHoc(runnerEnvVars, githubDetails);
        } catch (e) {
            logger.warn((e as Error).message);
            await requeueRunnerRequestToSQS(runnerRequest, record);
        }
    }
}
