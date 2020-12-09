#!/bin/bash

sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101
cd /tmp/dir_pkg_build/imagetomount
sudo losetup -P /tmp/archimage-docker-loop0  /tmp/dir_pkg_build/imagetomount/archlinux-pinephone-20201204.img
sudo /tmp/dir_pkg_build/createnode.sh
mkdir -p /media/archimage
sudo mount /tmp/archimage-docker-loop0p1 /media/archimage
sudo cp /usr/bin/qemu-aarch64-static /media/archimage/usr/bin/
sudo mkdir /media/archimage/tmp/dir_pkg_build
sudo rsync /tmp/dir_pkg_build /media/archimage/tmp/dir_pkg_build
sudo chown -R aurpackageadd /media/archimage/tmp/dir_pkg_build
sudo chown -R aurpackageadd /tmp/dir_pkg_build
sudo -u aurpackageadd sh -c "chroot /media/archimage/usr/bin/;source /tmp/environment.func;cd /tmp/dir_pkg_build;setup_distcc;makepkg -s --noconfirm"



