# EC2 Instance
resource "aws_instance" "OnPremise_Customer_Gateway_Server" {
  ami                  = "ami-0eda63ec8af4f056e"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.NetworkingWorkshopInstanceProfile.name

  network_interface {
    network_interface_id = aws_network_interface.OnPremise_Customer_Gateway_Server_ENI.id
    device_index         = 0
  }

  user_data = file("scripts/OnPremCustomerGatewayServer.sh")

  tags = {
    Name = "OnPremise Customer Gateway Server"
  }
}

resource "aws_instance" "OnPremise_App_Server" {
  ami                  = "ami-013a28d7c2ea10269"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.NetworkingWorkshopInstanceProfile.name

  network_interface {
    network_interface_id = aws_network_interface.OnPremise_App_Server_ENI.id
    device_index         = 0
  }

  user_data = file("scripts/OnPremAppServer.sh")

  tags = {
    Name = "OnPremise App Server"
  }
}

resource "aws_instance" "OnPremise_Dns_Server" {
  ami                  = "ami-013a28d7c2ea10269"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.NetworkingWorkshopInstanceProfile.name

  network_interface {
    network_interface_id = aws_network_interface.OnPremise_Dns_Server_ENI.id
    device_index         = 0
  }

  user_data = file("scripts/OnPremDnsServer.sh")

  tags = {
    Name = "OnPremise Dns Server"
  }
}

# Network Interface
resource "aws_network_interface" "OnPremise_Customer_Gateway_Server_ENI" {
  subnet_id       = aws_subnet.OnPremise_Public_Subnet_AZ1.id
  private_ips     = ["172.16.0.100"]
  security_groups = [aws_security_group.OnPremise_Server_Security_Group.id]
}

resource "aws_network_interface" "OnPremise_App_Server_ENI" {
  subnet_id       = aws_subnet.OnPremise_Private_Subnet_AZ1.id
  private_ips     = ["172.16.1.100"]
  security_groups = [aws_security_group.OnPremise_Server_Security_Group.id]
}

resource "aws_network_interface" "OnPremise_Dns_Server_ENI" {
  subnet_id       = aws_subnet.OnPremise_Private_Subnet_AZ1.id
  private_ips     = ["172.16.1.200"]
  security_groups = [aws_security_group.OnPremise_Server_Security_Group.id]
}

# Elastic IP
resource "aws_eip" "OnPremise_Customer_Gateway_Server_EIP" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.OnPremise_Customer_Gateway_Server_ENI.id
  associate_with_private_ip = "172.16.0.100"
}

# Security Group
resource "aws_security_group" "OnPremise_Server_Security_Group" {
  name        = "OnPremise_Server_Security_Group"
  vpc_id      = aws_vpc.OnPremise_VPC.id

  tags = {
    Name = "OnPremise Server Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "OnPremise_Server_Security_Group_Ingress_Rule" {
  security_group_id = aws_security_group.OnPremise_Server_Security_Group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  from_port   = -1
  to_port     = -1
}

resource "aws_vpc_security_group_egress_rule" "OnPremise_Server_Security_Group_Egress_Rule" {
  security_group_id = aws_security_group.OnPremise_Server_Security_Group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  from_port   = -1
  to_port     = -1
}
