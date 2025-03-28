#!/bin/bash

# Navigate to the directory where the playbooks are located
cd "$(dirname "$0")"

# Default playbook is install
PLAYBOOK="install_packages.yml"

# Check for the -u flag
while getopts "u" opt; do
  case $opt in
    u)
      PLAYBOOK="uninstall_packages.yml"
      ;;
    *)
      echo "Usage: $0 [-u]"
      exit 1
      ;;
  esac
done

# Disable host key checking
export ANSIBLE_HOST_KEY_CHECKING=False

# Run the selected playbook with the private key and extra vars from the environment variable
ansible-playbook -i inventory.ini --private-key="$ANSIBLE_PRIVATE_KEY" --extra-vars "$EXTRA_VARS" $PLAYBOOK
