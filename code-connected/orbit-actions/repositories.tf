# To enable branch protection after code.connected is discontinued

module "java-maven-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Demo workflows repository for a java project with maven"
    repository_name        = "java-maven-demo"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}
    }
}

module "csharp-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Demo workflows repository for a csharp project"
    repository_name        = "csharp-demo"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}

    }
}

module "go-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Demo workflows repository for a go project"
    repository_name        = "go-demo"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}

    }
}

module "swift-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Demo workflows repository for a swift project"
    repository_name        = "swift-demo"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}

    }
}

module "terraform-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Demo workflows repository for a terraform project"
    repository_name        = "terraform-demo"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}

    }
}

module "spaceship-kong-demo" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This repository contains a PoC for creating CI/CD workflows to Kong."
    repository_name        = "spaceship-kong-poc"
    repository_visibility = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    environments     = {
        dev = {
            team_reviewers                          = [module.teams["Spaceship"].team_id]
            only_allow_protected_branches_to_deploy = false
            only_allow_selected_branches_to_deploy  = true
        },
        int = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        },
        prd = {
            only_allow_protected_branches_to_deploy = true
            only_allow_selected_branches_to_deploy  = false
            team_reviewers                          = [module.teams["Spaceship"].team_id]
        }
    }
    branch_protection = {
        main = {}

    }
}

module "action-sync" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to sync actions from other github instances"
    repository_name        = "action-sync"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "axway-actions" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our axway actions"
    repository_name        = "axway-actions"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "checkov-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our checkov actions"
    repository_name        = "checkov-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "csharp-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our csharp actions"
    repository_name        = "csharp-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "docker-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our docker actions"
    repository_name        = "docker-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "terraform-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our terraform actions"
    repository_name        = "terraform-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "go-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our go actions"
    repository_name        = "go-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "java-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our java actions"
    repository_name        = "java-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "k8s-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our k8s actions"
    repository_name        = "k8s-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "node-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our node actions"
    repository_name        = "node-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "python-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our python actions"
    repository_name        = "python-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "swift-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our swift actions"
    repository_name        = "swift-workflows"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}

    }
    environments = {}
}

module "setup-kustomize" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install kustomize on the runner with cache"
    repository_name        = "setup-kustomize"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-maven" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install maven on the runner with cache"
    repository_name        = "setup-maven"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-regctl" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install regctl on the runner with cache"
    repository_name        = "setup-regctl"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-vault" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install vault on the runner with cache"
    repository_name        = "setup-vault"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-wizcli" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install wizcli on the runner with cache"
    repository_name        = "setup-wizcli"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-xq" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install xq on the runner with cache"
    repository_name        = "setup-xq"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-yq" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to install yq on the runner with cache"
    repository_name        = "setup-yq"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "spaceship-setup" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Validate inputs (MSID)"
    repository_name        = "spaceship-setup"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "download-from-artifactory" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to download artifacts from Artifactory 7"
    repository_name        = "download-from-artifactory"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {}
    environments = {}
}

module "download-from-nexus" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Action to download artifacts from nexus"
    repository_name        = "download-from-nexus"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "send-email" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Send email action"
    repository_name        = "send-email"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "ami-copy" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Copy AWS AMI action"
    repository_name        = "ami-copy"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "flyway-on-orbit" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Run flyway on orbit clusters"
    repository_name        = "flyway-on-orbit"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "metrics-collector" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our metrics collector action"
    repository_name        = "metrics-collector"
    repository_visibility  = "public"
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "template-action" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Template action"
    repository_name        = "template-action"
    repository_visibility  = "public"
    is_template = true
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "typescript-action-template" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Create a TypeScript Action with tests, linting, workflow, publishing, and versioning"
    repository_name        = "typescript-action-template"
    repository_visibility  = "public"
    is_template = true
    repository_teams       = {
        spaceship = {
            permission = "admin"
            team_id    = lower(lower(module.teams["Spaceship"].team_name))
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users  = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "artifactory-oidc-generic" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host our artifactory oidc generic actions"
    repository_name        = "artifactory-oidc-generic"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {
        "Vivek Raj" = {
            permission = "maintain"
            username   = "vivek-raj"
        },
        "Mangi Lal" = {
            permission = "maintain"
            username   = "MangiLal"
        }
    }
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "aws-ssm-get-parameters" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host the GHA to retrieves secrets from AWS Systems Manager (SSM) Parameter Store"
    repository_name        = "aws-ssm-get-parameters"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "containerized-job" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This action allows to deploy a container with a specific image in orbit cluster"
    repository_name        = "containerized-job"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "eks-deployment-status" {
    source                 = "../../modules/github/base-repository"
    repository_description = "This action allows to check the status of deployment(s)"
    repository_name        = "eks-deployment-status"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "short-hash-tagging" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host the Create tag with commit hash action"
    repository_name        = "short-hash-tagging"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "setup-certificates" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host the setup-certificate actions"
    repository_name        = "setup-certificates"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(lower(module.teams["Spaceship-L2"].team_name))
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

module "kong-action" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host the kong action."
    repository_name        = "kong-action"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    branch_protection = {
        main = {
            status_checks = [
                {
                    enforce_branches_up_to_date = true
                    checks = [
                        "GitHub Actions Test",
                        "TypeScript Tests"
                    ]
                }
            ]
        }
    }
    environments = {}
}

module "kong-workflows" {
    source                 = "../../modules/github/base-repository"
    repository_description = "Repository to host the kong workflows."
    repository_name        = "kong-workflows"
    repository_visibility  = "public"
    repository_teams = {
        spaceship = {
            permission = "admin"
            team_id    = lower(module.teams["Spaceship"].team_name)
        },
        spaceship-l2 = {
            permission = "triage"
            team_id    = lower(module.teams["Spaceship-L2"].team_name)
        }
    }
    repository_users = {}
    branch_protection = {
        main = {}
    }
    environments = {}
}

