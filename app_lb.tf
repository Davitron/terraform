# Load balancer for the VPC
resource "aws_lb" "app-loadbalancer" {
  name               = "app-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = ["${aws_security_group.app_sg.id}"]
  subnets            = ["${aws_subnet.public_subnet.id}", "${aws_subnet.public_subnet_2.id}"]
  security_groups    = ["${aws_security_group.app_sg.id}"]

  tags {
    Name = "App-Load-balancer"
  }
}

# Load Balancer Target group
resource "aws_lb_target_group" "app-target-grp" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.checkpoint_vpc.id}"
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "app-eg" {
  target_group_arn = "${aws_lb_target_group.app-target-grp.arn}"
  target_id        = "${aws_instance.app.id}"
  port             = "80"
}

# Load Balancer Listener
resource "aws_lb_listener" "app-listener" {
  load_balancer_arn = "${aws_lb.app-loadbalancer.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.app-target-grp.arn}"
    type             = "forward"
  }
}
