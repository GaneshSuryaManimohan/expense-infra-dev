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

variable "sg_tags" {
  type        = string
  default     = ""
}

variable "db_sg_description" {
  default = "SG for DB MySQL Instance"
}

variable "backend_sg_description" {
  default = "SG for backend"
}

variable "frontend_sg_description" {
  default = "SG for frontend"
}

variable "ansible_sg_description" {
  default = "SG for Ansible Instance"
}

variable "bastion_sg_description" {
  default = "SG for Bastion Instance"
}

variable "app_alb_description" {
  default = "SG for ALB"
}

variable "vpn_description" {
  default = "SG for VPN"
}

variable "vpn_sg_rules" {
  default = [
      {
          from_port = 943
          to_port = 943
          protocol = "tcp" 
          cidr_blocks = ["0.0.0.0/0"]
      },
      {
          from_port = 443
          to_port = 443
          protocol = "tcp" 
          cidr_blocks = ["0.0.0.0/0"]
      },
      {
          from_port = 1194
          to_port = 1194
          protocol = "udp" 
          cidr_blocks = ["0.0.0.0/0"]
      },
      {
          from_port = 22
          to_port = 22
          protocol = "tcp" 
          cidr_blocks = ["0.0.0.0/0"]
      }
  ]
}

