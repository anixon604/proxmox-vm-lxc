#!/bin/bash

# Cleans terraform state files
find . -name "*.tfstate" -delete
find . -name "*.tfstate.backup" -delete
find . -name "*.tfvars.json" -delete
find . -name "*.tfvars.json.backup" -delete
find . -type d -name ".terraform" -exec rm -rf {} +
find . -name ".terraform.lock.hcl" -delete

