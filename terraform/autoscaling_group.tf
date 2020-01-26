locals {
  userdata = <<EOF
#!/bin/bash

echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=true >> /etc/ecs/ecs.config

start ecs
EOF
}

resource "aws_launch_template" "sand_ecs_cluster01" {
  name = "${local.prefix}"

  image_id = "${local.ecs_ami}"
  key_name = "${local.key_pair}"

  vpc_security_group_ids = ["${aws_security_group.main.id}"]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "standard"
      volume_size           = 30
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.prefix}"
    }
  }

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ecs_instance_role.name}"
  }

  user_data = "${base64encode(local.userdata)}"
}

resource "aws_autoscaling_group" "sand_ecs_cluster01" {
  name = "${local.prefix}"

  vpc_zone_identifier = "${aws_subnet.public[*].id}"

  min_size = 1
  max_size = 2

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.sand_ecs_cluster01.id}"
        version            = "$Latest"
      }

      override {
        instance_type     = "c5.xlarge"
        weighted_capacity = "1"
      }
    }

    instances_distribution {
      on_demand_base_capacity = 0

      spot_allocation_strategy = "lowest-price"
      spot_max_price           = "0.08"
      spot_instance_pools      = 2

      on_demand_percentage_above_base_capacity = 0
    }
  }
}
