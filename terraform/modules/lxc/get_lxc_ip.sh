#!/bin/bash
set -x

# Read input from Terraform's external data source
read -r input

# Debug: Print the input received
echo "Received input: $input" >&2

# Parse input JSON
CTID=$(echo "$input" | jq -r '.ctid')
PVE_USER=$(echo "$input" | jq -r '.pve_user')
PVE_PRIVATE_KEY=$(echo "$input" | jq -r '.pve_private_key')
PVE_HOST=$(echo "$input" | jq -r '.pve_host')

# Debug: Print parsed values
echo "CTID: $CTID, PVE_USER: $PVE_USER, PVE_HOST: $PVE_HOST" >&2

# wait for container to obtain an IP address
while true; do
  IP=$(ssh -o StrictHostKeyChecking=no -i "$PVE_PRIVATE_KEY" "$PVE_USER@$PVE_HOST" "pct exec $CTID -- hostname -I" | awk '{print $1}')
  if [ -n "$IP" ]; then
    break
  fi
  sleep 5
done

# Check if IP was retrieved
if [ -z "$IP" ]; then
  echo "Failed to retrieve IP address for container $CTID" >&2
  exit 1
fi

# Output as JSON
jq -n --arg ip "$IP" '{"ip":$ip}'
