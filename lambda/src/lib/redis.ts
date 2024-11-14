import { RedisClientType, RedisDefaultModules, RedisFunctions, RedisModules, RedisScripts, createClient } from 'redis';
import { processRunnerEnvVars } from './env';
import { logger } from './logger';

let redisClient: RedisClientType<RedisDefaultModules & RedisModules, RedisFunctions, RedisScripts> | null;

export async function getRedisClient() {
    if (redisClient) {
        return redisClient;
    }

    const runnerEnvVars = processRunnerEnvVars();
    const url = `redis://${runnerEnvVars.redisUrl}:${runnerEnvVars.redisPort}`;

    logger.debug(`Connecting to redis instance on url: ${url}`);

    const client = createClient({ url });

    client.on('error', (err) => {
        throw new Error(`Redis Client Error: ${err}`);
    });

    await client.connect();

    redisClient = client;

    return client;
}

export async function deleteRedisClient() {
    if (redisClient) {
        await redisClient.disconnect();
    }

    redisClient = null;
}
