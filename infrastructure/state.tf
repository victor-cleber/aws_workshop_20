resource "aws_s3_bucket" "s3-remote-state" {
  bucket = "glpi-remote-state"
}

#resource "aws_s3_bucket_versioning" "versioning-s3-remote-state" {
#  bucket = aws_s3_bucket.s3-remote-state.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}