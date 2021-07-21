# talkdesk
Architecture includes terraform and ansible based templates/scripts.
Terraform templates includes EKS, VPC (public/private subnets) modules, also can be used for multi-environment/multi-region deployment (dr/qa/prod) by changing terraform workspace (terraform workspace select (qa/dr/prod)). By default it is set "dr".
As an ingress was used Nginx ingress.

To start application please run below command from "ansible" folder:
ansible-playbook playbook.yaml

During running process you will be asked to input AWS_ACCESS_KEY and AWS_SECRET_KEY, so no need to export those ones separately. Process can be take up to 20 minutes, after completion you will see URL which will take you to the requested result.

P.S. To completely remove all deployed infrastructure, please run below command from "terraform" folder:
terraform destroy -var 'env=dr' -auto-approve


###Prerequisites
1. AWS account with "AdministratorAccess" permission.
2. Ansible and Terraform installed LinuxOS machine.