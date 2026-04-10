# Terraform State file & Management

# **Terraform State file:**

- Every time you run Terraform, it records the information about your infrastructure in a terraform state file(`terraform.tfstate`).
- when you run the terraform command, it fetches the resource's latest status, compares it with the `tfstate` file, and determines what changes need to be applied. If Terraform sees a `drift`, it will re-create or modify the resource.
- **Note:** As you can see, this file is critically important. It is always good to store this file in some remote storage, for example, S3. In this way, your team member should have access to the same state file. Also, to avoid race conditions, i.e., two team members running terraform simultaneously and updating the state file, it's a good idea to apply locking, for example, via DynamoDB. For more information on how to do that, please check this doc: [**https://www.terraform.io/docs/language/settings/backends/s3.html**](https://www.terraform.io/docs/language/settings/backends/s3.html)

---

# **State Management**

Terraform tracks your infrastructure’s state in a state file. While not part of the file structure itself, it’s worth noting:

- **`Local State`**: Stored in `terraform.tfstate` in the working directory by default.
- **`Remote State`**: For collaboration or larger projects, you might store it remotely (e.g., in AWS S3 or Terraform Cloud) and configure this in your setup.