import * as utils from '../../../../src/lib/utils';
import * as logger from '../../../../src/lib/logger';
import 'jest-extended';
import {
    RUNNER_REQUEST_REQUEUE_INTERVAL_BASE_DELAY,
    RUNNER_REQUEST_REQUEUE_JITTER_DELAY_FACTOR,
} from '../../../../src/config';

jest.mock('../../../../src/lib/logger');

const loggerMock = logger as jest.Mocked<typeof logger>;

describe('utils', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('splitCAWELabel', () => {
        it('should split cawe label', () => {
            const caweLabel = 'cawe-linux-x64-general-small';
            const components = utils.splitCAWELabel(caweLabel);
            const expectedComponents: utils.LabelComponents = {
                os: 'linux',
                arch: 'x64',
                purpose: 'general',
                size: 'small',
            };

            expect(components).toEqual(expectedComponents);
        });
    });

    describe('filterCAWElabel', () => {
        it('should filter cawe label', () => {
            const labels = ['cawe-linux-x64-general-small', 'extraLabel'];

            const caweLabel = utils.filterCAWElabel(labels);

            expect(caweLabel).not.toEqual(undefined);
            expect(caweLabel).toEqual(labels[0]);
            expect(loggerMock.logger.debug).toHaveBeenCalledWith(`Cawe label: ${labels[0]}`);
        });

        it('should return undefined if no cawe label is found', () => {
            const labels = ['extraLabel'];

            const caweLabel = utils.filterCAWElabel(labels);

            expect(caweLabel).toEqual(undefined);
            expect(loggerMock.logger.warn).toHaveBeenCalledWith('Cawe label not found');
        });
    });

    describe('updateKeyValueArray', () => {
        it('should update first array with values from seccond array', () => {
            const arr1 = [
                {
                    Key: 'key1',
                    Value: 'value1',
                },
                {
                    Key: 'key2',
                    Value: 'value2',
                },
                {
                    Key: 'key3',
                    Value: 'value3',
                },
            ];

            const arr2 = [
                {
                    Key: 'key1',
                    Value: 'value4',
                },
                {
                    Key: 'key2',
                    Value: 'value5',
                },
            ];

            const mergedArr = utils.updateKeyValueArray(arr1, arr2);

            expect(mergedArr).toEqual([
                {
                    Key: 'key1',
                    Value: 'value4',
                },
                {
                    Key: 'key2',
                    Value: 'value5',
                },
                {
                    Key: 'key3',
                    Value: 'value3',
                },
            ]);
        });
    });

    describe('getUnixTimestamp', () => {
        it('should return unix timestamp based on a string', () => {
            const dateStr = new Date().toDateString();
            const unixTimestanp = utils.getUnixTimestamp(dateStr);

            const expectedUnixTimestamp = Math.floor(new Date(dateStr).getTime() / 1000);

            expect(unixTimestanp).toEqual(expectedUnixTimestamp);
        });
    });

    describe('getTTl', () => {
        it('should return the TTL value', () => {
            const before = new Date();
            const ttl = utils.getTTL();

            expect(ttl.getTime() > before.getTime()).toBeTruthy();
        });
    });

    describe('getSQSDelay', () => {
        it('should return base delay + jitter for requeued requests', () => {
            const delay = utils.getSQSDelay(false);

            expect(delay >= RUNNER_REQUEST_REQUEUE_INTERVAL_BASE_DELAY).toBeTruthy();
            expect(
                delay <= RUNNER_REQUEST_REQUEUE_INTERVAL_BASE_DELAY + 1 * RUNNER_REQUEST_REQUEUE_JITTER_DELAY_FACTOR,
            ).toBeTruthy();
            expect(loggerMock.logger.debug).toHaveBeenCalled();
        });

        it('should return base delay + jitter for requeued requests', () => {
            const delay = utils.getSQSDelay(true);

            expect(delay <= 1 * RUNNER_REQUEST_REQUEUE_JITTER_DELAY_FACTOR).toBeTruthy();
            expect(loggerMock.logger.debug).toHaveBeenCalled();
        });
    });

    describe('lowerCaseAllFields', () => {
        it('should lower case all keys on object', () => {
            const input = {
                AA: 'value',
                bb: 'value2',
            };

            const output = utils.lowerCaseAllFields(input);

            expect(output).toEqual({
                aa: 'value',
                bb: 'value2',
            });
        });
    });
});
