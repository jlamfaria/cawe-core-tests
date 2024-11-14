output "sqs_arn" {
  value = aws_sqs_queue.receiver_queue.arn
}

output "queue_url" {
  value = aws_sqs_queue.receiver_queue.url
}