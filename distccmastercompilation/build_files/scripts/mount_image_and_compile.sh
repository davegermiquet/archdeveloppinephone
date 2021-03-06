#!/usr/bin/env bash

if [ ! -e /tmp/modified_image/tmp/setup/finished ] ; then
sudo mknod -m 0660 "/tmp/archimage-docker-loop0" b 7 101

cd /tmp/setup/

sudo /tmp/setup/scripts/download_image.sh

sudo losetup -P /tmp/archimage-docker-loop0 /tmp/setup/image/pinephonearch.img
sudo /tmp/setup/scripts/createnode.sh

sudo mkdir -p /tmp/image_attached/
sudo mkdir -p /tmp/modified_image/

sudo mount /tmp/archimage-docker-loop0p1 /tmp/image_attached
sudo rsync -avh /tmp/image_attached/ /tmp/modified_image/
sudo cp /usr/bin/qemu-aarch64-static /tmp/modified_image/usr/bin
sudo mkdir -p /tmp/modified_image/tmp/setup/scripts

sudo mount -t proc /proc /tmp/modified_image/proc
sudo mount --rbind /sys /tmp/modified_image/sys
sudo mount --rbind /dev /tmp/modified_image/dev
sudo mount --rbind /run /tmp/modified_image/run

# Setup Done All Above is only done once Refresh Files


sudo cp /tmp/setup/scripts/setup_distcc.sh /tmp/modified_image/tmp/setup/scripts/

# Bug with QEMU and fakeroot :(

sudo cp /tmp/setup/scripts/testbuild.sh /tmp/modified_image/tmp/setup/scripts/

# Everything below is for your stuff in PKGBUILD

sudo mkdir -p /tmp/modified_image/tmp/setup/patches/
sudo cp /etc/resolv.conf /tmp/modified_image/etc/resolv.conf

sudo chroot /tmp/modified_image sh -c 'cd /tmp/setup/; \
scripts/setup_distcc.sh;\
scripts/testbuild.sh ;\
echo "root ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers ;\
echo "alarm ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers ;\
chown -c root:root /etc/sudoers ;\
chmod -c 0440 /etc/sudoers;\
chown -R alarm /tmp/setup;\
cat /tmp/setup/PKGBUILD;\
echo finished > /tmp/setup/finished'
fi

sudo mount -t proc /proc /tmp/modified_image/proc
sudo mount --rbind /sys /tmp/modified_image/sys
sudo mount --rbind /dev /tmp/modified_image/dev
sudo mount --rbind /run /tmp/modified_image/run
sudo cp /tmp/setup/patches/* /tmp/modified_image/tmp/setup/patches/
sudo cp /tmp/setup/PKGBUILD /tmp/modified_image/tmp/setup/

sudo chroot /tmp/modified_image sh -c 'cd /tmp/setup/; \
chown -R alarm /tmp/setup;\
sudo -u alarm  PATH=$PATH:/usr/lib/distcc:/usr/bin:/usr/sbin:/bin:/sbin \
makepkg -s --noconfirm'



# Release files are located below








