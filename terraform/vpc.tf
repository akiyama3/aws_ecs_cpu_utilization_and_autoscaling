resource "aws_vpc" "main" {
  cidr_block = "${local.vpc.cidr}"

  tags = {
    Name = "${local.vpc.name}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(local.public_subnets)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${local.public_subnets[count.index].az}"
  cidr_block              = "${local.public_subnets[count.index].cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.public_subnets[count.index].name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${local.prefix}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(local.public_subnets)}"

  subnet_id      = "${aws_subnet.public[count.index].id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${local.prefix}"
  }
}

resource "aws_route" "public_to_internet" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
