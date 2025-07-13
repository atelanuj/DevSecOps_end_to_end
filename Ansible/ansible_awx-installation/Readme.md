# AWX Installation Guide

This guide provides step-by-step instructions to install AWX using the AWX Operator on Kubernetes.

---

## Step 3: Install AWX Operator

1. **Create `kustomization.yaml`:**

    ```yaml
    ---
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    resources:
      - github.com/ansible/awx-operator/config/default?ref=2.19.1
    images:
      - name: quay.io/ansible/awx-operator
        newTag: 2.19.1
    namespace: awx
    ```

2. **Apply the configuration:**

    ```sh
    kubectl apply -k .
    ```

3. **Set the default namespace:**

    ```sh
    kubectl config set-context --current --namespace=awx
    ```

---

## Step 4: Install AWX

1. **Update `kustomization.yaml` resources as needed.**

2. **Create `awx-server.yaml`:**

    ```yaml
    ---
    apiVersion: awx.ansible.com/v1beta1
    kind: AWX
    metadata:
      name: awx-server
    spec:
      service_type: nodeport
    ```

3. **Edit the kustomization file** and add awx-server.yaml init
    
    ```yaml
   ---
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization
   resources:
        # Find the latest tag here: https://github.com/ansible/awx-operator/releases
        - github.com/ansible/awx-operator/config/default?ref=2.19.1
        - awx-server.yaml

   # Set the image tags to match the git version from above
   images:
        - name: quay.io/ansible/awx-operator
          newTag: 2.19.1

   # Specify a custom namespace in which to install AWX
   namespace: awx
    ```

4. **Apply the configuration:**

    ```sh
    kubectl apply -k .
    ```

5. **Check installation logs:**

    ```sh
    kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx
    ```

---

## Step 5: Enable External Access

Forward the AWX service port to access the UI externally for `LINUX` `shell`

```shell
kubectl port-forward service/awx-server-service --address 0.0.0.0 30080:80 &
```
Forward the AWX service port to access the UI externally for `WINDOWS` `Powershell`

```powershell
Start-Process "kubectl" -ArgumentList "port-forward --namespace awx service/awx-server-service --address 0.0.0.0 3008
```
---

**Note:**  
Replace versions and resource names as needed for your environment.

# Screen Shot
<img width="1397" height="929" alt="image" src="https://github.com/user-attachments/assets/6915faec-253b-48f3-82a8-b93fb3f0f398" />
<img width="1919" height="895" alt="image" src="https://github.com/user-attachments/assets/0a305f21-f9fa-4d43-a925-311c6bf2b9f9" />
