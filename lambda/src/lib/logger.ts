import { APIGatewayEvent, Context, SQSEvent } from 'aws-lambda';
import { Logger, TLogLevelName } from 'tslog';
import { addLogField } from './logFields';

export const logger = new Logger({
    colorizePrettyLogs: false,
    displayInstanceName: false,
    minLevel: (process.env.LOG_LEVEL as TLogLevelName) || 'info',
    name: 'runners',
    overwriteConsole: true,
    type: (process.env.LOG_TYPE as any) || 'pretty',
    displayDateTime: false,
    displayFilePath: 'hidden',
});

export function addLogEventHandler(event: SQSEvent | APIGatewayEvent, context: Context) {
    logger.setSettings({ requestId: context.awsRequestId });
    logger.debug(`Event: ${JSON.stringify(event)} Context: ${JSON.stringify(context)}`);
    addLogField('event', event);
}
