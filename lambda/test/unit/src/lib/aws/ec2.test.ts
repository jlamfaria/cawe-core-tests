import { getInstancesListFromFleet, validateEC2Instance } from '../../../../../src/lib/aws/ec2';
import * as sinon from 'sinon';
import 'jest-extended';
import { _InstanceType, CreateFleetCommandOutput, Instance } from '@aws-sdk/client-ec2';

describe('ec2', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('getInstancesListFromFleet', () => {
        it('should extract list of instance ids', async () => {
            const fleet: CreateFleetCommandOutput = {
                FleetId: 'fleetId',
                Instances: [{ InstanceIds: ['id1', 'id2'] }],
                $metadata: {},
            };

            const res = getInstancesListFromFleet(fleet);

            expect(res).toStrictEqual(['id1', 'id2']);
        });
    });

    describe('validateEC2Instance', () => {
        it('should return EC2Instance if InstanceId and InstanceType fields are defined', () => {
            const instance: Instance = {
                InstanceId: 'id1',
                InstanceType: _InstanceType.m7gd_medium,
            };

            const res = validateEC2Instance(instance);

            expect(res.InstanceId).toBeDefined();
            expect(res.InstanceType).toBeDefined();
            expect(res.InstanceId).toEqual(instance.InstanceId);
            expect(res.InstanceType).toEqual(instance.InstanceType);
        });

        it('should throw an error if InstanceId id not defined', () => {
            const instance: Instance = {
                InstanceType: _InstanceType.m7gd_medium,
            };

            try {
                const res = validateEC2Instance(instance);

                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('No InstanceId'));
            }
        });

        it('should throw an error if InstanceType id not defined', () => {
            const instance: Instance = {
                InstanceId: 'id1',
            };

            try {
                const res = validateEC2Instance(instance);

                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(new Error('No InstanceType'));
            }
        });
    });
});
