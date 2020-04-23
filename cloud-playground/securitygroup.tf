resource "aws_security_group" "kata-mariadb" {
  vpc_id      = "${aws_vpc.kata-vpc.id}"
  name        = "kata-mariadb"
  description = "allow mariadb from kata webserver"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.kata-sg-iac.id}"]  # allow access from kata instance
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "kata-mariadb"
  }
}
resource "aws_security_group" "kata-sg-elb" {
  vpc_id      = "${aws_vpc.kata-vpc.id}"
  name        = "kata-sg-elb"
  description = "security group for the application load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kata-elb"
  }
}


resource "aws_security_group" "kata-sg-iac" {
  vpc_id      = "${aws_vpc.kata-vpc.id}"
  name        = "kata-sg-iac"
  description = "security group that allows ssh only from the Office IP and Home IP"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.HOME_IP}", "${var.OFFICE_IP}"]
  }
   
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.kata-sg-elb.id}"]
  }

  tags = {
    Name = "kata-sg-iac"
  }
}