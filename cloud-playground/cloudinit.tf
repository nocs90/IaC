data "template_file" "init-script" {
  template = "${file("scripts/init.cfg")}"
  vars = {
    REGION = "${var.AWS_REGION}"
  }
}

data "template_cloudinit_config" "cloudinit-kickoff" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "scripts/init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.init-script.rendered}"
  }
}