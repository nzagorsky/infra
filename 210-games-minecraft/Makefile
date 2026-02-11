ifndef INFRA_SSH_USER
$(error INFRA_SSH_USER is not set; source your Bitwarden env note first)
endif

ifndef MINECRAFT_HOST
$(error MINECRAFT_HOST is not set; source your Bitwarden env note first)
endif

SSH_PATH = $(INFRA_SSH_USER)@$(MINECRAFT_HOST)
export DOCKER_HOST := ssh://$(SSH_PATH)
SHELL := /bin/bash

up:
	docker compose up -d --remove-orphans

logs:
	ssh $(SSH_PATH) docker logs -f minecraft
	
shell:
	ssh $(SSH_PATH)

down:
	docker compose down

init:
	ssh $(SSH_PATH) 'sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y docker.io qemu-guest-agent avahi-daemon && sudo gpasswd -a nzagorsky docker && sudo systemctl enable --now qemu-guest-agent'
