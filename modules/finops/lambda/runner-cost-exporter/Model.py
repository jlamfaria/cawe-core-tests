class Metric:
    def __init__(self, name, value, date, **kwargs):
        self.name = name
        self.value = value
        self.date = date
        self.__dict__.update(kwargs)

    def to_dict(self):
        return vars(self)

    def to_prometheus_format(self):
        additional_properties = ', '.join([f'{key}="{value}"' for key, value in self.__dict__.items() if key not in ['name', 'value', 'date']])
        return f'{self.name}{{{additional_properties}}} {self.value} {int(self.date.strftime("%s"))}'
