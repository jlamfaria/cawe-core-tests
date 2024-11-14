export interface IResponse {
    statusCode: number;
    headers?: object;
    body?: string;
}

export function response(code: number, message?: string): IResponse {
    return {
        statusCode: code,
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            message,
        }),
    };
}
