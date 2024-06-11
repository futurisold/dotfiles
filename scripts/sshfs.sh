#!/bin/bash

# Script that mounts a remote directory using sshfs
# Usage: sshfs.sh <remote-host> <remote-dir> <local-dir>
#        sshfs.sh research-ec2 /mnt ~/.sshfs/research-ec2

if [ $# -ne 3 ]; then
    echo "Usage: sshfs.sh <remote-host> <remote-dir> <local-dir>"
    exit 1
fi

if [ ! -d "$3" ]; then
    mkdir -p "$3"
fi

arguments=(
    "reconnect"
    "auto_cache"
    "Ciphers=aes128-ctr"
    "ConnectTimeout=5"
    "cache_timeout=60"
    "cache=yes"
)

options=$(printf ",%s" "${arguments[@]}")
options=${options:1}

sshfs "$1:$2" "$3" -o "$options"
