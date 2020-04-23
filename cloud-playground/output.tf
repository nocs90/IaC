output "kata-instance-endpoint" {
  value = "${aws_instance.kata-host.public_ip}"
}

output "kata-rds-endpoint" {
  value = "${aws_db_instance.katamariadb.endpoint}"
}

output "kata_rds_usr" {
  value = "${var.RDS_USER}"
}

output "kata-host-eip" {
  value = "${aws_eip.kata-eip}"
}

output "alb_id" {
  value = "${aws_alb.kata-elb.id}"
}

output "alb_dns_name" {
  value = "${aws_alb.kata-elb.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.kata-elb.zone_id}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.kata-elb-tg.arn}"
}

output "access" {
  value = "${aws_iam_access_key.katawatcher.id}"
}

output "secret" {
  value = "${aws_iam_access_key.katawatcher.encrypted_secret}"
}
