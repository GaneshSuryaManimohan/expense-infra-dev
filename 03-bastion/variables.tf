variable "project_name" {
  type        = string
  default     = "expense"
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "common_tags" {
  default     = {
    Project = "Expense"
    Environment = "Dev"
    Terraform = "True"
  }
}