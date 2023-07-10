# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "project1-terraform-remote-state"
    key       = "project1.tfstate"
    region    = "us-east-1"
    # profile   = 
  }
}