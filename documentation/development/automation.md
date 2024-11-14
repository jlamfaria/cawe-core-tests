This document describes the evaluation of automation best practices to be used in CAWE - Continuous Automation Workflow Enabler, which focuses on providing infrastructure and guidance for GitHub Actions.

# Terraform Automation

## Important Considerations

- Non-Interactive environment implies some changes on Terraform behavior. It's set by TF_IN_AUTOMATION env var and expects to have all the required inputs through variables on configuration files and environment variables.
- In an automated environment, manual changes should be avoided at all cases. These cause drift of the real state when compared with the expected one by terraform.
- Infrastructure definitions should also be versioned controlled as code
- Secrets should be managed on dedicated tools. e.g. HashiCorp's Vault

## Overview of the automation flow

The main stages of the automation flow using terraform are:

- Init - Where the Terraform working directory is setup
- Plan - It's the step where Terraform consumes all the configuration files and variables and creates a plan of actions that represent the intended infrastructure
- Review - Refers to the stage where the previously generated plan should be validated by an operator. It's a manual process and usually only mandatory on production environments.
- Apply - Refers to the stage where the the approved play is actually put in place by Terraform

It's important to run the plan and apply stage on the same machine or using tools that can guarantee that the underlying environment is alike. e.g. Docker containers

## Multi-environment infrastructure

- Terraform provides a workspace functionally that allows to have multiple settings for each
- The working directory used on the init stage should be independent
- Different cloud providers have different needs configuration wise that need to be taken in consideration

## Flow control based on Feature Flags

- Terraform has no dedicated feature to behave as a feature flag but it has a count parameter that can be used to instantiate or not a specific resource (1 or 0)
- Count parameter can be interpolated through other variables in \*.tf files
- Count parameter can be used to represent differenced between environments for example

## Tools to instruct Terraform

- Terraform can be instructed using regular bash scripts
- Github Actions and similar tools can be used to orchestrate the several steps with terraform CLI
- There is also Terraform Cloud provided by HashiCorp's it self

## Recommendation

- GitHub actions looks to be the most suitable tool to orchestrate Terraform flows in our case
  - Github actions allow us to implement trunk based development flow as mentioned on: [Development Flow](./development_flow.md)
  - Github actions provides ways to trigger workflows based on different triggers like git push, pull request creation, addition of labels, etc..
  - Github actions provides mechanisms to review and manually approve the deployment by a human operator
  - Github actions provides mechanisms to run workflows on schedule basis
- Regarding the development flow

  - Changes need related to infrastructure should be addressed in a new Pull Request in draft mode
  - Once PR is created / pushed with new commits, Github actions should trigger a new workflow with steps:
    - validation
    - generation of docs
    - Run TF init
    - Run static and unit tests
    - Run TF plan
    - Update PR (with plan)
  - Integration tests and e2e tests can be triggered via the addition of a new label on the Pull Request (Reduce the load when making small increments)
  - One the PR is considered ready, integration and e2e test should be run (via label addition)
  - The PR should be reviewed and approved by an human operator
  - Once approved developer should be able to trigger the main deployment flow by adding a label on PR

    - GHA workflow should make validations if the PR is up-to-date with the trunk branch
    - Run full set of tests as last barrier
    - Apply the TF plan on production env
    - Update PR with the outcome from the plan and apply
    - Merge PR automatically

## Deployment for different regions (EMEA 🇪🇺 and CN 🇨🇳)

- On the Spaceship Infrastructure setup, we have two "regions", EMEA and CN
- In the deployment workflows, there is a dropdown menu to select the region for deploying the Terraform infrastructure
- The options available are EMEA, CN, and both, as shown in the following picture:

![region](./images/dropdown-menu-regions.png)