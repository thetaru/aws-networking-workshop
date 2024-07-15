resource "aws_ec2_transit_gateway" "TGW" {
  description = "TGW for ap-northeast-1"

  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "enable"

  tags = {
    Name = "TGW"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC_A_Attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  vpc_id             = aws_vpc.VPC_A.id
  subnet_ids         = [
    aws_subnet.VPC_A_TGW_Subnet_AZ1.id,
    aws_subnet.VPC_A_TGW_Subnet_AZ2.id,
  ]

  transit_gateway_default_route_table_association = false

  tags = {
    Name = "VPC A Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC_B_Attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  vpc_id             = aws_vpc.VPC_B.id
  subnet_ids         = [
    aws_subnet.VPC_B_TGW_Subnet_AZ1.id,
    aws_subnet.VPC_B_TGW_Subnet_AZ2.id,
  ]

  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "VPC B Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "VPC_C_Attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id
  vpc_id             = aws_vpc.VPC_C.id
  subnet_ids         = [
    aws_subnet.VPC_C_TGW_Subnet_AZ1.id,
    aws_subnet.VPC_C_TGW_Subnet_AZ2.id,
  ]

  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "VPC C Attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table" "Default_TGW_Route_Table" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id

  tags = {
    Name = "Default TGW Route Table"
  }
}

resource "aws_ec2_transit_gateway_route_table" "Shared_Services_TGW_Route_Table" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id

  tags = {
    Name = "Shared Services TGW Route Table"
  }
}

resource "aws_ec2_transit_gateway_route_table" "VPN_Route_Table" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW.id

  tags = {
    Name = "VPN Route Table"
  }
}

# TGW Route Table Association
resource "aws_ec2_transit_gateway_route_table_association" "Default_TGW_Route_Table_Association_VPC_B_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_B_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Default_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_association" "Default_TGW_Route_Table_Association_VPC_C_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_C_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Default_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_association" "Shared_Services_TGW_Route_Table_Association_VPC_A_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_A_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Shared_Services_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_association" "VPN_Route_Table_Association_OnPremise_VPC_Attachment" {
  transit_gateway_attachment_id  = aws_vpn_connection.OnPremise_VPN_Connection.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.VPN_Route_Table.id
}

# TGW Route Table Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "Default_TGW_Route_Table_Propagation_VPC_A_Attachment" {
  transit_gateway_attachment_id  = aws_vpn_connection.OnPremise_VPN_Connection.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Default_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Default_TGW_Route_Table_Propagation_OnPremise_VPC_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_A_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Default_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Shared_Services_TGW_Route_Table_Propagation_VPC_B_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_B_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Shared_Services_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Shared_Services_TGW_Route_Table_Propagation_VPC_C_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_C_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Shared_Services_TGW_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "VPN_Route_Table_Propagation_VPC_A_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_A_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.VPN_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "VPN_Route_Table_Propagation_VPC_B_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_B_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.VPN_Route_Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "VPN_Route_Table_Propagation_VPC_C_Attachment" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.VPC_C_Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.VPN_Route_Table.id
}

resource "aws_ec2_transit_gateway_route" "Shared_Services_TGW_Route_Table_Routes_OnPremise_VPC" {
  destination_cidr_block         = "172.16.0.0/16"
  transit_gateway_attachment_id  = aws_vpn_connection.OnPremise_VPN_Connection.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Shared_Services_TGW_Route_Table.id
}
