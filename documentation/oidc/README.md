#  Introduction

This explains how the Orbit Spaceship team setup keyless deployment using OpenID Connect (OIDC) to securely integrate GitHub Enterprise with AWS, eliminating the need to distribute long-lived credentials (like aws access keys or aws secret keys) for authentication.

## Setup on AWS EMEA 🇪🇺

### Create the OpenID Connect Provider

The `Token URL` varies between the GitHub Instances:

- For `github.com`, it is `https://token.actions.githubusercontent.com`.
- For `code.connected.bmw`, it is `https://code.connected.bmw/_services/token`.
- For `atc-github.azure.cloud.bmw`, it is `https://atc-github.azure.cloud.bmw/_services/token`.

The client id list is the AWS sts → `sts.amazonaws.com`.

The thumbprint can be obtained in two ways:

#### Manually

1. Run the command:

```bash
openssl s_client -servername keys.code.connected.bmw -showcerts -connect keys.code.connected.bmw:443
```

2. Copy the certificate (last one) to a file (`certificate.crt`).
3. Run the command:

```bash
openssl x509 -in certificate.crt -fingerprint -noout
```
The fingerprint is the SHA1 Fingerprint=XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX, but without the ":".

You can use the command `sed` to get this:

```bash
openssl x509 -in certificate.crt -fingerprint -noout | sed 's/SHA1 Fingerprint=//g' | sed 's/://g'
```

#### Using Terraform Data Block

```hcl
data "tls_certificate" "github" {
  url = "https://${local.token_url}"
}
```

## Create the OIDC Provider Resource
### Using the AWS Portal
### Navigate to IAM > Identity provider > OIDC.
### Using Terraform


```hcl
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://${local.token_url}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.github.certificates.*.sha1_fingerprint
}
```

#### Create the Policy

In the values of the last condition, we should specify the repos we want to give access to in the format: repo:ORG/REPO:BRANCH (only replace capital letters). Since we want all repos of the CICD org, we used the following repo:cicd/*:

```hcl
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.token_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${local.token_url}:sub"
      values   = [
        "repo:ORG/REPO:BRANCH",
        "repo:ORG/*:*"
      ]
    }
  }
}
```

#### Add the OIDC Policy in the Role You Will Use

```hcl
resource "aws_iam_role" "role" {
  name                 = var.role_name
  path                 = "/example/"
  max_session_duration = local.max_session_duration
  description          = "Role created by TEAM NAME"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy_oidc.json
}
```

### Setup on GitHub

Add the Needed Permissions to the Pipelinepermissions:

```yaml
  id-token:
  contents: read
```

## Setup on AWS China 🇨🇳

Since we don't have perrmissions to set up the OIDC provider, we need to ask the TSP Cloud China team to do it for us.

A ticket  should be create in the ITSM next specifying the service offering **TSP Cloud-Ops**. On the ticket notes, you can provide the request OIDC information like this example below:

```text
Provider: code.connected.bmw/_services/token
Type: OpenID Connect
Audience: sts.amazonaws.com
Thumbprints: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

> In the future, we will be able to create the OIDC in the SCP Portal, but for now, we need to ask the TSP Cloud China team to do it for us.