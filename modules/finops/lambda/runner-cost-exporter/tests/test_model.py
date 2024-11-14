from Model import LabelCost, Metric


# Test for LabelCost class
def test_label_cost_to_dict():
    lc = LabelCost('example_label', 10.5, '2023-10-29', additional_info='some_info')
    result = lc.to_dict()
    expected_result = {
        'label': 'example_label',
        'cost': 10.5,
        'date': '2023-10-29',
        'additional_info': 'some_info'
    }
    assert result == expected_result


def test_label_cost_to_prometheus_format():
    lc = LabelCost('example_label', 10.5, '2023-10-29', additional_info='some_info')
    result = lc.to_prometheus_format()
    expected_result = 'label_cost{label="example_label"} 10.5 2023-10-29'
    assert result == expected_result


# Test for Metric class
def test_metric_to_dict():
    m = Metric('example_metric', 5, '2023-10-29', additional_info='some_info')
    result = m.to_dict()
    expected_result = {
        'name': 'example_metric',
        'value': 5,
        'date': '2023-10-29',
        'additional_info': 'some_info'
    }
    assert result == expected_result


def test_metric_to_prometheus_format():
    m = Metric('example_metric', 5, '2023-10-29', additional_info='some_info')
    result = m.to_prometheus_format()
    expected_result = 'example_metric{} 5 2023-10-29'
    assert result == expected_result
