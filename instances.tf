data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "pvt-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["private"].id
  vpc_security_group_ids      = [aws_security_group.sg-pvt.id]
  associate_public_ip_address = false
  user_data                   = file("apache.sh")
  tags = { Name = "pvt-apache-bastion" }
}

resource "aws_instance" "pub-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["public"].id
  vpc_security_group_ids      = [aws_security_group.sg-pub.id]
  associate_public_ip_address = true
  user_data                   = file("apache.sh")
  tags = { Name = "pub-apache-bastion" }
}