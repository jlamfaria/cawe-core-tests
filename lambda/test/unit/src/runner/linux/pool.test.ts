import * as poolUtils from '../../../../../src/runner/linux/poolUtils';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../../../src/runner/linux/poolUtils');

const poolUtilsMock = poolUtils as jest.Mocked<typeof poolUtils>;

describe('pool', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('scaleUpFromPool', () => {
        it('', () => {
            expect(true).toEqual(true);
        });
    });
});
