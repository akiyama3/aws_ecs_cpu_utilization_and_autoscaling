data http myip {
  url = "http://ipv4.icanhazip.com/"
}

locals {
  prefix = "ecstest"

  myip = "${chomp(data.http.myip.body)}"

  key_pair = "${local.prefix}"

  vpc = {
    name = "${local.prefix}"
    cidr = "10.0.0.0/16"
  }

  public_subnets = [
    {
      az   = "ap-northeast-1c"
      cidr = "10.0.0.0/24"
      name = "${local.prefix}-public-1c"
    },
    {
      az   = "ap-northeast-1d"
      cidr = "10.0.1.0/24"
      name = "${local.prefix}-public-1d"
    },
  ]

  ecs_ami = "ami-0cdf0c91f1d10e38e"
}
