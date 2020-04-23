resource "aws_iam_user" "katawatcher" {
  name = "katawatcher"
  path = "/monitoring/"

  tags = {
    tag-key = "monitoring"
  }
}

resource "aws_iam_access_key" "katawatcher" {
  user = "${aws_iam_user.katawatcher.name}"
  pgp_key = "keybase:nocs90"
}

resource "aws_iam_user_policy" "katawatcher-policy" {
  name = "katawatcher-policy"
  user = "${aws_iam_user.katawatcher.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudwatch:*",
        "logs:*",
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}