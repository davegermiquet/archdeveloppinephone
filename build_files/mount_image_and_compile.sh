#!/bin/bash

sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101
cd /tmp/dir_pkg_build/imagetomount
sudo losetup -P /tmp/archimage-docker-loop0  /tmp/dir_pkg_build/imagetomount/archlinux-pinephone-20201204.img
sudo /tmp/dir_pkg_build/createnode.sh

sudo mkdir -p /tmp/mountedarchimage
sudo mount /tmp/archimage-docker-loop0p1 /tmp/mountedarchimage
sudo mkdir /tmp/rootdrive
sudo rsync -avh /tmp/mountedarchimage/ /tmp/rootdrive/

ls -la /tmp/rootdrive

sudo cp /usr/bin/qemu-aarch64-static /tmp/rootdrive/usr/bin/
sudo mkdir -p /tmp/rootdrive/tmp/dir_pkg_build

sudo cp /tmp/dir_pkg_build/setup_distcc.sh /tmp/rootdrive/tmp/dir_pkg_build
sudo cp /tmp/dir_pkg_build/PKGBUILD /tmp/rootdrive/tmp/dir_pkg_build/

sudo mount -t proc /proc  /tmp/rootdrive/proc/
sudo mount --rbind /sys  /tmp/rootdrive/sys/
sudo mount --rbind /dev /tmp/rootdrive//dev/
sudo mount --rbind /run /tmp/rootdrive/run/
sudo cp /etc/resolv.conf /tmp/rootdrive/etc/resolv.conf

sudo chroot /tmp/rootdrive/sh -c 'cd /tmp/dir_pkg_build; \
./setup_distcc.sh; \
sudo -u alarm "export DISTCC_HOSTS=\"192.168.1.183/4 192.168.1.184/4\"; \
export CCACHE_DIR=/root/.ccache;export PATH=\"/usr/lib/distcc/:$PATH\"; \
makepkg -s --noconfirm"'







