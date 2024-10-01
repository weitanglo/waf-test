terraform {
  backend "s3" {
    bucket         = "terraform-state-security-web-waf-loweitang"
    dynamodb_table = "terraform-state-security-web-waf"
    encrypt        = true
    key            = "dev-flask-app.tfstate"
    region         = "ap-northeast-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-security-web-waf-loweitang"
    key    = "dev-network.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "terraform-state-security-web-waf-loweitang"
    key    = "dev-alb.tfstate"
    region = var.region
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}
