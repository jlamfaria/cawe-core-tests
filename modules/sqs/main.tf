resource "aws_sqs_queue" "receiver_queue" {
  # checkov:skip=CKV2_AWS_73

  name                        = var.fifo ? "${local.name_prefix}-${var.sqs_name}-queue.fifo" : "${local.name_prefix}-${var.sqs_name}-queue"
  fifo_queue                   = var.fifo
  content_based_deduplication = var.fifo

  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
  visibility_timeout_seconds        = var.visibility_timeout

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.sqs_name}-queue"
  })
}

