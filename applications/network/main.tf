module "main-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = var.env
  }
}

resource "aws_security_group" "api" {
  name   = "api-${var.env}"
  vpc_id = module.main-vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = module.main-vpc.private_subnets_cidr_blocks
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = module.main-vpc.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_security_group" "consumer" {
  name   = "consumer-${var.env}"
  vpc_id = module.main-vpc.vpc_id

  tags = {
    Environment = var.env
  }
}

resource "aws_security_group" "notification" {
  name   = "notification-${var.env}"
  vpc_id = module.main-vpc.vpc_id

  tags = {
    Environment = var.env
  }
}

resource "aws_security_group" "worker" {
  name   = "worker-${var.env}"
  vpc_id = module.main-vpc.vpc_id

  tags = {
    Environment = var.env
  }
}