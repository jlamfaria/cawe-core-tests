## AMIs

An Amazon Machine Image (AMI) is a supported and maintained image provided by CAWE that provides the information
required to launch an EC2 instance.

In this directory you can find images that are used by CAWE in the runners

| Folder                                                                                              | OS            | Comments                                                     |
| --------------------------------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------ |
| [macos_hypervisor](https://code.connected.bmw/cicd/cawe-core/tree/main/images/ami/macos_hypervisor) | macOS Ventura | This AMI contains the virtual API used to virtualize runners |

❗❗ &darr; Only applicable in future versions &darr; ❗❗

AMIs are deployed in the central account, 831308554080 and then distributed over the necessary accounts.

To build an AMI it is preferable to use the pipeline made for that purpose

If it is needed to build it manually the following command should be issued:

```
$ packer init <filename>.pkr.hcl
$ packer validate -var-file <filename>.pkrvars.hcl <filename>.pkr.hcl
$ packer build -var-file <filename>.pkrvars.hcl <filename>.pkr.hcl
```

❗ Make sure that the correct variables are set, specially the role to assume, so that the AMI is created in the correct account
