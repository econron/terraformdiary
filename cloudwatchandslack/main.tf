terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-20250107-v1"
    key = "terraform/state.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

// vpc
resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true // default
  enable_dns_hostnames = false // default
  assign_generated_ipv6_cidr_block = false // default
  tags = {
    Name = "myvpc1"
  }
}

// subnets
// public
resource "aws_subnet" "myvpc1-public-subnet-1a" {
  vpc_id = aws_vpc.myvpc1.id
  assign_ipv6_address_on_creation = false
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.0.0/20"
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native = false
  map_public_ip_on_launch = false

  tags = {
    Name = "myvpc1"
  }
}

resource "aws_subnet" "myvpc1-public-subnet-1c" {
  vpc_id = aws_vpc.myvpc1.id
  assign_ipv6_address_on_creation = false
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.16.0/20"
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native = false
  map_public_ip_on_launch = false

  tags = {
    Name = "myvpc1"
  }
}

// private
resource "aws_subnet" "myvpc1-private-subnet-1a" {
  vpc_id = aws_vpc.myvpc1.id
  assign_ipv6_address_on_creation = false
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.128.0/20"
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native = false
  map_public_ip_on_launch = false

  tags = {
    Name = "myvpc1"
  }
}

resource "aws_subnet" "myvpc1-private-subnet-1c" {
  vpc_id = aws_vpc.myvpc1.id
  assign_ipv6_address_on_creation = false
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.144.0/20"
  enable_dns64 = false
  enable_resource_name_dns_a_record_on_launch = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native = false
  map_public_ip_on_launch = false

  tags = {
    Name = "myvpc1"
  }
}

// publicのためのインターネットゲートウェイ
resource "aws_internet_gateway" "myvpc1-ig" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "myvpc1"
  }
}

// ルートテーブル
resource "aws_route_table" "myvpc1-route-table" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "myvpc1"
  }
}

// ルートの設定
// インターネットから対象サブネットへのルーティング
resource "aws_route" "myvpc1-public-route" {
  route_table_id = aws_route_table.myvpc1-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myvpc1-ig.id
}

// 紐付け
resource "aws_route_table_association" "myvpc1-route-table-association-1a" {
  subnet_id = aws_subnet.myvpc1-public-subnet-1a.id
  route_table_id = aws_route_table.myvpc1-route-table.id
}

resource "aws_route_table_association" "myvpc1-route-table-association-1c" {
  subnet_id = aws_subnet.myvpc1-public-subnet-1c.id
  route_table_id = aws_route_table.myvpc1-route-table.id
}

// ec2を作成する
// セキュリティグループとルールの作成
resource "aws_security_group" "myvpc1-sg1" {
  name = "myvpc1-sg1"
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "myvpc1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.myvpc1-sg1.id
  cidr_ipv4 = var.my_ip
  from_port = 22
  to_port = 22
  ip_protocol = "ssh"
}

resource "aws_vpc_security_group_egress_rule" "allow-all" {
  security_group_id = aws_security_group.myvpc1-sg1.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "mytestserver1" {
  ami = "ami-0ab02459752898a60"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.myvpc1-public-subnet-1a.id
  vpc_security_group_ids = [aws_security_group.myvpc1-sg1.id]
  tags = {
    Name = "myvpc1"
  }
}