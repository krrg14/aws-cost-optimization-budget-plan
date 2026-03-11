resource "aws_s3_bucket" "mybucket" {
    bucket = "terraform-backend-bucket-statefile-backup"

    force_destroy = true

    tags = { Name = "terraform statefile backup" }
}

resource "aws_s3_bucket_versioning" "my-version" {
    bucket = aws_s3_bucket.mybucket.id

    versioning_configuration {
    status = "Enabled"
    }
}