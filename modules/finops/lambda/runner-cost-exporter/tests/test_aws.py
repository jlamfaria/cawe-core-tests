import pytest
from unittest.mock import Mock, patch
from aws import get_ec2_cost_per_label, get_non_ec2_cost


@patch('aws.boto3.client')
def test_get_ec2_cost_per_label(mock_boto3_client):
    mock_ce = Mock()
    mock_response = {
        'ResultsByTime': [
            {
                'Groups': [
                    {
                        'Keys': ['t2.micro'],
                        'Metrics': {
                            'AmortizedCost': {'Amount': '10.5'}
                        }
                    }
                ]
            }
        ]
    }
    mock_ce.get_cost_and_usage.return_value = mock_response
    mock_boto3_client.return_value = mock_ce

    # Test data
    AWS_to_label_mapping = {
        'label1': {'instanceTypes': ['t2.micro']},
        'label2': {'instanceTypes': ['t2.small']}
    }
    start_time = '2023-10-01'
    end_time = '2023-10-05'

    # Call the function
    result = get_ec2_cost_per_label(AWS_to_label_mapping, start_time, end_time)

    # Assertion
    assert result == {'label1': 10.5, 'label2': 0}


@patch('aws.boto3.client')
def test_get_non_ec2_cost(mock_boto3_client):
    mock_ce = Mock()
    mock_response = {
        'ResultsByTime': [
            {
                'Total': {
                    'AmortizedCost': {'Amount': '50.5'}
                }
            }
        ]
    }
    mock_ce.get_cost_and_usage.return_value = mock_response
    mock_boto3_client.return_value = mock_ce

    # Test data
    start_time = '2023-10-01'
    end_time = '2023-10-05'

    # Call the function
    result = get_non_ec2_cost(start_time, end_time)

    # Assertion
    assert result == 50.5
