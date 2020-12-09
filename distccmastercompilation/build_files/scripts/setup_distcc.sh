#!/bin/bash
pacman -Syu --needed --noconfirm autoconf automake binutils bison fakeroot file findutils  flex  gawk  gcc gettext  grep  groff  gzip  libtool m4  make  pacman patch  pkgconf sed sudo texinfo which cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm gxmessage kdialog fluidsynth sdl sdl2 extra/glu f2fs-tools xz qemu-arch-extra distcc git rsync  cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm ccache gxmessage kdialog fluidsynth sdl sdl2 glu

echo "192.168.1.183/4 192.168.1.184/4" > /etc/distcc/hosts

COMPILERS_TO_REPLACE=$(ls /usr/lib/distcc/ | grep -v ccache )
COMPILERS_TO_REPLACE=" cc c++"

for bin in ; do
  rm /usr/lib/distcc/
done

  # Create distcc wrapper
echo "#!/usr/bin/env bash" > /usr/lib/distcc/distccwrapper
echo "export CCACHE_PREFIX=distcc" >> /usr/lib/distcc/distccwrapper
echo "export PATH=/usr/lib/ccache/:$PATH" >> /usr/lib/distcc/distccwrapper
echo "PATH=/usr/bin:$PATH /usr/lib/ccache/$(basename ${0}) $@" >> /usr/lib/distcc/distccwrapper

chmod +x /usr/lib/distcc/distccwrapper

# Create distcc wrapper
for bin in ; do
    ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/
done

mkdir -p /usr/lib/ccache/

for bin in ; do
    ln -s /usr/bin/ccache  /usr/lib/ccache/${bin}
done

export DISTCC_HOSTS="192.168.1.183/4 192.168.1.184/4"
export CCACHE_DIR=/root/.ccache
export PATH="/usr/lib/distcc/:$PATH"