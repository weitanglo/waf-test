data "aws_route53_zone" "alias" {
  for_each = local.alias_zones
  name     = each.key
}

locals {
  alias_zones = toset([
    for alias in var.create_aliases :
    alias["zone"]
  ])
# 結果は["sergiitest.website"］keyのみ
  alias_fqdns_with_zones = {
    for alias in var.create_aliases : format("%s.%s", alias["name"], alias["zone"]) => alias["zone"]
  }
}
# 結果は{flask.sergiitest.website" = "sergiitest.website"}
resource "aws_route53_record" "alias" {
  for_each = local.alias_fqdns_with_zones

  zone_id = data.aws_route53_zone.alias[each.value].zone_id
  name    = each.key
  type    = "A"
# each.valueはこのリソース内のfor_eachのvalue= alias["zone"]、data "aws_route53_zone"のfor_each(keyしかいない)ではない。
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
