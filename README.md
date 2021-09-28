## IaC Ansible

IaC ansible is project which is intended to setup all the required setup for 626 services such as device-monitoring-server, device-monitoring-dashboard, 626_vncDemo, AMI dashboard and their all respective dependencies using Ansible. <br />
Fundamental Concept of Ansible: Source Node, Target Node & Playbook. In playbook we defines different plays to perform on target Node (target machine) by issuing ansible command from source node (source machine).


## Setup

1. Make sure Ansilbe is installed on your source machine, one can follow [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for their respective computer system. Also, make sure target machine should be of 18.04 LTS version (As all the services are developed on this version only)

2. In ubuntu, at location `/etc/ansible` their is file name `hosts` (this is known as default inventory file of ansible). You can create your own inventory file too but for that you have to provide path of inventory file using `-i <path>` in ansible commands. 
 
3. Add your Target Node/hosts details you can add multiple Target hosts, group them, add variables etc. (explore [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) and [here](https://docs.ansible.com/ansible/2.9_ja/plugins/inventory/ini.html#examples)). following example is of ungrouped host(explore previous links) with details required to connect: <br />
`myhostname ansible_ssh_host=ubuntu@ec2-18-237-142-14.us-west-2.compute.amazonaws.com ansible_user=ubuntu ansible_ssh_private_key_file=/key/location/key.pem
 `

4. Now test if you are able to connect your 'all' or specific group of hosts or a single host by following command respectively from your local/source node. <br />
`ansible all -m ping` or `ansible groupname -m ping` or `ansible myhostname -m ping`

5. You should receive a success message on screen something like this. ![](https://gitlab.com/weare626/requirements-and-architecture/uploads/5b72021cb20c5e3af59a6d8665bea918/image.png)

6. Install ansible package in your source machine by running `ansible-galaxy collection install community.general` and `ansible-galaxy collection install community.general`.

## Execution Flow

i) `ansible-playbook basic-dependencies-setup.yml`

ii) `ansible-playbook keycloak-resources-setup.yml`
  Before running above command make sure you are using correct variables (check the vars section of _keycloak-resources-setup.yml_ and make changes according to your needs)

iii) `ansible-playbook influx-grafana-setup.yml` Before running above command make sure you are using correct variables (check the vars section of _influx-grafana-setup.yml_). <br />
After completion of tasks of this command make sure you add the Grafana API key in _DMSenv_. Following are the setups: <br />
 - Copy the Grafana API key which is displayed after running the above a command.
 - Now paste this API key in DMSenv against GRAFANA_API_KEY

iv) `ansible-playbook 626-services-setup.yml`
Before running this command, make sure that you make appropriate changes in configuration files (check _configFiles_ folders contains .env/.json files). Also, provide the path of folder (of remote machine) in which you want to setup all the 626 services against **remote626ServicesFolder** variable in _626-services-setup.yml_.

