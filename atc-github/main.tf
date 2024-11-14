module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "cicd" {
    source    = "./cicd"
    providers = {
        github = github.cicd-atc
    }
    team_members_github = module.product.github-teams-QNumber
}

module "orbit-actions" {
    source    = "./orbit-actions"
    providers = {
        github = github.orbit-actions-atc
    }
    team_members_github = module.product.github-teams-QNumber
}
