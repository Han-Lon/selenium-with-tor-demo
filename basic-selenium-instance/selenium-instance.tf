# Grab the most recent Ubuntu 18.04 LTS image from public AMIs
data "aws_ami" "ubuntu-image" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200611"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# Grab the IP of the local machine for setting up security group
data "http" "local-ip" {
  url = "https://ipv4.icanhazip.com/"
}

# Grab defalt VPC for setting up security group
data "aws_vpc" "default-vpc" {
  default = true
}

# Create a security group allowing SSH and VNC traffic inbound ONLY from the IP address of the local computer
resource "aws_security_group" "local-ssh-only" {
  name = "selenium-tor-demo-allow-ssh-local-machine"
  description = "Allow SSH and VNC traffic from local IP address"
  vpc_id = data.aws_vpc.default-vpc.id

  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["${trim(data.http.local-ip.body, "\n")}/32"]
    description = "SSH traffic from local machine"
  }

  ingress {
    from_port = 5901
    protocol = "TCP"
    to_port = 5901
    cidr_blocks = ["${trim(data.http.local-ip.body, "\n")}/32"]
    description = "VNC traffic from local macine"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Deploy the selenium-tor-demo instance via a Spot request (much cheaper than on-demand) in the default VPC
resource "aws_spot_instance_request" "selenium-instance" {
  ami = data.aws_ami.ubuntu-image.id
  instance_type = "t3.micro"
  spot_type = "one-time"  # Request will fulfill exactly once and then NOT refulfill when price drops back down
  spot_price = var.spot_price

  key_name = var.ec2_key_name  # This will not be automatically generated-- you will have to generate an AWS EC2 key pair beforehand

  user_data = templatefile("selenium-userdata.sh", {
    gecko_dl_url = var.gecko_dl_url
    tor_dl_url = var.tor_dl_url
  })

  vpc_security_group_ids = [aws_security_group.local-ssh-only.id]

  tags = {
    Name = "selenium-with-tor-demo"
  }
}