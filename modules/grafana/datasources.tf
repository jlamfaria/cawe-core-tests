resource "grafana_data_source" "victoria-metrics" {
    name = "Victoria Metrics"
    type = "prometheus"
    url = "http://cawe-monitoring-victoria-metrics-vmselect:8481/select/0/prometheus"
    json_data_encoded = jsonencode({
        tlsSkipVerify: true
    })
}

resource "grafana_data_source" "loki" {
    name = "Loki"
    type = "loki"
    url = "http://cawe-monitoring-loki:3100"
    json_data_encoded = jsonencode({
        tlsSkipVerify: true
    })
}

resource "grafana_data_source" "infinity" {
    name = "Infinity"
    type = "yesoreyeram-infinity-datasource"
    json_data_encoded = jsonencode({
        tlsSkipVerify: true
    })
}
