# File structure

- Terraform automatically loads and combines all `.tf` files in the current working directory into a single configuration.
- you don’t need to explicitly "call" one `.tf` file from another

```
my-terraform-project/
├── main.tf               # Main configuration or module calls
├── variables.tf          # Variable definitions
├── outputs.tf            # Output definitions
├── terraform.tfvars      # Variable values
├── providers.tf          # Provider configurations
├── modules/              # Reusable modules
│   ├── vpc/             # VPC module
│   │   ├── main.tf
│   │   ├── variables.tf 
│   │   ├── outputs.tf
│   ├── ec2/             # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── environments/         # Environment-specific configs
│   ├── dev/             # Development environment
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   ├── prod/            # Production environment
│   │   ├── main.tf
│   │   ├── terraform.tfvars
```

## Files:

- **`main.tf`**: This is the primary file where you define your infrastructure resources (e.g., AWS EC2 instances, VPCs) or call reusable modules. It serves as the entry point for your configuration.
- **`variables.tf`**: This file defines input variables, allowing you to make your configuration flexible and reusable by avoiding hardcoded values.
- **`outputs.tf`**: Here, you specify outputs that Terraform will display after applying the configuration, such as resource IDs or IP addresses, which can also be passed to other parts of your project.
- **`terraform.tfvars`**: This file provides specific values for the variables defined in variables.tf, making it easy to customize your setup without modifying the core configuration.
- **`providers.tf`**: A dedicated file for configuring providers (e.g., AWS, Azure), especially useful if you’re working with multiple or complex provider setups.
- `data.tf` file is typically used to store data sources that retrieve information from external systems or other Terraform configurations. These data sources allow Terraform to use the information defined outside of Terraform, such as fetching details about existing resources in cloud providers like AWS, Azure, or GCP
- `backend.tf`:the backend is a configuration block that determines how Terraform state is stored and managed. The backend configuration defines the location where the state file is stored and how it is accessed.

## Terraform Commands:

- **`terraform init`:** It’s going to download code for a provider(aws) that we will use.
- `terraform validate`: is used to validate the syntax and configuration of Terraform files.
- **`terraform fmt`** :This command is optional but recommended. This will rewrite terraform configuration files in a canonical format.
- **`terraform plan`:** This command will tell what terraform does before making any changes.
    - 1: (+ sign): Resource going to be created
    - 2: (- sign): Resource going to be deleted
    - 3: (~ sign): Resource going to be modified
- **`terraform apply`:** To apply the changes, run terraform apply command.
- `terrafrom destory`: used to delete created objects