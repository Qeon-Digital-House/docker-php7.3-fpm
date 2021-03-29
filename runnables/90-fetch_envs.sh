#!/bin/bash
# 90-fetch_envs.sh
# fetch all required environments and put it to working directory
# requires ETCD_SERVER, ENV_PATH, ENV_PREFIX

[ -z "$ETCD_SERVER" ] && { >&2 echo "No etcd endpoint specified. Set etcd endpoints with ETCD_SERVER environment variable."; exit 1; };
[ -z "$ENV_PATH" ] && { >&2 echo "No env file path set. Set env file path with ENV_PATH environment variable."; exit 1; };
[ -z "$ENV_PREFIX" ] && { >&2 echo "No env prefix set. Set env prefix path with ENV_PREFIX environment variable."; exit 1; };

# check if we have any etcd data to avoid bad env file.
ENV_SIZE=$(ETCDCTL_API=3 etcdctl --endpoints "$ETCD_SERVER" get --prefix "$ENV_PREFIX" | wc -l)

if [ "$ENV_SIZE" -eq "0" ]; then
    >&2 echo "Can't get env data from etcd. Skipping."
    exit 1
fi

# really fetch the entries from etcd.
ETCDCTL_API=3 etcdctl -w simple --endpoints "$ETCD_SERVER" get --prefix "$ENV_PREFIX" | while read -r KEY; do read -r VALUE; echo ${KEY##*/}=\"${VALUE}\"; done > "$ENV_PATH"
