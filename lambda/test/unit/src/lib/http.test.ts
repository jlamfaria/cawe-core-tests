import * as http from '../../../../src/lib/http';
import 'jest-extended';

describe('http', () => {
    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
    });

    describe('response', () => {
        it('should return formatted http reponse', () => {
            const code = 200;
            const message = '{}';

            const res = http.response(code, message);

            expect(res).toEqual({
                statusCode: code,
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message,
                }),
            });
        });
    });
});
