#!/bin/bash

sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101
cd /tmp/dir_pkg_build/imagetomount
sudo losetup -P /tmp/archimage-docker-loop0  /tmp/dir_pkg_build/imagetomount/archlinux-pinephone-20201204.img
sudo /tmp/dir_pkg_build/createnode.sh
mkdir -p /tmp/mountedarchimage
sudo mount /tmp/archimage-docker-loop0p1 /tmp/mountedarchimage
sudo cp /usr/bin/qemu-aarch64-static /tmp/mountedarchimage/usr/bin/
sudo mkdir -p /tmp/mountedarchimage/tmp/dir_pkg_build
sudo rsync /tmp/dir_pkg_build /tmp/mountedarchimage/tmp/dir_pkg_build
sudo chown -R aurpackageadd /tmp/dir_pkg_build
sudo chown -R aurpackageadd /tmp/mountedarchimage/tmp/dir_pkg_build
sudo -u aurpackageadd sh -c "chroot /tmp/mountedarchimage /usr/bin/bash;source /tmp/environment.func;cd /tmp/dir_pkg_build;setup_distcc;makepkg -s --noconfirm"



