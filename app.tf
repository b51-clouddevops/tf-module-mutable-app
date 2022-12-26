resource "null_resource" "app" {

  triggers = {
     
  }

  count = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT 

  provisioner "remote-exec" {
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.robot-secrets.secret_string)["SSH_PASSWORD"]
    host     = element(local.ALL_INSTANCE_IPS, count.index)
  }
    inline = [
      "ansible-pull -U https://github.com/b51-clouddevops/ansible.git -e ansible_user=centos -e ansible_password=DevOps321 -e DB_PASSWORD=RoboShop@1 -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e ENV=dev roboshop-pull.yml"
    ]
  }
}

# Note: Provisioners are create time by defaut.
# What it means ?  Provisioners will only run during the resource creation, rest of the times, they won't run.

# But, we can define when this provisioner has to run.

# In my case, I want provisioner to run all the time, whenever I run the job

