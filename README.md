# Proxmox Terraform Configuration

This repository contains Terraform and Ansible configurations for managing Proxmox VE infrastructure.

## Project Structure

```
proxmox/
├── terraform/
│ └── templates/
│     └── basic_lxc/
│     └── basic_vm/
└── ansible/
    └── roles/
```

## Prerequisites

- Terraform >= 1.0.0
- Proxmox VE server with PM_API_TOKEN_ID and PM_API_TOKEN_SECRET environment variables set
- Proxmox API token with appropriate permissions
- Ansible >= 2.10 (for installing packages in LXC containers)

## Setup

1. Clone this repository
2. Create a new instance
   ```
   ./new_instance.sh lxc <name>
   ./new_instance.sh vm <name>
   ```
3. Goto `terraform/<name>` and fill in the variables in the `terraform.tfvars` file
5. Run `terraform plan`
6. Run `terraform apply`

## Security Notes

- Never commit `terraform.tfvars` to version control
- Keep your API tokens secure
- Use appropriate permissions for your API tokens

## License

MIT License
