import { GITHUB_COM_ORIGIN } from '../../../../src/lib/github';
import { Environment, WebhookEnvVars } from '../../../../src/lib/env';
import {
    getMessageGroupId,
    parseWebhookHeaders,
    selectDelayBasedOnOS,
    selectQueueUrlBasedOnOS,
} from '../../../../src/webhook/webhookUtils';
import { RunnerRequest } from '../../../../src/runner/runnerRequest';
import * as utils from '../../../../src/lib/utils';
import * as sinon from 'sinon';
import 'jest-extended';

jest.mock('../../../../src/lib/utils');
jest.mock('../../../../src/lib/aws/ssm');
jest.mock('@octokit/webhooks');

const utilsMock = utils as jest.Mocked<typeof utils>;

describe('webhook', () => {
    const sandbox = sinon.createSandbox();

    beforeEach(() => {
        jest.resetModules();
        jest.resetAllMocks();
        sandbox.restore();
    });

    describe('parseWebhookHeaders', () => {
        it("should throw an error if 'x-hub-signature' is missing", () => {
            const headers: any = {};

            utilsMock.lowerCaseAllFields.mockReturnValue(headers);

            try {
                parseWebhookHeaders(headers);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(
                    new Error("Github event doesn't have signature. This webhook requires a secret to be configured"),
                );
            }
        });

        it("should throw an error if 'x-github-event' is missing", () => {
            const headers: any = {
                'x-hub-signature': 'sig',
            };

            utilsMock.lowerCaseAllFields.mockReturnValue(headers);

            try {
                parseWebhookHeaders(headers);
                expect(true).toEqual(false);
            } catch (e) {
                expect(e).toEqual(
                    new Error("Github event doesn't have an event. This webhook requires an event to be processed"),
                );
            }
        });

        it('should return if no error is found', () => {
            const headers: any = {
                'x-hub-signature': 'sig',
                'x-github-event': 'event',
                'x-github-enterprise-host': 'host',
            };

            const githubHost: string = headers['x-github-enterprise-host'] ?? new URL(GITHUB_COM_ORIGIN).hostname;
            const githubEvent: string = headers['x-github-event'];
            const githubSignature: string = headers['x-hub-signature'];
            const isEnterprise: boolean = headers['x-github-enterprise-host'] ? true : false;

            utilsMock.lowerCaseAllFields.mockReturnValue(headers);

            const result = parseWebhookHeaders(headers);

            expect(result).toEqual({
                githubHost,
                githubEvent,
                githubSignature,
                isEnterprise,
            });
        });

        it("should fallback to github.com if 'x-github-enterprise-host' is not set", () => {
            const headers: any = {
                'x-hub-signature': 'sig',
                'x-github-event': 'event',
            };

            const githubHost: string = headers['x-github-enterprise-host'] ?? new URL(GITHUB_COM_ORIGIN).hostname;
            const githubEvent: string = headers['x-github-event'];
            const githubSignature: string = headers['x-hub-signature'];
            const isEnterprise = headers['x-github-enterprise-host'] ? true : false;

            utilsMock.lowerCaseAllFields.mockReturnValue(headers);

            const result = parseWebhookHeaders(headers);

            expect(result).toEqual({
                githubHost,
                githubEvent,
                githubSignature,
                isEnterprise,
            });
        });
    });

    describe('selectQueueUrlBasedOnOS', () => {
        it('shoud return macos sqs url', () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const url = selectQueueUrlBasedOnOS(webhookEnvVars, true);

            expect(url).toEqual(webhookEnvVars.sqsUrlMacos);
        });

        it('shoud return linux sqs url', () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'sqs_l',
                sqsUrlMacos: 'sqs_m',
                githubAppSecretName: 'secret',
            };

            const url = selectQueueUrlBasedOnOS(webhookEnvVars, false);

            expect(url).toEqual(webhookEnvVars.sqsUrlLinux);
        });
    });

    describe('selectDelayBasedOnOS', () => {
        it('should call getSQSDelay for macos', () => {
            const delayMocked = 30;

            utilsMock.getSQSDelay.mockReturnValue(delayMocked);

            const delay = selectDelayBasedOnOS(true);

            expect(delay).toEqual(delayMocked);
        });

        it('should return 0 if not macos', () => {
            const delay = selectDelayBasedOnOS(false);

            expect(delay).toEqual(0);
        });
    });

    describe('getMessageGroupId', () => {
        it('should return a string with actionRequestMesssage id if queueUrl is equal to sqsUrlMacos on env vars', () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'url_l',
                sqsUrlMacos: 'url_m',
                githubAppSecretName: 'secret',
            };
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const queueUrl = webhookEnvVars.sqsUrlLinux;

            const result = getMessageGroupId(queueUrl, webhookEnvVars, runnerRequest);

            expect(result).toEqual(runnerRequest.id.toString());
        });

        it('should return undefined if queueUrl is not equal to sqsUrlMacos on env vars', () => {
            const webhookEnvVars: WebhookEnvVars = {
                region: 'r',
                environment: Environment.DEV,
                sqsUrlLinux: 'url_l',
                sqsUrlMacos: 'url_m',
                githubAppSecretName: 'secret',
            };
            const runnerRequest: RunnerRequest = {
                id: 0,
                action: '',
                eventType: '',
                repositoryName: '',
                repositoryOwner: '',
                githubHost: 'https://example.com',
                isEnterprise: true,
                installationId: 0,
                workflowName: '',
                workflowLabels: [],
                startedAt: '',
                ttl: new Date(),
            };

            const queueUrl = 'other';

            const result = getMessageGroupId(queueUrl, webhookEnvVars, runnerRequest);

            expect(result).toEqual(undefined);
        });
    });
});
