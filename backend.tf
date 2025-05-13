terraform {
  backend "s3" {
    bucket         = "nginx-terraform-state-lab"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "devops"
    encrypt        = true
  }
}
