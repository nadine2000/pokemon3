# 🧠 Pokémon App

This project deploys a Pokémon frontend and backend system on AWS EC2 instances using **Terraform** for infrastructure and **Ansible** for configuration.



## ✅ Requirements

Make sure the following tools are installed on your **Ubuntu machine**:
- Terraform
- Ansible
- Git
- AWS CLI



##  1. Set Up AWS Credentials
```bash
nano ~/.aws/credentials
````



## 2. Clone the Repository

```bash
git clone https://github.com/nadine2000/pokemon3
cd pokemon3
```


### 3. Make the Frontend Script Executable

```bash
chmod +x deploy.sh
```

### 4. Run the Frontend Setup Script

This script installs dependencies and prepares the frontend environment.

```bash
./deploy.sh
```

##  5. Run the Frontend
```bash
cd pokemon3/frontend
python3 main.py
```


## 🧽 Cleanup

To delete the key pair and remove infrastructure:

```bash
aws ec2 delete-key-pair --key-name gkey
rm ~/.gkey.pem
cd pokemon3/terraform
terraform destroy -auto-approve
```
