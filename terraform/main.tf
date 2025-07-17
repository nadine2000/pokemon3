# ---------- VPC ----------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}

# ---------- Subnet ----------
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "MainSubnet"
  }
}

# ---------- Internet Gateway and Routing ----------
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "MainRouteTable"
  }
}

resource "aws_route_table_association" "main_route_table_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# ---------- Security Groups ----------
resource "aws_security_group" "backend_sg" {
  name        = "backend_security_group"
  description = "Allow SSH, Flask, MongoDB"
  vpc_id      = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BackendSG"
  }
}

resource "aws_security_group" "game_sg" {
  name        = "game_security_group"
  description = "Allow SSH and all outbound"
  vpc_id      = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "GameSG"
  }
}

# ---------- Security Group Rules ----------

# Allow SSH to Backend
resource "aws_security_group_rule" "backend_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_sg.id
}

# Allow Flask port 5000 from Game SG
resource "aws_security_group_rule" "backend_allow_flask_from_game" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.game_sg.id
  security_group_id        = aws_security_group.backend_sg.id
}

# Allow SSH to Game EC2
resource "aws_security_group_rule" "game_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.game_sg.id
}

# ---------- EC2 Instances ----------
resource "aws_instance" "backend_server" {
  ami                         = "ami-05ee755be0cd7555c"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = true
  key_name                    = "gkey"
  user_data                   = file("${path.module}/backend.sh")

  tags = {
    Name = "BackendServer"
  }
}

resource "aws_instance" "game_server" {
  ami                         = "ami-05ee755be0cd7555c"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.game_sg.id]
  associate_public_ip_address = true
  key_name                    = "gkey"

  tags = {
    Name = "GameServer"
  }
}
