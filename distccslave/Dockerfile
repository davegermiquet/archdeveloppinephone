FROM archlinux:base-devel

# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

# Prerequisites for adding the repositories
# Remove the apt cache to keep layer-size small.
#!/usr/bin/env bash
RUN pacman -Syu --noconfirm distcc git aarch64-linux-gnu-gcc awk

RUN useradd -r -s /usr/bin/nologin aurpackageadd
RUN usermod --append --groups wheel aurpackageadd
RUN passwd -d aurpackageadd
RUN echo "%wheel      ALL=(ALL) ALL" > /etc/sudoers
RUN chown -c root:root /etc/sudoers
RUN chmod -c 0440 /etc/sudoers
RUN chmod 755 /var/log
USER aurpackageadd


RUN mkdir -p /tmp/addPackage
WORKDIR /tmp/addPackage
RUN git clone https://aur.archlinux.org/distccd-alarm.git
WORKDIR /tmp/addPackage/distccd-alarm
RUN sh -c "makepkg -si --noconfirm"

USER root
RUN touch /var/log/distccd.log 
RUN chown distcc /var/log/distccd.log 
RUN sh -c 'cd /usr/bin;for file in /usr/bin/aarch64*; do ln -s ${file} aarch64-unknown-linux-gnu-`echo "$file" | cut -d'-' --output-delimiter='-' -f4-`;done'
RUN sh -c 'cd /usr/bin;mv  cc oldcc'
RUN sh -c 'cd /usr/bin;mv  c++ oldcc++'
RUN sh -c 'cd /usr/bin;ln -s /usr/bin/aarch64-unknown-linux-gnu-c++ c++'
RUN sh -c 'cd /usr/bin;ln -s /usr/bin/aarch64-unknown-linux-gnu-gcc cc'
USER distcc
# This is the operations port
EXPOSE 3632
# This is the statistics port
EXPOSE 3633
EXPOSE 3634
EXPOSE 3635
EXPOSE 3636

ENTRYPOINT /usr/bin/distccd --no-detach --log-level debug --log-file=/var/log/distccd.log  --allow-private  --daemon $OPTIONS
