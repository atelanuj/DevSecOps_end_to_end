This markdown file contains a series of **HashiCorp Vault** commands designed to set up a secure, passwordless authentication trust between **GitHub Actions** and your Vault server using **OIDC (OpenID Connect)** / **JWT (JSON Web Token)**.

The ultimate goal of this setup is to allow your GitHub Actions workflows to securely ask Vault for temporary, short-lived AWS credentials to execute Terraform code, without you having to hardcode any long-lived secret keys into GitHub.

# Prerequisites Configure Vault
```bash
vault secrets enable aws
```
This command enables the **AWS Secrets Engine** in Vault. This engine is responsible for dynamically generating and managing AWS credentials.

```bash
vault write aws/config/root \
    access_key="<aws_access_key>" \
    secret_key="<aws_secret_key>" \
    region="us-east-1"
```
With this command, you are essentially handing over the master keys (Access Key and Secret Key) of an AWS IAM user or role to Vault. Vault will now use these credentials to act as that IAM user/role on your behalf. It will **dynamically generate short-lived credentials** based on the policies you define later.

```bash
# Create the role that vends S3 keys
vault write aws/roles/terraform-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
```
This command creates a role named `terraform-role` within Vault's AWS Secrets Engine. 
* `credential_type=iam_user`: This tells Vault that when this role is used, it should generate **AWS IAM User credentials** (an access key and secret key pair).
* `policy_document`: This is the actual AWS IAM policy that will be attached to the temporary IAM user that Vault creates on the fly. In this case, it grants `s3:*` permissions (full S3 access) to all resources (`*`).

# GitHub Actions OIDC trust
### 1. Enable JWT Auth
```bash
vault auth enable jwt
```
This command turns on the JWT (JSON Web Token) authentication engine in your Vault server. By default, Vault doesn't have this enabled.

### 2. Configure JWT Auth
```bash
vault write auth/jwt/config \
    bound_issuer = "https://token.actions.githubusercontent.com" \
    oidc_discovery_url = "https://token.actions.githubusercontent.com"
```
This tells Vault to trust GitHub as an Identity Provider. It effectively says: *"If someone comes to authenticate and presents a JWT token that was issued by `token.actions.githubusercontent.com`, you can cryptographically verify it and trust it."*

### 3. Create a Vault Policy
```bash
vault policy write terraform-policy - <<EOF
path "aws/creds/terraform-role" {
    capabilities = ["read"]
}
EOF
```
This creates a set of permissions (a policy) inside Vault named `terraform-policy`. 
* It grants **read** access to a specific Vault path: `aws/creds/terraform-role`. 
* This path belongs to Vault's AWS Secrets Engine. When this path is read by an authenticated user, Vault reaches out to AWS on the fly, generates short-lived, temporary AWS access and secret keys based on a pre-configured IAM role (`terraform-role`), and hands them back.

### 4. Bind the policy to your GitHub Repository
```bash
vault write auth/jwt/role/gh-actions-role - <<EOF
{
    "role_type": "jwt",
    "token_policies": ["terraform-policy"],
    "bound_audiences": ["https://github.com/atelanuj"],
    "ttl": "1h",
    "bound_claims": {
        "sub": "repo:atelanuj/DevSecOps_end_to_end:*"
    },
    "bound_claims_type": "glob",
    "user_claim": "sub"
}
EOF
```
This creates an authorization rule (a "role") named `gh-actions-role` and defines exactly **who** is allowed to use the `terraform-policy` we just created.
* **`token_policies`**: Anyone who assumes this role gets the `terraform-policy` (so they can generate AWS credentials).
* **`bound_audiences`**: Ensures the token was specifically intended for your GitHub account.
* **`ttl`**: The Vault token generated will automatically expire after 1 hour setup for your CI/CD job.
* **`bound_claims`**: **This is the most critical security boundary.** It checks the `sub` (subject) claim of the token provided by GitHub. It ensures that Vault will **only** accept authentication requests that originate specifically from your repository (`atelanuj/DevSecOps_end_to_end`). The `*` at the end means it will accept runs from any branch or tag in that repository. 