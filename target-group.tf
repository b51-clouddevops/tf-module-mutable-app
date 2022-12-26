# Creates the application target group
resource "aws_lb_target_group" "app" {
  name     = "${var.COMPONENT}-${var.ENV}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}

# Attach instances to the target group 
resource "aws_lb_target_group_attachment" "instances-attach" {
  count            =  var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = element(local.ALL_INSTANCE_IDS, count.index)
  port             = 8080
}

# Generates random number in the range of 100 to 999, which we use to assign a unique priority to the Listener rules
resource "random_integer" "priority" {
  min = 101
  max = 999
}

# Adding Rule inside the created private listerer
resource "aws_lb_listener_rule" "app-rule" {
  count        = var.LB_TYPE == "internal" ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result   # No two rules should have same priority, hence using the randomly created unique priority number

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONENAME}"]
    }
  }
}


# Adding Rule inside the created private listerer
resource "aws_lb_listener_rule" "public-app-rule" {
  count        = var.LB_TYPE == "internal" ? 0 : 1
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result   # No two rules should have same priority, hence using the randomly created unique priority number

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONENAME}"]
    }
  }
}