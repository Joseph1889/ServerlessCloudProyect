terraform {
  backend "s3" {
    bucket       = "mi-bucket-terraform-state-456789"
    key          = "terraform/state"
    region       = "us-east-1"
    use_lockfile = true
  }
}