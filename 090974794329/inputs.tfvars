role_to_assume       = "arn:aws-cn:iam::090974794329:role/cawe/cawe-developer"
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
    #https://code.connected.bmw/github-apps/cawe-connected-actions-int
    codeconnectedbmw = {
        app_id         = "82"
        client_id      = "Iv1.ebd19aad21d78a5c"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBc3VzRzYzU2JVanZKWmlUUkxIcVM3Q1E2bUdUTDg3UUloNDZJeVE0YkpqTUliZmJpCkpCaDF0QWd6UGs2blBOdGVHZTVTdzlKYUtGUm5tcW9QR3hPV0tjWjRrYnJmNlJzbnNSNFJXVVhiNjNLSTZUdVgKT1I0ekYvYlozcTdZRVlMTDh1d1dOLzJBalhXenlIMDhycVBKeU9FaGpoUy9WNjJCT2hyRFZhMWt4cE9nRnROUwpjVXp5TEgwUi9SelE3TVBoZUhXa3FGOW5XVWZQNFpkQndWQnAwUGZxZTBRNUtWV1cxTFZzMFFrK21zWVBEV0NzCjhhWWFkMnVTOW5aSkVlSUVQekh6MEhNY0dsd0RqOGZaampBb1dxWmljVWhBTjBLb2hUNlFKT3VINXpNWWw3RWIKNDMyeE12OStweFRrMUdHdy91ZVM5VkJqcWVCRUxNT3hLR2dPUFFJREFRQUJBb0lCQVFDWG1JNG5hSWpHTjRRZworT2NIQWVDRkZ2bFM4R3ppMDlNNlVHblR1UkVGMzgydnByVGJrcUlBWmNaTmI4VkJ5amxFVFd0eElrVmowSWhzClF0VkR3dWZFQTdkYSt2VUhoUXV2aGVON09iYnFHd1NvWWVaeTdnU3F0R3pMd21ldkJwMForakdsUlRUc0p5T3EKcDNxSUdwMDVpSSt1M0NOMy9ibjE2b0ZCa2daR1Baajc1UUEzUVB3aWh0dktWTWRySmhCZEQ1K0wzOWdSbWdvWAp6UFlKZEMrcml4dmZPVFkrK1ZiWFVwYTA3a2hPbzQ5K3duT1FVanVSU3k0bElFRHFYNFBrVmVza0lYcFVqb0tPCkRTWVg4bDF3ZjRwTjYza0dpSFBoTENsU3lpU0c2bXRaZnFKMk9KSGsyZEdxRDJGOU9IUlZiVFBKSGxscmVnVE0KcFlRVUlEdzlBb0dCQU9xb0lGSTdjKzNETyt0eDIxUStvMVlGRmtINUNOeXVPVzNQQmZZWHBpSlc0NGgrUzI4bQpJbnRaQ2ZJV3ZLRnM0ZGUzaEJVTXVUSXdxY3NycWJEVXlKQzVVTUl4dDdTVDVjQmFlQ2lvaENQV2xCTUlSUXRHCklRZXdhYUN3T3cvK2ZtT1VWWmpTcFJXOXpJN0ZFcGZiRWZwdHZpaTBCNkdVbzFiblErOStRZEdyQW9HQkFNTXgKRFRqVTZhUE1IL3puV3hmZnNaM0RCeHRFRmFBckNoL3F0a3c4czdPdktHMFBjdnI3TVpHQ3JoTW5Da3BkMVdYNQpzS3pQMFBUSURTQ3BZeUI1L1M5VVc1UW1LdkkydmprQ0JRQWI5dFc1RkduUjU2Z1BCWTgyZ055Rm5haEZEL1hSCnMzYzBWS21tazFrTkpxd3pFRXdZVFlWdEUyOGRLbC9GcEkrZlhvZTNBb0dBSitFKzdQclJydnpaT0NCM2lBL0YKTHA5YXN3ZWg2KzlvTHpOWjdnTUM1eDhoT0ZkT2RxdGlmTmdiQ3B1Mm56Q2tDVWRWR1VhNlNyOWVlL3NGc2RuWAo1RkM2V3VhY05BSldyNlF3ZTZoNEhLY2hMMExlaVJYNEV4aDJPeXI0UHJXZndVaTZhMmlSU2VxaDB6bkcrU3Z3CkdFR0NhZVIrejRVMVpWV1VoQ1ZQQmxVQ2dZRUFoTHhicUhVcGVTajc2OGtNNmx4RmRlcEZiK1pKNm9TNk91QXIKSGdiOWtVaWc3aUZlYUl6ZnRYc3ZrM2l1QjhwdHJ3NHdkaVJRamRWcEQvZ0FuL28xRWJXRkhXY2pOMW5BM0JXaQpmdU9GWk91YWxTZVlLSEltcnJBNnl6dlY3Yk1oV21KRGIrSFhYUk1aQ3FybHpKNWhDODVQRVZnT3FqWWtOY0s2CjJLeGc1VnNDZ1lCRGNYTGZTUHJGM0ZUakJwQWh0TXc0WUVMQkNybmhHeTJtVW55blpxVjNiaXAzMy9RbU4vMDEKaDM1ZFYwTTlvbHE1MXJtazFUdFdjbFVOcm1kSm40cTRNZDdIMkYzTFpYOXV5RnN2bUx0LzhMa3ZwQ29mK0hxUgpPdGtGQVdlc2l4VDZtZ1ZGYzVIcjNRYllYdlpjYy82bHpvV250TmFHcmNnVjdOaXZmeVRoZnc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
        webhook_secret = "CAWEsecret123!"
    }

    #https://atc-github.azure.cloud.bmw/github-apps/cawe-connected-actions-int
    atcgithubazurecloudbmw = {
        app_id         = "261"
        client_id      = "Iv1.25b72e93b9363443"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBdzUrNFZRTEYxb0YzeFR0WGN0SEZwZGdaL200VWhiQ0Q2Q0ozVGR5eVBSeXU4MVd4CkFEWkwxWEtEMUs2bjArS3pTckpHclQrWXRIM2dqTmZUL0FPQUQreUVhRTBEaTBjMGtYR2RTY3l2NllzRmdHY04KREZQNkg1a1JaSjlwYzQ0SVpYS3hnWUdlRi9vNWlRZTNoaGJFNGdsVGppR0M5cjhpVjJwcnhHckd0UFJNN1VrSAo1b1B6bHI5eUpzekU3M3FXZ2dHWVFJT0pSbW54T1hERlRBTjk2UVVYNWUrVmFEUyt5cWpxY3hFUzhwQ0MvZjAzClhkaEpjcnc2NG1iYWI3VkVXKytjU2lkd2w0ZUpEK1dPSHIwQUZtVWhOSkZNTURmekRoZVdEcGZjWDk0d2RjREkKNHhEaS9qR2FXRHRKRTdRZFRqbXFzQnU2enhHVFVodGFPUXVDTXdJREFRQUJBb0lCQUVEdHFrak0rczBQZTZsQwo0T3VESkk2L0F5R25kN2hIdGdBK01FcnZqVmtyUkFZUDB3ZTIvY1NDbGE3cHFWcHlTLy9tMi81MHRVSnk1U3phCkZjbjNmM0hKbHNqbmh0MmJiSjg1am5NSU5Qclc0YVNVajRnZjkweTFpVWhVZ0xPUjJNZVRJY2RTTmg3UE5ubDgKempUN0thMjhXcmM1K0RYZGlwQnBDZ3ZQUk5TYURGa0dEWU5ORDAraXJ2cFRKdXUxL2F1bldDSEN1RXZpQ3NpRwpiWXRHQmRYcmdjdGh1cEdvZ0tKRU1rZHdoZTVVeFlJVG1nYndIcTVIS0FsRWxRSmx4R2pyNS9pbFFtVWRqbU9BCkJFcjMrcFlwWFYzKytzbEM1TXdOSFFzUDcxQ3phNVRYa0JBd1gwN0JEVVhCdWxsNjlnYTNnNHlOQmhHTEUwRTMKMkRyOFdBRUNnWUVBOFBJUEthSVN0YjJZNTFZVVNPKy8vUmhnU3hsM0dyWmZzZ1NTaUViOUY1NEhFcEpvREJJbwpOZHFadEZsNkI3cXJGSUV4aHlnSERsRENuamwydE1SN1UzOVcwNk5KQ3FqalhSVmNhV3RoUUcwK2JLVjd6aUpNCjl0UEVydHNEbEZ4dUU0b2FOSEp1OTFaRWdhbVBtdUJEcHo1R1l5Tjg2cmUyQ1ZCY0Jnc1pUck1DZ1lFQXo5aTgKOGdYOU54dXhWc2pKYXNoUFA5cTkrU2ZjeEVIMTFPRGV1MW9ZdndnNDlxYlFEczNlWDVLQ1puT1JESXpLTFNqTQpmTVh3YkdTcENaYk9kZjRrVE1VT0ZrWWM0U1pKTGZHRUQ4T0FsMHFUYU40M0FGdTNDVHUyc1EvV1FRbm0raFRDCkc5VjI1aHg3Z0Z1ajNWVmRvdlFFR3lmZTVsUDZhV0V1YVZTV3ZvRUNnWUVBMU90elRyMDBmM29PZHMvd21RdVUKdzFvWkxnUlE1a0Fuaks3UnRxL1UxRndIci9mRkRuVzFKdklJUmdHVC91U01ibEJFcmtWSEJ2V0RKa050alF6YwpWc3IrdFlOajlwR01haU9JU0hobHRvTlRXTHRjRHFydERHblRNeG5EcmdXSUdLZy93LzBqNWxwTHE3RmxmOTJTCnEyWXkyVVR4REpKUHdTZE1TdUxmK0ZVQ2dZRUF6R1NYYW1uNVdQZ2lyUFZISFh0ZWM2em9wTnhPZmJGZnpyaFUKVUdtSmJGTHBzYVRaZGJWOXVQNmF2YVZvUHE4MUlyTzhZL2RETjFURjVtZ25JR0dMMFBMM3AyL0xkcDN2MlA1bwpvQmZobk9YNWtHYjJMNlFCbTFMZGxjRzlNTGhNTENHOXdTRnFpMS8zRTRNSzRkM1E5eTUvMnpTYVBtYlhHa28zCkdkM1ZZQUVDZ1lBV05iejV5eDhBSnFQZ3M3dk8yVVA3YmZDcTIxVktmVDRyd1doTXdxQTkxTWVueDNEZGtFN2QKSnRnYSszcXVhYU9wWmZLZjVyTGt5UEdYN3RLc1B0V2RmM0QyZHc4c2xBdFVtMHlwZVAvWG9GSTRYY2RzWWV1cApUdGdneXFYNWp4WUdJTE05aElTSDFoR1JZRjB1blZwL0RIcWhIQVR4MVpZQVFDZGJORDJ0c1E9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
        webhook_secret = "CAWEsecret123!"
    }

    atcgithubdevazurecloudbmw = {
        app_id         = "6"
        client_id      = "Iv1.04e9b38d18a90e02"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBMWtOYjJ3M0JJQmgwcjlxTXdTcHoxb0YvZTJnQzE4NTVtOTVvSGNKR1MwM25NNFFzCjBQRGZRUE1XbXhWZENNY3FTeHJoNURRaVNSZmRPQnhEZENYNzZtQmFxbWhDdVhvSXFwL2hEd3greE5oM0NSOVgKNmlCU0RMNnBlWXFMY1dHY2hKbFoxK3JMdmh6M3dxVUtQVzNvczZqcVM0K3A0NTk0cFVMUG9QV2w3MEQvYzh5YgpYU3NvV0tFc2ZTdTBGNi9tOXl5RFQ1WXE5M2RDQiswTkxmR05oRmNlN0t1OVdoeXl5VEY0Z3FXVlAzMVB2ZlFsCldmYTQ2YUJxd0hFa0tXZkZ4NjNyNGdvMXB0UmJ5VmF0TnNpc2VHZlZvV0IzS2ZsWTFpQ0VMQndDUVBkOGNsZjYKcDJJeFcrT1pNSDdtNHpnaGRaRld3SXdSeWRIRkpwSFkyZlNvMndJREFRQUJBb0lCQUNFdjU3OWpQd0dncUJwQQo2TUpXdUFDR3FGOU4rZnJCUVhiU0dTQmE0aFp4NTVqRUpVanJ0ampTTGpNeE9Pck9Kby9oaHhHWXZhTENyb0l0ClpvbE1CTndGdHFWa1pzbGh6SXZaSGJ2OS9IaXk2cVVnRkxidjhLV0d0cXRidVVPRGtnRzcydjJsb1k4OTMyWm4KdDlGUi85UXNHclkvZDFvSmJsOXluTVJhcUN3SmhhdjlkdXRqV1V0R0pVOFNFQUdmRnl4K1Y0aW1GSmViamxBVgpLNDNCZ3hnY1dsRk9PMmQwQW1GdHRSWWpKWlN6QVJpL0NwbXpjb0dkK2o5SzBGajhCUnNSRitUOVNWeXhVdkxGClNxQWpGeVlRWVVyUFY2dkJ4WVNhSkJKMEMvM1RzNHJkZE9BWFY1THJJdmgzZERWMjVJa0JMbzFHV05HdzEyMjEKc0E3L3h1RUNnWUVBODVWdjU1clgxeXRJUzRYN0RhTmN4ZXJLMGVQVU9FRmVTSUw0cVRLL2hEeWxYcnB1S0toLwpNMHJ4RWRqemtjdDk0OWU5eFE4ZktiYW1sZ3F6c0ZNYkZsWXUxV01mdXZXRTNzdE4xRFF0MitJTjhkOTlvSDQ0CkNDdWpmclhTb0QrUTdoK0M5RlNTYUFtTXBjMGZqSDUxSjRqRksxM2JENXIwT0xhSEoxVy9pTkVDZ1lFQTRTOVAKOFl6QXpUYngwWWFuRTl6N1h4a2FzMG1SOHl4U1JsSW1xVnh3WWNJc05GQmppd1NBRWtoMDhlQnd1bVdpSFptWAowSGxMYVQ0Y1R4ZURhRERncTFTWEdQY1VyL1RCS1FLUlprMXY3MW5QemoyWWJnaXpzSmNnN2RlSFlyYjhqT1dpCkVESVNXU3BTK0FuYjNsRTIxVTh2U3NXYWlTNHhiTEt4Y3RSVlFlc0NnWUJNSlEvcFg4OVBWUmx4ZW4yam9zalMKbWZZekxMeGZwWmVhcFU2a1hkZmV0N0tlYlRzWWZLdmUxZk9NTjd6VWU3OXI1VHBPaXM2Y0ZKdjQxWG1jaWk0eQppbGh6bmx3Qjd0Uk5iVkowSHFlalVBUTU4enByWEdtWnJFS2N6cXY4S2tMZEhYNnJjSENnRXpRamRIOERSVmpNCk5nWWs2MThhZnI4UHA0ZVNkVXk5c1FLQmdDVGdCb3RiclVidHRIUEhSUnp2bHdwZnBndXVCSVI1d1k5YWJKSlgKWE4vbFdDL0k2a1Fkbkl0aDZpU2h5RlA5eUtwb09JQWZITVpETVllU0ppYXR1bHpVSVZvcE8rNEVlbzBvcW43QwpONDVPZXNVZk9STHJ3ZUV0SG10VVhBdENRK0VleVljMWErUEdGb2dmdFMyV3h3L3ZRNk5POEp0K1FRRzMwVzhvCmJqMjVBb0dCQU9KaGRHbmtjbVhLUFdPVjhBZVVWenB3S0ZuWnJ0dFordThNcnR2OTFiZHBqWFo5Z2liRFZwSkkKWit0WVo3MlBEZWVpVG9CbEhMQVdwajk4VWVXb1VTaU9kMHhjditaekhaUlp4aE9oTDJSRWpUT0ZyVUFLNXNWaQp5U1ZKelZ4cUQyVXlkeXM3OG5kYnNNUUU4UGRQcnhJOEdkZkFUczEyR2hyYmhqMENTdXBOCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }

    #https://github.com/apps/cawe-connected-actions-int
    apigithubcom = {
        app_id         = "308616"
        client_id      = "Iv1.8d92f13fc0e45418"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBbmJqTmE4cW8rWWwwWC9RM2E2NDdwUmt0RXRROW5qWkkrZ0ZIcmxFQzlyeEVEOFpzCm5RK2luQVlVdjlNZlRpdkV6cjBTWHVsN3M3RlNrMmpLdzBzdC94K2JITERxdlk3SUkvc1pYSXlZd1VFa1FKYngKVmJuS3MvZStkLzNVM0hDSXJER2NBTldqTmY4OVJsb2F1UC9uN0VndTk3UEtnNERFeDRjNlFOTThiZUx1VTFrYwpzTkZieHNRWHJZTzMzTERLamNuNFdZS1RYcnE3L0ExU3pPRWxtTUZFVkpwL2NTYzZFejkxN2VKZTI2TW1JeGtaCmdSN1p0eW9nT1o3bzNkREFYR3JrbUxFVUh0QWFsYW81OXM0NDBZQzhBblhhUCttbFd3Vmh4blZnN1NrbnBTdmoKOFlHZC95a092by9pd0VRQitxbGFJVFFIYkpIajhwa2FhcFcydFFJREFRQUJBb0lCQURneVc0Y1hxNE5WOVpBbQozUVJTRFZCekd2dEZnanI0RHFKOWlFUFUrNkJjVGtmc3BGQ0YvS05wQzBXWi9PS0dkOVpOeWRqbGlqenBab205CllkbVoxT2E5SlRCZzNSTHpaOTVpSHBRNlNFYzdaYVpaNGQxd21JZnRNd0ZnQU5NV2lhd0k5UlBiQ3c4M1JXYm0KdmZUQ3dha1B3eVJnL0R4RXlsaHBsMWozcXVWZjBkb0J6N0ZtR1M1aVpSMDRyU0IzVjBqOEh0dDZKQnhwdDg4RwpVUUcxVFJGRFFJZnUyeWc2dGEvVXg1MmhIQzRuT1JoWXVYSVBwRW5zLzhtQ2U3OU5QWDBNSm1neXdFUVU5aE50CkQ2T0Y4VjlDRnNOL2lNbHY4aHR5ZGNPb1FSWkl4cWxRMmU4RDEwY2pKdkkybFNLU2t0OEpxOVBuUHhRS3NYZFYKelhVaVAyRUNnWUVBem40S2VzNGh2RFhkZ21SS0huUnFZa29oRzVqSXJpVGxuUSt5OExDcUVIcGI2RVg5N2d2dgpuWnpwM2VGZzVsaG1va2xZZDNRMFNFYVJmUmpxMFVybEZCOTBKSGpQai9sVVZrUDlRYkJ5blI4Z00rOWZsS0lTCjlJa2xVRkNqSzR4MlYwa3FFRmlOVzNUb1B5NVNhcmhQTW9qdVo0T1Y4NFFBM0hERnJadHcwUmtDZ1lFQXc0bGIKdWNMSkhmK2NiRTlncXdNMk42d1JhSThlTm1tcW9CSmNZTkQ0eXQ3SXpDUmVnVE92OFlJZFZsVFZIeHIrbW9GUQpuVEkyUGlXUHVqTVY3MmhJL2tXbWo2bm5yQ0Y2dkE4L29rTS91Qm1jbnNYVG1oN2pkNzNSUnRFRjczTHhVTGIyCmJCTDU2ZWRGUlpsMFRYaHp2MTJZbEd6WGV4eTRldVRNVFNCY3VmMENnWUVBZzd2aFQ2dEYxbDYrN0RxekZtN0sKbDk0VzlSWXBvUCtsQk9oSkRraUdsbkNaUmJ1eFhqWjdMYUEzaXZnSDY2d2wvZzZ3dzdSOHprZEc5Zm41aElBMQpXUHNnQzB5UGpwaFA5NkQwWnYzOGdNU2t0TDFYeXVrREVzS1Q3WU1rTmRvc2ZVOE42Tk8xaXMwd2hXNDE0aU9uClV1UU14RGtzWnVpbDYveCtBRjJVUWJFQ2dZRUFvT1RYYXdUU1JETGQzV2w3VzN3ckVxZ3RNdUlBdERsQ1FyQ1kKL3JrMDNvbHVwRHVRMzdOT0pPVXhpcVlITDY4Z3JMV1hSYUhaYkUydjlFQ3czZXZyay81dnpXcTZ6TEpIc1pMQwpnNXZlUkhnZW5hNmVMUVVabXAvQUlndEFYUVV4ZDM3MVNYeGIwNUdQT0hQS2RTeVY0WEw4WjdVZm9aZkNYSzBEClJydElVV2tDZ1lFQXczeFozaGtNK3JzOW9YbTdBQWlSbWZjTFptV1dBdUs4Z3VxY21lUzFsSkVYaFNJMlJLRXQKTWhLUzU2VG44VEdMUHpPZEhCYWxrN0tMWlpLSThWaU9wZmptQ0NCcDdLNHJaTkF0bXNsQVgvb3g1c1NsYi9vTApkL09pNGhkbkREcHpkenNzK0dndEVtNVdUb2RuZzZRdGhtcGN1MTVnb09FMzl4ZDFCSFBrL2ZFPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
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

environment  = "int"
group        = "cawe"
project_name = "cawe"
region       = "cn-north-1"
account_type = "ADV"

common_tags = {
    environment  = "int"
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
