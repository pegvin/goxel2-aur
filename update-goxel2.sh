#!/bin/bash

set -e

# Simple Script, Calculates The Sha512 Sums & updates the sums with version...

if [ -z "$1" ]; then
	echo "Error, Version Not Specified!"
else
	curl -L "https://github.com/pegvin/goxel2/archive/refs/tags/v$1.tar.gz" --output archive.tar.gz
	curl -L "https://github.com/goxel2/goxel2/releases/download/v$1/goxel2-x86_64.elf" --output goxel2-x86_64.elf
	curl -L "https://github.com/goxel2/goxel2/releases/download/v$1/goxel2-i686.elf" --output goxel2-i686.elf

	SHA512_SUM=`sha512sum "./archive.tar.gz" | cut -d " " -f 1`
	X86_64_SUM=`sha512sum "./goxel2-x86_64.elf" | cut -d " " -f 1`
	I686_SUM=`sha512sum "./goxel2-i686.elf" | cut -d " " -f 1`

	\cp templates/goxel2/PKGBUILD goxel2/PKGBUILD
	sed -i "s/__PACKAGE_VERSION__/$1/g" goxel2/PKGBUILD
	sed -i "s/__ARCHIVE_SHA512_SUMS__/$SHA512_SUM/g" goxel2/PKGBUILD

	cd goxel2/
	makepkg --printsrcinfo > .SRCINFO
	cd ../

	\cp templates/goxel2-bin/PKGBUILD goxel2-bin/PKGBUILD
	sed -i "s/__PACKAGE_VERSION__/$1/g" goxel2-bin/PKGBUILD
	sed -i "s/__ARCHIVE_SHA512_SUMS__/$SHA512_SUM/g" goxel2-bin/PKGBUILD
	sed -i "s/__BINARY_X86_64_SUMS__/$X86_64_SUM/g" goxel2-bin/PKGBUILD
	sed -i "s/__BINARY_I686_SUMS__/$I686_SUM/g" goxel2-bin/PKGBUILD

	cd goxel2-bin/
	makepkg --printsrcinfo > .SRCINFO
	cd ../

	rm archive.tar.gz
	rm goxel2-x86_64.elf
	rm goxel2-i686.elf
fi
