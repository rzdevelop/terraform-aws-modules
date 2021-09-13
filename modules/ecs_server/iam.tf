#######
## IAM Resources
#######

data "aws_iam_policy_document" "ecs_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

##### Task Execution Role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.full_name}-task-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
  tags = merge(local.default_tags, {
    Service    = "IAM"
    Feature    = "Role"
    ForFeature = "ECSService"
  })
}

data "aws_iam_policy_document" "task_execution_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:*:log-stream:*",
      "arn:aws:ecr:${var.region}:${local.account_id}:repository/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name   = "${local.full_name}-task-execution-policy"
  role   = aws_iam_role.ecs_task_execution_role.name
  policy = data.aws_iam_policy_document.task_execution_role_policy_document.json
}

##### Task Role

resource "aws_iam_role" "ecs_task_role" {
  name = "${local.full_name}-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
  tags = merge(local.default_tags, {
    Service    = "IAM"
    Feature    = "Role"
    ForFeature = "ECSService"
  })
}

data "aws_iam_policy_document" "task_role_policy_document" {
  statement {
    effect    = "Allow"
    actions   = var.task_role_actions
    resources = var.task_role_resources
  }
}

resource "aws_iam_role_policy" "task_role_policy" {
  name   = "${var.full_name}-task-policy"
  role   = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.task_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "task_role_additional_policy" {
  count      = var.enable_task_role_additional_policy ? 1 : 0
  role       = aws_iam_role.task_role.name
  policy_arn = var.additional_policy_arn
}
