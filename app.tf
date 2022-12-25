resource "null_resource" "app" {

  count = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT 

  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = elelocal.ALL_INSTANCE_IPS
  }

#   provisioner "remote-exec" {
#     inline = [
#       "ansible-pull -U https://github.com/b51-clouddevops/ansible.git -e ansible_user=centos -e ansible_password=DevOps321 -e DB_PASSWORD=RoboShop@1 -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev roboshop-pull.yml"
#     ]
#   }
}


count = 3 means 3 servers,

3 servers, 3 different IP addresses.