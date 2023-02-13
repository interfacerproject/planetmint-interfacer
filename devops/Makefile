# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2022-2023 Dyne.org foundation <foundation@dyne.org>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
