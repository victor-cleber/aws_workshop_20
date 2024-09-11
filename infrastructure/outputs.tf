output "remote_state_bucket_name" {
  description = "Bucket name"
  value = aws_s3_bucket.s3-remote-state.bucket
}

output "remote_state_bucket_arn" {
  description = "Bucket arn"
  value = aws_s3_bucket.s3-remote-state.arn
}