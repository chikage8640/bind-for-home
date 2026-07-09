#!/bin/bash

# 引数にDDNSで更新されてるドメインを指定すると、そっからの通信を振り分けるようにBINDの設定を書き換える
IP=$(dig +short $1)
if [ -z "$IP" ]; then
    echo "IP address not found for domain: $1"
    exit 1
fi

if ! grep -q "$IP" bind.conf; then
    echo "Updating BIND configuration with new IP: $IP"
    sed "s/HOME_IP_ADDR/$IP/g" bind.conf.base > bind.conf
    docker compose restart bind
fi
