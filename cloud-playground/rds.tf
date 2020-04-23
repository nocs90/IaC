resource "aws_db_subnet_group" "kata-mariadb-subnet" {
  name        = "mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids  = ["${aws_subnet.kata-sn-private-1.id}", "${aws_subnet.kata-sn-private-2.id}"]
}

resource "aws_db_parameter_group" "kata-mariadb-parameters" {
  name        = "mysql-parameters"
  family      = "mysql5.7"
  description = "Mysql parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "katamariadb" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro" # use micro if you want to use the free tier
  identifier              = "${var.RDS_NAME}"
  name                    = "${var.RDS_NAME}"
  username                = "${var.RDS_USER}"     # username
  password                = "${var.RDS_PASSWORD}" # password
  db_subnet_group_name    = "${aws_db_subnet_group.kata-mariadb-subnet.name}"
  parameter_group_name    = "${aws_db_parameter_group.kata-mariadb-parameters.name}"
  #publicly_accessible     = "true"
  multi_az                = "true" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = ["${aws_security_group.kata-mariadb.id}"]
  storage_type            = "gp2"
  backup_retention_period = 30                                            # backup retention period
  #availability_zone       = "${aws_subnet.kata-sn-public-1.availability_zone}" # preferred AZ
  skip_final_snapshot     = true                                          # skip final snapshot when you perform a terraform destroy
  tags = {
    Name = "kata-mariadb-instance"
  }
}

