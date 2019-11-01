#!/bin/bash
set -x

ISO_URL="https://github.com/rancher/k3os/releases/download/v0.5.0/k3os-arm64.iso"

cat <<EOF > /tmp/config.yaml
k3os:
  datasource: aws
  data_sources:
  - aws
  modules:
  - kvm
  - nvme
  ntp_servers:
  - 0.us.pool.ntp.org
  - 1.us.pool.ntp.org
EOF

apt-get update -y

apt-get install -y dosfstools parted

curl -o /tmp/install.sh https://raw.githubusercontent.com/rancher/k3os/master/install.sh

bash -x /tmp/install.sh --takeover --debug --tty ttyS0 --config /tmp/config.yaml --no-format $(findmnt / -o SOURCE -n) "${ISO_URL}"

sync

sleep 10

echo 'Setting this host as k3os master' > /tmp/dan.log
