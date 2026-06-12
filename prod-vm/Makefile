# Use > as the recipe prefix (so you can copy/paste without tab headaches).
.RECIPEPREFIX = >
.PHONY: init plan up connect stop start down ip

init:
> terraform init

plan:
> terraform plan

up:
> terraform apply -auto-approve

# SSH in over Bastion using the connect_hint output (Standard SKU + tunneling).
connect:
> bash -c "$$(terraform output -raw connect_hint)"

ip:
> terraform output -raw vm_private_ip

# Deallocate to stop compute charges (Bastion still bills — use `down` to stop all).
stop:
> az vm deallocate -g "$$(terraform output -raw resource_group)" -n vm-$${PREFIX:-azprod}

start:
> az vm start -g "$$(terraform output -raw resource_group)" -n vm-$${PREFIX:-azprod}

# Tear everything down (VM AND Bastion AND its public IP). Do this when finished.
down:
> terraform destroy -auto-approve
