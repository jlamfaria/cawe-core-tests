import { Lifecycle, getInstancesListFromFleet } from '../../lib/aws/ec2';
import { GithubDetails } from '../../lib/github';
import { RunnerEnvVars } from '../../lib/env';
import { logger } from '../../lib/logger';
import { createAdhocRunnerByLifecyle } from './adhocUtils';
import {
    RunnerState,
    RunnerTimer,
    RunnerType,
    getEC2InstanceById,
    setRunnerExpirationTTLOnRedis,
    setRunnerMetadataToRedis,
} from '../runner';
import { generateMetadata } from './metadata';

export const LIFECYCLES: Lifecycle[] = [Lifecycle.ON_DEMAND];

export async function scaleUpLinuxAdHoc(runnerEnvVars: RunnerEnvVars, githubDetails: GithubDetails) {
    logger.info('Processing scale up with new new adhoc instance');

    logger.debug(
        `Creating new adhoc runner(s) with: ${JSON.stringify({
            runnerEnvVars,
            githubDetails,
        })}`,
    );

    for (const lifecycle of LIFECYCLES) {
        try {
            const fleet = await createAdhocRunnerByLifecyle(runnerEnvVars, githubDetails, lifecycle);
            const instances = getInstancesListFromFleet(fleet);

            logger.info(`Instances planned to be created by AWS: ${JSON.stringify(instances)}`);

            const instanceId = instances[0];

            const adhocRunner = await getEC2InstanceById(instanceId);

            const metadata = generateMetadata(
                runnerEnvVars,
                adhocRunner,
                githubDetails,
                RunnerType.ADHOC,
                RunnerState.PROVISIONING,
                adhocRunner.InstanceLifecycle === Lifecycle.SPOT ? RunnerTimer.SPOT : RunnerTimer.DISABLED,
            );

            await setRunnerMetadataToRedis(instanceId, metadata);
            await setRunnerExpirationTTLOnRedis(instanceId);

            return;
        } catch (e) {
            logger.error(`Failed to launch ${lifecycle} instance. Error: ${(e as Error).message}`);
        }
    }

    throw new Error(`Exausted all attempts based on instance lifecycles: ${JSON.stringify(LIFECYCLES)}`);
}
