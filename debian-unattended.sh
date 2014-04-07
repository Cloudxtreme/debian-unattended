#!/bin/bash

# Install Prerequisites
sudo apt-get install virtinst -y

# Apply vanilla preseed config if $1
# TO DO: Check for file existence
FLAVOR=$1

if test -n "$FLAVOR" ; then 
    CONFIG=$FLAVOR
else
    CONFIG=vanilla
fi

cp preseed/$CONFIG /tmp/preseed.cfg

# Create QCOW2 Image
# TO DO: Image size
IMAGE=$CONFIG-debian-stable.qcow2
qemu-img create -f qcow2 $IMAGE 100G

# Get pwd
PWD=`pwd`

# virsh start network default
sudo virsh net-start default

# virt-install Debian
sudo virt-install --connect qemu:///system \
--location=http://http.debian.net/debian/dists/stable/main/installer-amd64 \
--initrd-inject=/tmp/preseed.cfg \
--extra-args="auto console=tty0 console=ttyS0,115200 DEBIAN_FRONTEND=text" \
--name d-i --ram=1024 \
--disk=path=$PWD/$IMAGE,bus=virtio,driver_name=qemu,driver_type=qcow2 \
--graphics none \
--serial file,path=/tmp/debian-unattended \
--noreboot \
--wait 10 \
--network=network=default,model=virtio

# Remove leftovers
rm /tmp/preseed.cfg /tmp/debian-unattended
