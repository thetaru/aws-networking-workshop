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

# Route Table
resource "aws_route_table" "VPC_A_Public_Route_Table" {
  vpc_id = aws_vpc.VPC_A.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC_A_IGW.id
  }

  tags = {
    Name = "VPC A Public Route Table"
  }
}

resource "aws_route_table" "VPC_A_Private_Route_Table" {
  vpc_id = aws_vpc.VPC_A.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.VPC_A_NATGW.id
  }

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering_Connection_Between_VPC_A_And_VPC_B.id
  }

  route {
    cidr_block = "10.2.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering_Connection_Between_VPC_A_And_VPC_C.id
  }

  tags = {
    Name = "VPC A Private Route Table"
  }
}

resource "aws_route_table_association" "VPC_A_Public_Route_Table_Association_Public_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_A_Public_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_A_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_A_Public_Route_Table_Association_Public_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_A_Public_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_A_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_A_Private_Route_Table_Association_Private_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_A_Private_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_A_Private_Route_Table.id
}

resource "aws_route_table_association" "VPC_A_Private_Route_Table_Association_Private_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_A_Private_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_A_Private_Route_Table.id
}

# Internet Gateway
resource "aws_internet_gateway" "VPC_A_IGW" {
  vpc_id = aws_vpc.VPC_A.id

  tags = {
    Name = "VPC A IGW"
  }
}

# NAT Gateway
resource "aws_eip" "VPC_A_NATGW_EIP" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "VPC_A_NATGW" {
  allocation_id = aws_eip.VPC_A_NATGW_EIP.id
  subnet_id     = aws_subnet.VPC_A_Public_Subnet_AZ1.id

  tags = {
    Name = "VPC A NATGW"
  }

  depends_on = [aws_internet_gateway.VPC_A_IGW]
}

# VPC Endpoint
resource "aws_vpc_endpoint" "VPC_A_KMS_Endpoint" {
  vpc_id            = aws_vpc.VPC_A.id
  service_name      = "com.amazonaws.ap-northeast-1.kms"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.VPC_A_Private_Subnet_AZ1.id,
    aws_subnet.VPC_A_Private_Subnet_AZ2.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "VPC A KMS Endpoint"
  }
}

resource "aws_vpc_endpoint" "VPC_A_S3_Endpoint" {
  vpc_id            = aws_vpc.VPC_A.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids  = [
    aws_route_table.VPC_A_Public_Route_Table.id,
    aws_route_table.VPC_A_Private_Route_Table.id,
    aws_vpc.VPC_A.default_route_table_id,
  ]

  tags = {
    Name = "VPC A S3 Endpoint"
  }
}