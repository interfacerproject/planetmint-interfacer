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
