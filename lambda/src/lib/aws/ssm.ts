import { GetParameterCommand, ParameterType, PutParameterCommand, SSMClient, SendCommandCommand } from '@aws-sdk/client-ssm';
import { getMandatoryEnvVar } from '../env';
import { logger } from '../logger';

export function getSSMClient(region?: string) {
    // AWS SDK uses AWS_REGION env var by default but we specify it here as best practice
    return new SSMClient({ region: region ? region : getMandatoryEnvVar('AWS_REGION') });
}

export async function getParameterValue(parameterName: string) {
    logger.debug(`Getting SSM parameter value with: ${JSON.stringify({ parameterName })}`);

    const client = getSSMClient();

    const input = {
        Name: parameterName,
        WithDecryption: true,
    };

    const command = new GetParameterCommand(input);

    try {
        const getParameterOutput = await client.send(command);

        if (!getParameterOutput.Parameter?.Value) {
            throw new Error('No value in this parameter: ' + parameterName);
        }

        return getParameterOutput.Parameter?.Value;
    } catch (e) {
        throw new Error(`Error getting parameter: ${parameterName}. Error: ${(e as Error).message}`);
    }
}

export async function putParameterValue(name: string, value: string, type: string) {
    logger.debug(`Putting SSM parameter value with: ${JSON.stringify({ name, value, type })}`);

    const client = getSSMClient();

    const input = {
        Name: name,
        Value: value,
        Type: type as ParameterType,
    };

    const command = new PutParameterCommand(input);

    try {
        await client.send(command);
    } catch (e) {
        throw new Error(`Error putting parameter: ${name}. Error: ${(e as Error).message}`);
    }
}

export async function sendCommand(instanceId: string, command: string) {
    logger.debug(`Send SSM command with: ${JSON.stringify({ instanceId, command })}`);

    const client = getSSMClient();

    const input = {
        DocumentName: 'AWS-RunShellScript',
        InstanceIds: [instanceId],
        Parameters: {
            commands: [command],
        },
    };

    const ssmCommand = new SendCommandCommand(input);

    try {
        const sendCommandOutput = await client.send(ssmCommand);

        if (!sendCommandOutput.Command?.CommandId) {
            throw new Error('No commandId');
        }

        return sendCommandOutput.Command.CommandId;
    } catch (e) {
        throw new Error(`Error sending command to instance: ${instanceId}. Error: ${(e as Error).message}`);
    }
}
