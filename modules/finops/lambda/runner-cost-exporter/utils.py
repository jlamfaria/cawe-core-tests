from Model import Metric
import pandas as pd


def calculate_minute_cost(non_ec2_minute_cost, ec2_cost, usage):
    return (ec2_cost / usage) + non_ec2_minute_cost


def calculate_non_ec2_cost_per_minute(non_ec2_cost, usage):
    return non_ec2_cost / sum(usage.values())


def calculate_customer_costs(raw_json, minute_cost_per_label_list, date):
    df = pd.json_normalize(raw_json)

    def find_object_by_label(label, object_list):
        for obj in object_list:
            if obj.label == label:
                return obj
        return None  # If the object with the label is not found

    # Preprocess the 'values' column
    df['values'] = df['values'].apply(lambda x: x[0][1])
    df['values'] = df['values'].astype(int)
    df['values'] = df['values'] / 60
    df = df.rename(columns={'metric.label': 'label', 'metric.repository_full_name': 'owner', 'values': 'usage'})

    # Aggregate the data by summing the values
    aggregated_data = df.groupby(['label', 'owner'])['usage'].sum()
    aggregated_data = aggregated_data.reset_index()
    aggregated_data['cost'] = [
        find_object_by_label(row['label'], minute_cost_per_label_list).value * row['usage']
        for _, row in aggregated_data.iterrows()
    ]

    dict_list = aggregated_data.to_dict(orient='records')
    results = [Metric(name="customer_costs", value=entry['cost'], date=date, org=entry['owner'].split("/")[0],
                      repo=entry['owner'].split("/")[1], label=entry['label']) for entry in
               dict_list]

    return results
