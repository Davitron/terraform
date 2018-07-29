# Application Front end instance 
resource "aws_instance" "app" {
  ami             = "${var.AMI_APP_ID}"
  instance_type   = "t2.micro"
  subnet_id       = "${aws_subnet.public_subnet_2.id}"
  security_groups = ["${aws_security_group.app_sg.id}"]
  key_name        = "${aws_key_pair.mykeypair.key_name}"
}
