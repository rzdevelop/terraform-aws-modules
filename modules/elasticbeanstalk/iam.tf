locals {
  ec2_role_name     = "${var.full_name}-eb-ec2"
  service_role_name = "${var.full_name}-eb-service"
}

resource "aws_iam_policy" "default" {
  name   = var.full_name
  policy = var.app_policy_json
}

### EC2 Role
data "template_file" "ec2_assume_policy" {
  template = file("${path.module}/policies/ec2_assume_policy.json.tpl")
}

resource "aws_iam_role" "ec2" {
  name               = local.ec2_role_name
  assume_role_policy = data.template_file.ec2_assume_policy.rendered
  tags = merge(var.tags, {
    Resource = "IAMRole"
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = local.ec2_role_name
  role = aws_iam_role.ec2.name
}

resource "aws_iam_policy_attachment" "ec2_attach_1" {
  name       = var.full_name
  roles      = [aws_iam_role.ec2.name]
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_policy_attachment" "ec2_attach_2" {
  name       = "${local.ec2_role_name}-attach-AWSElasticBeanstalkWebTier"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "ec2_attach_3" {
  name       = "${local.ec2_role_name}-attach-AWSElasticBeanstalkMulticontainerDocker"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_policy_attachment" "ec2_attach_4" {
  name       = "${local.ec2_role_name}-attach-AWSElasticBeanstalkWorkerTier"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "ec2_attach_5" {
  name       = "${local.ec2_role_name}-attach-AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


### Service Role
data "template_file" "elasticbeanstalk_assume_policy" {
  template = file("${path.module}/policies/elasticbeanstalk_assume_policy.json.tpl")
}

resource "aws_iam_role" "service" {
  name               = local.service_role_name
  assume_role_policy = data.template_file.elasticbeanstalk_assume_policy.rendered
  tags = merge(var.tags, {
    Resource = "IAMRole"
  })
}

resource "aws_iam_policy_attachment" "service_attach_1" {
  name       = "${local.service_role_name}-attach-AWSElasticBeanstalkEnhancedHealth"
  roles      = [aws_iam_role.service.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_policy_attachment" "service_attach_2" {
  name       = "${local.service_role_name}-attach-AWSElasticBeanstalkEnhancedHealth"
  roles      = [aws_iam_role.service.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}