variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}

variable "engine" {
  default = "postgres"
}

variable "parameter_group_name" {
  default = "default.postgres12"
}

variable "engine_version" {
  default = "12.7"
}

variable "name" {
  description = "DB name"
}

variable "identifier" {
  description = "DB identifier"
}

variable "username" {
  description = "DB username"
}

variable "password" {
  description = "DB password"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "storage_type" {
  default = "gp2"
}

variable "allocated_storage" {
  default = 20
}

variable "max_allocated_storage" {
  default = 21
}

# variable "subnet_group" {}

variable "sg_id" {
  description = "Security Group Id"
}
