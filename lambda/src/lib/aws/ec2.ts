import {
    _InstanceType,
    CreateFleetCommand,
    CreateFleetCommandInput,
    CreateFleetCommandOutput,
    CreateTagsCommand,
    CreateTagsCommandInput,
    DescribeInstancesCommand,
    DescribeInstancesCommandInput,
    DescribeInstancesCommandOutput, DescribeInstanceStatusCommand,
    DescribeInstanceStatusCommandInput, DescribeInstanceStatusCommandOutput,
    DescribeTagsCommand,
    DescribeTagsCommandInput,
    DescribeTagsCommandOutput,
    EC2Client,
    Instance,
    TagDescription,
} from '@aws-sdk/client-ec2';
import { compact } from 'lodash';
import { getMandatoryEnvVar } from '../env';

export enum Lifecycle {
    SPOT = 'spot',
    ON_DEMAND = 'on-demand',
}

export interface EC2Instance extends Instance {
    InstanceId: string;
    InstanceType: _InstanceType;
}

export function getEC2Client(region?: string) {
    // AWS SDK uses AWS_REGION env var by default but we specify it here as best practice
    return new EC2Client({ region: region ? region : getMandatoryEnvVar('AWS_REGION') });
}

export function getInstancesListFromFleet(fleet: CreateFleetCommandOutput) {
    return fleet.Instances?.flatMap((i) => i.InstanceIds?.flatMap((j) => j) || []) || [];
}

export async function launchFleet(createFleetRequestInput: CreateFleetCommandInput) {
    const ec2 = getEC2Client();

    try {
        const command = new CreateFleetCommand(createFleetRequestInput);

        return await ec2.send(command);
    } catch (e) {
        throw new Error(`Error launching fleet: ${e}`);
    }
}

export async function describeInstances(describeInstancesRequest: DescribeInstancesCommandInput, region?: string) {
    const ec2 = getEC2Client(region);

    let allInstances: any[] = [];
    let response: DescribeInstancesCommandOutput;

    const command = new DescribeInstancesCommand(describeInstancesRequest);

    try {
        do {
            response = await ec2.send(command);
            allInstances = allInstances.concat(compact(response.Reservations));
            describeInstancesRequest.NextToken = response.NextToken;
        } while (response.NextToken);

        return allInstances;
    } catch (e) {
        throw new Error(`Error describing instances: ${e}`);
    }
}

export async function describeTags(describeTags: DescribeTagsCommandInput) {
    const ec2 = getEC2Client();

    let allTags: any[] = [];
    let response: DescribeTagsCommandOutput;

    const command = new DescribeTagsCommand(describeTags);

    try {
        do {
            response = await ec2.send(command);
            allTags = allTags.concat(compact(response.Tags));
            describeTags.NextToken = response.NextToken;
        } while (response.NextToken);

        return allTags;
    } catch (error) {
        throw new Error(`Error describing tags: ${error}`);
    }
}

export async function createTags(createTagsInput: CreateTagsCommandInput) {
    const ec2 = getEC2Client();

    const command = new CreateTagsCommand(createTagsInput);

    try {
      return await ec2.send(command);
    } catch (error) {
        throw new Error(`Error creating tags: ${error}`);
    }
}

export async function describeInstanceStatus(describeInstanceRequest: DescribeInstanceStatusCommandInput) {
    const ec2 = getEC2Client();

    let allInstanceStatus: any[] = [];
    let response: DescribeInstanceStatusCommandOutput;

    const command = new DescribeInstanceStatusCommand(describeInstanceRequest);

    try {
        do {
            response = await ec2.send(command);
            allInstanceStatus = allInstanceStatus.concat(compact(response.InstanceStatuses));
            describeInstanceRequest.NextToken = response.NextToken;
        } while (response.NextToken);

        return allInstanceStatus;
    } catch (e) {
        throw new Error(`Error describing instance status: ${e}`);
    }
}

export function removeAWSTags(tags: TagDescription[]) {
    return tags.filter((tag) => !tag.Key?.startsWith('aws:'));
}

export function validateEC2Instance(instance: Instance) {
    if (!instance.InstanceId) {
        throw new Error('No InstanceId');
    }

    if (!instance.InstanceType) {
        throw new Error('No InstanceType');
    }

    const ec2Instance: EC2Instance = {
        ...instance,
        InstanceId: instance.InstanceId,
        InstanceType: instance.InstanceType,
    };

    return ec2Instance;
}

export function validateEC2Instances(instances: EC2Instance[]) {
    return instances.map((instance) => validateEC2Instance(instance));
}
