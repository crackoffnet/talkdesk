# talkdesk
1. AWS account should have "AdministratorAccess" permission.
2. terraform workspace select (qa/dr/prod)
3. terraform apply -var 'env=dr' -auto-approve