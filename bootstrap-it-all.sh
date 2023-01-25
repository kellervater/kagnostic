# fail on error
set -e 

# Install everything required for correct Ansible execution (except Ansible itself)
./util/install-prerequisites.sh

# Create a Netmaker instance
./util/setup-netmaker.sh

# Create a Network
./util/setup-networking.sh

# Create the Cluster
./util/setup-k8s.sh
