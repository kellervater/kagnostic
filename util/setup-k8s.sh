ANSIBLE_CONFIG=$(dirname "$0")/ansible.cfg ansible-playbook playbooks/setup-k8s.yaml -i inventory/kagnostic.yaml $1