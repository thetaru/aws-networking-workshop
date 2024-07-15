resource "aws_route53_resolver_endpoint" "NetworkingDayOutbound" {
  name      = "NetworkingDayOutbound"
  direction = "OUTBOUND"

  security_group_ids = [aws_vpc.VPC_A.default_security_group_id]

  ip_address {
    subnet_id = aws_subnet.VPC_A_Private_Subnet_AZ1.id
  }

  ip_address {
    subnet_id = aws_subnet.VPC_A_Private_Subnet_AZ2.id
  }

  tags = {
    Name = "NetworkingDayOutbound"
  }
}

resource "aws_route53_resolver_rule" "NetworkingDayRule" {
  name        = "NetworkingDayRule"
  domain_name = "example.corp"
  rule_type   = "FORWARD"

  resolver_endpoint_id = aws_route53_resolver_endpoint.NetworkingDayOutbound.id

  target_ip {
    ip   = "172.16.1.200"
    port = "53"
  }

  tags = {
    Name = "NetworkingDayRule"
  }
}

resource "aws_route53_resolver_rule_association" "NetworkingDayRule_Association_VPC_A" {
  resolver_rule_id = aws_route53_resolver_rule.NetworkingDayRule.id
  vpc_id           = aws_vpc.VPC_A.id
}

resource "aws_route53_resolver_rule_association" "NetworkingDayRule_Association_VPC_B" {
  resolver_rule_id = aws_route53_resolver_rule.NetworkingDayRule.id
  vpc_id           = aws_vpc.VPC_B.id
}

resource "aws_route53_resolver_rule_association" "NetworkingDayRule_Association_VPC_C" {
  resolver_rule_id = aws_route53_resolver_rule.NetworkingDayRule.id
  vpc_id           = aws_vpc.VPC_C.id
}
