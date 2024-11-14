locals {
    secrets = flatten([
        for env_name, env_config in var.environments :
        [
            for secret_name, secret_config in env_config.secrets :
            {
                environment  = env_name
                secret_name  = secret_config.secret_name
                secret_value = secret_config.secret_value
            }
        ]
        if contains(keys(env_config), "secrets")
    ])

    policies = flatten([
        for env_name, env_config in var.environments :
        [
            for policy_name, policy_config in env_config.policies :
            {
                environment    = env_name
                policy         = policy_name
                branch_pattern = policy_config.branch_patten
            }
        ]
        if contains(keys(env_config), "policies")
    ])

}
