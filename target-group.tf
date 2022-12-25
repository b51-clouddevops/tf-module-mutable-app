# Creates the application target group
resource "aws_lb_target_group" "app" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

# Attach instances to the target group 
resource "aws_lb_target_group_attachment" "instances-attach" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.test.id
  port             = 80
}