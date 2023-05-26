#Providers

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

#Data 
#Get AMI instance from AWS, make sure it's the most recent version. This will be referenced when creating the EC2.

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

#Resources 
#Generate a .pem file to SSH onto the instance.
#create private key
#Then create keypair
resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
}
resource "aws_key_pair" "keypair" {
  key_name = "keypair"
  #take the public key from the generated private key.
  public_key = tls_private_key.privatekey.public_key_openssh
  #Depends on private key being created
  depends_on = [tls_private_key.privatekey]
}
# Save the local version to your working directoy.
resource "local_file" "ssh_key" {
  content  = tls_private_key.privatekey.private_key_pem
  filename = "keypair2"

}


resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}


#In order to access the internet there also needs be an internet gateway, this can be retrieved from the aws_vpc object created above.
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.vpc1.id

}

#Create a subnet and use map_public_ip_on_launch so the EC2 has a public IP address as per the brief. Reference CIDR block from VPC.

resource "aws_subnet" "subnet" {
  cidr_block              = aws_vpc.vpc1.cidr_block
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = "true"
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc1.id

  #Define the route inside of the route table with the created internet gateway. We don't really need to define this seperate as we only have one route.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateway.id
  }

}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.routetable.id
}




#Create a security group and reference the VPC. Allow inbound SSH connections only.

resource "aws_security_group" "aws_security_group" {
  name = "allowssh"

  vpc_id = aws_vpc.vpc1.id
  ingress {

    protocol    = "TCP"
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_instance" "ec2instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet.id
  key_name               = "keypair"
  vpc_security_group_ids = [aws_security_group.aws_security_group.id]
}

#Output public DNS to SSH onto the EC2 instance.
output "aws_instance_public_dns" {
  value = aws_instance.ec2instance.public_dns
}

output "locationofpemfile" {
  value = path.cwd
}

