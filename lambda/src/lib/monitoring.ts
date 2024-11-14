import got from 'got';
import path from 'path';
import { WorkflowJobEvent, WorkflowRunEvent } from '@octokit/webhooks-types';
import { logger } from './logger';
import { filterCAWElabel, getUnixTimestamp, LabelComponents, splitCAWELabel } from './utils';
import { Environment, processRunnerEnvVars, processWebhookEnvVars } from './env';

export const VICTORIA_METRICS_SELECT = 'select/0/prometheus/api/v1';
export const VICTORIA_METRICS_INSERT = 'insert/0/prometheus/api/v1';
export const VICTORIA_METRICS_IMPORT = 'import/prometheus/metrics/job';

export enum VictoriaMetricsEndpoint {
    EGRESS = 'metrics-egress',
    INGRESS = 'metrics-injest',
}

export enum PrometheusQueryType {
    QUERY_RANGE = 'query_range',
    QUERY = 'query',
}

export interface BasePrometheusGetResponseData {
    status: string;
    isPartial: boolean;
    stats: {
        seriesFetched: string;
    };
    data: {
        resultType: string;
        result: {
            metric: Object;
            value: [string, string];
        }[];
    };
}

export interface CurrentMacOsUsage extends BasePrometheusGetResponseData {
    data: {
        resultType: string;
        result: {
            metric: CaweMetadataInfo;
            value: [string, string];
        }[];
    };
}

export interface JobTimestamp extends BasePrometheusGetResponseData {
    data: {
        resultType: string;
        result: [
            {
                metric: AnalyticsJobEvent;
                value: [string, string];
            },
        ];
    };
}

export interface CaweMetadataInfo {
    count: string;
    github_labels: string[];
}

export enum WorkflowJobStatus {
    QUEUED = 'queued',
    IN_PROGRESS = 'in_progress',
    COMPLETED = 'completed',
}

export enum AnalyticsJobEventType {
    WORKFLOW_JOB = 'workflow_job',
    WORKFLOW_RUN = 'workflow_run',
}

export enum AnalyticsJobLengthEventType {
    QUEUED_TIME = 'job_queued_time',
    IN_PROGRESS_TIME = 'job_in_progress_time',
}

export interface AnalyticsJobLengthEvent {
    timestamp: number;
    repository_full_name: WorkflowRunEvent['repository']['full_name'];
    workflow_job_runner_name: WorkflowJobEvent['workflow_job']['runner_name'];
    organization_id: number;
    organization_login: string;
    organization_url: string;
    installation_id: number;
    os?: LabelComponents['os'];
    arch?: LabelComponents['arch'];
    purpose?: LabelComponents['purpose'];
    size?: LabelComponents['size'];
    label?: string;
}

export interface AnalyticsJobEvent {
    timestamp: number;
    repository_full_name: WorkflowRunEvent['repository']['full_name'];
    organization_login: string;
    installation_id: number;
    workflow_job_id: WorkflowJobEvent['workflow_job']['id'];
    workflow_job_name: WorkflowJobEvent['workflow_job']['name'];
    workflow_job_labels: WorkflowJobEvent['workflow_job']['labels'];
    workflow_job_started_at: number;
    workflow_job_completed_at: number | null;
    workflow_job_conclusion: WorkflowJobEvent['workflow_job']['conclusion'];
    workflow_job_status: WorkflowJobEvent['workflow_job']['status'];
    workflow_job_run_id: WorkflowJobEvent['workflow_job']['run_id'];
    workflow_job_runner_name: WorkflowJobEvent['workflow_job']['runner_name'];
    workflow_job_runner_group_name: WorkflowJobEvent['workflow_job']['runner_group_name'];
    os?: LabelComponents['os'];
    arch?: LabelComponents['arch'];
    purpose?: LabelComponents['purpose'];
    size?: LabelComponents['size'];
}

export interface AnalyticsRunEvent {
    timestamp: number;
    repository_full_name: WorkflowRunEvent['repository']['full_name'];
    organization_login: string;
    workflow_run_id: WorkflowRunEvent['workflow_run']['id'];
    workflow_run_name: WorkflowRunEvent['workflow_run']['name'];
    workflow_run_status: WorkflowRunEvent['workflow_run']['status'];
    workflow_run_conclusion: WorkflowRunEvent['workflow_run']['conclusion'];
    workflow_run_workflow_id: WorkflowRunEvent['workflow_run']['workflow_id'];
    workflow_run_created_at: number;
    workflow_run_updated_at: number;
    workflow_run_run_started_at: number;
}

export function convertEnvironmentName(env: Environment) {
    return env === 'prd' ? 'prod' : env;
}

export function getVictoriaMetricsEndpoint(env: Environment, region: string, endpoint: VictoriaMetricsEndpoint) {
    const environment = env === Environment.DEV ? Environment.INT : convertEnvironmentName(env);

    return `https://${endpoint}.${environment}.eu-central-1.cawe.daytona.eu-central-1.aws.cloud.bmw`;
}

export async function processRunEventMetrics(workflowRunEvent: WorkflowRunEvent) {
    logger.info(`Processing metrics for workflow run event: ${JSON.stringify(workflowRunEvent)}`);
    await processAnalyticsRunEvent(workflowRunEvent);
}

export async function processJobEventMetrics(workflowJobEvent: WorkflowJobEvent) {
    logger.info(`Processing metrics for workflow job event: ${JSON.stringify(workflowJobEvent)}`);

    const caweLabel = filterCAWElabel(workflowJobEvent.workflow_job.labels);

    if (!caweLabel) {
        throw new Error("Event does not contain required 'cawe' label. Github job metrics will be ignored");
    }

    await processAnalyticsJobEvent(workflowJobEvent);
    await processAnalyticsJobLengthEvent(workflowJobEvent);
}

export async function processAnalyticsRunEvent(workflowRunEvent: WorkflowRunEvent) {
    try {
        const { environment, region } = processWebhookEnvVars();

        await postMetrics(
            path.join(
                getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.INGRESS),
                VICTORIA_METRICS_INSERT,
                VICTORIA_METRICS_IMPORT,
                `${AnalyticsJobEventType.WORKFLOW_RUN}/instance/${String(workflowRunEvent.workflow_run.id)}`,
            ),
            generatePrometheusMetric(
                AnalyticsJobEventType.WORKFLOW_RUN,
                generateAnalyticsRunEvent(workflowRunEvent),
                0,
            ),
        );
    } catch (e) {
        logger.warn(`Failed to process analytics run event: ${(e as Error).message}`);
    }
}

export async function processAnalyticsJobEvent(workflowJobEvent: WorkflowJobEvent) {
    try {
        const { environment, region } = processWebhookEnvVars();

        await postMetrics(
            path.join(
                getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.INGRESS),
                VICTORIA_METRICS_INSERT,
                VICTORIA_METRICS_IMPORT,
                `${AnalyticsJobEventType.WORKFLOW_JOB}/instance/${String(workflowJobEvent.workflow_job.id)}`,
            ),
            generatePrometheusMetric(
                AnalyticsJobEventType.WORKFLOW_JOB,
                generateAnalyticsJobEvent(workflowJobEvent),
                0,
            ),
        );
    } catch (e) {
        logger.warn(`Failed to process analytics job event: ${(e as Error).message}`);
    }
}

export async function processAnalyticsJobLengthEvent(workflowJobEvent: WorkflowJobEvent) {
    try {
        const { environment, region } = processWebhookEnvVars();

        const analyticsJobLengthEvent = generateAnalyticsJobLengthEvent(workflowJobEvent);

        switch (workflowJobEvent.workflow_job.status) {
            case WorkflowJobStatus.IN_PROGRESS:
                try {
                    const queueTimestamp = await getJobTimestamp(
                        workflowJobEvent.workflow_job.id,
                        WorkflowJobStatus.QUEUED,
                    );

                    await postMetrics(
                        path.join(
                            getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.INGRESS),
                            VICTORIA_METRICS_INSERT,
                            VICTORIA_METRICS_IMPORT,
                            `${AnalyticsJobLengthEventType.QUEUED_TIME}/instance/${String(
                                workflowJobEvent.workflow_job.id,
                            )}`,
                        ),
                        generatePrometheusMetric(
                            AnalyticsJobLengthEventType.QUEUED_TIME,
                            analyticsJobLengthEvent,
                            Math.floor(Date.now() / 1000) - queueTimestamp,
                        ),
                    );
                } catch (e) {
                    logger.warn(
                        `Failed to generate ${AnalyticsJobLengthEventType.QUEUED_TIME} metric. Error: ${
                            (e as Error).message
                        }`,
                    );
                }
                break;
            case WorkflowJobStatus.COMPLETED:
                try {
                    const inProgressTimestamp = await getJobTimestamp(
                        workflowJobEvent.workflow_job.id,
                        WorkflowJobStatus.IN_PROGRESS,
                    );

                    if (!workflowJobEvent.workflow_job.completed_at) {
                        throw new Error('Workflow job completed_at was not defined on event of type completed');
                    }

                    await postMetrics(
                        path.join(
                            getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.INGRESS),
                            VICTORIA_METRICS_INSERT,
                            VICTORIA_METRICS_IMPORT,
                            `${AnalyticsJobLengthEventType.IN_PROGRESS_TIME}/instance/${String(
                                workflowJobEvent.workflow_job.id,
                            )}`,
                        ),
                        generatePrometheusMetric(
                            AnalyticsJobLengthEventType.IN_PROGRESS_TIME,
                            analyticsJobLengthEvent,
                            getUnixTimestamp(workflowJobEvent.workflow_job.completed_at) - inProgressTimestamp,
                        ),
                    );
                } catch (e) {
                    logger.warn(
                        `Failed to generate ${AnalyticsJobLengthEventType.IN_PROGRESS_TIME} metric. Error: ${
                            (e as Error).message
                        }`,
                    );
                }
                break;
            default:
        }
    } catch (e) {
        logger.warn(`Failed to process analytics job length event: ${(e as Error).message}`);
    }
}

export function generateAnalyticsJobLengthEvent(workflowJobEvent: WorkflowJobEvent) {
    if (!workflowJobEvent.organization) {
        throw new Error('Missing Organization');
    }

    if (!workflowJobEvent.installation) {
        throw new Error('Missing Installation');
    }

    const analyticsEvent: AnalyticsJobLengthEvent = {
        timestamp: Math.floor(Date.now() / 1000),
        repository_full_name: workflowJobEvent.repository.full_name,
        workflow_job_runner_name: workflowJobEvent.workflow_job.runner_name,
        organization_id: workflowJobEvent.organization?.id,
        organization_login: workflowJobEvent.organization?.login,
        organization_url: workflowJobEvent.organization?.url,
        installation_id: workflowJobEvent.installation?.id,
    };

    const caweLabel = filterCAWElabel(workflowJobEvent.workflow_job.labels);

    const cawe_label_without_id = caweLabel?.split('_')[0] ?? '';

    if (caweLabel) {
        const labelComponents = splitCAWELabel(caweLabel);

        analyticsEvent.os = labelComponents.os;
        analyticsEvent.arch = labelComponents.arch;
        analyticsEvent.purpose = labelComponents.purpose;
        analyticsEvent.size = labelComponents.size;
        analyticsEvent.label = cawe_label_without_id;

        return analyticsEvent;
    }

    return analyticsEvent;
}

export function generateAnalyticsRunEvent(workflowRunEvent: WorkflowRunEvent) {
    if (!workflowRunEvent.organization) {
        throw new Error('Missing Organization');
    }

    if (!workflowRunEvent.installation) {
        throw new Error('Missing Installation');
    }

    const analyticsRunEvent: AnalyticsRunEvent = {
        timestamp: Math.floor(Date.now() / 1000),
        repository_full_name: workflowRunEvent.repository.full_name,
        organization_login: workflowRunEvent.organization?.login,
        workflow_run_id: workflowRunEvent.workflow_run.id,
        workflow_run_name: workflowRunEvent.workflow_run.name,
        workflow_run_status: workflowRunEvent.workflow_run.status,
        workflow_run_conclusion: workflowRunEvent.workflow_run.conclusion,
        workflow_run_workflow_id: workflowRunEvent.workflow_run.workflow_id,
        workflow_run_created_at: getUnixTimestamp(workflowRunEvent.workflow_run.created_at),
        workflow_run_updated_at: getUnixTimestamp(workflowRunEvent.workflow_run.updated_at),
        workflow_run_run_started_at: getUnixTimestamp(workflowRunEvent.workflow_run.updated_at),
    };

    return analyticsRunEvent;
}

export function generateAnalyticsJobEvent(workflowJobEvent: WorkflowJobEvent) {
    if (!workflowJobEvent.organization) {
        throw new Error('Missing Organization');
    }

    if (!workflowJobEvent.installation) {
        throw new Error('Missing Installation');
    }

    const runnerNameWithoutId = workflowJobEvent.workflow_job.runner_name?.split('_')[0] ?? null;

    const analyticsJobEvent: AnalyticsJobEvent = {
        timestamp: Math.floor(Date.now() / 1000),
        repository_full_name: workflowJobEvent.repository.full_name,
        organization_login: workflowJobEvent.organization?.login,
        installation_id: workflowJobEvent.installation?.id,
        workflow_job_id: workflowJobEvent.workflow_job.id,
        workflow_job_name: workflowJobEvent.workflow_job.name,
        workflow_job_labels: workflowJobEvent.workflow_job.labels,
        workflow_job_started_at: getUnixTimestamp(workflowJobEvent.workflow_job.started_at),
        workflow_job_completed_at:
            workflowJobEvent.workflow_job.completed_at != null
                ? getUnixTimestamp(workflowJobEvent.workflow_job.completed_at)
                : null,
        workflow_job_conclusion: workflowJobEvent.workflow_job.conclusion,
        workflow_job_status: workflowJobEvent.workflow_job.status,
        workflow_job_run_id: workflowJobEvent.workflow_job.run_id,
        workflow_job_runner_name: runnerNameWithoutId,
        workflow_job_runner_group_name: workflowJobEvent.workflow_job.runner_group_name,
    };

    const caweLabel = filterCAWElabel(workflowJobEvent.workflow_job.labels);

    if (caweLabel) {
        const labelComponents = splitCAWELabel(caweLabel);

        analyticsJobEvent.os = labelComponents.os;
        analyticsJobEvent.arch = labelComponents.arch;
        analyticsJobEvent.purpose = labelComponents.purpose;
        analyticsJobEvent.size = labelComponents.size;

        return analyticsJobEvent;
    }

    return analyticsJobEvent;
}

export async function getCurrentMacOsUsage(org: string) {
    try {
        const { environment, region } = processRunnerEnvVars();

        const body = await getMetrics<CurrentMacOsUsage>(
            path.join(
                getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.EGRESS),
                VICTORIA_METRICS_SELECT,
                PrometheusQueryType.QUERY,
            ),
            new URLSearchParams([
                [
                    'query',
                    `count_values by(github_labels) (\"count\", sum by(instance, github_labels) (cawe_metadata_info{job=\"macos\", github_org=\"${org}\"}))`,
                ],
                ['step', '5s'],
            ]),
        );

        const metrics = body.data.result;

        if (metrics.length === 0) {
            throw new Error('Unable to retrieve metrics');
        }

        const usage = Number(metrics[0].value[1]);

        logger.info(`Current macOS usage for ${org} is ${usage}`);

        return usage;
    } catch (e) {
        logger.warn((e as Error).message);
        logger.warn('Failing to get current macOs usage, falling back to 0');

        return 0;
    }
}

export async function getJobTimestamp(instance: number, status: 'queued' | 'in_progress') {
    const { environment, region } = processWebhookEnvVars();

    const queryParams = new URLSearchParams([
        ['query', `workflow_job{instance="${instance}",workflow_job_status="${status}"}`],
        ['step', '3h'],
        ['from', String(Math.floor(Date.now() / 1000) - 6 * 60 * 60 * 1000)],
        ['to', String(Math.floor(Date.now() / 1000))],
    ]);

    const bodyInst = await getMetrics<JobTimestamp>(
        path.join(
            getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.EGRESS),
            VICTORIA_METRICS_SELECT,
            PrometheusQueryType.QUERY,
        ),
        queryParams,
    );

    if (bodyInst.data.result.length) {
        return Number(bodyInst.data.result[0].metric.timestamp);
    }

    logger.warn('Instant query did not produce any results, trying range query looking at 6 hours in the past');

    const bodyRange = await getMetrics<JobTimestamp>(
        path.join(
            getVictoriaMetricsEndpoint(environment, region, VictoriaMetricsEndpoint.EGRESS),
            VICTORIA_METRICS_SELECT,
            PrometheusQueryType.QUERY_RANGE,
        ),
        queryParams,
    );

    if (bodyRange.data.result.length) {
        return Number(bodyRange.data.result[0].metric.timestamp);
    }

    throw new Error('Neither query or range query did return any results');
}

export async function getMetrics<T>(endpoint: string, searchParams?: URLSearchParams) {
    const response = await got.get<T>(endpoint, {
        searchParams,
        responseType: 'json',
        https: {
            rejectUnauthorized: false,
        },
    });

    if (!response.body) {
        throw new Error('Unable to retrieve metrics');
    }

    return response.body as T;
}

export async function postMetrics<T>(endpoint: string, body: string) {
    try {
        logger.debug(
            `Post Metrics: ${JSON.stringify({
                endpoint,
                body,
            })}`,
        );

        const response = await got.post<T>(endpoint, {
            body,
            responseType: 'json',
            https: {
                rejectUnauthorized: false,
            },
        });

        logger.debug(
            `Post metrics response details: ${JSON.stringify({
                statusCode: response.statusCode,
                body: response.body,
                headers: response.headers,
            })}}`,
        );

        if (response.statusCode !== 200 && response.statusCode !== 201) {
            throw new Error(`Failed to send metrics. Error: ${JSON.stringify(response.body)}`);
        }
    } catch (e) {
        logger.warn((e as Error).message);
    }
}

export function generatePrometheusMetric(job: string, obj: Object, value: number) {
    const metricArr = Object.keys(obj).map((key) => `${key}="${(obj as any)[key]}"`);
    const metrics = metricArr.join(',');

    return `${job}{${metrics}} ${value}`;
}
