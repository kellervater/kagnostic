ANSIBLE_CONFIG=$(dirname "$0")/ansible.cfg ansible-playbook setup-netmaker.yaml -i inventory/kagnostic.yaml $2