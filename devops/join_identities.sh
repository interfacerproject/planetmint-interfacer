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

## Old just generate validators for genesis
# jq -s '[to_entries | .[] | {"address": .value.address, "pub_key": .value.pub_key, "power": "10", "name": ("Node"+(.key | tostring))}]' identities/*

rm -f identities/persistent_peers
for f in identities/*/; do
  filename=`echo $f | cut -f2 -d/`
  hostname=`echo $filename | cut -f1 -d=`
  name=`echo $filename | cut -f2 -d=`
  key=`cat $f/key`
  id=`cat $f/id`
  echo "{\"name\": \"$name\", \"key\": $key}" >$f/namedkey
  echo -n "$id@$hostname:26656,">>identities/persistent_peers
done

jq -s '[.[] | {"address": .key.address, "pub_key": .key.pub_key, "power": "10", "name": .name}]' identities/*/namedkey >identities/validators

echo "{\"validators\": `cat identities/validators`, \"persistent_peers\":\"`cat identities/persistent_peers`\"}"
