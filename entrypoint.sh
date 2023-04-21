#!/bin/sh
set -e

# Get env vars in the Dockerfile to show up in the SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

echo "apt-get updating ..."
apt-get -y update

echo "Starting SSH ..."
sshd start

echo "Starting nginx ..."
nginx -g 'daemon off;'