#!/usr/bin/env bash
image=debian-11
datacenter=nbg1-dc3
srvtype=cx11

hcloud server create --name "$1" --image "${image}" --datacenter ${datacenter} --type ${srvtype} --ssh-key ./sshkey.pub

