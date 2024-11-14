import { getRedisClient } from '../../lib/redis';
import {
    getEC2InstanceById,
    getRunnerMetadataFromRedis,
    RunnerState,
    RunnerTimer,
    RunnerType,
    setRunnerExpirationTTLOnRedis,
    setRunnerMetadataToRedis,
    updateTags,
} from '../runner';
import { logger } from '../../lib/logger';
import { sendCommand } from '../../lib/aws/ssm';
import { GithubDetails } from '../../lib/github';
import { RunnerRequest } from '../runnerRequest';
import { RunnerEnvVars } from '../../lib/env';
import { generateMetadata } from './metadata';
import { sleep, timeoutPromise } from '../../lib/utils';
import {
    LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_INITAL_DELAY,
    LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_INTERVAL,
    LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_TIMEOUT,
    REDIS_DB_POOL,
} from '../../config';

export async function popInstanceFromRedis(caweLabel: string) {
    const redisClient = await getRedisClient();

    await redisClient.select(REDIS_DB_POOL);

    return await redisClient.LPOP(caweLabel);
}

export async function validateInstanceRegistration(instanceId: string) {
    while (true) {
        try {
            const runnerMetadata = await getRunnerMetadataFromRedis(instanceId);

            logger.debug(`Instance: ${instanceId} Metadata: ${JSON.stringify(runnerMetadata)}`);

            if (!runnerMetadata.state) {
                throw new Error(`Instance: ${instanceId} has no state field on metadata stored in redis`);
            }

            if (
                runnerMetadata.state === 'registered' ||
                runnerMetadata.state === 'in_use' ||
                runnerMetadata.state === 'rotten'
            ) {
                logger.info(`Instance: ${instanceId} was registered on Github org successfully`);

                return;
            }
        } catch (e) {
            logger.warn((e as Error).message);
        }

        await sleep(LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_INTERVAL * 1000);
    }
}

export async function assignEC2Instance(
    instanceId: string,
    runnerEnvVars: RunnerEnvVars,
    runnerRequest: RunnerRequest,
    githubDetails: GithubDetails,
) {
    const poolRunner = await getEC2InstanceById(instanceId);

    logger.debug(`poolRunner: ${JSON.stringify(poolRunner)}`);

    if (poolRunner.State?.Name !== 'running') {
        throw new Error(
            `Instance: ${instanceId} is not in running state. StateTransitionReason: ${poolRunner.StateTransitionReason}`,
        );
    }

    try {
        const runnerMetadata = await getRunnerMetadataFromRedis(instanceId);

        await setRunnerExpirationTTLOnRedis(instanceId);

        if (!runnerMetadata.state) {
            logger.warn(`Instance: ${instanceId} has no state property on metadata`);
        }

        if (runnerMetadata.state !== 'provisioned') {
            logger.warn(`Instance: ${instanceId} is not in state: provisioned`);
        }
    } catch (e) {
        logger.warn(`Failed to check provisioned state from metadata stored in redis. Error: ${(e as Error).message}`);
        logger.info('Will try to proceed with instance assignment anyway');
    }

    const metadata = generateMetadata(
        runnerEnvVars,
        poolRunner,
        githubDetails,
        RunnerType.POOL,
        RunnerState.REGISTERING,
        RunnerTimer.ORG_IDLE,
    );

    await setRunnerMetadataToRedis(instanceId, metadata);
    await setRunnerExpirationTTLOnRedis(instanceId);

    await updateTags(instanceId, poolRunner.Tags || [], [
        {
            Key: 'Name',
            Value: `pool-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                githubDetails.repositoryOwner
            }`,
        },
        {
            Key: 'Owner',
            Value: githubDetails.repositoryOwner,
        },
        {
            Key: 'Workflow_Labels',
            Value: runnerRequest.workflowLabels.join(',') || '',
        },
        {
            Key: 'Workflow_Started_Time',
            Value: runnerRequest.startedAt || '',
        },
    ]);

    await sendCommand(instanceId, '/etc/gha/register.sh');

    logger.info(
        `Waiting for command to be executed. Delay: ${LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_INITAL_DELAY} seconds`,
    );

    await sleep(LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_INITAL_DELAY * 1000);

    await timeoutPromise(
        LINUX_POOL_VALIDATE_GITHUB_REGISTRATION_TIMEOUT * 1000,
        validateInstanceRegistration(instanceId),
        'Timeout while waiting for pool instance registration on Github!',
    );
}
