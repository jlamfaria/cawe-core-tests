import { updateKeyValueArray } from '../lib/utils';
import {
    validateEC2Instances,
    describeInstances,
    describeInstanceStatus,
    createTags,
    describeTags,
    removeAWSTags,
    EC2Instance,
} from '../lib/aws/ec2';
import { RunnerMetadata } from './linux/metadata';
import { compact, flatten } from 'lodash';
import { EC2 } from 'aws-sdk';
import { getRedisClient } from '../lib/redis';
import { REDIS_DB_INSTANCES, REDIS_EXPIRE_TTL } from '../config';
import { logger } from '../lib/logger';

export enum RunnerType {
    ADHOC = 'adhoc',
    POOL = 'pool',
}

export enum RunnerTimer {
    ORG_IDLE = '1',
    DISABLED = '0',
    SPOT = '-1',
}

export enum RunnerState {
    PROVISIONING = 'provisioning',
    PROVISIONED = 'provisioned',
    REGISTERING = 'registering',
    REGISTERED = 'registered',
    IN_USE = 'in_use',
    ROTTEN = 'rotten',
    EXPIRED = 'expired',
    RECYCLED = 'recycled',
}

export async function getEC2InstanceById(instanceId: string) {
    const describeInstanceRequest: EC2.DescribeInstancesRequest = {
        Filters: [
            {
                Name: 'instance-id',
                Values: [instanceId],
            },
        ],
    };

    const rawRunners = await fetchRunners(describeInstanceRequest);
    const ec2Runners = validateEC2Instances(rawRunners);

    if (ec2Runners.length === 0) {
        throw new Error(`No instance matching instanceId: ${instanceId}`);
    }

    return ec2Runners[0];
}

export function filterInstancesById(runningInstances: EC2Instance[], instanceIds: string[]) {
    return runningInstances.filter((instance) => instance.InstanceId && instanceIds.includes(instance.InstanceId));
}

export async function filterHealthyInstances(instanceIds: string[]) {
    return await describeInstanceStatus({
        InstanceIds: instanceIds,
        Filters: [
            // Filter "healthy" instances
            {
                Name: 'instance-status.status',
                Values: ['ok'],
            },
        ],
    });
}

export async function fetchRunners(describeInstancesRequest: EC2.DescribeInstancesRequest, region?: string) {
    const runningInstancesOfSpecificTypeAndSize = await describeInstances(describeInstancesRequest, region);

    const runningInstances = flatten(
        compact(runningInstancesOfSpecificTypeAndSize.map((reservation) => reservation.Instances)),
    );

    return runningInstances;
}

export async function getTags(instanceId: string) {
    const describeTagsParams = {
        Filters: [
            {
                Name: 'resource-id',
                Values: [instanceId],
            },
        ],
    };

    return await describeTags(describeTagsParams);
}

export async function updateTags(instanceId: string, oldTags: EC2.Types.Tag[], newTags: EC2.Types.Tag[]) {
    const filteredResult = removeAWSTags(oldTags);
    const allTags = updateKeyValueArray(filteredResult, newTags);

    const createTagsParams = {
        Resources: [instanceId],
        Tags: allTags.map((tag) => ({
            Key: tag.Key,
            Value: tag.Value,
        })),
    };

    await createTags(createTagsParams);
}

export async function getRunnerMetadataFromRedis(instanceId: string) {
    const redisClient = await getRedisClient();

    await redisClient.select(REDIS_DB_INSTANCES);

    logger.debug(`Getting instance metadata from redis db${REDIS_DB_INSTANCES} key for instanceId: ${instanceId}`);

    const runnerMetadata: RunnerMetadata = (await redisClient.json.get(instanceId)) as any;

    if (!runnerMetadata) {
        throw new Error('No instance found on redis db');
    }

    logger.debug(
        `Instance metadata: ${JSON.stringify(
            runnerMetadata,
        )} from redis db${REDIS_DB_INSTANCES} key for instanceId: ${instanceId}`,
    );

    return runnerMetadata;
}

export async function setRunnerMetadataToRedis(instanceId: string, runnerMetadata: RunnerMetadata) {
    const redisClient = await getRedisClient();

    await redisClient.select(REDIS_DB_INSTANCES);

    logger.debug(
        `Setting instance metadata: ${JSON.stringify(
            runnerMetadata,
        )} on redis db${REDIS_DB_INSTANCES} key for instanceId: ${instanceId}`,
    );

    await redisClient.json.set(instanceId, '$', runnerMetadata as any);
}

export async function setRunnerState(instanceId: string, state: RunnerMetadata['state']) {
    const redisClient = await getRedisClient();

    await redisClient.select(REDIS_DB_INSTANCES);

    logger.debug(`Setting instance state: ${state} on redis db${REDIS_DB_INSTANCES} key for instanceId: ${instanceId}`);

    await redisClient.json.set(instanceId, '$.state', state);
}

export async function setRunnerExpirationTTLOnRedis(instanceId: string) {
    const redisClient = await getRedisClient();

    await redisClient.select(REDIS_DB_INSTANCES);

    const ttl = REDIS_EXPIRE_TTL;

    logger.debug(`Setting redis db${REDIS_DB_INSTANCES} key expiration TTL for instanceId: ${instanceId} TTL: ${ttl}`);

    await redisClient.expire(instanceId, ttl);
}
