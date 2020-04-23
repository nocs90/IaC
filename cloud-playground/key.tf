resource "aws_key_pair" "kataKey" {
  key_name   = "kataKey"
  public_key = "${file(var.PATH_TO_PUBLIC_KEY)}"
}
