RUN CMDS IN TERRAFORM DIR

```
terraform init .
terraform plan -out=tfplan -input=false .
terraform apply -input=false tfplan
```