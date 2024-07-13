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
