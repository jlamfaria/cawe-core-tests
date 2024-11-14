import got from 'got';
import * as short from 'short-uuid';
import { shuffle } from 'lodash';
import { SQSRecord } from 'aws-lambda';
import { processGithubDetails } from '../../lib/github';
import { logger } from '../../lib/logger';
import { RunnerEnvVars } from '../../lib/env';
import { validateEC2Instances } from '../../lib/aws/ec2';
import { checkQoSUsage, listMacOsHosts } from './macosUtils';
import { RunnerRequest, requeueRunnerRequestToSQS } from '../runnerRequest';

export interface MacOSHostVMRequest {
    job_id: string;
    macos_version: string;
    config: {
        org: string;
        repo: string;
        url: string;
        labels: string[];
        token: string;
        runnerGroup: string;
    };
}

export async function scaleUpMacos(record: SQSRecord, runnerEnvVars: RunnerEnvVars) {
    logger.info(
        `Processing scale up event: ${JSON.stringify({
            record,
            runnerEnvVars,
        })}`,
    );

    const runnerRequest: RunnerRequest = JSON.parse(record.body);
    const githubDetails = await processGithubDetails(runnerEnvVars, runnerRequest);
    const macOSHosts = await listMacOsHosts();
    const validatedHosts = validateEC2Instances(macOSHosts);

    const shuffledHosts = shuffle(validatedHosts);

    logger.debug(`Available hosts: ${JSON.stringify(shuffledHosts.map((host) => host.InstanceId))}`);

    if (shuffledHosts.length == 0) {
        logger.warn('No macOS hosts available');
        await requeueRunnerRequestToSQS(runnerRequest, record);

        return;
    }

    if (!(await checkQoSUsage(shuffledHosts, runnerRequest, githubDetails, record))) {
        return;
    }

    for (const host of shuffledHosts) {
        logger.debug(`Attempting with ${host.InstanceId}`);

        const request: MacOSHostVMRequest = {
            job_id: `${host.InstanceId}-${short.generate().slice(0, 6)}`,
            macos_version: 'sonoma',
            config: {
                org: githubDetails.repositoryOwner,
                repo: githubDetails.repositoryName,
                url: githubDetails.runnerDetails.url.href,
                labels: githubDetails.runnerDetails.labels,
                token: githubDetails.runnerDetails.registrationToken,
                runnerGroup: githubDetails.runnerDetails.runnerGroup,
            },
        };

        logger.debug(`Request info: ${JSON.stringify(request)}`);

        try {
            const { body } = await got.post(`http://${host.PrivateIpAddress}/VM/request`, {
                json: request,
            });

            logger.info(`Allocated VM on: ${host.InstanceId} response: ${body}`);

            return;
        } catch (e) {
            logger.warn(`Unable to allocate VM on host: ${host.InstanceId}`);

            if ((e as Error).message) {
                logger.warn(`Error: ${(e as Error).message}`);
            }
        }
    }

    logger.info('No allocation available in any host');

    await requeueRunnerRequestToSQS(runnerRequest, record);
}
