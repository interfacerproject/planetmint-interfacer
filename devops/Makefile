
ANSIPLAY = ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory hosts.toml --ssh-common-args '-o StrictHostKeyChecking=accept-new -o IdentitiesOnly=yes' --private-key ./sshkey $(1)

ssh: HOST ?= node-0
ssh: LOGIN ?= root
ssh: ## open an ssh session on HOST=name (see make server-list)
	@ssh $(shell hcloud server list -o noheader -o columns=name,ipv4 | awk '/${HOST} /{print $$2}') \
	 -l ${LOGIN} -i ./sshkey -o StrictHostKeyChecking=accept-new -o IdentitiesOnly=yes


install: inventory
install: ## Install planetmint, tarantool and tendermint
	$(call ANSIPLAY, install-planetmint.yml)

config-tendermint: inventory
config-tendermint: ## Collect identities and upload genesis file
	$(call ANSIPLAY, config-tendermint.yml)

start: inventory
start: ## Start planetmint and tendermint
	$(call ANSIPLAY, start-planetmint.yml)

drop: inventory
drop: ## Delete all data in planetmint
	$(call ANSIPLAY, drop-planetmint.yml)

stop: inventory
stop: ## Stop planetmint and tendermint
	$(call ANSIPLAY, stop-planetmint.yml)

inventory:
inventory: ## create an ansible inventory (used internally)
	@echo "[planetmint]" > hosts.toml
	@hcloud server list -o noheader -o columns=name,ipv4 \
	| awk '//{printf "%s name=%s\n", $$2, $$1}' >> hosts.toml
