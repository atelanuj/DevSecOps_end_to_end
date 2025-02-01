# How to connect Ansible to worker node

## Create a `hosts` file
- add below line in it.
```
[myhost]
<Machine_public_IP> ansible_ssh_user=ubuntu ansible_private_key_file=<private ssh key path>
```

## test the connection
```
ansible all -m ping
```
