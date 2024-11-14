import boto3


def get_ec2_cost_per_label(AWS_to_label_mapping, start_time, end_time):
    ce = boto3.client('ce')

    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start_time,
            'End': end_time
        },
        Granularity='DAILY',
        Metrics=['AMORTIZED_COST'],
        GroupBy=[{
            'Type': 'DIMENSION',
            'Key': 'INSTANCE_TYPE'
        }],
        Filter={
            'Dimensions': {
                'Key': 'SERVICE',
                'Values': ['Amazon Elastic Compute Cloud - Compute']
            }
        }
    )

    total_cost_per_key = {}

    for label, instance_types in AWS_to_label_mapping.items():
        total_cost_per_key[label] = 0  # Initialize total cost for each label to 0
        for result in response['ResultsByTime']:
            for group in result['Groups']:
                if group['Keys'][0] in instance_types['instanceTypes']:
                    cost = group['Metrics']['AmortizedCost']['Amount']
                    total_cost_per_key[label] += float(cost)

    return total_cost_per_key


def get_non_ec2_cost(start_time, end_time):
    ce = boto3.client('ce')
    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start_time,
            'End': end_time
        },
        Granularity='DAILY',
        Metrics=['AMORTIZED_COST'],
        Filter={
            'Not': {
                'Dimensions': {
                    'Key': 'SERVICE',
                    'Values': ['Amazon Elastic Compute Cloud - Compute']
                }
            }
        }
    )

    return float(response['ResultsByTime'][0]['Total']['AmortizedCost']['Amount'])
