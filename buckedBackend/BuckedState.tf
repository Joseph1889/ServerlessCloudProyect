provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "mi-bucket-terraform-state-456789"

  tags = {
    Name = "Terraform State Bucket"
  }
}
