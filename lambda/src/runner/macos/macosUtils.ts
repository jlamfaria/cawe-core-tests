import { SQSRecord } from 'aws-lambda';
import { EC2Instance } from '../../lib/aws/ec2';
import { GithubDetails } from '../../lib/github';
import { getCurrentMacOsUsage } from '../../lib/monitoring';
import { logger } from '../../lib/logger';
import { fetchRunners } from '../runner';
import { RunnerRequest, requeueRunnerRequestToSQS } from '../runnerRequest';
import { MACOS_MAX_ALLOCATION_PERCENTAGE } from '../../config';

export async function listMacOsHosts() {
    const params = {
        Filters: [
            {
                Name: 'instance-state-name',
                Values: ['running'],
            },
            {
                Name: 'tag:Os',
                Values: ['macos'],
            },
            {
                Name: 'tag:State',
                Values: ['provisioned'],
            },
        ],
    };

    logger.debug(`Filter macos instances: ${JSON.stringify(params)}`);

    return await fetchRunners(params, 'eu-west-1');
}

export async function checkQoSUsage(
    hosts: EC2Instance[],
    runnerRequest: RunnerRequest,
    githubDetails: GithubDetails,
    record: SQSRecord,
) {
    const currentMacOsUsage = await getCurrentMacOsUsage(githubDetails.repositoryOwner);
    const nextMacOSUsage = currentMacOsUsage + 1;
    const total = hosts.length * 2;
    const newPercentage = (nextMacOSUsage / total) * 100;

    logger.info(
        `Usage count by ${githubDetails.repositoryOwner} org: ${nextMacOSUsage} out of ${total} VMs = ${newPercentage}%`,
    );
    logger.info(
        `Usage quota by ${githubDetails.repositoryOwner} org: ${newPercentage}% out of ${MACOS_MAX_ALLOCATION_PERCENTAGE}%`,
    );

    if (newPercentage > MACOS_MAX_ALLOCATION_PERCENTAGE) {
        logger.warn(`Org ${githubDetails.repositoryOwner} has reached the maximum macOS VM allocation`);

        await requeueRunnerRequestToSQS(runnerRequest, record);

        return false;
    }

    return true;
}
