variable "table_name" {
  description = "Table Name"
}

variable "billing_mode" {
  description = "DynamoDB Billing Mode"
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "The number of read units for this table."
  default     = 5
}

variable "write_capacity" {
  description = "The number of write units for this table."
  default     = 5
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key."
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key."
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions"
  type        = list(map(string))
  default     = []
}

variable "global_secondary_indexes" {
  description = "Describe a GSI for the table"
  default     = []
}

variable "local_secondary_indexes" {
  description = "Describe an LSI on the table"
  default     = []
}

variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}