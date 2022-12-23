data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "b51-tf-remote-state-bucket"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "b51-tf-remote-state-bucket"
    key    = "alb/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}


# Fecthes the AMI ID of the AMI To Use
data "aws_ami" "myami" {
  most_recent      = true
  name_regex       = "b51-ansible-base"
  owners           = ["self"]
}

