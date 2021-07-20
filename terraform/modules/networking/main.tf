###############################
# VPC
###############################
resource "aws_vpc" "vpc" {
  cidr_block             = var.cidr_block
  enable_dns_hostnames   = true
  enable_dns_support     = true
  tags                   = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-vpc"}))}"
}

##############################
# SUBNETS
##############################
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-public-subnet"}))}"
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags                    = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-private-subnet"}))}"
}

###############################
# IGW
###############################
resource "aws_internet_gateway" "public_igw" {
    vpc_id     = aws_vpc.vpc.id
    tags       = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-public-internet-gw"}))}"
}

###############################
# EIP
###############################
resource "aws_eip" "public_eip" {
  count         = length(var.public_subnets)
  vpc           = true
  tags          = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-public-eip-gw"}))}"
  depends_on    = [aws_internet_gateway.public_igw]
}

##############################
# NAT-GW
##############################
resource "aws_nat_gateway" "public_nat_gw" {
  count                   = length(var.public_subnets)
  allocation_id           = element(aws_eip.public_eip.*.id, count.index)
  subnet_id               = element(aws_subnet.public_subnets.*.id, count.index)
  tags                    = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-public-nat-gw"}))}"
}

##############################
# Route Table/association
##############################
resource "aws_route_table" "private_route_table" {
  count            = length(var.private_subnets)
  vpc_id           = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.public_nat_gw.*.id, count.index)
  }
  tags             = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-private-route-table"}))}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }

  tags       = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-public-route-table"}))}"
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.public_route_table.*.id, count.index)
}