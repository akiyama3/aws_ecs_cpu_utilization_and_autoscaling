resource "aws_security_group" "main" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "${local.prefix}"

  tags = {
    Name = "${local.prefix}"
  }
}

resource "aws_security_group_rule" "allow_egress" {
  security_group_id = "${aws_security_group.main.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_from_local_cidr" {
  security_group_id = "${aws_security_group.main.id}"
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["${aws_vpc.main.cidr_block}"]
}

resource "aws_security_group_rule" "allow_ssh" {
  security_group_id = "${aws_security_group.main.id}"
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["${local.myip}/32"]
}
