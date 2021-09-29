# Create env for AMI service
resource "local_file" "ami_env" {
    content  = <<EOF
KeycloakResource=${var.keycloakClientId}

KeycloakServerUrl=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}/auth

KeycloakRealm=${var.realm}

KEYCLOAK_URL=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}

SERVER_URL=http://${aws_instance.ansible.public_ip}:${var.serverPort}

DEVICE_URL=http://${aws_instance.ansible.public_ip}:${var.devicePort}
    EOF
    filename = "envfolder/AMIenv"
}

# Create env for Data Ingestion service
resource "local_file" "data_ingestion_env" {
    content  = <<EOF
MACHINE_DATA_PATH=/home

INFLUX_HOST=${aws_instance.ansible.public_ip}

INFLUX_DB=${var.influxdbName}

INFLUX_PORT=${var.influxdbPort}

INFLUX_USER=${var.influxUser}

INFLUX_PASS=${var.influxPassword}

HOSPITAL_TIMEZONE=GMT-0400
    EOF
    filename = "envfolder/dataIngestionEnv"
}

# Create env for Device Monitoring Dashboard service
resource "local_file" "dmd_env" {
    content  = <<EOF
REACT_APP_SERVER_HOST=http://${aws_instance.ansible.public_ip}:${var.serverPort}

REACT_APP_GRAFANA_SERVER=http://${aws_instance.ansible.public_ip}:${var.grafanaPort}/

REACT_APP_KEYCLOAK_REALM=${var.realm}

REACT_APP_KEYCLOAK_URL=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}/auth

REACT_APP_KEYCLOAK_CLIENT_ID=${var.keycloakClientId}

REACT_APP_FTP_URL=ftp://${aws_instance.ansible.public_ip}:21

REACT_APP_GRAFANA=true
    EOF
    filename = "envfolder/DMDenv"
}

# Create env for Device Monitoring Server service
resource "local_file" "dms_env" {
    content  = <<EOF
GRAFANA_URL=http://${aws_instance.ansible.public_ip}:${var.grafanaPort}

GRAFANA_ADMIN_URL=http://${var.grafanaUser}:${var.grafanaPassword}@${aws_instance.ansible.public_ip}:${var.grafanaPort}

KEYCLOAK_ADMIN_USERNAME=${var.masterUserName}

KEYCLOAK_ADMIN_PASSWORD=${var.masterPassword}

KEYCLOAK_REALM=${var.realm}

KEYCLOAK_URL=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}

MONGO_URL=mongodb://localhost:27017/${var.realm}

ADMIN_USERID=3

FTP_HOST=${aws_instance.ansible.public_ip}

GRAFANA_SERVER=true

VNC_URL=http://${aws_instance.ansible.public_ip}:${var.vncPort}

INFLUX_USERNAME=${var.influxUser}

INFLUX_PASSWORD=${var.influxPassword}

INFLUX_HOST=${aws_instance.ansible.public_ip}

INFLUX_PORT=${var.influxdbPort}

INFLUX_DATABASE=${var.influxdbName}

DATA_INGESTION_FILE_PATH=${var.remote626ServicesFolder}/626-data-ingestion
    EOF
    filename = "envfolder/DMSenv"
}

# Create env for VNC service
resource "local_file" "vnc_env" {
    content  = <<EOF
KeycloakResource=${var.keycloakClientId}

KeycloakServerUrl=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}/auth

KeycloakRealm=${var.realm}

KEYCLOAK_URL=http://${aws_instance.ansible.public_ip}:${var.keycloakPort}

SERVER_URL=http://${aws_instance.ansible.public_ip}:${var.serverPort}
    EOF
    filename = "envfolder/VNCenv"
}

# Create host file for ansbile
resource "local_file" "ansible_hosts" {
    content  = <<EOF
ansible_python_interpreter=/usr/bin/python3

${var.ansibleHost} ansible_ssh_host=ubuntu@${aws_instance.ansible.public_dns} ansible_user=ubuntu ansible_ssh_private_key_file=${var.keyPairPemLocation}
    EOF
    filename = "ansibleHosts"
}

# Create Keycloak DMD json creds
resource "local_file" "dmd_keycloak" {
    content  = "{\"realm\":\"weare626\",\"auth-server-url\":\"http://${aws_instance.ansible.public_ip}:8080/auth\",\"ssl-required\":\"none\",\"resource\": \"${var.keycloakClientId}\",\"public-client\":true,\"confidential-port\":0}"
    filename = "envfolder/DMDkeycloak.json"
}