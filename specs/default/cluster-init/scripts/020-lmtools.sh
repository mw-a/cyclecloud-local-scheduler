#!/bin/sh

set -e

a=$(mktemp)
curl -o "$a" https://damassets.autodesk.net/content/dam/autodesk/www/files/linux/nlm11.19.9.0_ipv4_ipv6_linux64.tar.gz
echo "5cd50f617f4befebf1b4dab0a5c6f82d3dfd030a003cbc0d9521153031cb16c6 $a" | sha256sum -c

d=$(mktemp -d)
tar -xf "$a" -C "$d"

d2=$(mktemp -d)
pushd "$d"
rpm2cpio "$d"/*.rpm | cpio -id

mkdir /opt/lmtools
cp "$(find . -name lmutil | head -1)" /opt/lmtools/lmutil
chown 755 /opt/lmtools/lmutil
ln -sfn /opt/lmtools/lmutil /opt/lmtools/lmstat
ln -sfn /opt/lmtools/lmutil /opt/lmtools/lmver
ln -sfn /opt/lmtools/lmutil /opt/lmtools/lmver

popd
rm -rf "$d" "$d2" "$a"
