# NETWORK :: SECTION START#
# NETWORK :: SECTION START#


module "vpc" {
  source  = "cloudposse/vpc/aws"
  #version = "0.28.1"

  cidr_block = "10.189.11.0/24"

  context = module.this.context
  tags = {"Purpose" : "PoC", "Phase" : "Testing"}
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.2"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block           = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "alb" {
  source  = "cloudposse/alb/aws"
  version = "1.4.0"

  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnets.public_subnet_ids
  access_logs_enabled = false

  # This additional attribute is required since both the `alb` module and `elastic_beanstalk_environment` module
  # create Security Groups with the names derived from the context (this would conflict without this additional attribute)
  attributes = ["shared"]

  context = module.this.context
}
