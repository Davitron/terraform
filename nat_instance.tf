# NAT Instance 
resource "aws_instance" "nat_instance" {
  ami = "ami-076d5d61"

  instance_type = "t2.micro"

  # VPC subnet to be launched in 
  subnet_id = "${aws_subnet.public_subnet.id}"

  # the security group to use for both inbound and outbound traffic 
  security_groups = ["${aws_security_group.nat_sg.id}"]

  associate_public_ip_address = true
  source_dest_check           = false

  key_name = "${aws_key_pair.mykeypair.key_name}"
}

# Elastic IP being attached and associated with the NAT instance
resource "aws_eip" "nat-instance-eip" {
  instance = "${aws_instance.nat_instance.id}"
  vpc      = true
}
