#!/usr/bin/env bash
export pkgname=fakeroot-tcp
export _pkgname=fakeroot
export pkgver=1.25.3
export pkgrel=1
curl http://ftp.debian.org/debian/pool/main/f/${_pkgname}/${_pkgname}_${pkgver}.orig.tar.gz -o fakeroot.tar.gz
tar -zxvf fakeroot.tar.gz
cd ${_pkgname}-${pkgver}
  ./bootstrap
  ./configure --prefix=/usr \
    --libdir=/usr/lib/libfakeroot \
    --disable-static \
    --with-ipc=tcp
PATH=$PATH:/usr/lib/distcc:/usr/bin:/usr/sbin:/bin:/sbin
make
make install
sh -c "ls -la /usr/bin/fakeroot;ls -la /usr/bin/fakeroot-tcp;exit 0"



