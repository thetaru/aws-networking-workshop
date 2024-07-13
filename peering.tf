resource "aws_vpc_peering_connection" "Peering_Connection_Between_VPC_A_And_VPC_B" {
  vpc_id      = aws_vpc.VPC_A.id
  peer_vpc_id = aws_vpc.VPC_B.id
  auto_accept = true # 両方のVPCが同じAWSアカウントおよびリージョンにあるため有効にする

  tags = {
    Name = "VPC A <> VPC B"
  }
}

resource "aws_vpc_peering_connection" "Peering_Connection_Between_VPC_A_And_VPC_C" {
  vpc_id      = aws_vpc.VPC_A.id
  peer_vpc_id = aws_vpc.VPC_C.id
  auto_accept = true # 両方のVPCが同じAWSアカウントおよびリージョンにあるため有効にする

  tags = {
    Name = "VPC A <> VPC C"
  }
}
