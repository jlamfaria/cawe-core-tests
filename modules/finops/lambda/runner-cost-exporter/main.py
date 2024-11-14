from datetime import datetime, timedelta
from victoria_metrics import get_overall_usage_per_label, send_metric_to_victoria_metrics, \
    get_usage_from_victoria_metrics
from aws import get_ec2_cost_per_label, get_non_ec2_cost
from Model import Metric
from utils import calculate_minute_cost, calculate_non_ec2_cost_per_minute, calculate_customer_costs

AWSResourcesMapping = {
    # general
    'cawe-linux-x64-general-small': {
        'instanceTypes': ['t3a.small', 't3.small'],
    },
    'cawe-linux-x64-general-medium': {
        'instanceTypes': ['t3a.medium', 't2.medium', 'a1.large', 't3.medium'],
    },
    'cawe-linux-x64-general-large': {
        'instanceTypes': ['t3a.xlarge', 't2.xlarge', 't3.xlarge'],
    },
    # compute
    'cawe-linux-x64-compute-small': {
        'instanceTypes': ['c6i.large', 'c5a.large', 'c6a.large', 'c5.large'],
    },
    'cawe-linux-x64-compute-medium': {
        'instanceTypes': ['c4.xlarge', 'c3.xlarge', 'c5a.xlarge'],
    },
    'cawe-linux-x64-compute-large': {
        'instanceTypes': ['c5a.2xlarge', 'c6a.2xlarge', 'c6i.2xlarge', 'c5.2xlarge'],
    },
    # memory
    'cawe-linux-x64-memory-small': {
        'instanceTypes': ['r6a.large', 'r3.large', 'r5a.large'],
    },
    'cawe-linux-x64-memory-medium': {
        'instanceTypes': ['r3.xlarge', 'r6a.xlarge', 'r5a.xlarge'],
    },
    'cawe-linux-x64-memory-large': {
        'instanceTypes': ['r3.2xlarge', 'r6a.2xlarge', 'r5a.2xlarge'],
    },
    # ------------------------------------------------------------------- Linux Ubuntu Arm
    'cawe-linux-arm64-general-small': {
        'instanceTypes': ['t4g.small'],
    },
    'cawe-linux-arm64-general-medium': {
        'instanceTypes': ['a1.large', 't4g.medium'],
    },
    'cawe-linux-arm64-general-large': {
        'instanceTypes': ['m6g.large', 'm6gd.large', 't4g.large'],
    },
    # compute
    'cawe-linux-arm64-compute-small': {
        'instanceTypes': ['c6g.large', 'c6gd.large', 'c6gn.large', 'c7g.large'],
    },
    'cawe-linux-arm64-compute-medium': {
        'instanceTypes': ['c6g.xlarge', 'c6gd.xlarge', 'c6gn.xlarge', 'c7g.xlarge'],
    },
    'cawe-linux-arm64-compute-large': {
        'instanceTypes': ['c6g.2xlarge', 'c6gd.2xlarge', 'c6gn.2xlarge', 'c7g.2xlarge'],
    },
    # memory
    'cawe-linux-arm64-memory-small': {
        'instanceTypes': ['r6g.large', 'r6gd.large'],
    },
    'cawe-linux-arm64-memory-medium': {
        'instanceTypes': ['r6g.xlarge', 'r6gd.xlarge'],
    },
    'cawe-linux-arm64-memory-large': {
        'instanceTypes': ['r6g.2xlarge', 'r6gd.2xlarge'],
    },
    'cawe-macos-arm64': {
        'instanceTypes': ['mac2'],
    }
}


def main(start_date, end_date):
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    print(f"Considering time range from {start_date} to {end_date}")

    ec2_costs = get_ec2_cost_per_label(AWSResourcesMapping, start_date.isoformat(), end_date.isoformat())

    for label, cost in ec2_costs.items():
        print(f"{label} has a cost of {cost:.5f} euros")

    print("\n")

    usage = get_overall_usage_per_label(AWSResourcesMapping, start_date.isoformat(), end_date.isoformat())

    non_ec2_costs = get_non_ec2_cost(start_date.isoformat(), end_date.isoformat())
    send_metric_to_victoria_metrics(
        Metric("non_ec2_costs_total", non_ec2_costs, start_date))

    if sum(usage.values()) == 0:
        print(f"There is no usage for this period, skipping usage metrics")
        return

    for label, minutes in usage.items():
        print(f"{label} was used for {minutes:.2f} minutes")

    minute_cost_per_label = []
    for label in AWSResourcesMapping.keys():
        if usage[label] > 0:
            minute_cost_per_label.append(
                Metric(name='label_cost', label=label, value=calculate_minute_cost(0, ec2_costs[label], usage[label]),
                       date=start_date))

    print("\n")

    for i in minute_cost_per_label:
        print(f"The cost per minute for {i.label} is {i.value:.5f} euros")

    non_ec2_minute_cost = calculate_non_ec2_cost_per_minute(non_ec2_costs, usage)

    print("\n")

    print(
        f"A total of {non_ec2_costs:.5f} euros were spent on non ec2 resources, which equates to an extra "
        f"{non_ec2_minute_cost:.5f} euros per minute")

    minute_cost_per_label = []
    for label in AWSResourcesMapping.keys():
        if usage[label] > 0:
            minute_cost_per_label.append(
                Metric(name='label_cost', label=label,
                       value=calculate_minute_cost(non_ec2_minute_cost, ec2_costs[label], usage[label]),
                       date=start_date))

    print("\n")

    for i in minute_cost_per_label:
        print(f"The final cost per minute for {i.label} is {i.value:.5f} euros")

    print("\n")

    ################################################### Per Org costs #################################################

    print("Calculating customer costs ...")

    raw_usage = get_usage_from_victoria_metrics(start_date, end_date)

    customer_costs = calculate_customer_costs(raw_usage, minute_cost_per_label, start_date)

    print("Sending metrics to Victoria metrics")
    send_metric_to_victoria_metrics(minute_cost_per_label)
    send_metric_to_victoria_metrics(Metric(name="non_ec2_costs_minute", value=non_ec2_minute_cost, date=start_date))
    send_metric_to_victoria_metrics(customer_costs)
    print("Done")


def lambda_handler(event, context):
    if 'start_date' in event:
        start_date = datetime.strptime(event['start_date'], '%Y-%m-%d').date()
    else:
        start_date = datetime.today().date() - timedelta(days=2)

    if 'end_date' in event:
        end_date = datetime.strptime(event['end_date'], '%Y-%m-%d').date()
    else:
        end_date = datetime.today().date() - timedelta(days=1)

    main(start_date, end_date)


if __name__ == '__main__':
    # To run locally add the METRICS_INJEST_URL and METRICS_EGRESS_URL environment variables first!

    start = datetime.strptime("2023-10-30", '%Y-%m-%d').date()
    end = datetime.strptime("2023-10-31", '%Y-%m-%d').date()

    main(start, end)
