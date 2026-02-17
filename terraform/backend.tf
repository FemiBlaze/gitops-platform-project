terraform {
  backend "s3" {
    bucket         = "gitops-platform-tfstate-blaze"
    key            = "project-3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

