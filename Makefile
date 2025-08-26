.PHONY: all init plan deploy destroy lint \
        infra-init infra-plan infra-apply infra-destroy \
        apps-init apps-plan apps-apply apps-destroy

ENV ?= dev

all: deploy

### -------- INFRA -------- ###
infra-init:
	cd infra && tofu init

infra-plan: infra-init
	cd infra && tofu plan -var-file=environments/$(ENV).tfvars

infra-apply: infra-plan
	cd infra && tofu apply -var-file=environments/$(ENV).tfvars -auto-approve

infra-destroy:
	cd infra && tofu destroy -var-file=environments/$(ENV).tfvars -auto-approve

### -------- APPS -------- ###
apps-init: infra-apply
	cd apps && tofu init

apps-plan: apps-init
	cd apps && tofu plan -var-file=environments/$(ENV).tfvars

apps-apply: apps-plan
	cd apps && tofu apply -var-file=environments/$(ENV).tfvars -auto-approve

apps-destroy:
	cd apps && tofu destroy -var-file=environments/$(ENV).tfvars -auto-approve

### -------- COMBINED -------- ###
init: infra-init apps-init

plan: infra-plan apps-plan

deploy: infra-apply apps-apply

# Destroy apps first, then infra
destroy: apps-destroy infra-destroy

lint:
	tofu fmt -write=true -recursive
