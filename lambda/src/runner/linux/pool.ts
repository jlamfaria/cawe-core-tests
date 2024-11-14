import { GithubDetails } from '../../lib/github';
import { logger } from '../../lib/logger';
import { RunnerRequest } from '../runnerRequest';
import { RunnerEnvVars } from '../../lib/env';
import { assignEC2Instance, popInstanceFromRedis } from './poolUtils';

export async function scaleUpLinuxFromPool(
    runnerEnvVars: RunnerEnvVars,
    runnerRequest: RunnerRequest,
    githubDetails: GithubDetails,
) {
    logger.info('Processing scale up with instance from the pool');

    const caweLabel = githubDetails.runnerDetails.labels[0];

    let assigned = false;

    while (!assigned) {
        const caweLabelWithoutId = caweLabel.split('_')[0];

        const instanceId = await popInstanceFromRedis(caweLabelWithoutId);

        if (!instanceId) {
            throw new Error(`Redis LPOP returned no instance matching ${caweLabelWithoutId}`);
        }

        logger.debug(`instanceId: ${instanceId}`);

        try {
            await assignEC2Instance(instanceId, runnerEnvVars, runnerRequest, githubDetails);

            assigned = true;
        } catch (e) {
            logger.warn(`Failed to assign instance from the pool. Error: ${(e as Error).message}`);
            logger.info('Will try to fetch another instance from the pool');
        }
    }
}
