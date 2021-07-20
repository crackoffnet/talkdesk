# talkdesk
1. AWS account should have "AdministratorAccess" permission.
2. terraform workspace select (qa/dr/prod) (by default will be DR, optional step)
3. terraform apply -var 'env=dr' -auto-approve
4. terraform destroy -var 'env=dr' -auto-approve