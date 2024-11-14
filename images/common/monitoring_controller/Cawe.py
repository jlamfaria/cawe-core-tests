import json


class Cawe:

    def __init__(self, metric_name):
        self.metric_name = metric_name
        self.metric_value = 0
        self.type = None
        self.timer = None
        self.github_labels = None
        self.github_url = None
        self.github_token = None
        self.github_org = None
        self.aws_region = None
        self.aws_auto_scaling_group_name = None
        self.aws_instance_type = None
        self.aws_instance_id = None

    def to_dict(self):
        return vars(self)

    def fill_from_metadata(self):
        with open('/etc/gha/metadata.json', 'r') as f:
            data = json.load(f)

        if 'github' in data:
            self.github_org = data['github'].get('org', "")
            self.github_url = data['github'].get('url', "")
            self.github_labels = data['github'].get('labels', "")
        else:
            self.github_org = ""
            self.github_url = ""
            self.github_labels = ""

        if 'aws' in data:
            self.aws_instance_id = data['aws'].get('instanceId', "")
            self.aws_instance_type = data['aws'].get('instanceType', "")
            self.aws_auto_scaling_group_name = data['aws'].get('autoScalingGroupName', "")
            self.aws_region = data['aws'].get('region', "")
        else:
            self.aws_instance_id = ""
            self.aws_instance_type = ""
            self.aws_auto_scaling_group_name = ""
            self.aws_region = ""

        self.timer = data.get('timer', "")
        self.type = data.get('type', "")

        return self


