#!/bin/bash

sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101
cd /tmp/dir_pkg_build/imagetomount
sudo losetup -P /tmp/archimage-docker-loop0  /tmp/dir_pkg_build/imagetomount/archlinux-pinephone-20201204.img\
sudo parted /tmp/archimage-docker-loop0 resizepart 1 50G

sudo /tmp/dir_pkg_build/createnode.sh
sudo resize.f2fs /tmp/archimage-docker-loop0p1

sudo mkdir -p /tmp/mountedarchimage
sudo mount /tmp/archimage-docker-loop0p1 /tmp/mountedarchimage
sudo cp /usr/bin/qemu-aarch64-static /tmp/mountedarchimage/usr/bin/
sudo mkdir -p /tmp/mountedarchimage/tmp/dir_pkg_build
sudo cp /tmp/dir_pkg_build/setup_distcc.sh /tmp/mountedarchimage/tmp/dir_pkg_build
sudo cp /tmp/dir_pkg_build/PKGBUILD /tmp/mountedarchimage/tmp/dir_pkg_build/

sudo mount -t proc /proc  /tmp/mountedarchimage/proc/
sudo mount --rbind /sys  /tmp/mountedarchimage/sys/
sudo mount --rbind /dev  /tmp/mountedarchimage/dev/
sudo mount --rbind /run /tmp/mountedarchimage/run/
sudo cp /etc/resolv.conf /tmp/mountedarchimage/etc/resolv.conf

sudo chroot /tmp/mountedarchimage sh -c 'cd /tmp/dir_pkg_build; \
./setup_distcc.sh; \
sudo -u alarm "export DISTCC_HOSTS=\"192.168.1.183/4 192.168.1.184/4\"; \
export CCACHE_DIR=/root/.ccache;export PATH=\"/usr/lib/distcc/:$PATH\"; \
makepkg -s --noconfirm"'







