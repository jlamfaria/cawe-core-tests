import os
import platform
import subprocess

import requests
import socket
import sys
import time

from Cawe import Cawe
from Metric import Metric

AVF_PROC_NAME = "/System/Library/Frameworks/Virtualization.framework/Versions/A/XPCServices/com.apple.Virtualization.VirtualMachine.xpc/Contents/MacOS/com.apple.Virtualization.VirtualMachine"


def main():
    try:
        sleep = int(sys.argv[1])
    except IndexError:
        sleep = 10

    try:
        endpoint = sys.argv[2]
    except IndexError:
        endpoint = "https://metrics-injest.prod.eu-central-1.cawe.daytona.eu-central-1.aws.cloud.bmw"

    while True:

        all_metrics = []
        if job == "macos_hypervisor":
            all_metrics.append(Metric("virt_process_count_int", __get_number_of_vms()))
        else:
            all_metrics.append(Cawe(metric_name="cawe_metadata_info").fill_from_metadata())

        payload = __generate_payload(all_metrics)
        requests.post(
            endpoint + "/insert/0/prometheus/api/v1/import/prometheus/metrics/job/" + job + "/instance/"
            + socket.gethostname(),
            data=payload, verify=False)
        time.sleep(sleep)


def __generate_payload(objects):
    response = requests.get("http://localhost:9100/metrics")
    to_send = response.content.decode()
    for obj in objects:
        metric_value = '' if obj.metric_value is None else f' {obj.metric_value}'
        metric = '{}{{{}}}{}\n'.format(
            obj.metric_name,
            ','.join(['{}="{}"'.format(k, getattr(obj, k)) for k in obj.__dict__.keys() if
                      k not in ['metric_name', 'metric_value']]),
            metric_value
        )
        to_send += metric
    return to_send


def __get_job_name():
    os_name = platform.system().lower()
    if os_name == "linux":
        return "linux"
    elif os_name == "darwin":
        if os.path.exists('/etc/virtualizationAPI'):
            return "macos_hypervisor"
        else:
            return "macos"
    else:
        return "unknown"


def __get_number_of_vms():
    output = subprocess.run(["ps", "aux"], stdout=subprocess.PIPE)
    output = subprocess.run(["grep", "-v", "grep"], input=output.stdout, stdout=subprocess.PIPE)
    output = subprocess.run(["grep", "-oc", AVF_PROC_NAME], input=output.stdout, stdout=subprocess.PIPE)
    return output.stdout.decode("utf-8")


if __name__ == "__main__":
    job = __get_job_name()
    main()
