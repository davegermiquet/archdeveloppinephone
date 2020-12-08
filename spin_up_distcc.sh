#!/bin/bash
mkdir -p /tmp/dev/
cat << EOF > /tmp/dev/Dockerfile
FROM archlinux:base-devel
ARG PACKAGES="ARMv8"

# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash
RUN pacman -Syu --noconfirm distcc git


RUN useradd -r -s /usr/bin/nologin aurpackageadd
RUN usermod --append --groups wheel aurpackageadd
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

# This is the operations port
EXPOSE 3632
# This is the statistics port
EXPOSE 3633
EXPOSE 3634
EXPOSE 3635
EXPOSE 3636

ENTRYPOINT /usr/bin/distccd --no-detach --log-level debug --log-file=/var/log/distcd.log  --allow-private  --daemon $OPTIONS
EOF
cd /tmp/dev
docker build . -t distccarch
docker stop distccarch;docker rm distccarch;docker run -d  -p3636:3636 -p3635:3635 -p3632:3632 -p3634:3634 -p3633:3633 -eOPTIONS="--allow 0.0.0.0/0" --name distccarch -dit distccarch /bin/bash
