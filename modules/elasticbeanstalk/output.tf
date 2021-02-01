output "id" {
  value = aws_elastic_beanstalk_environment.default.id
}

output "name" {
  value = aws_elastic_beanstalk_environment.default.name
}

output "endpoint_url" {
  value = aws_elastic_beanstalk_environment.default.endpoint_url
}

output "load_balancers" {
  value = aws_elastic_beanstalk_environment.default.load_balancers
}