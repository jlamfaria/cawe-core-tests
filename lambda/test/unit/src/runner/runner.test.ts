import { EC2 } from 'aws-sdk';
import { compact, flatten } from 'lodash';
import * as ec2 from '../../../../src/lib/aws/ec2';
import * as logger from '../../../../src/lib/logger';
import * as utils from '../../../../src/lib/utils';
import { GithubDetails, AppInstallationLevel } from '../../../../src/lib/github';
import {
    fetchRunners,
    filterHealthyInstances,
    filterInstancesById,
    getTags,
    updateTags,
} from '../../../../src/runner/runner';
import * as sinon from 'sinon';
import 'jest-extended';
import path from 'path';
import { _InstanceType } from '@aws-sdk/client-ec2';

jest.mock('../../../../src/lib/utils');
jest.mock('../../../../src/lib/logger');
jest.mock('../../../../src/lib/aws/ec2');

const utilsMock = utils as jest.Mocked<typeof utils>;
const loggerMock = logger as jest.Mocked<typeof logger>;
const ec2Mock = ec2 as jest.Mocked<typeof ec2>;

const githubDetails: GithubDetails = {
    apiUrl: new URL('https://example.com/api/v1'),
    githubHost: 'https://example.com/',
    isEnterprise: true,
    repositoryOwner: 'repoOwner',
    repositoryName: 'repoName',
    appDetails: {
        appId: 0,
        privateKey: '',
        appAuthToken: '',
    },
    installationDetails: {
        installationId: 0,
        installationLevel: AppInstallationLevel.ORG,
        installationAuthToken: '',
    },
    runnerDetails: {
        url: new URL(`https://${path.join('https://example.com/', 'repoOwner', 'repoName')}`),
        registrationToken: '',
        labels: [],
        runnerGroup: 'rg',
    },
    workflowDetails: {
        workflowLabels: [],
        startedAt: '',
    },
};

describe('runner', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('filterHealthyInstances', () => {
        it('should Return Healthy Instances', async () => {
            const instanceIds: string[] = ['cawe-1', 'cawe-2', 'cawe-3'];
            const result = [
                {
                    InstanceId: 'cawe-1',
                    InstanceStatus: {
                        Status: 'ok',
                    },
                },
            ];

            ec2Mock.describeInstanceStatus.mockResolvedValue(result);

            const healthyInstances = await filterHealthyInstances(instanceIds);

            expect(healthyInstances).toStrictEqual(result);
        });
    });

    describe('filterInstancesById', () => {
        it('should filter instances by Id', () => {
            const runningInstances: ec2.EC2Instance[] = [
                {
                    InstanceId: 'cawe',
                    InstanceType: _InstanceType.a1_metal,
                },
                {
                    InstanceId: 'cawe-1',
                    InstanceType: _InstanceType.a1_metal,
                },
            ];

            const ids = ['cawe'];

            expect(filterInstancesById(runningInstances, ids)).toEqual([{ InstanceId: 'cawe', InstanceType: 'a1.metal' }]);
        });
    });

    describe('fetchRunners', () => {
        it('should return running instances', async () => {
            const allInstances: EC2.Reservation[] = [
                {
                    Instances: [
                        {
                            InstanceId: 'cawe-1',
                            Tags: [
                                {
                                    Key: 'tag:State',
                                    Value: 'provisioned',
                                },
                                {
                                    Key: 'tag:aws:autoscaling:groupName',
                                    Value: 'cawe-linux-x64-general-medium',
                                },
                            ],
                        },
                    ],
                },
            ];
            const describeInstancesRequest: EC2.DescribeInstancesRequest = {
                Filters: [
                    // Filter "running" instances
                    {
                        Name: 'instance-state-name',
                        Values: ['running'],
                    },
                    // Filter "Provisioned" instances from the pools
                    {
                        Name: 'tag:' + 'State',
                        Values: ['provisioned'],
                    },
                    // Filter by CAWE label
                    {
                        Name: 'tag:' + 'aws:autoscaling:groupName',
                        Values: [githubDetails.runnerDetails.labels[0]],
                    },
                ],
            };

            const runningInstances = flatten(compact(allInstances.map((reservation) => reservation.Instances)));

            ec2Mock.describeInstances.mockResolvedValue(allInstances);

            const result = await fetchRunners(describeInstancesRequest);

            expect(result).toStrictEqual(runningInstances);
        });
    });

    describe('getTags', () => {
        it('should resolve with the current instance tags', async () => {
            const instanceId = 'id1';
            const tagsResult: EC2.Types.Tag[] = [
                {
                    Key: 'key-a',
                    Value: 'value-a',
                },
            ];

            const describeTagsParams = {
                Filters: [
                    {
                        Name: 'resource-id',
                        Values: [instanceId],
                    },
                ],
            };

            ec2Mock.describeTags.mockResolvedValue(tagsResult);

            const result = await getTags(instanceId);

            expect(ec2Mock.describeTags).toHaveBeenCalledWith(describeTagsParams);
            expect(result).toEqual(tagsResult);
        });

        it('should reject if describeTags rejects', async () => {
            const instanceId = 'id1';
            const tagsResult: EC2.Types.Tag[] = [
                {
                    Key: 'key-a',
                    Value: 'value-a',
                },
            ];

            const describeTagsParams = {
                Filters: [
                    {
                        Name: 'resource-id',
                        Values: [instanceId],
                    },
                ],
            };

            const describeTagsMockedError = new Error('describeTagsMockedError');

            ec2Mock.describeTags.mockRejectedValue(describeTagsMockedError);

            try {
                const result = await getTags(instanceId);

                expect(true).toEqual(false);
                expect(loggerMock.logger.debug).toHaveBeenCalledWith(`describeTags: ${JSON.stringify(tagsResult)}`);
                expect(result).toEqual(tagsResult);
            } catch (e) {
                expect(e).toEqual(describeTagsMockedError);
            }

            expect(ec2Mock.describeTags).toHaveBeenCalledWith(describeTagsParams);
        });
    });

    describe('updateTags', () => {
        it('should call resolve with updated tags', async () => {
            const instanceId = 'id1';
            const oldTags: EC2.Types.Tag[] = [];
            const newTags: EC2.Types.Tag[] = [];
            const filteredResult: EC2.Types.Tag[] = [];
            const allTags: EC2.Types.Tag[] = [
                {
                    Key: 'k',
                    Value: 'v',
                },
            ];

            ec2Mock.removeAWSTags.mockReturnValue(filteredResult);
            utilsMock.updateKeyValueArray.mockReturnValue(allTags);

            const createTagsParams = {
                Resources: [instanceId],
                Tags: allTags.map((tag) => ({
                    Key: tag.Key,
                    Value: tag.Value,
                })),
            };

            await updateTags(instanceId, oldTags, newTags);

            expect(utilsMock.updateKeyValueArray).toHaveBeenCalledWith(filteredResult, newTags);
        });
    });
});
