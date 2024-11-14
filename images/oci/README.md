## OCIs

The Open Container Initiative (OCI) is a Linux Foundation project, started in June 2015 by Docker, to design open
standards for operating-system-level virtualization (software containers), most importantly Linux containers.

In this directory you can find images that are used by CAWE in the runners

| Folder                         | OS            | Comments                             |
| ------------------------------ | ------------- | ------------------------------------ |
| [ventura](./ventura/README.md) | macOS Ventura | This image hosts a macos cawe runner |

OCIs are uploaded to the central account, 831308554080 and then distributed over the necessary accounts.

❗ To build an OCI the environment cannot be virtualized, therefore this cannot be executed inside a normal CAWE runner❗

[Pipeline build documentation](./Pipeline.md)

### Build commands

```
$ packer init <filename>.pkr.hcl
$ packer validate -var-file <filename>.pkvars.hcl <filename>.pkr.hcl
$ packer build -var-file <filename>.pkvars.hcl <filename>.pkr.hcl
```

Next, we need to send this new image to the ECR

- Set the right profile (export AWS_PROFILE or use cawe-tools)
- Login to the ECR

  `aws ecr get-login-password --region eu-west-1 | sudo tart login --username AWS --password-stdin 831308554080.dkr.ecr.eu-west-1.amazonaws.com`

- Push (specify the correct tag version)  
  `tart push < local-vm-name -> cawe-ventura > 831308554080.dkr.ecr.eu-west-1.amazonaws.com/cawe-ventura:< version >`
