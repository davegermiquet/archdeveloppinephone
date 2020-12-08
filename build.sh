#!/bin/bash
mkdir -p /tmp/dev/
cat << EOF > /tmp/dev/Dockerfile
FROM archlinux:base-devel
ARG PACKAGES="distccd-alarm-armv8 "

# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash

RUN /usr/bin/pacman -Syu $PACKAGES 

RUN bash -c 'echo -n "Removing existing distcc symlinks... " && \
	rm -f /usr/lib/distcc/${ARCH}-gcc ; \
    rm -f /usr/lib/distcc/${ARCH}-g++ ;\
    rm -f /usr/lib/distcc/cc  ; \
    rm -f s/usr/lib/distcc/c++; \
	echo -n "Creating new symlinks for ${ARCH}..." && \
	ln -s /usr/bin/distcc /usr/lib/distcc/${ARCH}-gcc && \
	ln -s /usr/bin/distcc /usr/lib/distcc/${ARCH}-g++ &&\
    ln -s /usr/bin/distcc /usr/lib/distcc/cc  && \
    ln -s /usr/bin/distcc /usr/lib/distcc/c++'
    
# This is the operations port
EXPOSE 3632
# This is the statistics port
EXPOSE 3633
EXPOSE 3636
RUN touch /var/log/distcd.log
RUN chown distccd /var/log/distcd.log
USER distccd
ENTRYPOINT /usr/bin/distccd --no-detach --log-level debug --log-file=/var/log/distcd.log  --allow-private  --daemon $OPTIONS
EOF
cd /tmp/dev
docker build . -t distccarch