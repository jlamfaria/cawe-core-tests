import { compact } from 'lodash';
import { logger } from './logger';
import { randomBytes } from 'crypto';
import {
    RUNNER_REQUEST_REQUEUE_INTERVAL_BASE_DELAY,
    RUNNER_REQUEST_REQUEUE_JITTER_DELAY_FACTOR,
    RUNNER_REQUEST_TTL,
} from '../config';

export interface LabelComponents {
    os: string;
    arch: string;
    purpose?: string;
    size?: string;
    githubRunId?: string;
    githubRunAttempt?: string;
}

export function filterCAWElabel(labels: string[]) {
    const caweLabel = compact(
        labels.map((label) => (label === 'dependabot' || label.startsWith('cawe') ? label : null)),
    )[0];

    if (caweLabel) {
        logger.debug(`Cawe label: ${caweLabel}`);

        return caweLabel;
    }

    logger.warn('Cawe label not found');
}

export function splitCAWELabel(label: string) {

    const githubComponents = label.split('_');
    const components = githubComponents[0].split('-');

    let parsedComponents: LabelComponents;

    if (label === 'dependabot') {
        parsedComponents = {
            os: 'linux',
            arch: 'arch',
            purpose: 'dependabot',
            size: '',
        };
    } else {
        parsedComponents = {
            os: components[1],
            arch: components[2],
            purpose: components[3],
            size: components[4],
            githubRunId: githubComponents[1],
            githubRunAttempt: githubComponents[2],
        };
    }

    logger.debug(`Cawe label components: ${JSON.stringify(parsedComponents)}`);

    return parsedComponents;
}

export function updateKeyValueArray<T extends { Key?: string; Value?: string }>(array1: T[], array2: T[]) {
    return array1.map((a) => ({
        ...a,
        ...array2.find((b) => b.Key === a.Key),
    }));
}

export function getUnixTimestamp(dateStr: string) {
    const date = new Date(dateStr);

    return Math.floor(date.getTime() / 1000);
}

export function getTTL() {
    return new Date(Date.now() + RUNNER_REQUEST_TTL * 1000);
}

export function getSQSDelay(newEvent: boolean) {
    //Same as Math.random(1)
    const rnd = randomBytes(4).readUint32LE() / 0x100000000;

    const jitter = Math.floor(rnd * RUNNER_REQUEST_REQUEUE_JITTER_DELAY_FACTOR);
    const total = (newEvent ? 0 : RUNNER_REQUEST_REQUEUE_INTERVAL_BASE_DELAY) + jitter;

    logger.debug(`Delay => Jitter: ${jitter} Total: ${total}`);

    return total;
}

export function lowerCaseAllFields(input: { [key: string]: any }) {
    const newObject: { [key: string]: any } = {};

    for (const key in input) {
        newObject[key.toLowerCase()] = input[key];
    }

    return newObject;
}

export async function timeoutPromise<T>(timeoutMs: number, promise: Promise<T>, failureMessage?: string) {
    let timeoutHandle: NodeJS.Timeout;

    const timeoutPromise = new Promise((resolve, reject) => {
        timeoutHandle = setTimeout(() => reject(new Error(failureMessage)), timeoutMs);
    });

    return Promise.race([promise, timeoutPromise]).then((result) => {
        clearTimeout(timeoutHandle);

        return result;
    });
}

export function sleep(milliseconds: number) {
    return new Promise((resolve) => setTimeout(resolve, milliseconds));
}
