import pytest
from utils import calculate_minute_cost, calculate_non_ec2_cost_per_minute


# Test for calculate_minute_cost function
def test_calculate_minute_cost():
    result = calculate_minute_cost(0.5, 10, 55)
    expected_result = 0.6818181818181819
    assert result == expected_result


# Test for calculate_non_ec2_cost_per_minute function
def test_calculate_non_ec2_cost_per_minute():
    usage = {'service1': 100, 'service2': 200, 'service3': 300}
    result = calculate_non_ec2_cost_per_minute(10, usage)
    expected_result = 0.016666666666666666
    assert result == expected_result
