# Proxmox Terraform Configuration

This repository contains Terraform configurations for managing Proxmox VE infrastructure.

## Project Structure

```
.
├── modules/
│   ├── proxmox-lxc/         # Reusable LXC container module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── proxmox-vm/          # Reusable VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── ubuntu-lxc/      # Example LXC deployment
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── terraform.tfvars.example
│   │   └── ubuntu-vm/       # Example VM deployment
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── terraform.tfvars.example
│   └── prod/                # Production environment (similar structure)
├── templates/
│   └── cloud-init/          # Cloud-init templates
│       └── ubuntu.cloud-config.tftpl
├── .gitignore
└── README.md
```

## Prerequisites

- Terraform >= 1.0.0
- Proxmox VE server
- Proxmox API token with appropriate permissions

## Setup

1. Clone this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your Proxmox credentials
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned changes:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Variables

- `proxmox_api_url`: The URL of your Proxmox API
- `proxmox_api_token_id`: Your Proxmox API token ID
- `proxmox_api_token_secret`: Your Proxmox API token secret

## Security Notes

- Never commit `terraform.tfvars` to version control
- Keep your API tokens secure
- Use appropriate permissions for your API tokens

## License

MIT License
