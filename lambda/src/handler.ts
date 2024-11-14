import { APIGatewayEvent, Context, SQSEvent } from 'aws-lambda';
import { printLogFields } from './lib/logFields';
import { logger, addLogEventHandler } from './lib/logger';
import { processRunnerEnvVars, processWebhookEnvVars } from './lib/env';
import { response } from './lib/http';
import { processGithubWebhook } from './webhook/webhook';
import { processRunnerRequest } from './requester/requester';
import { scaleUpLinux } from './runner/linux/linux';
import { scaleUpMacos } from './runner/macos/macos';
import { deleteRedisClient } from './lib/redis';

export async function githubWebhookHandler(event: APIGatewayEvent, context: Context) {
    try {
        addLogEventHandler(event, context);
        logger.info('Handling Github webhook event', printLogFields());

        await processGithubWebhook(event, processWebhookEnvVars());

        return response(200, 'Success');
    } catch (e) {
        logger.error((e as Error).message, printLogFields());

        return response(500, `Error processing webhook: ${(e as Error).message}`);
    }
}

export async function linuxScalingHandler(event: SQSEvent, context: Context) {
    try {
        addLogEventHandler(event, context);
        logger.info('Handling linux scaling event', printLogFields());

        await Promise.all(event.Records.map((record) => scaleUpLinux(record, processRunnerEnvVars())));
    } catch (e) {
        logger.error((e as Error).message, printLogFields());
    } finally {
        await deleteRedisClient();
    }
}

export async function macosScalingHandler(event: SQSEvent, context: Context) {
    try {
        addLogEventHandler(event, context);
        logger.info('Handling macOS scaling event', printLogFields());

        await Promise.all(event.Records.map((record) => scaleUpMacos(record, processRunnerEnvVars())));
    } catch (e) {
        logger.error((e as Error).message, printLogFields());
    }
}

export async function requesterHandler(event: any, context: Context) {
    try {
        addLogEventHandler(event, context);
        logger.info('Handling schedule runner request event', printLogFields());

        await processRunnerRequest(event, processWebhookEnvVars());

        return response(200, 'Success');
    } catch (e) {
        logger.error((e as Error).message, printLogFields());

        return response(500, `Error processing schedule runner request: ${(e as Error).message}`);
    }
}
