# aws
region="ap-south-1"
accessKey="AKIAULUGNFF6E2GEPZOX"
secretKey="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"
# ansible
ansibleHost="vishalsinha"
# gitlab creds
gitlabUserName="harsh.g@smarter.codes"
gitlabUserPassword="hp2009fbc++"
# security group
securityGroupName="Terraform Ansible Group 1"
# instance
ami="ami-04bde106886a53080"
instanceType="t2.medium"
keyName="626_terraform"
instanceName="Terraform"
# grafana
grafanaPort=3000
grafanaPortDocker=3000
grafanaUser="admin"
grafanaPassword="admin"
grafanaAPIkeyName="testkey"
# influx
influxdbPort=8086
influxdbPortDocker=8086
datasourceName="influxDB"
influxUser="admin"
influxPasswordinit="\"'weare626'\""
influxPassword="weare626"
influxdbName="telegraf"
influxInitOrg="weare626"
# keycloak
keycloakPort=8080
keycloakPortDocker=8080
dashboardPort=2000
realm="weare626"
masterUserName="admin"
masterPassword="admin"
group="testGroup"
initialFirstName="Vishal"
initialLastName="Sinha"
initialMobile="99889988"
initialUserName="adminuser"
initialPassword="testing"
initialUserEmail="adminuser@weare626.com"
roleName="626-admin"
protocol="http"
keycloakClientId="node-test"
# extra roles in keycloak
roleName1="626-engineer"
roleName2="hospital-admin"
roleName3="hospital-user"
# 626 services
serverPort=4000
devicePort=3080
vncPort=3082
# ftp
ftpUsername="vishal"
ftpPassword="vishal"
# permission file location in source machine
# This permission file should be able to access the created VM (keyName in instance env)
keyPairPemLocation="/etc/ansible/acess/626_terraform.pem"
# remote machine deployment location
remote626ServicesFolder="/home/ubuntu/ansible"