
# Creates SPOT Server
resource "aws_spot_instance_request" "spot" {
  count                        = var.SPOT_INSTANCE_COUNT
  ami                          = data.aws_ami.myami.image_id
  instance_type                = var.INSTANCE_TYPE
  wait_for_fulfillment         = true
  vpc_security_group_ids       = [aws_security_group.allow_app.id]
  subnet_id                    = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID, count.index)

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }

#   connection {
#     type     = "ssh"
#     user     = "centos"
#     password = "DevOps321"
#     host     = self.private_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "ansible-pull -U https://github.com/b51-clouddevops/ansible.git -e ansible_user=centos -e ansible_password=DevOps321 -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev roboshop-pull.yml"
#     ]
#   }
}


# Creates On-Demand-Server
resource "aws_instance" "od" {
  count                      = var.OD_INSTANCE_COUNT
  ami                        = data.aws_ami.myami.image_id
  instance_type              = var.INSTANCE_TYPE
  vpc_security_group_ids     = [aws_security_group.allow_app.id]
  subnet_id                  = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID, count.index)

#   connection {
#     type     = "ssh"
#     user     = "centos"
#     password = "DevOps321"
#     host     = self.private_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "ansible-pull -U https://github.com/b51-clouddevops/ansible.git -e ansible_user=centos -e ansible_password=DevOps321 -e DB_PASSWORD=RoboShop@1 -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev roboshop-pull.yml"
#     ]
#   }
}




# tags for ec2
resource "aws_ec2_tag" "name-tags" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  resource_id =  concat(aws_spot_instance_request.spot.*.spot_instance_id, aws_instance.od.*.id)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}
}