You will need the following applications/package installed on DOCKERS host system:

qemu qemu-user-static


How to start up a distcc client (on computational servers):

Make sure docker and docker-compose is installed:

Git clone this folder

then typethis

> docker-compose -f docker-compose-slave.yml up -d

Want to build a package:

(Read the vars in dockerfile you can only change DISTCC_HOSTS for now at the moment i still have to make the others configurable)

Put the arch image in the following folder (ARCH IMAGE PLEASE): build_files/image  (this one example: https://github.com/dreemurrs-embedded/Pine64-Arch/releases)

named: pinephonearch.img

(Example is the following):

Edit the PKGBUILD file in the build_files folder and make your download/build instuctions in makepkg format (as mentioned here)

https://wiki.archlinux.org/index.php/makepkg

When building this, will only build once the package is made, you can run it everytime, and it won't reinitialize unless necessary.
If all else fails delete image and try again, because sometimes a compilation won't reconfigure (IE CMAKE)

Put all your file thats needed in the build_files folder, or in that folder its a shared volumes

Run This:

> docker-compose -f docker-compose-master.yml up 


I make no guaranetees. but this shouldn't break anything. The content used here is AS-IS

Credits so far:
@PixelPaintBrush
@JustinL (And other people in #PinePhone the best place to be!)
@Armen138

Just ask to be put on here actually , you know who talks in #PinePhone the open source #PinePhone community rocks!

To reset and delete the container:

docker-compose -f docker-compose-slave.yml rm


To rebuild the container:

docker-compose -f docker-compose-slave.yml build





