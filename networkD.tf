# VPC
resource "aws_vpc" "OnPremise_VPC" { 
  cidr_block = "172.16.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "OnPremise VPC"
  }
}

# VPC DHCP Options
resource "aws_vpc_dhcp_options" "OnPremise_VPC_DHCP_Options" {
  domain_name                       = "example.corp"
  domain_name_servers               = ["172.16.1.200"]

  tags = {
    Name = "OnPremise VPC DHCP Options"
  }
}

resource "aws_vpc_dhcp_options_association" "OnPremise_VPC_DHCP_Options_Association" {
  vpc_id          = aws_vpc.OnPremise_VPC.id
  dhcp_options_id = aws_vpc_dhcp_options.OnPremise_VPC_DHCP_Options.id
}

# Subnet
resource "aws_subnet" "OnPremise_Public_Subnet_AZ1" {
  vpc_id     = aws_vpc.OnPremise_VPC.id
  cidr_block = "172.16.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "OnPremise Public Subnet AZ1"
  }
}

resource "aws_subnet" "OnPremise_Private_Subnet_AZ1" {
  vpc_id     = aws_vpc.OnPremise_VPC.id
  cidr_block = "172.16.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "OnPremise Private Subnet AZ1"
  }
}

# Network ACL
resource "aws_network_acl" "OnPremise_Workload_Subnets_NACL" {
  vpc_id = aws_vpc.OnPremise_VPC.id
  
  tags = {
    Name = "OnPremise Workload Subnets NACL"
  }
}

resource "aws_network_acl_association" "OnPremise_Workload_Subnets_NACL_Association_Public_Subnet_AZ1" {
  network_acl_id = aws_network_acl.OnPremise_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.OnPremise_Public_Subnet_AZ1.id
}

resource "aws_network_acl_association" "OnPremise_Workload_Subnets_NACL_Association_Private_Subnet_AZ1" {
  network_acl_id = aws_network_acl.OnPremise_Workload_Subnets_NACL.id
  subnet_id      = aws_subnet.OnPremise_Private_Subnet_AZ1.id
}

resource "aws_network_acl_rule" "OnPremise_Workload_Subnets_NACL_Ingress_Rule" {
  network_acl_id = aws_network_acl.OnPremise_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = false        # ingress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "OnPremise_Workload_Subnets_NACL_Egress_Rule" {
  network_acl_id = aws_network_acl.OnPremise_Workload_Subnets_NACL.id
  rule_number    = 100
  egress         = true         # egress rule
  protocol       = -1           # all protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Route Table
resource "aws_route_table" "OnPremise_Public_Route_Table" {
  vpc_id = aws_vpc.OnPremise_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.OnPremise_IGW.id
  }

  tags = {
    Name = "OnPremise Public Route Table"
  }
}

resource "aws_route_table" "OnPremise_Private_Route_Table" {
  vpc_id = aws_vpc.OnPremise_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.OnPremise_NATGW.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    network_interface_id = aws_network_interface.OnPremise_Customer_Gateway_Server_ENI.id
  }

  tags = {
    Name = "OnPremise Private Route Table"
  }
}

resource "aws_route_table_association" "OnPremise_Public_Route_Table_Association_Public_Subnet_AZ1" {
  subnet_id      = aws_subnet.OnPremise_Public_Subnet_AZ1.id
  route_table_id = aws_route_table.OnPremise_Public_Route_Table.id
}

resource "aws_route_table_association" "OnPremise_Private_Route_Table_Association_Private_Subnet_AZ1" {
  subnet_id      = aws_subnet.OnPremise_Private_Subnet_AZ1.id
  route_table_id = aws_route_table.OnPremise_Private_Route_Table.id
}

# Internet Gateway
resource "aws_internet_gateway" "OnPremise_IGW" {
  vpc_id = aws_vpc.OnPremise_VPC.id

  tags = {
    Name = "OnPremise IGW"
  }
}

# NAT Gateway
resource "aws_eip" "OnPremise_NATGW_EIP" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "OnPremise_NATGW" {
  allocation_id = aws_eip.OnPremise_NATGW_EIP.id
  subnet_id     = aws_subnet.OnPremise_Public_Subnet_AZ1.id

  tags = {
    Name = "OnPremise NATGW"
  }

  depends_on = [aws_internet_gateway.OnPremise_IGW]
}
