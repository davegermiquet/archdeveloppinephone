pkgname=Zandronum
pkgver=3.1
pkgrel=1
pkgdesc='Zandronum Doom Like Game'
url=https://github.com/ptitSeb/zandronum
arch=('arm64')
license=('Sleepycat License')

build() {
   git clone https://github.com/ptitSeb/zandronum.git
   cd zandronum
   mkdir build
   cd build
   cmake .. -DCMAKE_BUILD_TYPE=Release -DSERVERONLY=OFF -DRELEASE_WITH_DEBUG_FILE=OFF
   make
}

package() {
   cd zandronum/build
   make install
}