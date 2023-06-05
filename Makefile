
pxe_etc:=`pwd`
DOCKER_TAG:=latest

DOCKER?=docker
DOCKER_COMPOSE?=docker compose 
DOCKER_IMAGE?=chao123/netboot-server
SAMBA_DOCKER_IMAGE?=dreamcat4/samba
DOCKER_REGISTRY?=ghcr.io
DOCKER_REGISTRY_USER?=sio

.PHONY: build
build: ## Build pxe docker image
	cd dnsmasq_tftp && $(DOCKER) build --pull -t "$(DOCKER_IMAGE):$(DOCKER_TAG)" .
	cd samba && $(DOCKER) build  -t "$(SAMBA_DOCKER_IMAGE):$(DOCKER_TAG)" .

.PHONY: pxe-sh
ssh: ## Run pxe and shell in this container
	@docker run --rm \
		--privileged \
		-v $(pxe_etc):/root/\
		-it \
		$(DOCKER_IMAGE)${DOCKER_TAG}

.PHONY: serve-start
serve-start: serve-pxe serve-http ## Start both http server docker.

.PHONY: serve-restart
serve-restart:serve-stop serve  ## Restart servers.

.PHONY: serve-stop
serve-stop: ## Stop servers.
	-cd dnsmasq_tftp && $(DOCKER_COMPOSE) down -t 0
	-cd ipxe && $(DOCKER_COMPOSE) down -t 0

.PHONY: serve-pxe
serve-pxe:## Start pxe docker.
	cd dnsmasq_tftp && $(DOCKER_COMPOSE) up &

.PHONY: serve-http
serve-http:## Start http server docker.
	cd ipxe && $(DOCKER_COMPOSE) up &

.PHONY: serve-samba
serve-samba: ## Start samba server docker.
	cd samba && $(DOCKER_COMPOSE) up &

.PHONY: help
help: ## Show this help menu.
	@grep -E '^[a-zA-Z1-9_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
