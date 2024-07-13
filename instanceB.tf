# EC2 Instance
resource "aws_instance" "VPC_B_Private_AZ1_Server" {
  ami                  = "ami-013a28d7c2ea10269"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.NetworkingWorkshopInstanceProfile.name

  network_interface {
    network_interface_id = aws_network_interface.VPC_B_Private_AZ1_Server_ENI.id
    device_index         = 0
  }

  tags = {
    Name = "VPC B Private AZ1 Server"
  }
}

# Network Interface
resource "aws_network_interface" "VPC_B_Private_AZ1_Server_ENI" {
  subnet_id       = aws_subnet.VPC_B_Private_Subnet_AZ1.id
  private_ips     = ["10.1.1.100"]
  security_groups = [aws_security_group.VPC_B_Security_Group.id]
}

# Security Group
resource "aws_security_group" "VPC_B_Security_Group" {
  name        = "VPC_B_Security_Group"
  description = "Open-up ports for ICMP"
  vpc_id      = aws_vpc.VPC_B.id

  tags = {
    Name = "VPC B Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "VPC_B_Security_Group_Ingress_Rule" {
  security_group_id = aws_security_group.VPC_B_Security_Group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "icmp"
  from_port   = -1
  to_port     = -1
}

resource "aws_vpc_security_group_egress_rule" "VPC_B_Security_Group_Egress_Rule" {
  security_group_id = aws_security_group.VPC_B_Security_Group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  from_port   = -1
  to_port     = -1
}
