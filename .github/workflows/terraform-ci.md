This markdown file contains a series of **HashiCorp Vault** commands designed to set up a secure, passwordless authentication trust between **GitHub Actions** and your Vault server using **OIDC (OpenID Connect)** / **JWT (JSON Web Token)**.

The ultimate goal of this setup is to allow your GitHub Actions workflows to securely ask Vault for temporary, short-lived AWS credentials to execute Terraform code, without you having to hardcode any long-lived secret keys into GitHub.

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