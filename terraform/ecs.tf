resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}"
}

resource "aws_ecr_repository" "sample_app" {
  name = "${local.prefix}/sample-app"
}

locals {
  task_definitions = [
    {
      cpu_unit = 512
      proc     = 1
    },
    {
      cpu_unit = 512
      proc     = 2
    },
    {
      cpu_unit = 1024
      proc     = 1
    },
    {
      cpu_unit = 1024
      proc     = 2
    },
    {
      cpu_unit = 3072
      proc     = 3
    },
  ]
}


resource "aws_ecs_task_definition" "sample_apps" {
  count = "${length(local.task_definitions)}"

  family = "${local.prefix}-${local.task_definitions[count.index].cpu_unit}cpu-${local.task_definitions[count.index].proc}proc"

  container_definitions = <<EOF
[
  {
    "name": "app",
    "image": "${aws_ecr_repository.sample_app.repository_url}:latest",
    "cpu": ${local.task_definitions[count.index].cpu_unit},
    "memory": 256,
    "environment": [
        {
            "name": "PROC",
            "value": "${local.task_definitions[count.index].proc}"
        }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "sample_apps" {
  count = "${length(local.task_definitions)}"

  name            = "${local.prefix}-${local.task_definitions[count.index].cpu_unit}cpu-${local.task_definitions[count.index].proc}proc"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.sample_apps[count.index].arn}"
  desired_count   = 0

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
