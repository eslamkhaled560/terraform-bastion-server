resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidrs["route-table"]
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-route-table-bastion" }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "private-route-table-bastion" }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = var.cidrs["route-table"]
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "pub-rt-association" {
  subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "pvt-rt-association" {
  subnet_id      = aws_subnet.subnets["private"].id
  route_table_id = aws_route_table.private-route-table.id
}