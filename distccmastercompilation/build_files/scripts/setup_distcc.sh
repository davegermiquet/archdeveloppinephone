#!/bin/bash
pacman -Syu --needed --noconfirm base-devel mercurial autoconf automake binutils bison fakeroot file findutils  flex  gawk  gcc gettext  grep  groff  gzip  libtool m4  make  pacman patch pkgconf sed sudo texinfo which cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm gxmessage fluidsynth sdl sdl2 extra/glu f2fs-tools xz distcc git rsync  cmake sdl2 glew-wayland glew1.10 libglvnd openssl sqlite3 gtk2 zlib nasm ccache gxmessage kdialog fluidsynth qemu-arch-extra sdl sdl2 patch glu
COMPILERS_TO_REPLACE=$(ls /usr/lib/distcc/ | grep -v distcc)

for bin in ${COMPILERS_TO_REPLACE}; do
  rm /usr/lib/distcc/${bin}
done


for bin in ${COMPILERS_TO_REPLACE}; do
  rm /usr/lib/distcc/bin/${bin}
done

  # Create distcc wrapper
echo "#!/usr/sbin/env bash" > /usr/lib/distcc/distccwrapper
echo "export CCACHE_PREFIX=distcc" >> /usr/lib/distcc/distccwrapper
echo "export PATH=/usr/lib/ccache/bin:\$PATH" >> /usr/lib/distcc/distccwrapper
echo "export PATH=/usr/lib/distcc:\$PATH" >> /usr/lib/distcc/distccwrapper
echo "PATH=/usr/bin:$PATH /usr/lib/ccache/bin/\$(basename \${0}) \$@" >> /usr/lib/distcc/distccwrapper

chmod +x /usr/lib/distcc/distccwrapper


for bin in ${COMPILERS_TO_REPLACE}; do
  ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/bin/${bin}
done

for bin in ${COMPILERS_TO_REPLACE}; do
  ln -s /usr/lib/distcc/distccwrapper /usr/lib/distcc/${bin}
done


for bin in ${COMPILERS_TO_REPLACE}; do
  rm /usr/lib/ccache/bin/${bin}
done

for bin in ${COMPILERS_TO_REPLACE}; do
    ln -s /usr/bin/ccache  /usr/lib/ccache/bin/${bin}
done

export DISTCC_HOSTS="192.168.1.183/4 192.168.1.184/4"
export PATH="/usr/lib/distcc/:$PATH"

