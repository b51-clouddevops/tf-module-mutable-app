resource "aws_route53_record" "record" {
  zone_id = data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONEID
  name    = "${var.COMPONENT}-dev.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONENAME}"
  type    = "CNAME"
  ttl     = 10
  records = var.LB_TYPE == "internal" ? [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ALB] : [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_ALB]
}

# If the record created is called by backend module, record should be created under private hosted zone
# If the record created is called by frontend module, record should be created under public hosted zone