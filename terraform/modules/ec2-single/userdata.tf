data "template_cloudinit_config" "ec2" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"

    content = templatefile("${path.module}/templates/userdata.sh.tpl", {
      region = var.region
      project = var.project
      env = var.env
      account_id = var.account_id
      app_name = local.app_name_full
    })
  }
}
