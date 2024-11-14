import * as logFields from '../../../../src/lib/logFields';
import 'jest-extended';

describe('logFields', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('addLogField', () => {
        it('should add log fields', () => {
            logFields.addLogField('key', 'value');

            expect(logFields.getLogField('key')).toEqual('value');
        });
    });

    describe('getLogField', () => {
        it('should return log field based on key name', () => {
            logFields.addLogField('key', 'value');

            const value = logFields.getLogField('key');

            expect(value).toEqual('value');
        });
    });

    describe('print', () => {
        it('should print the log fields', () => {
            logFields.addLogField('key', 'value');

            const res = logFields.printLogFields();

            expect(res).toEqual(
                JSON.stringify({
                    key: 'value',
                }),
            );
        });
    });
});
