#!/bin/bash

ARCH=${ARCH-"stm32f103"}
THREADS=${THREADS-"-j4"}

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TOOLCHAIN_FILE="$ROOT/toolchains/$ARCH.cmake"

if [ ! -d "build_target" ]
then
	mkdir "build_target"
fi

PREFIX=${PREFIX-"$ROOT/build_target/toolchain/"}
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"




MODULES="crc32 rdp serial-datagram"
TARGETS="cnccontrol_rt"

echo "Arch: " $ARCH
echo
for module in $MODULES
do
	echo "Building module: " $module
	echo
	dir="build_target/$module"
	if [ ! -d "$dir" ]
	then
		mkdir "$dir" 
	fi
	cd "$dir"

	rm -r *
	cmake "../../$module" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" 
	make $THREADS
	make install

	cd ../..
	echo
done

for module in $TARGETS
do
	echo "Building target: " $module
	echo
	dir="build_target/$module"
	if [ ! -d "$dir" ]
	then
		mkdir "$dir" 
	fi
	cd "$dir"

	rm -r *
	cmake "../../$module" -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" -DBUILD_TYPE="$ARCH"
	make $THREADS

	cd ../..
	echo
done

