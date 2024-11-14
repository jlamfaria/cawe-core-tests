import { Lifecycle, getInstancesListFromFleet, launchFleet } from '../../lib/aws/ec2';
import { GithubDetails } from '../../lib/github';
import { RunnerEnvVars } from '../../lib/env';
import { logger } from '../../lib/logger';
import { RunnerType } from '../runner';
import {
    _InstanceType,
    CreateFleetCommandInput,
    DefaultTargetCapacityType,
    FleetLaunchTemplateOverridesRequest,
} from '@aws-sdk/client-ec2';

export interface TargetAWSResources {
    launchTemplateName: string;
    instanceTypes: _InstanceType[];
}

export interface AWSResourcesMapping {
    [key: string]: TargetAWSResources;
}

export const AWS_RESOURCES_MAPPING: AWSResourcesMapping = {
    //general
    'dependabot': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c6a.large'],
    },
    'cawe-linux-x64-general-small': {
        // 2cpu 2gb ram -> small cpu burst
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.small', 't3.small'],
    },
    'cawe-linux-x64-general-medium': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.medium', 't2.medium', 'a1.large', 't3.medium'],
    },
    'cawe-linux-x64-general-large': {
        // 4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.xlarge', 't2.xlarge', 't3.xlarge'],
    },
    // compute
    'cawe-linux-x64-compute-small': {
        //2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c6i.large', 'c5a.large', 'c6a.large', 'c5.large'],
    },
    'cawe-linux-x64-compute-medium': {
        //4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c4.xlarge', 'c3.xlarge', 'c5a.xlarge'],
    },
    'cawe-linux-x64-compute-large': {
        //8cpu 16gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c5a.2xlarge', 'c6a.2xlarge', 'c6i.2xlarge', 'c5.2xlarge'],
    },
    // memory
    'cawe-linux-x64-memory-small': {
        // 2cpu 15gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r6a.large', 'r3.large', 'r5a.large'],
    },
    'cawe-linux-x64-memory-medium': {
        // 4cpu 30gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r3.xlarge', 'r6a.xlarge', 'r5a.xlarge'],
    },
    'cawe-linux-x64-memory-large': {
        // 8cpu 60gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r3.2xlarge', 'r6a.2xlarge', 'r5a.2xlarge'],
    },
    //------------------------------------------------------------------- Linux Ubuntu Arm ----------------------------------------
    'cawe-linux-arm64-general-small': {
        // 2cpu 2gb ram -> small cpu burst
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['t4g.small'],
    },
    'cawe-linux-arm64-general-medium': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['a1.large', 't4g.medium'],
    },
    'cawe-linux-arm64-general-large': {
        // 4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['m6g.large', 'm6gd.large', 't4g.large'],
    },
    // compute
    'cawe-linux-arm64-compute-small': {
        //2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.large', 'c6gd.large', 'c6gn.large', 'c7g.large'],
    },
    'cawe-linux-arm64-compute-medium': {
        //4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.xlarge', 'c6gd.xlarge', 'c6gn.xlarge', 'c7g.xlarge'],
    },
    'cawe-linux-arm64-compute-large': {
        //8cpu 16gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.2xlarge', 'c6gd.2xlarge', 'c6gn.2xlarge', 'c7g.2xlarge'],
    },
    // memory
    'cawe-linux-arm64-memory-small': {
        // 2cpu 15gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.large', 'r6gd.large'],
    },
    'cawe-linux-arm64-memory-medium': {
        // 4cpu 30gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.xlarge', 'r6gd.xlarge'],
    },
    'cawe-linux-arm64-memory-large': {
        // 8cpu 60gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.2xlarge', 'r6gd.2xlarge'],
    },
    //------------------------------------------------------------------- Linux Ubuntu x64 with -cn suffix ----------------------------------------
    'dependabot-cn': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c6a.large'],
    },
    'cawe-linux-x64-general-small-cn': {
        // 2cpu 2gb ram -> small cpu burst
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.small', 't3.small'],
    },
    'cawe-linux-x64-general-medium-cn': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.medium', 't2.medium', 'a1.large', 't3.medium'],
    },
    'cawe-linux-x64-general-large-cn': {
        // 4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['t3a.xlarge', 't2.xlarge', 't3.xlarge'],
    },
    // compute
    'cawe-linux-x64-compute-small-cn': {
        //2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c6i.large', 'c5a.large', 'c6a.large', 'c5.large'],
    },
    'cawe-linux-x64-compute-medium-cn': {
        //4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c4.xlarge', 'c3.xlarge', 'c5a.xlarge'],
    },
    'cawe-linux-x64-compute-large-cn': {
        //8cpu 16gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['c5a.2xlarge', 'c6a.2xlarge', 'c6i.2xlarge', 'c5.2xlarge'],
    },
    // memory
    'cawe-linux-x64-memory-small-cn': {
        // 2cpu 15gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r6a.large', 'r3.large', 'r5a.large'],
    },
    'cawe-linux-x64-memory-medium-cn': {
        // 4cpu 30gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r3.xlarge', 'r6a.xlarge', 'r5a.xlarge'],
    },
    'cawe-linux-x64-memory-large-cn': {
        // 8cpu 60gb ram
        launchTemplateName: 'cawe-runner-launch-template-x64',
        instanceTypes: ['r3.2xlarge', 'r6a.2xlarge', 'r5a.2xlarge'],
    },
    //------------------------------------------------------------------- Linux Ubuntu Arm with -cn suffix ----------------------------------------
    'cawe-linux-arm64-general-small-cn': {
        // 2cpu 2gb ram -> small cpu burst
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['t4g.small'],
    },
    'cawe-linux-arm64-general-medium-cn': {
        // 2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['a1.large', 't4g.medium'],
    },
    'cawe-linux-arm64-general-large-cn': {
        // 4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['m6g.large', 'm6gd.large', 't4g.large'],
    },
    // compute
    'cawe-linux-arm64-compute-small-cn': {
        //2cpu 4gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.large', 'c6gd.large', 'c6gn.large', 'c7g.large'],
    },
    'cawe-linux-arm64-compute-medium-cn': {
        //4cpu 8gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.xlarge', 'c6gd.xlarge', 'c6gn.xlarge', 'c7g.xlarge'],
    },
    'cawe-linux-arm64-compute-large-cn': {
        //8cpu 16gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['c6g.2xlarge', 'c6gd.2xlarge', 'c6gn.2xlarge', 'c7g.2xlarge'],
    },
    // memory
    'cawe-linux-arm64-memory-small-cn': {
        // 2cpu 15gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.large', 'r6gd.large'],
    },
    'cawe-linux-arm64-memory-medium-cn': {
        // 4cpu 30gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.xlarge', 'r6gd.xlarge'],
    },
    'cawe-linux-arm64-memory-large-cn': {
        // 8cpu 60gb ram
        launchTemplateName: 'cawe-runner-launch-template-arm64',
        instanceTypes: ['r6g.2xlarge', 'r6gd.2xlarge'],
    },
};

export async function createAdhocRunnerByLifecyle(
    runnerEnvVars: RunnerEnvVars,
    githubDetails: GithubDetails,
    lifecycle: Lifecycle,
) {
    logger.debug(`Attempting ${lifecycle} instance`);

    const fleetRequestConfig = createFleetRequest(runnerEnvVars, githubDetails, lifecycle);
    const fleet = await launchFleet(fleetRequestConfig);

    logger.debug(`Create EC2 fleet response: ${JSON.stringify(fleet)}`);

    const instances = getInstancesListFromFleet(fleet);

    if (instances.length === 0) {
        throw new Error('AWS returned a fleet with 0 instances');
    }

    logger.info(`Created fleet with instance(s): ${JSON.stringify(instances)}`);

    return fleet;
}

/**
 * EC2 fleet spec:
 * https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateFleet.html
 * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet.html
 * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-fleet-examples.html
 * https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.Client.create_fleet
 */
export function createFleetRequest(
    runnerEnvVars: RunnerEnvVars,
    githubDetails: GithubDetails,
    instanceLifecycle: DefaultTargetCapacityType,
) {

    const caweLabelWithoutId = githubDetails.runnerDetails.labels[0].split('_')[0];
    const linuxTarget = AWS_RESOURCES_MAPPING[caweLabelWithoutId];

    if (!linuxTarget) {
        throw new Error(
            `Unable to find a suitable aws resource configuration with: ${githubDetails.runnerDetails.labels[0]}`,
        );
    }

    const overrides: FleetLaunchTemplateOverridesRequest[] = [];

    runnerEnvVars.subnets.forEach((s) => {
        linuxTarget.instanceTypes.forEach((i) => {
            overrides.push({
                SubnetId: s,
                InstanceType: i,
            });
        });
    });

    const config: CreateFleetCommandInput = {
        LaunchTemplateConfigs: [
            {
                LaunchTemplateSpecification: {
                    LaunchTemplateName: linuxTarget.launchTemplateName,
                    Version: '$Default',
                },
                Overrides: overrides,
            },
        ],
        SpotOptions: {
            AllocationStrategy: 'capacity-optimized',
        },
        OnDemandOptions: {
            AllocationStrategy: 'lowest-price',
        },
        TargetCapacitySpecification: {
            TotalTargetCapacity: 1,
            DefaultTargetCapacityType: instanceLifecycle,
        },
        TagSpecifications: [
            {
                ResourceType: 'instance',
                Tags: [
                    { Key: 'Type', Value: RunnerType.ADHOC },
                    { Key: 'Owner', Value: githubDetails.repositoryOwner },
                    {
                        Key: 'Name',
                        Value: `adhoc-${githubDetails.runnerDetails.labels[0].replace('cawe-', '')}-${
                            githubDetails.repositoryOwner
                        }`,
                    },
                    { Key: 'Workflow_Labels', Value: githubDetails.workflowDetails.workflowLabels.join(',') },
                    { Key: 'Workflow_Started_Time', Value: githubDetails.workflowDetails.startedAt },
                ],
            },
        ],
        Type: 'instant',
    };

    logger.info(`Will create a new EC2 fleet based on the configuration: ${JSON.stringify(config)}`);

    return config;
}
