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
make
cd doc
po4a -k 0 --rm-backups --variable "srcdir=../doc/" po4a/po4a.cfg
make install
install -dm755 "$pkgdir"/etc/ld.so.conf.d/

