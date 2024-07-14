# VPC
resource "aws_vpc" "VPC_B" { 
  cidr_block = "10.1.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC B"
  }
}

# Subnet
resource "aws_subnet" "VPC_B_Public_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC B Public Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_B_Private_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC B Private Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_B_Public_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC B Public Subnet AZ2"
  }
}

resource "aws_subnet" "VPC_B_Private_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC B Private Subnet AZ2"
  }
}

resource "aws_subnet" "VPC_B_TGW_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.5.0/28"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC B TGW Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_B_TGW_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_B.id
  cidr_block = "10.1.5.16/28"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC B TGW Subnet AZ2"
  }
}

# Network ACL
resource "aws_network_acl" "VPC_B_Workload_Subnets_NACL" {
  vpc_id = aws_vpc.VPC_B.id
  
  tags = {
    Name = "VPC B Workload Subnets NACL"
  }
}

resource "aws_network_acl_association" "VPC_B_Workload_Subnets_NACL_Association_Public_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_B_Public_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_B_Workload_Subnets_NACL_Association_Private_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_B_Private_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_B_Workload_Subnets_NACL_Association_Public_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_B_Public_Subnet_AZ2.id
}

resource "aws_network_acl_association" "VPC_B_Workload_Subnets_NACL_Association_Private_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_B_Private_Subnet_AZ2.id
}

resource "aws_network_acl_rule" "VPC_B_Workload_Subnets_NACL_Ingress_Rule" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = false        # ingress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "VPC_B_Workload_Subnets_NACL_Egress_Rule" {
  network_acl_id = aws_network_acl.VPC_B_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = true         # egress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Route Table
resource "aws_route_table" "VPC_B_Public_Route_Table" {
  vpc_id = aws_vpc.VPC_B.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC_B_IGW.id
  }

  tags = {
    Name = "VPC B Public Route Table"
  }
}

resource "aws_route_table" "VPC_B_Private_Route_Table" {
  vpc_id = aws_vpc.VPC_B.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.VPC_B_NATGW.id
  }

  # VPC Peering Connection
  # route {
  #   cidr_block = "10.0.0.0/16"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.Peering_Connection_Between_VPC_A_And_VPC_B.id
  # }

  # Transit Gateway
  route {
    cidr_block = "10.0.0.0/8" # 集約ルート
    transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  }

  tags = {
    Name = "VPC B Private Route Table"
  }
}

resource "aws_route_table_association" "VPC_B_Public_Route_Table_Association_Public_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_B_Public_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_B_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_B_Public_Route_Table_Association_Public_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_B_Public_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_B_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_B_Private_Route_Table_Association_Private_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_B_Private_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_B_Private_Route_Table.id
}

resource "aws_route_table_association" "VPC_B_Private_Route_Table_Association_Private_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_B_Private_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_B_Private_Route_Table.id
}

# Internet Gateway
resource "aws_internet_gateway" "VPC_B_IGW" {
  vpc_id = aws_vpc.VPC_B.id

  tags = {
    Name = "VPC B IGW"
  }
}

# NAT Gateway
resource "aws_eip" "VPC_B_NATGW_EIP" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "VPC_B_NATGW" {
  allocation_id = aws_eip.VPC_B_NATGW_EIP.id
  subnet_id     = aws_subnet.VPC_B_Public_Subnet_AZ1.id

  tags = {
    Name = "VPC B NATGW"
  }

  depends_on = [aws_internet_gateway.VPC_B_IGW]
}

# VPC Endpoint
resource "aws_vpc_endpoint" "VPC_B_KMS_Endpoint" {
  vpc_id            = aws_vpc.VPC_B.id
  service_name      = "com.amazonaws.ap-northeast-1.kms"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.VPC_B_Private_Subnet_AZ1.id,
    aws_subnet.VPC_B_Private_Subnet_AZ2.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "VPC B KMS Endpoint"
  }
}

resource "aws_vpc_endpoint" "VPC_B_S3_Endpoint" {
  vpc_id            = aws_vpc.VPC_B.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids  = [
    aws_route_table.VPC_B_Public_Route_Table.id,
    aws_route_table.VPC_B_Private_Route_Table.id,
    aws_vpc.VPC_B.default_route_table_id,
  ]

  tags = {
    Name = "VPC B S3 Endpoint"
  }
}
