export ENV_PACKAGES="base-devel cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm gxmessage kdialog fluidsynth sdl sdl2 extra/glu"
export ENV_NUM_OF_CPUS=6
export ENV_DISTCC_HOSTS="192.168.1.183/4 192.168.1.184/4"

cat << EOF > /tmp/dev/Dockerfile
FROM archlinux:base-devel
ARG ARG_PACKAGES
ARG ARG_DISTHOSTS
ARG NUM_OF_CPUS=3
ENV ENV_NUM_OF_CPUS=${ARG_NUM_OF_CPUS}
ENV ENV_PACKAGES=$ARG_PACKAGES
ENV ENV_DISTCC_HOSTS=$ARG_DISTHOSTS

# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash
RUN pacman -Syu --noconfirm distcc git $ENV_PACKAGES


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

ENTRYPOINT /usr/bin/distccd  --log-level debug --log-file=/var/log/distcd.log  --allow-private  --daemon $OPTIONS
EOF


RUN mkdir -p /tmp/deploypackage
COPY ./PKGBUILD /tmp/deploypackage
RUN cd /tmp/deploypackage
RUN makepkg -s

cd /tmp/dev
docker build . -t distcompile
docker stop distcompile;docker rm distcompile;docker run -d  -p3633:3633 -p3636:3636 -p3635:3635 -p3632:3632 -p3634:3634 -p3633:3633 -eOPTIONS="--allow 0.0.0.0/0" --name distcompile -dit distcompile /bin/bash
