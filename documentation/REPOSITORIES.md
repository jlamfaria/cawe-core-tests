# Create a new repository and add it to our IaC project

Steps:
1. Create a new repository on GitHub
2. Clone the repository to your local machine
3. Init the repository (branch, commit, push)
4. Add the repository to our IaC project
5. Login to AWS - do not select any profile `cawe -init`
6. Login to CodeConnected and ATC GitHub `gh auth login`
7. Run `terraform init` to initialize the new module
8. Check if you are in the correct workspace `terraform workspace list` 
9. Switch to the correct workspace (code-connected or atc-github) `terraform workspace select WORKSPACE`
10. Run `terraform apply` to apply the changes


## Extra notes:

#### [Docs for how to login with gh cli](https://cli.github.com/manual/gh_auth_login)


#### If we need to set secrets in the repository, we can use the sops integration: 
  1. Call the sops module and use the output in the secrets object in the environment file.


#### Please inspect the variable declaration in the github/repository module to see how to use ahh of the variables.

#### If you get the error "name already exists on this account", please run this command
   1. `terraform import module.orbit-actions.module.REPO_NAME.github_repository.repository REPO_NAME`