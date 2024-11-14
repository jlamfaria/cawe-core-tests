const fields: { [key: string]: string } = {};

export function printLogFields(): string {
    return JSON.stringify(fields);
}

export function addLogField(key: string, value: any) {
    fields[key] = value;
}

export function getLogField(key: string) {
    return fields[key];
}
