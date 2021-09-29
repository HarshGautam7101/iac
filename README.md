# IaC Ansible

IaC ansible is project which is intended to setup all the required setup for 626 services such as device-monitoring-server, device-monitoring-dashboard, 626_vncDemo, AMI dashboard and their all respective dependencies using Ansible. <br />
Fundamental Concept of Ansible: Source Node, Target Node & Playbook. In playbook we defines different plays to perform on target Node (target machine) by issuing ansible command from source node (source machine).

This project uses `Terraform` to automate all the deployments. All the process looks something like this:
- Create a Security Group in AWS
- Open required ports in security group for 626 services
- Create an EC2 instance using the above created security group
- Create all envs for the 626 services
- Create Ansible Host file
- Start Ansible Playbook for installing [Basic Dependencies](./basic-dependencies-setup.yml).
- Start Ansible Playbook for installing [Keycloak Resources](./keycloak-resources-setup.yml).
- Start Ansible Playbook for installing [Influx and Grafana](./influx-grafana-setup.yml).
- Generate Grafana Api Key & append it into envs using [Save Grafana Key Shell Script](./saveGrafanaKey.sh).
- Start Ansible Playbook for installing [626 Services](./626-services-setup.yml).

The whole process stated above is automatic using `Terraform`. You only need to set terraform vars in [Terraform tfvars](./terraform.tfvars) and start it, rest it will automatically do. You can take refence from [Terraform tfvars example file](./terraform.tfvars.example) to set varibles.


# Installation

We need to install two things:
- Ansible
- Terraform

### A) Ansible

1. Make sure Ansilbe is installed on your source machine, one can follow [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for their respective computer system. 

2. Install ansible package in your source machine by running `ansible-galaxy collection install community.general` and `ansible-galaxy collection install community.grafana`.

### B) Terraform

1. [Download Terraform](https://www.terraform.io/downloads.html) for your machine distribution.

2. For Linux users, It downloads a zip file. You will need to unzip it at `/usr/bin/` location.

- Do that using this command: `sudo unzip terraform_1.0.6_linux_amd64.zip -d /usr/bin`.

3. You should be able to get `Terraform version` by running `terraform -v`. We used `Terraform v1.0.6`.

**Note:** Download [this extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) in vscode for terraform syntax highlighting.



# Execution

1. Set [terraform vars](./terraform.tfvars) correctly, can take reference from this [terraform vars example file](./terraform.tfvars.example).

2. Run `terraform init` to initialize a working directory containing Terraform configuration files.

3. Run `terraform apply --auto-approve` to execute the actions proposed in a Terraform plan.

**Note:** You can tear down all the deployments using `terraform destroy --auto-approve`.

# Troubleshooting
## Testing if Ansible is correctly installed or not

1. Perform the installation steps of the Ansible provided above.

2. Create a target machine in the EC2 instance. Also, make sure target machine should be of 18.04 LTS version (As all the services are developed on this version only)

3. In ubuntu, at location `/etc/ansible` their is file name `hosts` (this is known as default inventory file of ansible). You can create your own inventory file too but for that you have to provide path of inventory file using `-i <path>` in ansible commands. 
 
4. Add your Target Node/hosts details you can add multiple Target hosts, group them, add variables etc. (explore [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) and [here](https://docs.ansible.com/ansible/2.9_ja/plugins/inventory/ini.html#examples)). following example is of ungrouped host(explore previous links) with details required to connect: <br />
`myhostname ansible_ssh_host=ubuntu@ec2-18-237-142-14.us-west-2.compute.amazonaws.com ansible_user=ubuntu ansible_ssh_private_key_file=/key/location/key.pem
 `

5. Now test if you are able to connect your 'all' or specific group of hosts or a single host by following command respectively from your local/source node. <br />
`ansible all -m ping` or `ansible groupname -m ping` or `ansible myhostname -m ping`

6. You should receive a success message on screen something like this. ![](https://gitlab.com/weare626/requirements-and-architecture/uploads/5b72021cb20c5e3af59a6d8665bea918/image.png)

7. If you are able to get something like the above screenshot message, ansible is correctly working for you.

## If you are getting some permission issue errors

You can try these two solutions:

1. Go to the pem file location & change permission scope of you `.pem` file using `chmod 400 626_terraform.pem`.

2. Change permission scope of [Save Grafana Key](./saveGrafanaKey.sh) using `chmod +x ./saveGrafanaKey.sh`.