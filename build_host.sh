#!/bin/bash

PREFIX=${PREFIX-"$HOME/.local/"}
THREADS=${THREADS-"-j4"}

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MODULES="crc32 rdp serial-datagram"
UTILS="rdpos_terminal"
TARGETS="cnccontrol_rt"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

if [ ! -d "build_host" ]
then
	mkdir "build_host"
fi

echo "Arch: test"
echo
for module in $MODULES $UTILS
do
	echo "Building module: " $module
	echo
	dir="build_host/$module"
	if [ ! -d "$dir" ]
	then
		mkdir "$dir" 
	fi
	cd "$dir"

	rm -r *
	cmake "../../$module" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="$PREFIX" -DBUILD_TESTING=ON
	make $THREADS
	make install

	cd ../..
	echo
done

for module in $TARGETS
do
	echo "Building target: " $module
	echo
	dir="build_host/$module"
	if [ ! -d "$dir" ]
	then
		mkdir "$dir" 
	fi
	cd "$dir"

	rm -r *
	cmake "../../$module" -DBUILD_TYPE="test" -DCMAKE_INSTALL_PREFIX="$PREFIX"
	make $THREADS

	cd ../..
	echo
done

