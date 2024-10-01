locals {
  name_prefix = format("%s-%s", var.project, var.env)
  alb_name    = format("%s-%s", local.name_prefix, "test")

  common_tags = {
    Env       = var.env
    ManagedBy = "terraform"
    Project   = var.project
  }

  lb_account_id = lookup({
    "us-east-1"    = "127311923021"
    "us-east-2"    = "033677994240"
    "us-west-1"    = "027434742980"
    "us-west-2"    = "797873946194"
    "af-south-1"   = "098369216593"
    "ca-central-1" = "985666609251"
    "eu-central-1" = "054676820928"
    "eu-west-1"    = "156460612806"
    "eu-west-2 "   = "652711504416"
    "eu-south-1"   = "635631232127"
    "eu-west-3"    = "009996457667"
    "eu-north-1"   = "897822967062"
    "ap-southeast-1" = "114774131450"
    "ap-southeast-2" = "783225319266"
    "ap-northeast-1" = "582318560864"
    },
    var.region
  )
}

# Elastic Load Balancing root account (this is not your AWS account)
# https://dev.classmethod.jp/articles/elb-access-log-bucket-policy/