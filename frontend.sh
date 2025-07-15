#!/bin/bash

cd terraform

aws ec2 create-key-pair \
  --key-name gkey \
  --key-type rsa \
  --query 'KeyMaterial' \
  --output text > ~/.gkey.pem

chmod 400 ~/.gkey.pem

terraform init
terraform plan
terraform apply -auto-approve

frontend_ip=$(terraform output -raw game_server_public_ip)
backend_ip=$(terraform output -raw backend_server_private_ip)


touch ../ansible/inventory.ini
echo "[frontend]" > ../ansible/inventory.ini
echo "$frontend_ip ansible_user=ec2-user ansible_ssh_private_key_file=~/.gkey.pem" >> ../ansible/inventory.ini
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml --extra-vars "backend_ip=${backend_ip}"
ssh -i ~/.gkey.pem ec2-user@$frontend_ip
