# 🧠 Pokémon App

This project deploys a Pokémon frontend and backend system on AWS EC2 instances using **Terraform** for infrastructure and **Ansible** for configuration.

---

## ✅ Requirements

Make sure the following tools are installed on your **Ubuntu machine**:
- Terraform
- Ansible
- Git
- AWS CLI

---

## 🔐 1. Set Up AWS Credentials

Run:

```bash
nano ~/.aws/credentials
````

---

## 📦 2. Clone the Repository

```bash
git clone https://github.com/nadine2000/pokemon3
cd pokemon3/terraform
```

---

## 🔑 3. Create SSH Key Pair

```bash
aws ec2 create-key-pair \
  --key-name gkey \
  --key-type rsa \
  --query 'KeyMaterial' \
  --output text > ~/.gkey.pem

chmod 400 ~/.gkey.pem
```

---

## ⚙️ 4. Launch EC2 Instances with Terraform

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

> 🔁 Save the **public** and **private IPs** of both backend and frontend EC2 instances.

---
## 🚀 5. Now the backend server will Run automatically 
---

## 🎨 6. Run the Frontend
### a) Configure Ansible Inventory

Edit the inventory:

```bash
nano pokemon3/ansible/inventory.ini
```

Add your frontend EC2 public IP:

```ini
[frontend]
<frontend_public_ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/.gkey.pem
```

---

### b) Run Ansible Playbook

```bash
cd pokemon3/ansible
ansible-playbook -i inventory.ini playbook.yml
```

---

### c) SSH into Frontend and Run App

```bash
ssh -i ~/.gkey.pem ec2-user@<frontend_server_public_ip>
```

---

### d) Update API URL in Frontend

Edit the file:

```bash
nano pokemon3/frontend/db.py
```

Update this line:

```python
API_BASE_URL = "http://<backend_private_ip>:5000"
```
---
### e) Run App

```bash
cd pokemon3/frontend
python3 main.py
```
---

## 🧽 Cleanup

To delete the key pair and remove infrastructure:

```bash
aws ec2 delete-key-pair --key-name gkey
rm ~/.gkey.pem
```

```bash
cd pokemon3/terraform
terraform destroy -auto-approve
```
