provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
}

# security group
resource "aws_security_group" "master" {
  vpc_id = "vpc-0f28bcc0b6a596b84"

# port 22 for ssh conection
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# port 3306 for db connection
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# open to all
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" represents all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Exploitable Windows - VSCODE_XAMP
resource "aws_instance" "Window_VSCODE_XAMP" {
  ami           = "ami-0e531e2365203ce30"  # Replace with your desired AMI ID
  instance_type = "t3a.medium"  # Replace with your desired instance type
  key_name      = aws_key_pair.master-key-pair.key_name
  subnet_id     = "subnet-0fd31cfc06b1857a4"
  availability_zone = "ap-south-1a"

  security_groups = [aws_security_group.master.id]

  tags = {
    Name = var.instance_name1
  }
}

resource "local_file" "local_key_pair" {
  filename        = "${var.keypair_name}.pem"
  file_permission = "0400"
  content         = tls_private_key.master-key-gen.private_key_pem
}

output "pem_file_for_ssh" {
  value     = tls_private_key.master-key-gen.private_key_pem
  sensitive = true
}

# Corrected output names to remove slashes
output "Window_VSCODE_XAMP_public_ip" {
  value = aws_instance.Window_VSCODE_XAMP.public_ip
}

output "VSCODE_XAMP_Windows_Username" {
  value = "Administrator"
}

output "VSCODE_XAMP_Windows_Password" {
  value = "t&1Wgv!=*HxXsi;Ca8Q7oP);*hidnQ5@"
}

