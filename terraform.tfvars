# aws
region=""
accessKey=""
secretKey=""

# ansible
ansibleHost=""

# gitlab creds
gitlabUserName=""
gitlabUserPassword=""

# security group
securityGroupName=""

# instance
ami=""
instanceType=""
keyName=""
instanceName=""

# grafana
grafanaPort=3000
grafanaPortDocker=3000
grafanaUser=""
grafanaPassword=""
grafanaAPIkeyName=""

# influx
influxdbPort=8086
influxdbPortDocker=8086
datasourceName=""
influxUser=""
influxPasswordinit=""
influxPassword=""
influxdbName=""
influxInitOrg=""

# keycloak
keycloakPort=8080
keycloakPortDocker=8080
dashboardPort=2000
realm=""
masterUserName=""
masterPassword=""
group=""
initialFirstName=""
initialLastName=""
initialMobile=""
initialUserName=""
initialPassword=""
initialUserEmail=""
roleName=""
protocol=""
keycloakClientId=""
# extra roles in keycloak
roleName1=""
roleName2=""
roleName3=""

# 626 services
serverPort=4000
devicePort=3080
vncPort=3082

# ftp
ftpUsername=""
ftpPassword=""

# permission file location in source machine
# This permission file should be able to access the created VM (keyName in instance env)
keyPairPemLocation=""

# remote machine deployment location
remote626ServicesFolder=""