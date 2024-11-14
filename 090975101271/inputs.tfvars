role_to_assume       = "arn:aws-cn:iam::090975101271:role/cawe/cawe-developer"
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
            desired_capacity = 3
        }
        list = ["t3a.small", "t3.small"]
    },
    "cawe-linux-x64-general-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 3
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
            desired_capacity = 3
        }
        off_peak_capacity = {
            desired_capacity = 3
        }
        list = ["c6i.large", "c5.large", "c5a.large", "c6a.large"]
    },
    "cawe-linux-x64-compute-medium-cn" = {
        on_peak_capacity = {
            desired_capacity = 3
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
    #https://code.connected.bmw/github-apps/cawe-connected-actions
    codeconnectedbmw = {
        app_id         = "80"
        client_id      = "Iv1.bb96242be230bfd7"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBem9yRzBScm1IWk9Uc1hzWFg0M3M3SEdoTmd1OWtNcUx4RWdpMHBMMkZVbEs2REpzClVXZGJQVGNtbXEwZXdQQ2c3am5hbm14cmxwaDJGZzMvYTdkN2lrVWIwK2JSUllKZ1pBMDhIMXpjTmhzV3BFOEsKRVU3SEsraHNGTkI5WGVvRThGUnRKaitUTHVTM21aaXNRb0kwK3d4cEdyWkorWXg4RGxpYWJyUmhHYnRFYjhqcQpQYnJjL051UExGZXZLYk9DM2xGalc5OUJaTDcxTGZQNG5xOHo3MFVISG92ZkFwaTN4bEJLSW5zR2pYL1psSlQwCmswOE9HYUhqNU01UmxZVGtqWW1jQ3l4UXlTVEpoM0tIdjJuS1lOYmZEN1grVDlDZUhxbFNYWkI5Y1JUM3BLMGQKMFkwUnVWWFY0cnEyWGJZZTVrK05nNVFWRDkxUC84OGRYV012S1FJREFRQUJBb0lCQVFDUE4rUE5NNTNGZklPNQpXZVZIT1I3RWhiYUh4M1JYWmx1c2EyamFJMVhJUk41UVRFYVgyOWVFaHkyWnE5bmJaLy92c09aTFhGcnVQaUlFCkFRalFKSmJodGpJcHFiQUxSdkNYOENWMGlldVpDUWVXUDhoM1grejBJV0p3dkhGeUljZnk3bGdSWVp3cHRDY3IKdHBZY09EV01yM3BpTDJ6MFFkbjBDTFJ0ZDE2dGU5SjRJUWZjckRlcWo5VXVQbEJ1RHpwbFVpNzROUmYrdVAxNQpDd041clNBb29xNjU2QVBRRVpJYW9lZkZrQUE3UG5aN0hwRzluWVdWYjZjaWtSREs1ck1tVlROTVQrZStIZkw0CnVXZGp5NURpMktJcTkyL1hKQUFZRUNCQi82U1ZTRzBFQXFWbFZla29rTi8ySmJIMGh5Q3h5VnNGOU5iSEtCbGQKUENkeVlaVlJBb0dCQU9qMHVnREhqUnQxWmF1cGxiNEZLNW1OaGc2ZWJOQ2NMREFoY05sYXI2SUtQUVdqb0k4TQpWeXlCNlJFdmxQdUdsSU1kcExsZFBlbldaZktINzc0dzQvNTEyai9hRnV6aHRjdm4xc252WEtLOXprTDlrRGhXCkNNcHNWSDI0YVpkejZkeDJmYjl2bm1yTU0vRFJTcUNkWXltSUMzOW5rTHFKdEhIcUlFR1NVNTNIQW9HQkFPTDUKS0RHOUZ5RjF3SkMyUlhuVHdFODY5TkFrRzZuNVRxRE4wbStwQ0s5K1R3NkFSRU9Mc0VoWHBZTm16NUU5TzFJcwpvL09UdUI0TW9SR1lacTRZV3p5dWtNWDZDaFFJN2xIaDkzTjRCUnRNTHBoUFlrSmQvSnFrWWM3WGxQVnJRcEttCkxTY0tnZGo3TG9LcngvYkhNTXFNeVJCdktWY3FxSlU2TGFZeDVZdVBBb0dBTE55OFdWd1VxNTRQSjJEd1NuamEKYmFiWWswWWxOSU51NnhIMWxwWWxUckprRUFyejU3aDdyVUdUYmREWkF4dG16RjFRRkxhRkx0d3dJK1hUNEsrdgpxSmh2b0c1U2plbmx4Yy92Q0ZLRlozM2dFL3lhNG82SEFOeWQ1TnczMFlmc0dKM2xGNUhhVXp6aUg5VmVadElJCmY3NElZTS9FQ25oc2ZLZVc4S25LV284Q2dZQmVCbE5GVDR6ZWVwWThISlhwWXZQK25uQytMTWNkQWI4MTFDM0IKdmVkd004WHlQdWFJaUx5TksyblFabTNFUC9ac0V6d1Q4blRLVmZiL2YvL0JUU3UybHFZNHJWMHhjWVd3ZkFoegpXQnZkZEJDMVhlVlprdS9LN0Ivc2ZOZ2pWcnlzWFpURTRKQnIzNW9qM1orbnRscWEvZmxwQ25PNHZWNDYrMi9mCnNqbmlOd0tCZ1FET1lVTlZVODdLbnZRT21DU1pkMjMwMHQyUXVhcWh4WkVtMGE4cVJjNmRJSCs4NnFuaE5xYkQKU055eDlJekdCdlo1K2hGYVB1dmkydDlKOXdMRnhXdllmb2xFMVZyeFRyN3MyNDJQQThDM3ZIdTNZY09QQjU0RQp6V3FEWG5XWnJCUUl2RjBSSkJZWGdzK1U1VzlVelpZb01ublk1WGhGNmhTd0pZUWpIMlVxNHc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo="
        webhook_secret = "CAWEsecret123!"
    }

    #https://atc-github.azure.cloud.bmw/github-apps/cawe-connected-actions
    atcgithubazurecloudbmw = {
        app_id         = "260"
        client_id      = "Iv1.a1fee2f70a8631b1"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBc2Y3akp0d3JyQ1FPbnk5VHQwSytMNnBQekc0MDUyWTVZbUtDaHlmOEM5dVp6bjhjClU0QzZUamExOHFuSWJZQUZTS2h0MEh5YlBvWDBDUlFJR2QyTWE5bDNxcGd0aDhjbkU4ZW9hTEV6VERON2k2dWgKMS9WdnoxWTlpaG9iYitsU3BnNEI2Rm9Eb0N3WGxMYkZ1bkhMd0p0YWhnZGR3SEdtZkw4OEhOY0o3d2lFdXNrZgpncktpRHBvRjlDd3UrZmRZYk5PV2lXNUZoVEFubDJiLzgzeSsxVUwrTU5MZitOc0M5NkhjSDY1TExkWGhUbzZZClFqTVg0dkdGa1lwWHZqR2dIdXc2dVlPaHhJSzVrOENOaGMrbTdLMzNCam41aHEwVFdxMkFRek4rM011NG8wSk0KMVpiNXFkUldvT2lBRWVwRzFld1RmUnpzRTFMSDUyRm5BdUl3UXdJREFRQUJBb0lCQVFDdGhGek1OVFlkeWNpMwpSZHZHZXpvTUhXdE5UdUlqOG5OZWhjblpHQkdOUGJiaXB1ZG1QOGRmRjlhbmlQdnFRekxqY2M0YndGMVd4aDd2CitxY3JEOThrQkF1ME1rV3daMlNnMDdKSTNQVzFBenNkSFdQWXMxc2NOR1lwaXVuVVh4QkM4TVRMVFhUYllDQmMKeVJCWWdUYXZ2TUt5aGR2UER2dk9BRjhKZmxnZ3UvemNsTHowL3ZyTldSQWtoV0xiQitzNGNDKzRFRTNOVTVHcQprbUd4TXh0cEV2M2FkNG9FMnZSQ3pqdDFrRVVlRTZSUGxpQTlvMnFtelRubmZlSktOdUpDV2NQanM2RGR4T1ZKCjdIQkVKNW9HN0daU3BCNC9ocXVsNkpnTFZDRjIzNFg3UlVMRFRTOFBPUlVuK1ZBUGNPZ1FwVnVjK3grVllpc0cKS0RyWUFsVUJBb0dCQU5wSVBhODRUMzRaNFpZTG5CTTVORFhNSjNSbVB5Wi9ML1J4SW0rRHdyeE5uUkxyTEVZago0aG5HM1FqeFE2eEJVZTZlclBQZTRSYUFnYlp6QkxNR3IxYnNtb3pSS044SHpyYzZ2b1lJakR6RlkvMTExWk1NCnJGQjZyN2U4cHlTaWdSZ0FtVk03S1l0K2JXM1BUdWUrUjBLeDFxWE9hRGt5bGNKRFdsOW5KSk1yQW9HQkFOREEKa0JTaW56YmlQWnUwN2pJUDlqVW5sVFp0amRzQ2lJR2hXTmF3WllZS0R3a0h3c3JUL1o1aGE0WUtCSk5UZ2pVWQpKbTlxak9Rc0twQ25zT0ZGT1dlTWVndUZod3MrRHZqZEl1RERYdHlwN0lLanhyNnVLNnZ2dnZZb1lmeTFRVGN4CkVvTDJHNjJHMjRNUmhxWlZDeHF6eFB1TnFUeUdWVWx3SmN5d05DdEpBb0dBZW80czlBQXR3YU5PWVN4TGlRK0oKSE50dkc0OTh6V1NEekQ3cEVxdHIzc1hFOXlaTFNXWkVRQ3pEVlk0QWJPcVAwZVlOUFM5YU9ZUVZVQmJzQUlnMApVaDJ0K0hwRzlGSXg0Zlo5bWt1YVVWU1NlM0I1WllLc0ROT1ZiUmZpMEZMZElGalZ2VUZ1WmYrcCtRbDRSKzB4Cm5XUzBHNHYwUUlrQ1JId0VkYVEzaU5rQ2dZQW9kTGszbHBDZWxWZjFQaXBQZjNKcXVNSWRLendycnFELzVtSU8KTVY5cmk3V0FQWVhOd3luS3NQeWluSHhvaE8yZUZwRVVWS1Q3YjJmTVl3TlBsUmZiN29pVWhRczM3WTMvUXZRSQpkVFNFTlZaRnR6SEVNSUw4TGxsbTRVcWtMQWg0aHNVY3BrK1U0S2JZRHVSMmhkTENHUWJhN1loWDEzemQzNk1qCnVSNVRLUUtCZ0NYOGZlMGRZTkhtWU1pUzY5L0pHdDFwUEJ2QVNuUnVPRXRrSFVOVWozbnljVEZDbjNlVGF3eloKYUlyNFhFbk45N2RPQURiOXp2VTdJOHNYQUJCNm1SUVRMNVI4RUJINE9uWWRvYjQ2Y05UMU9tRHZtWldaRTVoKwpId0hDVmMwTXQ1L2VNR3RQQWFYcENud1dwRVJiYVVaL2RFNHdPYXBqeFpEaGZSbmJRV09nCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }

    atcgithubdevazurecloudbmw = {
        app_id         = "6"
        client_id      = "Iv1.04e9b38d18a90e02"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBMWtOYjJ3M0JJQmgwcjlxTXdTcHoxb0YvZTJnQzE4NTVtOTVvSGNKR1MwM25NNFFzCjBQRGZRUE1XbXhWZENNY3FTeHJoNURRaVNSZmRPQnhEZENYNzZtQmFxbWhDdVhvSXFwL2hEd3greE5oM0NSOVgKNmlCU0RMNnBlWXFMY1dHY2hKbFoxK3JMdmh6M3dxVUtQVzNvczZqcVM0K3A0NTk0cFVMUG9QV2w3MEQvYzh5YgpYU3NvV0tFc2ZTdTBGNi9tOXl5RFQ1WXE5M2RDQiswTkxmR05oRmNlN0t1OVdoeXl5VEY0Z3FXVlAzMVB2ZlFsCldmYTQ2YUJxd0hFa0tXZkZ4NjNyNGdvMXB0UmJ5VmF0TnNpc2VHZlZvV0IzS2ZsWTFpQ0VMQndDUVBkOGNsZjYKcDJJeFcrT1pNSDdtNHpnaGRaRld3SXdSeWRIRkpwSFkyZlNvMndJREFRQUJBb0lCQUNFdjU3OWpQd0dncUJwQQo2TUpXdUFDR3FGOU4rZnJCUVhiU0dTQmE0aFp4NTVqRUpVanJ0ampTTGpNeE9Pck9Kby9oaHhHWXZhTENyb0l0ClpvbE1CTndGdHFWa1pzbGh6SXZaSGJ2OS9IaXk2cVVnRkxidjhLV0d0cXRidVVPRGtnRzcydjJsb1k4OTMyWm4KdDlGUi85UXNHclkvZDFvSmJsOXluTVJhcUN3SmhhdjlkdXRqV1V0R0pVOFNFQUdmRnl4K1Y0aW1GSmViamxBVgpLNDNCZ3hnY1dsRk9PMmQwQW1GdHRSWWpKWlN6QVJpL0NwbXpjb0dkK2o5SzBGajhCUnNSRitUOVNWeXhVdkxGClNxQWpGeVlRWVVyUFY2dkJ4WVNhSkJKMEMvM1RzNHJkZE9BWFY1THJJdmgzZERWMjVJa0JMbzFHV05HdzEyMjEKc0E3L3h1RUNnWUVBODVWdjU1clgxeXRJUzRYN0RhTmN4ZXJLMGVQVU9FRmVTSUw0cVRLL2hEeWxYcnB1S0toLwpNMHJ4RWRqemtjdDk0OWU5eFE4ZktiYW1sZ3F6c0ZNYkZsWXUxV01mdXZXRTNzdE4xRFF0MitJTjhkOTlvSDQ0CkNDdWpmclhTb0QrUTdoK0M5RlNTYUFtTXBjMGZqSDUxSjRqRksxM2JENXIwT0xhSEoxVy9pTkVDZ1lFQTRTOVAKOFl6QXpUYngwWWFuRTl6N1h4a2FzMG1SOHl4U1JsSW1xVnh3WWNJc05GQmppd1NBRWtoMDhlQnd1bVdpSFptWAowSGxMYVQ0Y1R4ZURhRERncTFTWEdQY1VyL1RCS1FLUlprMXY3MW5QemoyWWJnaXpzSmNnN2RlSFlyYjhqT1dpCkVESVNXU3BTK0FuYjNsRTIxVTh2U3NXYWlTNHhiTEt4Y3RSVlFlc0NnWUJNSlEvcFg4OVBWUmx4ZW4yam9zalMKbWZZekxMeGZwWmVhcFU2a1hkZmV0N0tlYlRzWWZLdmUxZk9NTjd6VWU3OXI1VHBPaXM2Y0ZKdjQxWG1jaWk0eQppbGh6bmx3Qjd0Uk5iVkowSHFlalVBUTU4enByWEdtWnJFS2N6cXY4S2tMZEhYNnJjSENnRXpRamRIOERSVmpNCk5nWWs2MThhZnI4UHA0ZVNkVXk5c1FLQmdDVGdCb3RiclVidHRIUEhSUnp2bHdwZnBndXVCSVI1d1k5YWJKSlgKWE4vbFdDL0k2a1Fkbkl0aDZpU2h5RlA5eUtwb09JQWZITVpETVllU0ppYXR1bHpVSVZvcE8rNEVlbzBvcW43QwpONDVPZXNVZk9STHJ3ZUV0SG10VVhBdENRK0VleVljMWErUEdGb2dmdFMyV3h3L3ZRNk5POEp0K1FRRzMwVzhvCmJqMjVBb0dCQU9KaGRHbmtjbVhLUFdPVjhBZVVWenB3S0ZuWnJ0dFordThNcnR2OTFiZHBqWFo5Z2liRFZwSkkKWit0WVo3MlBEZWVpVG9CbEhMQVdwajk4VWVXb1VTaU9kMHhjditaekhaUlp4aE9oTDJSRWpUT0ZyVUFLNXNWaQp5U1ZKelZ4cUQyVXlkeXM3OG5kYnNNUUU4UGRQcnhJOEdkZkFUczEyR2hyYmhqMENTdXBOCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }

    #https://github.com/apps/cawe-connected-actions
    apigithubcom = {
        app_id         = "308622"
        client_id      = "Iv1.142981d6129b055d"
        key_base64     = "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBbG9yVzNzY1FzVGl2YmlGTVo4VnJaNDhNZW1jc1o2WUcxUk94eE5iaGhDaFlhKzZUCkdqRkszOGdKeFJGeFdFWkZ2UXcxM0ZIVDI4REtuU3RUbG9YQnRURGxsdDdsQXJTUHh6R2ZmcUgyTC9Bb3FCSWoKS3BJdXJpczlObkwxczN1SktTYllpb1BMU2RsbGdyZ3lOWU5ISlRsWFhIby9GSW1FWUIyRC9aM0JLR25uNTdidQpNZklHVVljY2JFVlJiQWE5RWhKeUxTTHdRak1TUC90YnpPRnNZTTFOcWNZVlZ5MHJMNHFBRWl4YUwyMDY1VTFqCjBoT3kzbmpzTERaSytjRVMxNUFPQmFpMWM0dE1Zb3A0dG9Oc3V1VEp0NTl6cXk3bjFmQmpyVW9NenFYbUtua3QKNVU3RzlvZEtjSi9nTndyYjNMdC9qKzVSUnFpR0VkNjc2VnZya3dJREFRQUJBb0lCQUJyV0oxWFJnTjFHOEtjZQpVb09SUXdOVUVmSmtJQnRlRW91N2xnNDBERUhGKzNWS00za1EzbnNrS3ZHeG1WWVdPT3BwbWRScjFldXY0NjYvCkFZaXMwWXBlYkI5SUh1VXJrUkgrZTZOVWRoRzNxMWZDMi9nRDFVU0JPc2xSRnhIbTdOMmtLaWdQTkpjMnBRejMKanlQUkFrYlZnUWhnVm94dnMyUjYvb09nc3NWa1RjL2xOK2ZWNDBtb1czcW5UaWN1Y1lSeGt2OWdmYi8vN3Q2RApFUStEUG56d1UwY0tETlFySkNRaHR2SlV5dXd4Y2VkTlVzVWZGdUtFMWMwa2NFSllqVlZhaW43VHk2SXZlcDZCClpsYUozWmh4bGV5bGJWLzdCbmh2aHlwNDNIOGpUVzlETk5TdUtYL0lpdktCMmRKRWwyRFVUUHl5SlRjVW5FajkKNnVVZUJZa0NnWUVBeEpYWlYyTTNybE5EK0JNWUFWUzFHUkpsVjdrYWZxcFZFUVBzK2RSMEliNTlmMmZJaVpDOAowK3l1SkdNRXN3S2NNYWh4MlhKc1JWNUJEUTVTWUdvdFZpNEJDUEJBRkw3bVdpRTNneGdLcFpwcjQxRXdma3ZvCnVFZ3JMbXRCcjYxblhtOE1tbzNSQ0Q2UVg5SkRMaEtpU3lGd3Eya2RWSDZySlNMYVF2dXV2YmNDZ1lFQXhBcVEKQzliY29qS2o0WnFHR3ZHQjREemYrVWQvS1VBWURaVlQ2MTUzRzdHeXZBVFRpeEcxTkQxUjlZZFRBdnpHNlJrZApKTjNmQ213c3U2OXMvWFF3NWV6UFZkMml4Y2dPV1NJWlNqN0czcktVSnBOcFU1dUdIWmo5U2ovelRvN3JTNUlnCnBkYVBZVis1SnVYZHI0ZzFtdm92OGsySVEwb201T3RnSjhsdmdRVUNnWUFrUFA5WXBaaVJFUlpaZDZPWU16WkQKRGVvU2xyTzBuOCtZbUdHcDJDa2tRMG85SHpPUGNGZnV0UldRN1pQakw5cjlLSEQ4UmFTQjBSTXF4ZllYZ2RzagpwTTFhQ1hlMm0wNDVWU0Eza1VuOUp3ODJVelFlUS8zOVlvaGJRVGhWbXlDUC91YVM0d3VpZW00QXkvRElZSFQ4ClpvaXZnR3dBdEd6MkpvdVhoMis1MXdLQmdILzNFUjNaUzczSVpuY09JYm1XcVp0UXdUWjd1QUthSnRrKy96OWwKTTBSdGt1anVFWlAycEJ5TVptSnB5Z0xxTTREV2R0S296VDJGYlJHNktkK3JwM3QrUDd5aDV1MUpjQ3c0ZU4rZwo2TGxYUWlPSUY3bU9qRlhubG5hUUZlYlNuYjUvalRZVFB4WmxvSHRHa3BWUXlRVDNpTEtXYjNyVS9WeHlWQnJFCmZ6ZHRBb0dBZkRQdllTWWQ1TUFFelRtalVGSlQ4VHhTTE1JM0o3Q0czT3VDejdBVVFLZjU3azllOHVjVDFUWDQKM1JITXhkUEVXZUhkS1ZnUStMZ1IvV2taRGEzRkFWbmtGS0R4TzNEZlpIQ1RpL3pDUjVGRXNKVVdDNXFlQVNVago2NDZpOFJMaGFKdGRqK0tuSTNPcUJRbHJEVFpWYTYvaFVvT2VIQjVEZjBnaDA1SmlXQTA9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
        webhook_secret = "CAWEsecret123!"
    }
}


### API GATEWAY / Lambda - Webhook ####

lambda_webhook_function_name = "webhook-receiver"
relative_webhook_url         = "webhook"


### API GATEWAY / Lambda - Runners ####
lambda_runners_function_name = "runners"
lambda_runners-macos_function_name = "runners-macos"

lambda_zip = "../lambda/dist/lambda.zip"

lambda_code = "../lambda"

### General ###

environment  = "prd"
group        = "cawe"
project_name = "cawe"
region       = "cn-north-1"
account_type = "ADV"

common_tags = {
    environment  = "prd"
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
nginx_max_size         = 9

ami_linux_ubuntu_x64_version   = "v1.14.2"
ami_linux_ubuntu_arm64_version = "v1.14.2"
