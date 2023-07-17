# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "project1-terraform-remote-state"
    key       = "terraform.tfstate"
    region    = "us-east-1"
    # profile   = 
    # dynamodb_table = "state-lock"
  }
}