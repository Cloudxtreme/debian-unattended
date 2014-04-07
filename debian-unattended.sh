sudo virt-install --connect qemu:///system \
--location=http://ftp.ro.debian.org/debian/dists/stable/main/installer-amd64 \
--initrd-inject=/home/bud/code/debian-unattended/preseed.cfg \
--extra-args="auto console=tty0 console=ttyS0,115200 DEBIAN_FRONTEND=text" \
--name d-i --ram=512 \
--disk=path=/home/bud/code/debian-unattended/debian-stable.qcow2,bus=virtio,driver_name=qemu,driver_type=qcow2 \
--graphics none \
--serial file,path=/tmp/debian-stable-preseed \
--noreboot \
--network=network=default,model=virtio
