terraform {
  backend "s3" {
    bucket         = "terraform-state-security-web-waf-loweitang"
    dynamodb_table = "terraform-state-security-web-waf"
    encrypt        = true
    key            = "dev-network.tfstate"
    region         = "ap-northeast-1"
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}

module "network" {
  source = "../../modules/network"

  account_id = var.account_id
  env        = var.env
  project    = var.project
  region     = var.region

  az_num              = 3
  vpc_ip_block        = "172.27.72.0/22"
  subnet_cidr_private = "172.27.72.0/24"
  subnet_cidr_public  = "172.27.73.0/24"
  new_bits_private    = 2
  new_bits_public     = 2
  natgw_count         = "none"
  
  app_direct_access = {
    "vpn" = {
      "157.205.123.180/32" = "VPN",
    }
  }

  public_ips = {
    "0.0.0.0/0" = "Open",
  }

  public_ips_v6 = {
    "::/0" = "Open",
  }

  app_ports = [
    80,
    443,
  ]
}
