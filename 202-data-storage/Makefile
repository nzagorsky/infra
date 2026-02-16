ifndef INFRA_SSH_USER
$(error INFRA_SSH_USER is not set; source your Bitwarden env note first)
endif

ifndef DATA_STORAGE_HOST
$(error DATA_STORAGE_HOST is not set; source your Bitwarden env note first)
endif

HOST = $(DATA_STORAGE_HOST)
SSH_PATH = $(INFRA_SSH_USER)@$(HOST)

export DOCKER_HOST := ssh://$(SSH_PATH)

.PHONY: shell init nfs


up:
	docker-compose up -d --remove-orphans

exec:
	ssh -t $(SSH_PATH) docker exec -it cloudflare_ddns sh

logs:
	docker-compose logs

shell:
	ssh $(SSH_PATH)

init:
	ssh $(SSH_PATH) 'sudo apt-get update -y && sudo apt-get install -y qemu-guest-agent avahi-daemon docker.io && sudo systemctl enable --now qemu-guest-agent && sudo gpasswd -a nzagorsky docker'


nfs:
	ssh $(SSH_PATH)  < setup_nfs.sh
