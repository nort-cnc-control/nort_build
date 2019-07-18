#!/bin/bash

PREFIX=${PREFIX-"$HOME/.local/"}
THREADS=${THREADS-"-j4"}

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TARGETS="cnccontrol_rt"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

if [ ! -d "build_host" ]
then
	mkdir "build_host"
fi

echo "Arch: test"
echo

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
	cmake "../../$module" -DBUILD_TYPE="test"
	make $THREADS

	cd ../..
	echo
done

