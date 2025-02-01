# How to connect Ansible to worker node

## Install Ansible
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

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
