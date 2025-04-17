module "db" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.db_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "db"
    common_tags = var.common_tags
}

module "backend" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.backend_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "backend"
    common_tags = var.common_tags
}

module "frontend" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.frontend_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "frontend"
    common_tags = var.common_tags
}

module "bastion" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.bastion_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "bastion"
    common_tags = var.common_tags
}

module "app_alb" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.app_alb_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "app_alb"
    common_tags = var.common_tags
}

module "vpn" {
    source = "../../terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_description = var.vpn_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "vpn"
    ingress_rules = var.vpn_sg_rules
    common_tags = var.common_tags
}

# DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.backend.sg_id
  security_group_id = module.db.sg_id
}

# DB is accepting connections from bastion
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

# DB is accepting connections from VPN
resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.vpn.sg_id
  security_group_id = module.db.sg_id
}

# backend is accepting connections from ALB
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id       = module.app_alb.sg_id
  security_group_id = module.backend.sg_id
}

# backend is accepting connections from VPN (ssh)
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

# backend is accepting connections from VPN (http)
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id       = module.vpn.sg_id
  security_group_id = module.backend.sg_id
}

# backend is accepting connections from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}

# frontend is accepting connections from internet
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

# frontend is accepting connections from bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}
