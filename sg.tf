resource "aws_security_group" "alb_app" {

  name               = "roboshop-${var.COMPONENT}-${var.ENV}"
  name               = "roboshop-${var.COMPONENT}-${var.ENV}"
  vpc_id             = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "Allow http from internal traffic only"
    from_port        = frotnend = 80 ; backend = 8080
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-private-alb-${var.ENV}"
  }
}