resource "aws_vpc" "vpc" {
  cidr_block = var.cidrs["vpc"]
  tags = { Name = "tf-bastion" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name= "igw-bastion" }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets["public"].id
  depends_on    = [aws_internet_gateway.igw]
  tags = { Name = "nat-bastion" }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_cidrs
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value
  tags = {Name = "${each.key}-subnet-bastion"}
}