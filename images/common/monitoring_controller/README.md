## Monitoring controller

This is a python application that can fetch the exported data from `localhost:9100/metrics`(via prometheus
node_exporter) and push it to the Victoria metrics cluster endpoint.
This accepts two parameters on the `main.py` call, them being the refresh interval (how often are metrics pushed) and
the VM endpoint.
If no parameters are provided it will default to `10` and `https://metrics-injest.prod.eu-central-1.cawe.daytona.eu-central-1.aws.cloud.bmw`

Apart from node metrics it can also send custom metrics. In fact it just needs a python object to work with. After
adding it to the array `all_metrics` all of those object will be processed and pushed.
By default there is a template object called "Metric" that accepts only a metric_name and metric_value. One can create
custom object to better work with custom metrics. The Cawe object is an example. It loads a series of information from
the metadata.json file and then it is consumed by the main logic.

This can also detect the OS it is running on and therefore select the appropriate `job` label to push the metrics with

### How to run

- Install the requerements

  - `pip3 install -r /etc/gha/common/monitoring_controller/requirements.txt`

- Run the app

  - `python3 main.py $time $metrics_endpoint`

- (Optional) Run as service

  - Add the following service:

    ```[Unit]
        Description=Monitoring controller

        [Service]
        User=ec2-user
        Group=ec2-user
        Type=simple
        Restart=on-failure
        WorkingDirectory=/etc/gha/common/monitoring_controller/
        ExecStart=/bin/python3 /etc/gha/common/monitoring_controller/main.py 10 $metrics_endpoint

        [Install]
        WantedBy=multi-user.target
    ```

    This in an example for linux, running inside our CAWE Runners
