# Database Instance 

resource "aws_instance" "database-instance" {
  ami           = "${var.AMI_DB_ID}"
  instance_type = "t2.micro"

  # VPC subnet to be launched in 
  subnet_id = "${aws_subnet.private_subnet.id}"

  # the security group to use for both inbound and outbound traffic 
  security_groups = ["${aws_security_group.connect-ssh.id}"]

  key_name = "${aws_key_pair.mykeypair.key_name}"
}
