resource "aws_customer_gateway" "OnPremise_Customer_Gateway" {
  bgp_asn    = 65000
  ip_address = aws_eip.OnPremise_Customer_Gateway_Server_EIP.public_ip
  type = "ipsec.1"

  tags = {
    Name = "OnPremise Customer Gateway"
  }
}

resource "aws_vpn_connection" "OnPremise_VPN_Connection" {
  transit_gateway_id  = aws_ec2_transit_gateway.TGW.id
  customer_gateway_id = aws_customer_gateway.OnPremise_Customer_Gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "OnPremise VPN Connection"
  }
}
