resource "aws_s3_bucket" "logs" {
  count = var.logs_bucket == null ? 0 : 1

  bucket = var.logs_bucket
  # acl    = "private" # tfsec:ignore:AWS002

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }

  # lifecycle_rule {
  #   id      = "delete"
  #   enabled = true

  #   expiration {
  #     days = var.logs_expiration
  #   }
  # }

  force_destroy = var.logs_bucket_force_destroy

  tags = local.common_tags
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
#   count = var.logs_bucket == null ? 0 : 1

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
#   bucket = aws_s3_bucket.logs[0].id
# }
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/default-encryption-faq.html

resource "aws_s3_bucket_ownership_controls" "logs" {
  count = var.logs_bucket == null ? 0 : 1
  bucket = aws_s3_bucket.logs[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs" {
  count = var.logs_bucket == null ? 0 : 1

  depends_on = [aws_s3_bucket_ownership_controls.logs]

  bucket = aws_s3_bucket.logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  count = var.logs_bucket == null ? 0 : 1
  bucket = aws_s3_bucket.logs[0].id

  rule {
    id = "delete"

    expiration {
      days = var.logs_expiration
    }

    status = "Enabled"
  }
}

data "aws_iam_policy_document" "alb_logs_s3" {
  count = var.logs_bucket == null ? 0 : 1

  statement {
    sid = "AlbS301"

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs[0].arn}/${var.logs_prefix}/AWSLogs/${var.account_id}/*"]

    principals {
      identifiers = ["arn:aws:iam::${local.lb_account_id}:root"]
      type        = "AWS"
    }
  }

  statement {
    sid = "AlbS302"

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs[0].arn}/${var.logs_prefix}/AWSLogs/${var.account_id}/*"]

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    sid = "AlbS303"

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs[0].arn]

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  count = var.logs_bucket == null ? 0 : 1

  bucket = aws_s3_bucket.logs[0].id
  policy = data.aws_iam_policy_document.alb_logs_s3[0].json
}
