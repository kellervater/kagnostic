# kagnostic
This repository contains Ansible playbooks for a cloud agnostic k8s setup using Netmaker and Rancher Kubernetes Engine.



# Prerequisistes
* Access to a DNS provider for your `example.com` url. You must be able to create DNS entries which will point to your computing instances.
* At least 4 computing instances, each with a static public ip address. It doesn't matter if or in which cloud they are located. Just mind the [Firewall Settings](#firewall-settings)! Also, you need ssh access to each instance, since Ansible relies on ssh here.
* A local linux distribution (on Windows you can use a WSL2 Ubuntu distro)
* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (tested with 6.7.0) on your local machine. 

# Firewall Settings
If in the cloud(s) or not, you will have to adjust your firewall settings for each computing instance accordingly. 
Here's an example list of how to configure firewalls in general on different cloud providers:
* [GCP](https://cloud.google.com/vpc/docs/using-firewalls?hl=en) -> Create some Firewall Rules with a network tag and add this respective tag to your instance
* [Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/nsg-quickstart-portal#create-a-network-security-group) -> tbd....
* [AWS](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) -> create a security group with all the rules required and assign it to your instance
* [UFW](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server) -> if you are on bare metal, UFW may be the easiest way to go. (Though I am using it myself it feels like it fails some time... but I wasn't able to pinpoint my problems with it yet). 

Now, let's get down to business!
## Netmaker
Open ports 443 (and optionally 80) and at least one UDP port starting at `51821`. 
You'll need 1 UDP port per netmaker network you intend to have. 
For reference see [Netmaker Documentation](https://docs.netmaker.org/quick-start.html#open-firewall).
> **Security Advice**: I would highly recommend opening port 443(and 80) only to IPs you know instead of all (0.0.0.0/0). A password leak may cause serios issues if the firewall doesn't block bad actors here. For example: One could just silently create an external client which may intrude via the Netmaker VPN which may be considered as secure in our setup. TODO: verify which ips need access. At least it's all the IPs in the inventory file and your local one ;-)
## Nodes 
* 443 for all (0.0.0.0/0) -> since you most likely want to expose some kind of https Service to the world
* 22 at least for your personal/company IP (required for all Ansible setup operations)
* TODO: lookup if udp ports are required on nodes??
* All TCP traffic from Netmaker Network (e.g. `network.address_range` in [inventory file](inventory/kagnostic.yaml)). Will look something like `Anywhere on nm-{{ network.id }}  ALLOW   {{ network.address_range }}`). If you want to make it more secure you can pinpoint it down to each port used between kubernetes nodes and to external clients (like your devs)

# Usage
to be continued...


# Open Topics
* [ ] Test with nodes farther away from each other to check if cluster behaves correctly
* [ ] Bonus: Explain on how to create VMs (including firewall settings) on different cloud providers
* [ ] DNS Load Balancing for HA setups
* [ ] It would be cleaner to integrate netmaker related templates directly from the makers instead of customizing them into jinja files. Have to talk to @afeiszli to align here.