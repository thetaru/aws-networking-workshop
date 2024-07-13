# VPC
resource "aws_vpc" "VPC_A" { 
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC A"
  }
}

# Subnet
resource "aws_subnet" "VPC_A_Public_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC A Public Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_A_Private_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC A Private Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_A_Public_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC A Public Subnet AZ2"
  }
}

resource "aws_subnet" "VPC_A_Private_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_A.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC A Private Subnet AZ2"
  }
}

# Network ACL
resource "aws_network_acl" "VPC_A_Workload_Subnets_NACL" {
  vpc_id = aws_vpc.VPC_A.id
  
  tags = {
    Name = "VPC A Workload Subnets NACL"
  }
}

resource "aws_network_acl_association" "VPC_A_Workload_Subnets_NACL_Association_Public_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_A_Public_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_A_Workload_Subnets_NACL_Association_Private_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_A_Private_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_A_Workload_Subnets_NACL_Association_Public_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_A_Public_Subnet_AZ2.id
}

resource "aws_network_acl_association" "VPC_A_Workload_Subnets_NACL_Association_Private_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_A_Private_Subnet_AZ2.id
}

resource "aws_network_acl_rule" "VPC_A_Workload_Subnets_NACL_Ingress_Rule" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = false        # ingress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "VPC_A_Workload_Subnets_NACL_Egress_Rule" {
  network_acl_id = aws_network_acl.VPC_A_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = true         # egress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}
