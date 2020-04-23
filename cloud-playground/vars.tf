variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}

# check EC2 AMI through https://cloud-images.ubuntu.com/locator/ec2/
variable "AMIS" {
  type = "map"
  default = {
    eu-west-1    = "ami-01cca82393e531118"
    eu-central-1 = "ami-0cdab515472ca0bac"
    eu-north-1   = "ami-c37bf0bd"
  }
}

variable "PATH_TO_PRIVATE_KEY" {}
variable "PATH_TO_PUBLIC_KEY" {}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}
variable "RDS_PASSWORD" {}
variable "RDS_USER" {}
variable "RDS_NAME" {}

variable "HOME_IP" {}
variable "OFFICE_IP" {}
variable "EC2_PRIVATE_IP" {
  default = "10.1.1.123"
}
