# Repetition helpers. Run `make` targets from this folder. See README.md.
.RECIPEPREFIX = >
RG = rg-azlab
VM = vm-azlab

up:        ## Build the exact VM from code (a couple of minutes)
> terraform init -upgrade
> terraform apply -auto-approve

plan:      ## Preview changes — read this like a receipt before applying
> terraform plan

down:      ## DESTROY everything (cheapest). Rebuild later with: make up
> terraform destroy -auto-approve

stop:      ## DEALLOCATE — keeps the VM + its data, stops compute billing
> az vm deallocate -g $(RG) -n $(VM)

start:     ## Start a deallocated VM back up (seconds)
> az vm start -g $(RG) -n $(VM)

ssh:       ## SSH in
> @eval "$$(terraform output -raw ssh)"

ip:        ## Print the public IP
> @terraform output -raw public_ip
