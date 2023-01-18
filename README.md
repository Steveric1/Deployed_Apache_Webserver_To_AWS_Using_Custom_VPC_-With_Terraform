# Deployed_Apache_Webserver_To_AWS_Using_Custom_VPC_-With_Terraform
![works](https://user-images.githubusercontent.com/105046475/213189772-9b25f749-f6bb-4b58-a93a-ef17d2fa6a08.png)
## Terraform
#### Terraform is an IAC(Infrastructure as code) tools, used by Devops team to automate various tasks infrastructure tasks. The provisioning of AWS instacnce can be provisioned using terraform script it’s a cloud-agnostic, open-source provisioning tool written in the Go language and created by HashiCorp. You can read up more on terraform from there site https://www.terraform.io/ or read up https://www.varonis.com/blog/what-is-terraform
## Must know basic terraform commands
### 1 Terraform Init
#### The terraform init command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.
### 2 Terraform apply 
#### The terraform plan command lets you to preview the actions Terraform would take to modify your infrastructure, or save a speculative plan which you can apply later. The function of terraform plan is speculative: you cannot apply it unless you save its contents and pass them to a terraform apply command.
### 3 Terraform apply
#### The terraform apply command performs a plan just like terraform plan does, but then actually carries out the planned changes to each resource using the relevant infrastructure provider's API. It asks for confirmation from the user before making any changes, unless it was explicitly told to skip approval.
### 4 terraform destroy 
#### The terraform destroy command terminates resources managed by your Terraform project. This command is the inverse of terraform apply in that it terminates all the resources specified in your Terraform state. It does not destroy resources running elsewhere that are not managed by the current Terraform project.
##### Visit terraform official web page to learn more of terraform commands :point_right: https://www.terraform.io/ 
#### THANKS :smiley:
