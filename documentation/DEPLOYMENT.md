# How to Deploy From Scratch

## Requirements

- Access to [BMW Customer Portal for Amazon Web Services](https://manage.aws.bmw.cloud).
- Access to AWS with your Active Directory credentials via SSO
- Ability to assume `UserFull` role in all target accounts.
- AWS CLI - https://aws.amazon.com/cli
- Python 3 - https://www.python.org
- PyPi (pip) - https://pypi.org
- BMW AWS CLI - https://atc.bmwgroup.net/bitbucket/projects/FPCBMW/repos/bmwaws-cli/browse
- Terraform CLI installed version >= 1.3.2 - [Download Terraform](https://www.terraform.io/downloads)
- Node 16 - https://nodejs.org/en/download/
- Checkov - https://www.checkov.io/
- Run `npm i` on the root of the repo to configure the git hooks

## Git Hooks

- [pre-commit](./.husky/pre-commit)

## Deployment

0. Make sure you are logged in on AWS CLI with your own personal account.

   [cawe-tools](https://code.connected.bmw/cicd/cawe-tools) can be uses to clean any previously assumed role and select the `bmwsso` credentials

   ```
   cawe -c -p
   bmwaws login
   cawe -cred bmwsso
   ```

   Current credentials can be validated using:

   ```
   aws sts get-caller-identity
   ```

1. We need to provision our CAWE Admin account first because we will use it as our central account.

   Go to folder `831308554080` and run the following commands:

   ```
   terraform init
   ```

   ```
   terraform workspace new 831308554080
   ```

   ```
   terraform apply --var-file inputs.tfvars --var role_to_assume="arn:aws:iam::831308554080:role/fpc/UserFull"
   ```

2. Provision the transit account.

   Go to folder `932595925475` and run the following commands:

   ```
   terraform init
   ```

   ```
   terraform workspace new 932595925475
   ```

   The apply command should be only applied to the IAM Module

   ```
   terraform apply --var-file inputs.tfvars --var role_to_assume="arn:aws:iam::932595925475:role/fpc/UserFull"
   ```

3. Provision the stack account

   Go to folder `092228957173` and run the following commands:

   ```
   terraform init
   ```

   ```
   terraform workspace new 092228957173
   ```

   The apply command should be only applied to the IAM Module

   ```
   terraform apply --var-file inputs.tfvars --var role_to_assume="arn:aws:iam::092228957173:role/fpc/UserFull"
   ```

4. Deploy in the transit account:

   Go to folder `932595925475` and run the following commands:

   ```
   terraform workspace select 932595925475
   ```

   ```
   terraform apply --var-file inputs.tfvars
   ```

5. Deploy in the stack account:

   Go to folder `092228957173` and run the following commands:

   ```
   terraform workspace select 092228957173
   ```

   ```
   terraform apply --var-file inputs.tfvars
   ```
