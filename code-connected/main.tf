module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}


module "cicd" {
    source    = "./cicd"
    providers = {
        github = github.cicd-code-connected
    }
    team_members_github = module.product.github-teams
}

module "orbit-actions" {
    source    = "./orbit-actions"
    providers = {
        github = github.orbit-actions-code-connected
    }
    team_members_github = module.product.github-teams
}
