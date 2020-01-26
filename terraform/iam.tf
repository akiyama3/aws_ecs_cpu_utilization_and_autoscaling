resource "aws_iam_role" "ecs_instance_role" {
  name = "${local.prefix}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  role = "${aws_iam_role.ecs_instance_role.name}"
  path = "/"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach01" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
