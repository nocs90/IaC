#!/bin/bash
# Simple bash script that exec terraform and ansible playbook

TERRAFORM_DIR="/Users/nocs/Documents/cloud-engineer/application/cloud-playground"
ANSIBLE_DIR="/Users/nocs/Documents/cloud-engineer/application/ansible-conf"
KEY_PATH="/Users/nocs/.ssh/kataKey"

default_user="ubuntu"

cd $TERRAFORM_DIR

# verify your terraform source code 
terraform plan

# apply infrastructure configuration
terraform apply -auto-approve

# retrieve EC2 elastic ip address
ELASTIC_IP="$(terraform output kata-host-eip | grep -w 'public_ip' | awk -F "\"" '{ print $4 }')"

echo $ELASTIC_IP # debug print

echo "[kata-web]" > $ANSIBLE_DIR/hosts
echo $ELASTIC_IP >> $ANSIBLE_DIR/hosts

terraform output kata-rds-endpoint | awk -F "\:" '{printf $1}' > $TERRAFORM_DIR/rds-endpoint.txt
terraform output access > $TERRAFORM_DIR/access-key-ID.txt
terraform output secret | base64 --decode | keybase pgp decrypt > $TERRAFORM_DIR/access-secret-key.txt

RDS_ENDPOINT="$(cat rds-endpoint.txt)"

ansible-playbook --vault-password-file ~/.kata-vault-pass.txt -u $default_user --key-file=$KEY_PATH --ssh-common-args="-o StrictHostKeyChecking=no" -i $ANSIBLE_DIR/hosts $TERRAFORM_DIR/kata-web.yml

exit 0
