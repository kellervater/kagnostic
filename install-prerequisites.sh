#!/bin/bash

# Install all Ansible dependencies required to run the playbooks (but not Ansible itself)
# Imports gpg key into keyring
# Installs Ansible collections and roles used in playbooks
set -e

# download latest stable sops
SOPS_VERSION=3.7.1
wget https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb -O sops.deb

sudo wget https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_linux_amd64 -O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
sudo pip install --upgrade requests jinja2
sudo apt install -y zip jq expect ./sops.deb
export GPG_TTY=$(tty) # to enable password input on decryption

# Import gpg keys in local keyring.
# this enables you to re-encrypt secrets located in (ansible/secret)
$(dirname "$0")/sops/import-keys.sh
$(dirname "$0")/ansible/install-roles.sh

rm -rf sops.deb