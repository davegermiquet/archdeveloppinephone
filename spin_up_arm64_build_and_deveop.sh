# EXAMPLE OF PACKAGES TO INSTALL FOR Zandronum
# Change for packages or your particular system environment for cpus and hosts

export ENV_PACKAGES="autoconf automake binutils bison fakeroot file findutils  flex  gawk  gcc gettext  grep  groff  gzip  libtool m4  make  pacman patch  pkgconf sed sudo texinfo which cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm gxmessage kdialog fluidsynth sdl sdl2 extra/glu f2fs-tools"
export ENV_NUM_OF_CPUS=6
export ENV_DISTCC_HOSTS="192.168.1.183/4 192.168.1.184/4"
export ARCH_IMAGE="archlinux-pinephone-20201204.img.xz"

mkdir tmp
cat << END > tmp/environment.func
function setup_distcc() {
  echo "$ENV_DISTCC_HOSTS" > /etc/distcc/hosts
  if [ -z \$(find . -maxdepth 1 -name "configure.ac") ]; then
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    dpkg-reconfigure distcc
    COMPILERS_TO_REPLACE=\$(ls /usr/lib/distcc/ | grep -v ccache )
    COMPILERS_TO_REPLACE="${COMPILERS_TO_REPLACE} cc c++"
    
    for bin in ${COMPILERS_TO_REPLACE}; do
      rm /usr/lib/distcc/${bin};
    done

      # Create distcc wrapper
    echo "#!/usr/bin/env bash" > /usr/lib/distcc/distccwrapper
    echo "export CCACHE_PREFIX=distcc" >> /usr/lib/distcc/distccwrapper
    echo "export PATH=/usr/lib/ccache/:\$PATH" >> /usr/lib/distcc/distccwrapper
    echo "PATH=/usr/bin:\$PATH /usr/lib/ccache/\$(basename \${0}) \$@" >> /usr/lib/distcc/distccwrapper
    
    chmod +x /usr/lib/distcc/distccwrapper

    # Create distcc wrapper
    for bin in ${COMPILERS_TO_REPLACE}; do
        ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/${bin}
    done
    
    mkdir -p /usr/lib/ccache/
    
    for bin in ${COMPILERS_TO_REPLACE}; do
        ln -s /usr/bin/ccache  /usr/lib/ccache/\${bin}
    done
    
    export DISTCC_HOSTS="$ENV_DISTCC_HOSTS"
    export CCACHE_DIR=/root/.ccache
    export PATH="/usr/lib/distcc/:\$PATH"
  fi
}
END

cat << EOF > Dockerfile
FROM archlinux:base-devel
ARG ARG_PACKAGES
ARG ARG_DISTHOSTS
ARG NUM_OF_CPUS=3
ARG PKG_BUILD_LOCATION
ARG ARG_DOWNLOAD_ARCH_IMAGE="https://github.com/dreemurrs-embedded/Pine64-Arch/releases/download/20201204/archlinux-pinephone-20201204.img.xz"
ENV ENV_NUM_OF_CPUS=${ARG_NUM_OF_CPUS}
ENV ENV_PACKAGES=$ARG_PACKAGES
ENV ENV_DISTCC_HOSTS=$ARG_DISTHOSTS
ENV HOME=$PACKAGE_BUILD_LOCATION
ENV DOWNLOAD_ARCH_IMAGE=$ARG_DOWNLOAD_IMAGE

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


COPY build_files /tmp/dir_pkg_build
COPY tmp/environment.func /tmp/dir_pkg_build/environment.func
RUN ls /tmp/dir_pkg_build
ENTRYPOINT /tmp/dir_pkg_build/mount_image_and_compile.sh
EOF


docker build . -t distcompile
docker stop distcompile;docker rm distcompile;
docker run  -a STDIN -a STDOUT -i --privileged=true --name distcompile -t distcompile /bin/bash
losetup -D 

