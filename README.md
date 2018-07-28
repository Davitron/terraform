# Deploy Checkpoint Using Terraform.

## Introduction

This is a project that showcases the automationa and configuration of the build process of an application from the point where the image is built to the point where the image lauched and the product is hosted and deployed without manually doing anything else in the terminal of each of the launched intances.

### Technology and Platforms Used

- [Packer](https://www.packer.io/docs/index.html)
- [Terraform](https://www.terraform.io/docs/index.html)
- [AWS](aws.amazon.com)

### How to begin Terraform build.

This project has different terraform scripts that helps with the deployment process, however there are two packer template json files. Those files have this snippets of code

```
"variables": {
    "aws_access_key": "",
    "aws_secret_key": ""
  },
```

where you are required to include your `aws credentials` in order to allow `packer` have `authorised` access to your account in order to be able to build the `AMI` needed by the `Terraform scripts`.

Also the `Terraform` script would also need the `aws access & secret keys` there are two ways in which this can be added and made available to the scripts.

- by creating a `terraform.tfvars` file where the `key=value` are added as `access_key="value"` and `secret_key="value"`
- follow the documemtation [terraform docs](https://www.terraform.io/intro/getting-started/build.html) by creating a `~/.aws/credentials` file and then storing your `access and secret keys` there.

After adding the credentials, an `ssh key` would need to be generated in order for `terraform` to while launching the instance create a secure way of `ssh` into the instance.

run the command `ssh-keygen name-of-keygen-file`
follow the instructions, however when it prompts you to enter a `passphrase` just press the `return key` or `enter button` on your keyboard to move on to the next step.
At the end a `public name-of-keygen-file.pub` file would be generated and this file should be protected at all cost and not pushed to source control.
Also a `private key-gen-file` will be generated at the same time the public one was.
The public Key is used to create an authentication mechanism with the instance and the Private key is used to `login/ssh` into the instance.

When all the above is done do the following next:

- run the command the command `bash start_build.sh` to begin the build with packer and deployment and launching process with Terraform.

When the `start_build.sh` script is run, the first packer build starts and the `postgresql database instances` is built and provisoned and configured with `postgresql`, with `password` getting changed and a databse called `events_manager` is created.

#### NOTE:

on line 11 in the `db-postgres.sh` script where password for the postgres user is being changed should be changed to reflect the kind of password you would want. NEVER USE THE DEFAULT POSTGRES PASSWORD.
`sudo -u postgres psql postgres --command '\password abcd1234'`

During the build process of each Packer-templates, a `packer_output.txt` is being generated and the last two lines of that file is where the `ami-id` dynamically needed by terraform to complete configuration and deployment are kept.

An `amivar.tf` file is also created in order to make it easier to bring the AMI-ID gotten from the txt file more easily accessible to terraform.

At the end of the build process, a VPC should have been configured, a nat instance, 3 subnets two public and one private
and one load balancer.
