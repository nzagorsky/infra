ifndef INFRA_SSH_USER
$(error INFRA_SSH_USER is not set; source your Bitwarden env note first)
endif

ifndef DATA_DB_HOST
$(error DATA_DB_HOST is not set; source your Bitwarden env note first)
endif

SSH_PATH = $(INFRA_SSH_USER)@$(DATA_DB_HOST)
export DOCKER_HOST := ssh://$(SSH_PATH)


up:
	docker compose up -d --remove-orphans

logs:
	ssh $(SSH_PATH) docker logs -f postgres

shell:
	ssh $(SSH_PATH)

down:
	docker compose down

init:
	ssh $(SSH_PATH) 'sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y docker.io qemu-guest-agent avahi-daemon && sudo gpasswd -a nzagorsky docker'
