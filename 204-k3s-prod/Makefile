ifndef INFRA_SSH_USER
$(error INFRA_SSH_USER is not set; source your Bitwarden env note first)
endif

ifndef K3S_PROD_HOST
$(error K3S_PROD_HOST is not set; source your Bitwarden env note first)
endif

HOST = $(K3S_PROD_HOST)
SSH_PATH = $(INFRA_SSH_USER)@$(HOST)

# Server setup
up:
	ssh $(SSH_PATH) "curl -sfL https://get.k3s.io | sh -"

pull-config:
	ssh $(SSH_PATH) "sudo cat /etc/rancher/k3s/k3s.yaml | sed 's/127.0.0.1/$(HOST)/g'" > ~/.config/kube/prod

init:
	ssh $(SSH_PATH) "sudo apt-get install -y qemu-guest-agent avahi-daemon && sudo systemctl enable --now qemu-guest-agent && printf '%s\n' 'net.ipv4.ip_forward=1' 'net.ipv6.conf.all.forwarding=1' 'net.ipv4.conf.all.rp_filter=0' 'net.ipv4.conf.default.rp_filter=0' 'net.ipv4.conf.all.src_valid_mark=1' | sudo tee /etc/sysctl.d/99-tailscale.conf >/dev/null && sudo sysctl --system"

shell:
	ssh $(SSH_PATH)

secrets:
	kubectl get ns media >/dev/null 2>&1 || kubectl create ns media
	kubectl get ns gluetun >/dev/null 2>&1 || kubectl create ns gluetun
	kubectl get ns vpn >/dev/null 2>&1 || kubectl create ns vpn
	kubectl get ns searxng >/dev/null 2>&1 || kubectl create ns searxng
	kubectl get ns activepieces >/dev/null 2>&1 || kubectl create ns activepieces
	kubectl get ns tailscale >/dev/null 2>&1 || kubectl create ns tailscale
	kubectl get ns cloudflare-ddns >/dev/null 2>&1 || kubectl create ns cloudflare-ddns
	: "$${TRANSMISSION_SYNOLOGY_PASSWORD:?TRANSMISSION_SYNOLOGY_PASSWORD is not set}"
	: "$${TRANSMISSION_PROTONVPN_KEY:?TRANSMISSION_PROTONVPN_KEY is not set}"
	: "$${CLOUDFLARE_DDNS_KEY:?CLOUDFLARE_DDNS_KEY is not set}"
	: "$${PROTONVPN_SCRAPING_KEY:?PROTONVPN_SCRAPING_KEY is not set}"
	: "$${TS_AUTHKEY:?TS_AUTHKEY is not set}"
	kubectl -n media create secret generic smb-creds \
		--from-literal=username="transmission" \
		--from-literal=password="$$TRANSMISSION_SYNOLOGY_PASSWORD" \
		--dry-run=client -o yaml | kubectl apply -f -
	kubectl -n media create secret generic gluetun-secret \
		--from-literal=WIREGUARD_PRIVATE_KEY="$$TRANSMISSION_PROTONVPN_KEY" \
		--dry-run=client -o yaml | kubectl apply -f -
	kubectl -n cert-manager create secret generic cloudflare-api-token-secret \
	  --from-literal=api-token="$$CLOUDFLARE_DDNS_KEY" \
	  --dry-run=client -o yaml | kubectl apply -f -
	kubectl -n cloudflare-ddns create secret generic cloudflare-ddns \
	  --from-literal=API_KEY="$$CLOUDFLARE_DDNS_KEY" \
	  --dry-run=client -o yaml | kubectl apply -f -
	kubectl -n gluetun create secret generic gluetun-secret \
		--from-literal=WIREGUARD_PRIVATE_KEY="$$PROTONVPN_SCRAPING_KEY" \
		--dry-run=client -o yaml | kubectl apply -f -
	kubectl -n searxng get secret searxng-secret >/dev/null 2>&1 || \
		kubectl -n searxng create secret generic searxng-secret \
			--from-literal=SECRET_KEY="$$(openssl rand -hex 32)"
	kubectl -n activepieces get secret activepieces-secret >/dev/null 2>&1 || \
		kubectl -n activepieces create secret generic activepieces-secret \
			--from-literal=POSTGRES_PASSWORD="$$(openssl rand -hex 32)" \
			--from-literal=AP_ENCRYPTION_KEY="$$(openssl rand -hex 16)" \
			--from-literal=AP_JWT_SECRET="$$(openssl rand -hex 32)"
	kubectl -n tailscale create secret generic tailscale-auth \
		--from-literal=TS_AUTHKEY="$$TS_AUTHKEY" \
		--dry-run=client -o yaml | kubectl apply -f -

bootstrap:
	flux bootstrap git --url=https://github.com/nzagorsky/infra.git --branch=master --path=204-k3s-prod

cluster-vars:
	: "$${BASE_DOMAIN:?BASE_DOMAIN is not set}"
	: "$${ACME_EMAIL:?ACME_EMAIL is not set}"
	kubectl -n flux-system create configmap cluster-vars \
		--from-literal=BASE_DOMAIN="$$BASE_DOMAIN" \
		--from-literal=ACME_EMAIL="$$ACME_EMAIL" \
		--dry-run=client -o yaml | kubectl apply -f -

status:
	flux get all

reconcile:
	kubectl apply -f flux-system/gotk-sync.yaml
	flux reconcile source git flux-system
	flux reconcile kustomization flux-system --with-source

check:
	flux check --pre
