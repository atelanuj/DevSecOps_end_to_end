# 🚀 Vault + AWS EC2 (Assume Role) Setup Guide

## 📌 Overview

This guide explains how to configure **HashiCorp Vault with AWS** to generate **temporary credentials** using IAM Role assumption and use them to create EC2 instances securely.

---

## 🟢 Step 1: Create IAM User (vault-user)

* Create an IAM user named: `vault-user`
* Generate **Access Key & Secret Key**
* Save these credentials securely (used in Vault configuration)

---

## 🟢 Step 2: Create IAM Role

* Create a role named: `EC2-Instance-Role`
* This role will be assumed by Vault to create EC2 instances

---

## 🟢 Step 3: Configure Trust Policy

Attach the following **trust policy** to the role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::194477973016:user/vault-user"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

---

## 🟢 Step 4: Enable AWS Secrets Engine in Vault

```bash
vault secrets enable aws
```

---

## 🟢 Step 5: Configure AWS Credentials in Vault

```bash
vault write aws/config/root \
    access_key=<AWS_ACCESS_KEY> \
    secret_key=<AWS_SECRET_KEY> \
    region=ap-south-1
```

---

## 🟢 Step 6: Create Vault Role for EC2

```bash
vault write aws/roles/ec2-role \
  credential_type=assumed_role \
  role_arns=arn:aws:iam::194477973016:role/EC2-Instance-Role
```

---

## 🟢 Step 7: Verify Vault Role

```bash
vault read aws/roles/ec2-role
```

Expected output should include:

* `credential_type: assumed_role`
* `role_arns: [EC2-Instance-Role]`

---

## 🟢 Step 8: Generate Temporary AWS Credentials

```bash
vault read aws/creds/ec2-role
```

---

## 🔐 Output

Vault will return:

* `access_key`
* `secret_key`
* `security_token`

👉 These are **temporary credentials** (auto-expire)

---

## 🚀 Final Flow

```text
Vault → AssumeRole (EC2-Instance-Role) → AWS STS → Temporary Credentials → EC2 Creation
```

---

## ⚠️ Best Practices

* Avoid long-lived AWS credentials
* Use IAM roles with least privilege
* Rotate Vault root credentials periodically
* Prefer role-based authentication over IAM users in production

---

## 🎯 Summary

* IAM User (`vault-user`) → authenticates Vault
* IAM Role (`EC2-Instance-Role`) → grants EC2 permissions
* Vault → generates short-lived AWS credentials securely

---

🔥 You now have a secure **Vault + AWS integration using AssumeRole**
