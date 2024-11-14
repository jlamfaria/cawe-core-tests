# Troubleshooting Guide

## Spinup Static Runners on Target Org

Developer guide to provision static runners in CAWE as failover solution can be found
[here](./documentation/failover/README.md).

## Validade Github App Fingerprint

https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps

Validate sha256 fingerprint:

```sh
openssl rsa -in PATH_TO_PEM_FILE -pubout -outform DER | openssl sha256 -binary | openssl base64
```

## Cleanup Terraform State Lock

When a Github job with terraform actions is canceled, terraform state might get stuck with an throw an error such as:

<b>

```
   │ Error: Error acquiring the state lock
   │
   │ Error message: ConditionalCheckFailedException: The conditional request
   │ failed
   │ Lock Info:
   │   ID:        <Resource-ID>
   │   Path:      ca-remote-state-prd/ca-accounts/<Account>/terraform.tfstate
   │   Operation: OperationTypePlan
   │   Who:       root@i-0c943ae760b3fd7fc
   │   Version:   1.1.9
   │   Created:   2023-09-29 14:36:03.956150917 +0000 UTC
   │   Info:
   │
   │
   │ Terraform acquires a state lock to protect the state from being written
   │ by multiple users at the same time. Please resolve the issue above and try
   │ again. For most commands, you can disable locking with the "-lock=false"
   │ flag, but this is not recommended.
   ╵
```

Validate that no one else is making working on that `<Account>` id.

</b>

0. Make sure you are logged in on AWS CLI with your own personal account as referred in the [deployment guide](./DEPLOYMENT.md).

1. Go to folder `<Account>` and run the following commands:

```
terraform init
```

```
terraform workspace select <Account>
```

```
terraform force-unlock <Resource-ID>
```

If the error still persists:

3. Open AWS portal and login on Admin account with userfull permissions
4. Go to DynamoDB service
5. Select `ca-remote-state-prd-dynamodb` table and click on `Explore table Items` button
6. Search for the entry with the same <Resource-ID> and delete it

## Renew OIDC Fingerprint

When OIDC Fingerprint expires Github jobs start failing with:
<b>"Error: OpenIDConnect provider's HTTPS certificate doesn't match configured thumbprint"</b>

0. Make sure you are logged in on AWS CLI with your own personal account as referred in the [deployment guide](./DEPLOYMENT.md).

1. We need to re-aply our CAWE Admin account to update OIDC fingerprint.

   Go to folder `831308554080` and run the following commands:

   ```
   terraform init
   ```

   ```
   terraform workspace select 831308554080
   ```

   ```
   terraform apply --var-file inputs.tfvars --var role_to_assume="arn:aws:iam::831308554080:role/fpc/UserFull"
   ```
