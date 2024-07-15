# VPC
resource "aws_vpc" "VPC_C" { 
  cidr_block = "10.2.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC C"
  }
}

# Subnet
resource "aws_subnet" "VPC_C_Public_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC C Public Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_C_Private_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC C Private Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_C_Public_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC C Public Subnet AZ2"
  }
}

resource "aws_subnet" "VPC_C_Private_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC C Private Subnet AZ2"
  }
}

resource "aws_subnet" "VPC_C_TGW_Subnet_AZ1" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.5.0/28"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "VPC C TGW Subnet AZ1"
  }
}

resource "aws_subnet" "VPC_C_TGW_Subnet_AZ2" {
  vpc_id     = aws_vpc.VPC_C.id
  cidr_block = "10.2.5.16/28"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "VPC C TGW Subnet AZ2"
  }
}

# Network ACL
resource "aws_network_acl" "VPC_C_Workload_Subnets_NACL" {
  vpc_id = aws_vpc.VPC_C.id
  
  tags = {
    Name = "VPC C Workload Subnets NACL"
  }
}

resource "aws_network_acl_association" "VPC_C_Workload_Subnets_NACL_Association_Public_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_C_Public_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_C_Workload_Subnets_NACL_Association_Private_Subnet_AZ1" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_C_Private_Subnet_AZ1.id
}

resource "aws_network_acl_association" "VPC_C_Workload_Subnets_NACL_Association_Public_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_C_Public_Subnet_AZ2.id
}

resource "aws_network_acl_association" "VPC_C_Workload_Subnets_NACL_Association_Private_Subnet_AZ2" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.VPC_C_Private_Subnet_AZ2.id
}

resource "aws_network_acl_rule" "VPC_C_Workload_Subnets_NACL_Ingress_Rule" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = false        # ingress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "VPC_C_Workload_Subnets_NACL_Egress_Rule" {
  network_acl_id = aws_network_acl.VPC_C_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = true         # egress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Route Table
resource "aws_route_table" "VPC_C_Public_Route_Table" {
  vpc_id = aws_vpc.VPC_C.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.VPC_C_IGW.id
  }

  tags = {
    Name = "VPC C Public Route Table"
  }
}

resource "aws_route_table" "VPC_C_Private_Route_Table" {
  vpc_id = aws_vpc.VPC_C.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.VPC_C_NATGW.id
  }

  # VPC Peering Connection
  # route {
  #   cidr_block = "10.0.0.0/16"
  #   vpc_peering_connection_id = aws_vpc_peering_connection.Peering_Connection_Between_VPC_A_And_VPC_C.id
  # }

  # Transit Gateway
  route {
    cidr_block = "10.0.0.0/8" # 集約ルート
    transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  }

  # VPN Connection
  route {
    cidr_block = "172.16.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  }

  tags = {
    Name = "VPC C Private Route Table"
  }
}

resource "aws_route_table_association" "VPC_C_Public_Route_Table_Association_Public_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_C_Public_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_C_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_C_Public_Route_Table_Association_Public_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_C_Public_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_C_Public_Route_Table.id
}

resource "aws_route_table_association" "VPC_C_Private_Route_Table_Association_Private_Subnet_AZ1" {
  subnet_id      = aws_subnet.VPC_C_Private_Subnet_AZ1.id
  route_table_id = aws_route_table.VPC_C_Private_Route_Table.id
}

resource "aws_route_table_association" "VPC_C_Private_Route_Table_Association_Private_Subnet_AZ2" {
  subnet_id      = aws_subnet.VPC_C_Private_Subnet_AZ2.id
  route_table_id = aws_route_table.VPC_C_Private_Route_Table.id
}

# Internet Gateway
resource "aws_internet_gateway" "VPC_C_IGW" {
  vpc_id = aws_vpc.VPC_C.id

  tags = {
    Name = "VPC C IGW"
  }
}

# NAT Gateway
resource "aws_eip" "VPC_C_NATGW_EIP" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "VPC_C_NATGW" {
  allocation_id = aws_eip.VPC_C_NATGW_EIP.id
  subnet_id     = aws_subnet.VPC_C_Public_Subnet_AZ1.id

  tags = {
    Name = "VPC C NATGW"
  }

  depends_on = [aws_internet_gateway.VPC_C_IGW]
}
