#!/bin/bash

sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101

cd /tmp/setup/

sudo losetup -P /tmp/archimage-docker-loop0  /tmp/setup/image/pinephonearch.img
sudo /tmp/setup/scripts/createnode.sh

sudo mkdir -p /tmp/image_attached
sudo mkdir -p /tmp/modified_image

sudo mount /tmp/archimage-docker-loop0p1 /tmp/image_attached	
sudo rsync -avh /tmp/image_attached/* /tmp/modified_image/

sudo cp /usr/bin/qemu-aarch64-static /tmp/modified_image/usr/bin/

sudo mkdir -p /tmp/modified_image/tmp/setup/scripts

sudo cp /tmp/setup/scripts/setup_distcc.sh /tmp/modified_image/tmp/setup/scripts/

sudo cp /tmp/setup/PKGBUILD /tmp/modified_image/tmp/setup/

sudo mount -t proc /proc /tmp/modified_image/proc
sudo mount --rbind /sys /tmp/modified_image/sys
sudo mount --rbind /dev /tmp/modified_image/dev
sudo mount --rbind /run /tmp/modified_image/run

sudo cp /etc/resolv.conf /tmp/modified_image/etc/resolv.conf

sudo chroot /tmp/modified_image/ sh -c 'cd /tmp/setup/scripts/; \
./setup_distcc.sh; \
sudo -u alarm "export DISTCC_HOSTS=\"192.168.1.183/4 192.168.1.184/4\"; \
export CCACHE_DIR=/root/.ccache;export PATH=\"/usr/lib/distcc/:$PATH\"; \
makepkg -s --noconfirm"'







