data "aws_acm_certificate" "kata_cert" {
  domain   = "develop.alessioscuderi.it"
  statuses = ["ISSUED"]
}

resource "aws_alb" "kata-elb" {
  name               = "kata-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.kata-sg-elb.id}"]
  subnets            = ["${aws_subnet.kata-sn-public-1.id}","${aws_subnet.kata-sn-public-2.id}","${aws_subnet.kata-sn-public-3.id}"]  

  #instances = ["${aws_instance.kata-host.id}"]
   #cross_zone_load_balancing   = true
   idle_timeout                = 400
   #connection_draining         = true
   #connection_draining_timeout = 400

  #enable_deletion_protection = true

  #access_logs {
  #  bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #  prefix  = "test-lb"
  #  enabled = true
  #}
  #cross_zone_load_balancing   = true
  #connection_draining         = true
  #connection_draining_timeout = 400
  tags = {
    Name = "kata-elb"
  }
}

resource "aws_alb_target_group" "kata-elb-tg" {
  name     = "kata-elb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.kata-vpc.id}"
  

  health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      interval            = 30
  }
}

resource "aws_alb_listener" "kata-elb-listener" {
  load_balancer_arn = "${aws_alb.kata-elb.arn}"
  port = "443"
  protocol = "HTTPS"
  certificate_arn   = "${data.aws_acm_certificate.kata_cert.arn}"
  ssl_policy        = "ELBSecurityPolicy-2015-05"

  default_action {
    target_group_arn = "${aws_alb_target_group.kata-elb-tg.arn}"
    type             = "forward"
    
  }
}

resource "aws_alb_target_group_attachment" "kata-elb-tg-att" {

    target_group_arn = "${aws_alb_target_group.kata-elb-tg.arn}"
    target_id = "${aws_instance.kata-host.id}"
    port = 80
}