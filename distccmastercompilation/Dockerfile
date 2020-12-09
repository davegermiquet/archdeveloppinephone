FROM archlinux:base-devel
# ARG_PACKAGES,ENV_PACKAGES For Packages, needed for Arch Image
# ARG_DISTHOSTS, ENV_DISTCC_HOSTS For Hosts for it to connect to
# ARG NUM_OF_CPUS,  ENV_NUM_OF_CPUS For Changing the CPUS to use for DistCC clients

ARG ARG_PACKAGES
ARG ARG_DISTHOSTS
ARG NUM_OF_CPUS=3


ENV ENV_NUM_OF_CPUS=${ARG_NUM_OF_CPUS}
ENV ENV_PACKAGES=$ARG_PACKAGES
ENV ENV_DISTCC_HOSTS=$ARG_DISTHOSTS


# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash

RUN pacman -Syu --noconfirm --needed xz qemu-arch-extra distcc git rsync $ENV_PACKAGES
RUN useradd -m -g users -G wheel,storage,power -s /bin/bash  aurpackageadd
RUN passwd -d aurpackageadd
RUN echo "%wheel      ALL=(ALL) ALL" > /etc/sudoers
RUN chown -c root:root /etc/sudoers
RUN chmod -c 0440 /etc/sudoers
USER aurpackageadd

RUN mkdir -p /tmp/addPackage
WORKDIR /tmp/addPackage
RUN git clone https://aur.archlinux.org/distccd-alarm.git
WORKDIR /tmp/addPackage/distccd-alarm
RUN sh -c "makepkg -si --noconfirm"

RUN mkdir -p /tmp/addPackage
WORKDIR /tmp/addPackage
RUN git clone https://aur.archlinux.org/binfmt-qemu-static.git
WORKDIR /tmp/addPackage/binfmt-qemu-static
RUN sh -c "makepkg -si --noconfirm"

RUN mkdir -p /tmp/addPackage
WORKDIR /tmp/addPackage
RUN git clone https://aur.archlinux.org/qemu-user-static-bin.git
WORKDIR /tmp/addPackage/qemu-user-static-bin
RUN sh -c "makepkg -si --noconfirm"

VOLUME ["/tmp/setup"]
ENTRYPOINT /tmp/setup/scripts/mount_image_and_compile.sh