# ELASTIC IPs
resource "aws_eip_association" "kata-eip-assoc" {
  instance_id = "${aws_instance.kata-host.id}"
  allocation_id = "${aws_eip.kata-eip.id}"
}

# EC2 INSTANCES
resource "aws_instance" "kata-host" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"


  # generate a public ip address 
  associate_public_ip_address = false

  # set to true if you want to enable Termination Protection
  disable_api_termination = false

  # the VPC subnet
  subnet_id = "${aws_subnet.kata-sn-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.kata-sg-iac.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.kataKey.key_name}"

  # user data
  user_data = "${data.template_cloudinit_config.cloudinit-kickoff.rendered}"

  tags = {
    Name = "kata-host"
  }

  volume_tags = {
    Name = "kata-host-disk"
  }

  root_block_device {
    volume_size = "20"
  }
}
resource "aws_eip" "kata-eip" {
  vpc      = true
  instance = "${aws_instance.kata-host.id}"
  tags = {
    Name = "kata-host-EIP"
  }
}
