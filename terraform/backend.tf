terraform {
  backend "s3" {
    bucket = "silich-s3"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}