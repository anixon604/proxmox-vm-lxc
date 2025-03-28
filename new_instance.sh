#!/bin/bash

# This file takes in arguments <type> <name> and will copy new folder from basic_lxc or basic_vm
# and will rename the folder to <name> and will rename the example.tfvars file to variables.tfvars

type=$1
name=$2

if [ "$type" != "lxc" ] && [ "$type" != "vm" ]; then
    echo "Invalid type. Please use 'lxc' or 'vm'."
    exit 1
fi

if [ -z "$name" ]; then
    echo "Name is required."
    exit 1
fi

if [ "$type" == "lxc" ]; then
    cp -r terraform/templates/basic_lxc terraform/$name
    mv terraform/$name/example.tfvars terraform/$name/terraform.tfvars
    # replace the name in variables.tfvars file with the new name
    sed -i '' "s/^hostname[[:space:]]*=.*/hostname = \"$name\"/" terraform/$name/terraform.tfvars
elif [ "$type" == "vm" ]; then
    cp -r terraform/templates/basic_vm terraform/$name
    mv terraform/$name/example.tfvars terraform/$name/terraform.tfvars
    # replace the name in variables.tfvars file with the new name
    sed -i '' "s/^name[[:space:]]*=.*/name = \"$name\"/" terraform/$name/terraform.tfvars
fi

# inside the new folder, run terraform init
cd terraform/$name
terraform init

