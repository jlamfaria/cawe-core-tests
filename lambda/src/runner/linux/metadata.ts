import { GithubDetails } from '../../lib/github';
import { RunnerState, RunnerTimer, RunnerType } from '../runner';
import { EC2Instance, Lifecycle } from '../../lib/aws/ec2';
import { RunnerEnvVars } from '../../lib/env';

export interface RunnerAWSMetadata {
    env: string;
    region: string;
    instanceId: string;
    instanceType: string;
    instanceLifecycle: string;
    autoScalingGroupName: string;
}

export interface RunnerGithubMetadata {
    org: string;
    repo: string;
    token: string;
    runnerGroup: string;
    labels: string;
    url: string;
}
export interface RunnerMetadata {
    aws: RunnerAWSMetadata;
    github: RunnerGithubMetadata;
    type: RunnerType;
    state: RunnerState;
    timer?: RunnerTimer;
}

export function generateMetadata(
    runnerEnvVars: RunnerEnvVars,
    runner: EC2Instance,
    githubDetails: GithubDetails,
    type: RunnerType,
    state: RunnerState,
    timer?: RunnerTimer,
) {

    const fullLabel = githubDetails.runnerDetails.labels[0];
    const runnerNameWithoutId = fullLabel.split('_')[0];

    const metadata: RunnerMetadata = {
        aws: {
            env: runnerEnvVars.environment,
            region: runnerEnvVars.region,
            instanceId: runner.InstanceId,
            instanceType: runner.InstanceType,
            instanceLifecycle:
                runner.InstanceLifecycle === Lifecycle.SPOT ? runner.InstanceLifecycle : Lifecycle.ON_DEMAND,
            autoScalingGroupName: runnerNameWithoutId,
        },
        github: {
            org: githubDetails.repositoryOwner,
            repo: githubDetails.repositoryName,
            token: githubDetails.runnerDetails.registrationToken,
            runnerGroup: githubDetails.runnerDetails.runnerGroup,
            labels: githubDetails.runnerDetails.labels.join(','),
            url: githubDetails.runnerDetails.url.href,
        },
        type,
        state,
        timer,
    };

    return metadata;
}
