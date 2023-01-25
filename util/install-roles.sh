# role for installing docker and certbot
ansible-galaxy install geerlingguy.docker,6.0.4 --force
# role for installing kubectl
ansible-galaxy install andrewrothstein.kubectl,v1.2.5 --force
# install tools to manage authorized_keys
ansible-galaxy collection install ansible.posix --force