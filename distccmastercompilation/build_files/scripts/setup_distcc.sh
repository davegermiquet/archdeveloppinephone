#!/usr/bin/env bash

pacman -Syu --needed --noconfirm base-devel rsync distcc sudo git po4a cmake automake autoconf
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

