role_to_assume       = "arn:aws-cn:iam::090973320140:role/cawe/cawe-developer"
admin_cawe_developer = "arn:aws-cn:iam::096149471542:role/cawe/cawe-developer"

kms_principals = [
    "arn:aws-cn:iam::096149471542:root",
    "arn:aws-cn:iam::090973320140:root",
    "arn:aws-cn:iam::090973320140:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws-cn:iam::090974794329:root",
    "arn:aws-cn:iam::090974794329:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws-cn:iam::090975101271:root",
    "arn:aws-cn:iam::090975101271:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
]

kms_key_arn = "arn:aws-cn:kms:cn-north-1:096149471542:key/2b4c0bd9-395f-4a5e-8ea0-70541cbba65e"

external_connections = []

instance_types_x64 = {
    "cawe-linux-x64-general-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 3
        }
        off_peak_capacity = {
            desired_capacity = 1
        }
        list = ["t3a.small", "t3.small"]
    },
    "cawe-linux-x64-general-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 1
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["t2.medium", "t3a.medium"]
    },
    "cawe-linux-x64-general-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 2
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["t3.xlarge", "t3a.xlarge", "t2.xlarge"]
    },
    "cawe-linux-x64-compute-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c6i.large", "c5.large", "c5a.large", "c6a.large"]
    },
    "cawe-linux-x64-compute-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c4.xlarge", "c3.xlarge", "c5a.xlarge"]
    },
    "cawe-linux-x64-compute-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c5.2xlarge", "c5a.2xlarge", "c6a.2xlarge", "c6i.2xlarge"]
    },
    "cawe-linux-x64-memory-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["r6a.large", "r3.large", "r5a.large"]
    },
    "cawe-linux-x64-memory-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["r3.xlarge", "r5a.xlarge", "r6a.xlarge"]
    },
    "cawe-linux-x64-memory-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 2
        }
        off_peak_capacity = {
            desired_capacity = 1
        }
        list = ["r3.2xlarge", "r5a.2xlarge", "r6a.2xlarge"]
    }
}

instance_types_arm64 = {
    "cawe-linux-arm64-general-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 1
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["t4g.small"]
    },

    "cawe-linux-arm64-general-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 2
        }
        off_peak_capacity = {
            desired_capacity = 1
        }
        list = ["t4g.medium"]
    },

    "cawe-linux-arm64-general-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 1
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["m6g.large", "m6gd.large", "t4g.large"]
    },

    "cawe-linux-arm64-compute-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c6g.large", "c6gd.large", "c6gn.large", "c7g.large"]
    },

    "cawe-linux-arm64-compute-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c6g.xlarge", "c6gd.xlarge", "c6gn.xlarge", "c7g.xlarge"]
    },

    "cawe-linux-arm64-compute-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["c6g.2xlarge", "c6gd.2xlarge", "c6gn.2xlarge", "c7g.2xlarge"]
    },

    "cawe-linux-arm64-memory-small-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["r6g.large", "r6gd.large"]
    },

    "cawe-linux-arm64-memory-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["r6g.xlarge", "r6gd.xlarge"]
    },

    "cawe-linux-arm64-memory-large-cn" = {
        on_peak_capacity = {
            desired_capacity = 0
        }
        off_peak_capacity = {
            desired_capacity = 0
        }
        list = ["r6g.2xlarge", "r6gd.2xlarge"]
    }
}
### SSM ####

github_app = {
    #https://code.connected.bmw/github-apps/cawe-connected-actions-dev
    codeconnectedbmw = {
        app_id         = "81"
        client_id      = "Iv1.0dc053b330c87fbe"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBcHd0VHFtVHluRnBBdGlTeFBheTJLU0ZpeWlCWFg0YXpaQjBPNTM1V1ZJODNTTHBvCjJJNERCK2FIbnRMUWRtbXRCSGkwcEpxT0RmSjM4ZDBuVjhpbXpvVlFQdGtNNnhwaDdvK28wZUJYdnNOY1FaMVQKZVpxVCs2U1NWZWtrUGhBODVWL2IyQXJoN3RlaStnMjk5NlhlWUJPVE1wRHYvM3hvNGZiaEhHZ0crSnIyTmNTeQpLWXpJY1FXUW45NVNWNEtmSmpBSzFYQkpMVEhFUWJrV2dwT1UrYVJGdjV6cjBOajJHZUlXV3lwWDB0TFlmb2xaCnNzdE5xNW1PcG96eHdteUpEYitSMzAvTDQ3Y3NyM3pkZmFTcjMxdmFJRk1oc0NuS0REVWtacmo1VjFNM0dUZWsKWk1VbUhTVkRuT0lHdHlqd1plVVBjTUloMndFLytVRVhsVytOdHdJREFRQUJBb0lCQUJuSUdzS3F6L01uenVNTgo2TGt2SmZKVkw4MG9qck8wczQxWkdzcko2Z01sRTVCTERSR1hZWXBmbjBENUlxbVVCOXN2MGhteHJRa2tDalV2ClAvcEJndFZQS0NKN0Y0NVZ4Uld2NEl0OEI2N3VzaGVDYzdiS0Q5ci8vSUg3K05jSFpJNjJhOVQ5WVArZkVvMXIKZjQxd2NWRDgxSFF5Z0lnN0tHanYxTEN3c1pxKytDa3BFV3ZCdW1HV3JzbVdJdnl2ZFo4UXdDTmpmZHgybU9ndwp3eHV1VjB2NVJYTWRiZm0rdDZ6N1duTlBrUUpJbUFtcDdCRHlLUFRmUXloeWJaZjFVL0lsSWhNb2VtNTFlNlFvClNmNHRTV3JRcEMrRE1YWGxTeCtKUEFLMHV4YVIzTGFTOHJveWRmbVNTaUlUQzZGbDM5bmw4UzFXODVJMTNjbWkKVUJpWjh1RUNnWUVBMkZDanlPNVNFa1NSRXdwOGQxZGMzdFNhSTVrSWU3bm5WM2FDYWlJbmxGRzVYaU83WjFhegp6L3dTRGhtNVdpUE45OWpTTENjQS9VQTh4dHVRZVNUOUpEQ1grK1FwMzh4N0hLS2FwSWFBU3UwM2RMNWc5THhwCkpCUDNDOHZSR01oVXRmUkRQcitPamFWR1JzY0xaMGFDRTFhSHhUQ1VJSDMvdUFiaWM3S2puU2NDZ1lFQXhiQ28KUmg2Z1g4bEVoVVZJQnB6Rjh2bFM1OE9RaXlyWVRDMEtnRzNaZlZoYmNXR0wvd3MvdzJUVUxBYVNoR2d3ZWduUQpQWmhqYjR4dmlKcVVweDkvOHM5UEF2cTBNYmVlblByS0grWFMzbXpRS3ZjMVpaZGhqK2VVaWFMbzhnT2VlYVJSClg5OEtHUnpnOGFPNDNmRWg3ME5OdVI4LzRDM2VvVXN0SGczc0JQRUNnWUVBeE5xMkFyQm5mZnBxTC9MV0RHRXoKd2hHbWFJam5BSG5RLzNaNC9vOHdoN2pMd2RFd3hiMVFqQkV3ZVNhTjJHdEhFS3Qvc1BDWjVONmxzSzYxenBtTAp5WGh6aDZjL09FekZLTzBOWUhhS29DVTYxNEk5aDl0Q3I3Ti9tbnVVUVVKbVhPUDZva3IvTndaV2F5ak94dUNTCmxYaWt2QjRXWDI5cTNSVmUxYjJYU2ZjQ2dZQnlMRmJqT0dqektUQ1RyN0dyYi91N0dsZlJWdGN5S09xSEJEUmUKZkJMeUc0ZWtjZXdDdnFKeTNOYlZIbTZjWGZneFkxMkxWV21JVVJsUlVjV3N4N3FEcDB0QXN6NUN3SU93c2Y3dQpjVE5hRm9vYlptN0dYNm1QRFBaeWowM3VDRDBNaitRWGRKOUdaYkZjbld2MWNvQmd5UVFvZUczUnNXdzB4MUFsClhYRUVZUUtCZ0QvQ3doN1FMVlNkZmlWbDFJMG02WllUTnRLSitDQkhLb1cwbGFoUWFkZDl3UXhIdkQ3K2VYOTgKdm8xOS9LRE05b0xqbldzTDJsQ280MUZuR2d6dVZrQlJXNmRiT3RINFhCSVZRL2VIZnBHWDkwcXFkL1RTZEhjNwo4V1ZObUplalZSYU9jNkY2QXoybExrNGtucEh3RHArYU45a1piWVE3d0xaWUVKaVBrT2xDCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }

    #https://atc-github.azure.cloud.bmw/github-apps/cawe-connected-actions-dev
    atcgithubazurecloudbmw = {
        app_id         = "101"
        client_id      = "Iv1.5aa080f818981e8e"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBcGJBdENsN0xleFFWaWhwSFFWbEJXY0ZYWitNemRjQkErcW5URDhOQUdFOEF5Ti9SClg1cTZ6NVhGampxTm9VWks0Ulg0OHhTeTB0TjM5VVRtKzcrTHh0ZytOb2RvZXcyRVVqdk9RWThoQUNNOWR2MnQKaHdac2puN1R3cGtXdTZ1T3hvUVdOS1BrMGN3TFlKRjFOVFZTWDVLa3AydDdUU0hlZGwvcEE5djJVUUcyLzM3dQoyLzVOMUJyb2hpTGtnbWF2d3JOWm05MW5oTHo4WVp6eEJlWWRBM3poNmN0UjJoVndUVWcvNk5BQ09jQ1N0ZWhmClUrbnJmbVlISFM5MjRVSHdPbW4vYndadG41WTM0b0huZS91TG5UT0JRdzdWN3FCT3lLWHluYUFMM2NqdFFocEcKN2NzVWtNcjNpN29CL3RVNEVuaHZsUmdJZE8yTGI5Z29KbkljM3dJREFRQUJBb0lCQUZ0d1J1c2FOYUhQQzdRVApuSTlyK3F6V0RxNitySCtuZ2pUVDFDODJ5Z0NnV1FhQ3ZzSE1XcHlGUTJtaTF0YlNQRERNTjMrdlJLRWxJMmF3Cmgra1haTVJ3UXFWRlJWdmpzY3JRUnB2WHFaYXgzQkgzSGZVT2pvcDFZOWhaTkRxT0MxVnpQKzM5SlNMRFFPUWkKWWxUakFIck9LeUJhS01vQWp3MDFFUnVZSU8vQzV5b1hZbURLcEV5c0FiQkRTdnQ4bUFjcSt5Q3kraGI3R2tuZApaZWN0dEFuRUQ2eVR0VUxoS3F2ZEpJcXpYRkRhT3o4SXJWU3dVUkkxN1p2V1pKTHJkc3NJaHY3dU9vZlpscXpQCjdudzJkbG5JbjBFZWV3SVI3dHUwU2tYeE9qanhXQXlReDltNHhWdXE0T0l3ajEvTG5RQ0RFMzVGbStGck9tcmUKMlBCYklnRUNnWUVBMFNiNnFZSCsxVnd6c2RVZmNIcUkrM09udjB4LzNuYkw0UllQN1ZXQkZNTHJTUXVQaHVhbgpQaU1VMklMenhCdEpXN240QldidzY1TTFyQlA0TEI2UExONS9vUlBYdUIwOFllZE9ENC9FWm5saWlTQTU5WnJqCmlPTFBNQ1l6RCtxUW1CZE52RC9UN3FEanEzVExSSWlMMTB4Tk93U08xMjk4RHZrakUrN0Y4NzhDZ1lFQXlzenIKUFU5Q3BlTGRiZDdKbmRRT3QyV0JCcW5kYmtIVWNoREcxRzZEd2JPaEdpTThMUmRsOGpNMGx4T3kyMlIyeWhZRAoyeHJwY1pwa2doZ3hkTy9GYitlcmdEaTN1dlZ3allOV2gvQjczb2I1S2xtTUJ4eHYwRWJmQ29pcjVKcjVQdTJ4CjlCalB6UExLS1BKSlJaWE9MM3RBK2p0TzJsWDRTRVRzNGtlNW51RUNnWUJHSThaSDlqcFpudlFQSFNQUCtxZloKZTYyenI1bnFKdmkwWVV1eUVjeWFBOHdYMFBLdkVNYmhSYTZGOVZSK1haQTZYS0ZhWG0xSTh6TTZvKy9FQy9PRAozcEg2bU1idERaRGtYRWVIWEhWRzBFcEZKak9KdEFtK0xDSERTZXd4MkQzcFkxZEVYRHRjZVVRZ2lhaHBNVW1FClNDaFdORzhhdkY1a1B4U09hTEtselFLQmdRQ2ZqajMrVEovWk4vYVMvTmVQajBuTXpOV0kwcGhlcVBobWpnQ0IKSGpvWGFpWjBGQWpDU1VoeUdBdG1XWjg4c1h3c1hzbkYxeFNYeHFzUkY4dkJmdXZOc1czalFieDhJYUxlRTlrKwp0dHdlSmY5ZmJIaVpGNng1SjJsUU5sdFhUdjZPbmlDR05nYzM3a1ZUbGR4RUhTck5mS0dRdnB5NWR5NFNYZmdwCng5aW93UUtCZ1FDOFVkVGFzN0V3VUxpNmx2MnhLb1I3SGRjUUFzRDdzOU02WHd6a3F6QkRnN2JNNVd2cSt1eVkKU04wM2NyNWRIeHRHYkZmQzg3MkFOSlE3ZjZBUkNUa2lFaGlVcU0zRndPblBTc1ZISHFGT3V4ajgxOElHYTZyegpxOTRrT0dia1crWXpDTVA3TDZ6N1UxUElTNHhnS1JvUzNhKzBucEl2NWQ1czRnYmNLRC8weGc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
        webhook_secret = "CAWEsecret123!"
    }

    atcgithubdevazurecloudbmw = {
        app_id         = "6"
        client_id      = "Iv1.04e9b38d18a90e02"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBMWtOYjJ3M0JJQmgwcjlxTXdTcHoxb0YvZTJnQzE4NTVtOTVvSGNKR1MwM25NNFFzCjBQRGZRUE1XbXhWZENNY3FTeHJoNURRaVNSZmRPQnhEZENYNzZtQmFxbWhDdVhvSXFwL2hEd3greE5oM0NSOVgKNmlCU0RMNnBlWXFMY1dHY2hKbFoxK3JMdmh6M3dxVUtQVzNvczZqcVM0K3A0NTk0cFVMUG9QV2w3MEQvYzh5YgpYU3NvV0tFc2ZTdTBGNi9tOXl5RFQ1WXE5M2RDQiswTkxmR05oRmNlN0t1OVdoeXl5VEY0Z3FXVlAzMVB2ZlFsCldmYTQ2YUJxd0hFa0tXZkZ4NjNyNGdvMXB0UmJ5VmF0TnNpc2VHZlZvV0IzS2ZsWTFpQ0VMQndDUVBkOGNsZjYKcDJJeFcrT1pNSDdtNHpnaGRaRld3SXdSeWRIRkpwSFkyZlNvMndJREFRQUJBb0lCQUNFdjU3OWpQd0dncUJwQQo2TUpXdUFDR3FGOU4rZnJCUVhiU0dTQmE0aFp4NTVqRUpVanJ0ampTTGpNeE9Pck9Kby9oaHhHWXZhTENyb0l0ClpvbE1CTndGdHFWa1pzbGh6SXZaSGJ2OS9IaXk2cVVnRkxidjhLV0d0cXRidVVPRGtnRzcydjJsb1k4OTMyWm4KdDlGUi85UXNHclkvZDFvSmJsOXluTVJhcUN3SmhhdjlkdXRqV1V0R0pVOFNFQUdmRnl4K1Y0aW1GSmViamxBVgpLNDNCZ3hnY1dsRk9PMmQwQW1GdHRSWWpKWlN6QVJpL0NwbXpjb0dkK2o5SzBGajhCUnNSRitUOVNWeXhVdkxGClNxQWpGeVlRWVVyUFY2dkJ4WVNhSkJKMEMvM1RzNHJkZE9BWFY1THJJdmgzZERWMjVJa0JMbzFHV05HdzEyMjEKc0E3L3h1RUNnWUVBODVWdjU1clgxeXRJUzRYN0RhTmN4ZXJLMGVQVU9FRmVTSUw0cVRLL2hEeWxYcnB1S0toLwpNMHJ4RWRqemtjdDk0OWU5eFE4ZktiYW1sZ3F6c0ZNYkZsWXUxV01mdXZXRTNzdE4xRFF0MitJTjhkOTlvSDQ0CkNDdWpmclhTb0QrUTdoK0M5RlNTYUFtTXBjMGZqSDUxSjRqRksxM2JENXIwT0xhSEoxVy9pTkVDZ1lFQTRTOVAKOFl6QXpUYngwWWFuRTl6N1h4a2FzMG1SOHl4U1JsSW1xVnh3WWNJc05GQmppd1NBRWtoMDhlQnd1bVdpSFptWAowSGxMYVQ0Y1R4ZURhRERncTFTWEdQY1VyL1RCS1FLUlprMXY3MW5QemoyWWJnaXpzSmNnN2RlSFlyYjhqT1dpCkVESVNXU3BTK0FuYjNsRTIxVTh2U3NXYWlTNHhiTEt4Y3RSVlFlc0NnWUJNSlEvcFg4OVBWUmx4ZW4yam9zalMKbWZZekxMeGZwWmVhcFU2a1hkZmV0N0tlYlRzWWZLdmUxZk9NTjd6VWU3OXI1VHBPaXM2Y0ZKdjQxWG1jaWk0eQppbGh6bmx3Qjd0Uk5iVkowSHFlalVBUTU4enByWEdtWnJFS2N6cXY4S2tMZEhYNnJjSENnRXpRamRIOERSVmpNCk5nWWs2MThhZnI4UHA0ZVNkVXk5c1FLQmdDVGdCb3RiclVidHRIUEhSUnp2bHdwZnBndXVCSVI1d1k5YWJKSlgKWE4vbFdDL0k2a1Fkbkl0aDZpU2h5RlA5eUtwb09JQWZITVpETVllU0ppYXR1bHpVSVZvcE8rNEVlbzBvcW43QwpONDVPZXNVZk9STHJ3ZUV0SG10VVhBdENRK0VleVljMWErUEdGb2dmdFMyV3h3L3ZRNk5POEp0K1FRRzMwVzhvCmJqMjVBb0dCQU9KaGRHbmtjbVhLUFdPVjhBZVVWenB3S0ZuWnJ0dFordThNcnR2OTFiZHBqWFo5Z2liRFZwSkkKWit0WVo3MlBEZWVpVG9CbEhMQVdwajk4VWVXb1VTaU9kMHhjditaekhaUlp4aE9oTDJSRWpUT0ZyVUFLNXNWaQp5U1ZKelZ4cUQyVXlkeXM3OG5kYnNNUUU4UGRQcnhJOEdkZkFUczEyR2hyYmhqMENTdXBOCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }

    #https://github.com/apps/cawe-connected-actions-dev
    apigithubcom = {
        app_id         = "299747"
        client_id      = "Iv1.8849a02dc042492b"
        #generate with: openssl enc -base64 -in spaceship.2024-03-20.private-key.pem | tr -d '\n'
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBME0veFZUZThRWDZydWpkOWFsL0hBMWR3RGJxWmNjdHlsWXJzNUlvYVNoU0VRYnJFCnJCbVdoZVpHMzIvVmNUd0x2ajhyYWF3UEVaaDE4c0lPWnpiU2lyWFRVSWFNQ2FhUDRVMVJhaXBxamZXNWhKeFQKTFBuaEovRlJYcC9tZDZJNUtuZWJRRlR4QTZIUEk5WnVWT0tYSzgxZE1DMUQzMytOTGpjaUxhN2E0M2IzSUZrVwp5TkNwTXpGMEhqLzBpdld2Q0VPcGh1a29RUUQ5bWN2amhNWTdYRTNBOFZ1MENCTGlJcFlPRmM2Wm9SYnZMb284CldVbG00YmxQZitmczhYdmg0Tk5DRThTeGhZZXFnSmVLd3ZzZGFuSDBUTGMycE1lb3hrU0c0TGZWSnVrL2hTYmgKcVpvb2NxbElPak9lUmt1UXZCREpHV1VFdk9HamwzZk1ZTmtZd3dJREFRQUJBb0lCQUF2blRzS2s0cjU1RWlFVAplTHJQcXZDdDAxMTAvYnBXOXJrL3FqRjlEZktiS003MmJxL0E1YXZNYk0zZitqTHlVVmtQRU5KOVZINlVTbVVFCld2M1hTamxPRkRYSzljQzNGZ3lwODdJeHFORmU2S3grbk44N2YzSmZkMXdGa1lYUVlhSGlINStUT0FvVTkxSDcKcjE1M2JGYTY1azBReDRXK0o3WXl2bWdNUjc0ZnQ1NnB5eHpCNVNiYlVXeVhlM2ROaTk3ck1lNHQrbVpTcjFNawpnWlVlSktBTEVSdmFMK2tCVmxxZ0dvRUkxMVpDdVhZN1AyVGcwYTJzR3ZtZTVycDlQU2lGa2lySFIvOGwxeVVrCk1RVWNxSFFTSGh1R0cwT1ptWm9Da0xiSjVjd1o1Q3p1bDlGQU5rWkVQZ01JWFhGMGhRb0xIV1hPdk5VT0FwWisKMkc5SENrRUNnWUVBOVV1eTQrN01OTGFKSDNxWDNTMFBadGNYRjBxMEFTU0VmNm5GeWUyTWlibzE3WkhFcUVtegpCT2c5TDhETVhjbElBTUl5bHF3eUVzaVN6RTdaR244OG1hZXNsS2hxSjZpa20yRnd6MVRaSm5YRDVSYjJ4NWtVCkZxZXdabll5MGtEUDhsdDBwUXEwbFlxSWFYRFlHSHEwTVVwenVDRWF3NGZPTlNBd1puK295aWNDZ1lFQTJleXMKRzJFVElBUUdtU3Irc3lJVUhKUjFhOFMxNzNOTWFjM0dML1J2Uzh2R25iblFXTkY1ckNzYWtwcnlUNk9YQ1RmeApUTnpFcHZvT1dTTTVqbUJ1LzNnQk40bG5nVE1aY2lOTzRCR21QaXRTWFRhUExqNVpVQmNxc0g2Zmp0Sml2Uko3CnBEekZRNFpoUXljMUhoQ0hCOVZmS1FiT3U3MWd2OVlFQzQ3L2FnVUNnWUJlVHcxblh3OTZFTmdsbHkrK0pLM3cKUHpBc2oxY252VStIK2RFR3N1TStySzVCT2JNZmRMNTBXNG55eXpDSHVuU0pmaUNQRjROay8yS1pWSk5hQWFOZAovRDU1SlVzekZqNjdVcnBackdpVXhlQmNPdmtFZ3BGYnFIdEUyWnJ1aFdhdDZvV3RVckZkY1ZiREcxU3FETHNzCjNGQWpjZTdsVUZoeXluNXhXaEdlTHdLQmdRQ3FCS1c1cnFDM0o2em1MczhMZnBqbU8wVG8wVTJJQlJJbXNhM2YKbC9xRXpmU2s5V1VCQmx6QTM5Z1piTjJER0lRcll3UFZEYUEzRFh2SU8xMGFJVTQzN2E0MVgvUHFycTA1aVNadQpWaGEzQmlGNks2akZVVXRvMnNvcGJJQ2JjclFxQXBPSDdRbVJ4dk4yNnMzY0tOVFFYYjJpU25kYnJVSWdLSjU3ClRoTWk2UUtCZ1FEYnlyMWhnbHM3cFVHMTBrdkJqNHBJcWo3dTdNUGhlVlVjTnVXRlNuZ0hLaUp1ZGZ2YS9IcGkKMjVQRzl4QkZ2bW9YOFpKWU9HWmliUlRuWk9hSFlzNTVqb0dXQ2FHWUZiZnVmOU1rcDJXQnVVeVJRekswTnExKwpTYzFzMTFYbmllZExMN1IxMzFxZnQ0bGI5dktJbk1Udmo0M2QrWGp6elo3aHNIWWVXWndTR3c9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
        webhook_secret = "CAWEsecret123!"
    }
}


### API GATEWAY / Lambda - Webhook ####

lambda_webhook_function_name = "webhook-receiver"
relative_webhook_url         = "webhook"


### API GATEWAY / Lambda - Runners ####
lambda_runners_function_name = "runners"

lambda_zip = "../lambda/dist/lambda.zip"

lambda_code = "../lambda"

### General ###

environment  = "dev"
group        = "cawe"
project_name = "cawe"
region       = "cn-north-1"
account_type = "ADV"

common_tags = {
    environment  = "dev"
    project_name = "CAWE"
}

hosted_zones = [
    "bmwgroup.net",
    "aws.cloud.bmw",
    "azure.cloud.bmw",
    "bmw.corp",
    "muc",
    "aws.unicom.cloud.bmw"
]
nginx_ports = [
    443,
    444,
    3000,
    8080,
    9020,
    9021,
    9080,
    9090,
    9091,
    9093,
    9243,
    9914,
    12443,
    15898,
    16215,
    16216,
    19914,
    9999
]

load_balancers_vpc1 = [
    "wheel",
    "radiator",
    "headlight",
]

target_groups_vpc1 = [
    {
        subdomain     = "test"
        hosted_zone   = "azure.cloud.bmw"
        load_balancer = "wheel"
        service_port  = 9100
        service_ip    = "160.48.166.1",
    },
    {
        subdomain     = "test"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "radiator"
        service_port  = 9100
        service_ip    = "160.48.166.2",
    },
    {
        subdomain     = "mail"
        hosted_zone   = "bmwgroup.net"
        load_balancer = "radiator"
        service_port  = 587
        service_ip    = "160.50.251.10",
    },
    {
        subdomain     = "test"
        hosted_zone   = "aws.unicom.cloud.bmw"
        load_balancer = "headlight"
        service_port  = 9100
        service_ip    = "160.48.166.3"
    }  ,
    {
        subdomain     = "atc-github"
        hosted_zone   = "azure.cloud.bmw"
        load_balancer = "wheel"
        service_port  = 443
        service_ip    = "160.48.166.4",
    },
    {
        subdomain     = "atc-github"
        hosted_zone   = "azure.cloud.bmw"
        load_balancer = "wheel"
        service_port  = 22
        service_ip    = "160.48.166.4"
    }
    ]

dns_prefixes_vpc1 = [
    { hosted_zone = "azure.cloud.bmw", subdomain = "test", load_balancer = "wheel" },
    { hosted_zone = "bmwgroup.net", subdomain = "test", load_balancer = "radiator" },
    { hosted_zone = "bmwgroup.net", subdomain = "mail", load_balancer = "radiator" },
    { hosted_zone = "aws.unicom.cloud.bmw", subdomain = "test", load_balancer = "headlight" },
    { hosted_zone = "azure.cloud.bmw", subdomain = "atc-github", load_balancer = "wheel" }
]

nginx_ami_name         = "cawe-nginx-ubuntu-x64-v1.2.3"
nginx_instance_type    = "t3a.small"
nginx_desired_capacity = 4
nginx_min_size         = 4
nginx_max_size         = 6

ami_linux_ubuntu_x64_version   = "v1.14.2"
ami_linux_ubuntu_arm64_version = "v1.14.2"
