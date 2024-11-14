# A generic metric with just name and value

class Metric:
    def __init__(self, metric_name, metric_value):
        self.metric_name = metric_name
        self.metric_value = metric_value

    def to_dict(self):
        return vars(self)
