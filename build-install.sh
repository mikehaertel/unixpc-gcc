#!/bin/sh
PREFIX=${PREFIX-/opt/unixpc}

case $PATH in
*$PREFIX/bin*)
	;;
*)
	PATH=$PATH:$PREFIX/bin
	;;
esac

set -e -x

mkdir build
cd build

mkdir -p $PREFIX/unixpc
tar -C $PREFIX/unixpc -xJf ../dist/unixpc-xenv.tar.xz

tar -xJf ../dist/binutils-2.13.2.1a.tar.xz
cd binutils-2.13.2.1
patch -p0 < ../../patch/binutils.patch
./configure --prefix=$PREFIX --target=unixpc
make && make install
cd ..

tar -xJf ../dist/gcc-3.3.6.tar.xz
cd gcc-3.3.6
patch -p0 < ../../patch/gcc.patch
./configure --enable-languages=c --enable-obsolete --prefix=$PREFIX --target=unixpc --with-gnu-as
make && make install
cd ..

cd ../lib
$PREFIX/bin/unixpc-as crt0.s -o $PREFIX/unixpc/lib/crt0.o
cd ..

$PREFIX/bin/unixpc-gcc -o hello hello.c -O -v
