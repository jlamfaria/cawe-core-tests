import os
import unittest
import responses
from unittest.mock import patch, MagicMock, call

from victoria_metrics import (
    get_label_usage_from_victoria_metrics,
    get_overall_usage_per_label,
    send_metric_to_victoria_metrics,
    _post_to_victoria_metrics,
)

url = "https://testdomain.com"


class TestVictoriaMetrics(unittest.TestCase):
    @responses.activate
    @patch('victoria_metrics.os.environ', {'METRICS_EGRESS_URL': url})
    def test_get_label_usage_from_victoria_metrics(self):
        responses.add(responses.GET, url + '/select/0/prometheus/api/v1/query_range',
                      json={'data': {
                          'result': [{'values': [['2023-10-27T00:00:00Z', '10'], ['2023-10-28T00:00:00Z', '15']]}]}})
        label = "label"
        start_time = "2023-10-27T00:00:00Z"
        end_time = "2023-10-28T00:00:00Z"
        result = get_label_usage_from_victoria_metrics(label, start_time, end_time)
        self.assertEqual(result, 25)

    @patch('victoria_metrics.get_label_usage_from_victoria_metrics')
    def test_get_overall_usage_per_label(self, mock_get_label_usage_from_victoria_metrics):
        mock_get_label_usage_from_victoria_metrics.side_effect = lambda label, start_time, end_time: len(label)

        AWS_to_label_mapping = {'label1': 'value1', 'label2': 'value2', 'label3': 'value3'}
        start_time = "2023-10-27T00:00:00Z"
        end_time = "2023-10-28T00:00:00Z"

        expected_result = {'label1': 6.0, 'label2': 6.0, 'label3': 6.0}
        result = get_overall_usage_per_label(AWS_to_label_mapping, start_time, end_time)
        self.assertEqual(result, expected_result)
