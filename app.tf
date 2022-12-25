resource "null_resource" "app" {

  count = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT 

  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_PASSWORD"]
    host     = element(local.ALL_INSTANCE_IPS, count.index)
  }

#   provisioner "remote-exec" {
#     inline = [
#       "ansible-pull -U https://github.com/b51-clouddevops/ansible.git -e ansible_user=centos -e ansible_password=DevOps321 -e DB_PASSWORD=RoboShop@1 -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev roboshop-pull.yml"
#     ]
#   }
}


count = 3 means 3 servers,

3 servers, 3 different IP addresses.