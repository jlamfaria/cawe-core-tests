module "spaceship" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Next generation Github Runners"
    repository_name        = "spaceship"
    repository_topics = ["spaceship"]
    repository_visibility  = "private"
    has_discussions        = true
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = [
                        "Build & Push DEV/INT Env. (reporter)"
                    ]
                }
            ]
        }
    }
}

module "cawe-core" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Spaceship core components"
    repository_name        = "cawe-core"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    has_discussions        = true
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = [
                        "Plan DEV Transit - 932595925475 / terraform-plan",
                        "Plan DEV Advanced - 092228957173 / terraform-plan",
                        "Plan DEV CN - 090973320140 / terraform-plan", "Plan INT ADV - 500643607194 / terraform-plan",
                        "Plan INT Transit - 565128768560 / terraform-plan",
                        "Plan INT CN - 090974794329 / terraform-plan",
                        "Test Lambdas"
                    ]
                }
            ]
        }
    }
}

module "cawe-api" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Spaceship product management API"
    repository_name        = "cawe-api"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    has_discussions        = true
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = [
                        "test-node"
                    ]
                }
            ]
        }
    }
}

module "cawe-runner-ubuntu-x64" {
    source                 = "../../modules/github/base-repository"
    repository_description = "CAWE AMIs to support our GitHub Runners"
    repository_name        = "cawe-runner-ubuntu-x64"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            policies = {
                tag = {
                    branch_patten = "v*"
                },
                main = {
                    branch_patten = "main"
                }
            }
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = ["Build Runner to DEV", "Build Runner to INT"]
                }
            ]
        }
    }
}


module "cawe-nginx-ubuntu-x64" {
    source                 = "../../modules/github/base-repository"
    repository_description = "CAWE AMIs to proxy connections from our GitHub Runners to BMW intranet"
    repository_name        = "cawe-nginx-ubuntu-x64"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            policies = {
                version = {
                    branch_patten = "v*"
                },
                main = {
                    branch_patten = "main"
                }
            }
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = ["Build Runner to DEV CN", "Build Runner to DEV CN"]
                }
            ]
        }
    }
}

module "cawe-runner-ubuntu-arm64" {
    source                 = "../../modules/github/base-repository"
    repository_description = "CAWE AWS AMIs to support our GitHub Runners"
    repository_name        = "cawe-runner-ubuntu-arm64"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            policies = {
                version = {
                    branch_patten = "v*"
                },
                main = {
                    branch_patten = "main"
                }
            }
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = ["Build Runner to DEV CN", "Build Runner to DEV CN"]
                }
            ]
        }
    }
}

module "cawe-runner-macos" {
    source                 = "../../modules/github/base-repository"
    repository_description = "CAWE AMIs to support our GitHub Runners"
    repository_name        = "cawe-runner-macos"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}
    }
}


module "runner-common" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This repository holds the common utilities between the runner images"
    repository_name        = "runner-common"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(lower(module.teams["Spaceship"].team_name))
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {}
    branch_protection = {
        main = {}
    }
}

module "ADR" {
    source                 = "../../modules/github/base-repository"
    repository_description = "An architecture decision record (ADR) is a document that captures an important architecture decision made along with its context and consequences."
    repository_name        = "ADR"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {}
    branch_protection = {
        main = {}
    }
}

module "cawe-remote-state" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This repository includes the necessary resources (S3 Terraform Backend) needed to manage infrastructure for Connected Actions."
    repository_name        = "cawe-remote-state"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {}
    branch_protection = {
        main = {}
    }
}

module "cawe-requester" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This project is an Express server that interacts with GitHub's API to manage installations and workflow jobs. It uses the Octokit library to communicate with GitHub and Axios for HTTP requests."
    repository_name        = "cawe-requester"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {
        dev = {
            team_reviewers = []
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            secrets = {}
        },
        int = {
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
            team_reviewers = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {
        }
    }
}

module "cawe-tools" {
    source                 = "../../modules/github/base-repository"
    repository_description = "A CLI tool, written in Python, to ease the Continuous Automation Workflow Enabler (CAWE) development"
    repository_name        = "cawe-tools"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {}
    branch_protection = {
        main = {}
    }
}

module "docker-images" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to store Docker Images"
    repository_name        = "docker-images"
    repository_topics = ["spaceship"]
    repository_visibility  = "internal"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    environments = {}
    branch_protection = {
        main = {}
    }
}
