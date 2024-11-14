import json
import os
import requests

def get_label_usage_from_victoria_metrics(label, start_time, end_time):
    url = os.environ['METRICS_EGRESS_URL'] + "/select/0/prometheus/api/v1/query_range"

    params = {
        'query': f"sum(job_in_progress_time{{label=\"{label}\"}})/60",
        'start': start_time,
        'end': end_time,
        'step': '1h'
    }

    response = requests.get(url, params=params, verify=False)
    try:
        data = json.loads(response.text)['data']['result']
        values = data[0]['values']
        return sum(float(value[1]) for value in values)
    except (KeyError, IndexError, TypeError):
        return 0


def get_usage_from_victoria_metrics(start_time, end_time):
    url = os.environ['METRICS_EGRESS_URL'] + "/select/0/prometheus/api/v1/query_range"

    params = {
        'query': "job_in_progress_time{}",
        'start': start_time,
        'end': end_time,
        'step': '1h'
    }

    response = requests.get(url, params=params, verify=False)
    data = json.loads(response.text)['data']['result']
    return data


def get_overall_usage_per_label(AWS_to_label_mapping, start_time, end_time):
    total_usage_per_key = {}

    for label in AWS_to_label_mapping.keys():
        total_usage_per_key[label] = float(get_label_usage_from_victoria_metrics(label, start_time, end_time))

    return total_usage_per_key


def send_metric_to_victoria_metrics(data):
    if isinstance(data, list):
        for entry in data:
            _post_to_victoria_metrics(entry)
    else:
        _post_to_victoria_metrics(data)


def _post_to_victoria_metrics(obj):
    url = os.environ.get('METRICS_INJEST_URL')

    try:
        response = requests.post(
            url + "/insert/0/prometheus/api/v1/import/prometheus/metrics/job/runner-cost-exporter/instance/",
            data=obj.to_prometheus_format(), verify=False)

        if response.status_code == 200:
            print(f"Metrics uploaded successfully. => {obj.to_prometheus_format()}")

        else:
            print(f"Failed with status code {response.status_code} - {response.reason}")

    except requests.exceptions.RequestException as e:
        print(f"Failed to upload metrics: {e}")
