variable "name" {
  type        = string
  description = "IAM Role Name. -task-role is appended"
}

variable "tags" {
  type    = map(string)
  default = {}
}

output "ecs_task_role_name" {
  description = "The ECS Task Role name to attach policies as needed"
  value       = aws_iam_role.ecs_task_role.name
}


data "aws_iam_policy_document" "ecs_trust_policy" {
  version = "2012-10-17"
  statement {
    sid           = "ECSTrustPolicy"
    effect        = "Allow"
    actions       = ["sts:AssumeRole"]
    not_actions   = []
    not_resources = []
    resources     = []

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json

  tags = merge(var.tags, {
    Service = "IAM"
    Feature = "Role"
  })
}
