provider "aws" {
  region = var.region
  access_key = var.accessKey
  secret_key = var.secretKey
}

# Create the Security Group
resource "aws_security_group" "ansible_security_group" {
  name = var.securityGroupName
  description  = var.securityGroupName
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow ingress of port 21
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
  }

  # allow ingress of keycloakPort
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = var.keycloakPort
    to_port     = var.keycloakPort
    protocol    = "tcp"
  }

  # allow ingress of grafanaPort
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = var.grafanaPort
    to_port     = var.grafanaPort
    protocol    = "tcp"
  }

  # allow ingress of dashboardPort
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = var.dashboardPort
    to_port     = var.dashboardPort
    protocol    = "tcp"
  }

  # allow ingress of serverPort
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = var.serverPort
    to_port     = var.serverPort
    protocol    = "tcp"
  }

  # allow ingress of influxdbPort
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = var.influxdbPort
    to_port     = var.influxdbPort
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = var.securityGroupName
     Description = var.securityGroupName
  }
}

# Create EC2 instance
resource "aws_instance" "ansible" {
  ami = var.ami
  instance_type = var.instanceType
  key_name = var.keyName
  security_groups = [ aws_security_group.ansible_security_group.name ]
  tags = {
    "Name" = var.instanceName
  }
}

resource "null_resource" "delay" {}

# Add time delay of 2 min to start the instance properly
resource "time_sleep" "wait_2_minutes" {
  depends_on = [null_resource.delay, aws_instance.ansible]

  create_duration = "2m"
}

# Start Ansible Playbook for installing basic dependencies
resource "null_resource" "basic_dep_ansible" {
 provisioner "local-exec" {
    command = "ansible-playbook basic-dependencies-setup.yml --extra-vars 'hosts=${var.ansibleHost} ftpUsername=${var.ftpUsername} ftpPassword=${var.ftpPassword}' -i ansibleHosts"
  }
  depends_on = [aws_instance.ansible, local_file.ansible_hosts, time_sleep.wait_2_minutes]
}

# Start Ansible Playbook for installing Keycloak service
resource "null_resource" "keycloak_ansible" {
 provisioner "local-exec" {
    command = "ansible-playbook keycloak-resources-setup.yml --extra-vars 'hosts=${var.ansibleHost} serverUrl=${aws_instance.ansible.public_ip} keycloakPort=${var.keycloakPort} keycloakPortDocker=${var.keycloakPortDocker} dashboardPort=${var.dashboardPort} serverPort=${var.serverPort} grafanaPort=${var.grafanaPort} realm=${var.realm} masterUserName=${var.masterUserName} masterPassword=${var.masterPassword} group=${var.group} initialFirstName=${var.initialFirstName} initialLastName=${var.initialLastName} initialMobile=${var.initialMobile} initialUserName=${var.initialUserName} initialPassword=${var.initialPassword} initialUserEmail=${var.initialUserEmail} roleName=${var.roleName} keycloakClientId=${var.keycloakClientId} roleName1=${var.roleName1} roleName2=${var.roleName2} roleName3=${var.roleName3} protocol=${var.protocol}' -i ansibleHosts"
  }
  depends_on = [null_resource.basic_dep_ansible]
}

# Start Ansible Playbook for installing Influx and Grafana service
resource "null_resource" "influx_grafana_ansible" {
 provisioner "local-exec" {
    command = "ansible-playbook influx-grafana-setup.yml --extra-vars 'hosts=${var.ansibleHost} serverUrl=${aws_instance.ansible.public_ip} grafanaPort=${var.grafanaPort} grafanaPortDocker=${var.grafanaPortDocker} influxdbPort=${var.influxdbPort} influxdbPortDocker=${var.influxdbPortDocker} grafanaPort=${var.grafanaPort} keycloakPort=${var.keycloakPort} grafanaUser=${var.grafanaUser} grafanaPassword=${var.grafanaPassword} grafanaAPIkeyName=${var.grafanaAPIkeyName} datasourceName=${var.datasourceName} influxUser=${var.influxUser} influxPasswordinit=${var.influxPasswordinit} influxPassword=${var.influxPassword} influxdbName=${var.influxdbName} influxInitOrg=${var.influxInitOrg} gitlabUserName=${var.gitlabUserName} gitlabUserPassword=${var.gitlabUserPassword} masterUserName=${var.masterUserName} masterPassword=${var.masterPassword} protocol=${var.protocol}' -i ansibleHosts"
  }
  depends_on = [null_resource.keycloak_ansible]
}

# Curl request to get the grafana api key
resource "null_resource" "grafana_api_key" {
 provisioner "local-exec" {
    command = <<EOT
curl --location --request POST 'http://${var.grafanaUser}:${var.grafanaPassword}@${aws_instance.ansible.public_ip}:${var.grafanaPort}/api/auth/keys' \
--header 'Content-Type: application/json' \
--data-raw '{"name":"testkey5", "role":"Admin"}' \
-o grafanaApiResponse.json
    EOT
  }
  depends_on = [
    null_resource.influx_grafana_ansible
  ]
}

# Save grafana api key into the env
resource "null_resource" "save_grafana_key" {
 provisioner "local-exec" {
    command = "./saveGrafanaKey.sh"
  }
  depends_on = [
    null_resource.grafana_api_key
  ]
}

# Start Ansible Playbook for installing 626 services
resource "null_resource" "services_626_ansible" {
 provisioner "local-exec" {
    command = "ansible-playbook 626-services-setup.yml --extra-vars 'hosts=${var.ansibleHost} gitlabUserName=${var.gitlabUserName} gitlabUserPassword=${var.gitlabUserPassword} remote626ServicesFolder=${var.remote626ServicesFolder}' -i ansibleHosts"
  }
  depends_on = [null_resource.save_grafana_key]
}
