#!/bin/bash

# Install all Ansible dependencies required to run the playbooks (but not Ansible itself)
# Imports gpg key into keyring
# Installs Ansible collections and roles used in playbooks
set -e

sudo pip install --upgrade jinja2
$(dirname "$0")/ansible/install-roles.sh