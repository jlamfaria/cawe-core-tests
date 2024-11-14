import { SendMessageRequest, SQS } from '@aws-sdk/client-sqs';
import { getMandatoryEnvVar } from '../env';
import { logger } from '../logger';

export function getSQSClient(region?: string) {
    // AWS SDK uses AWS_REGION env var by default but we specify it here as best practice
    return new SQS({ region: region ? region : getMandatoryEnvVar('AWS_REGION') });
}

export async function sendSQSMessage(queueUrl: string, messageBody: string, delay?: number, messageGroupId?: string) {
    const client = getSQSClient();

    const params: SendMessageRequest = {
        MessageBody: messageBody,
        QueueUrl: queueUrl,
    };

    if (delay) {
        params.DelaySeconds = delay;
    }

    if (messageGroupId) {
        params.MessageGroupId = messageGroupId;
    }

    try {
        await client.sendMessage(params);
        logger.info(`Message sent to SQS: ${JSON.stringify(params)}`);
    } catch (error) {
        throw new Error(`Error sending message to SQS. Error: ${(error as Error).message}`);
    }
}

export async function getQueueUrl(queueArn: string) {
    const sqs = getSQSClient();

    const params = {
        QueueName: queueArn.split(':').slice(-1)[0],
    };

    const getQueueUrlOutput = await sqs.getQueueUrl(params);
    const queueUrl = getQueueUrlOutput.QueueUrl;

    if (!queueUrl) {
        throw new Error(`Unable to get queue url based on queueArn: ${queueArn}`);
    }

    return queueUrl;
}
