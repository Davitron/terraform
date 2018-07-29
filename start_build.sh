#!/usr/bin/env bash
# File: start_build

set -x 

function buildrun {
  # Previous output txt .tf  files are removed before a new one is generated 
  rm packer_output.txt
  rm amivar.tf

  # Packer build is run on the packer template for the Database 
  # Image and the AMI ID is appended to the txt file
  packer build packer-db-terraform.json | tee packer_output.txt
  AMI_DB_ID=`egrep -oe 'ami-.{17}' packer_output.txt |tail -n1`
  echo 'variable "AMI_DB_ID" { default = "'${AMI_DB_ID}'" }' >> amivar.tf
  echo 'next build'
  # Packer build is run on the App AMI and the ID is also appended to the txt file
  packer build packer-app-terraform.json | tee packer_output.txt
  AMI_APP_ID=`egrep -oe 'ami-.{17}' packer_output.txt |tail -n1`
  echo 'variable "AMI_APP_ID" { default = "'${AMI_APP_ID}'" }' >> amivar.tf

}


buildrun