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
$PREFIX/bin/unixpc-gcc -c -O2 -Wall atexit.c -o ../build/atexit.o
$PREFIX/bin/unixpc-gcc -c -O2 -Wall exit.c -o ../build/exit.o
$PREFIX/bin/unixpc-as -o ../build/_exit.o _exit.s

cd ../build
$PREFIX/bin/unixpc-ar r $PREFIX/unixpc/lib/libc.a atexit.o exit.o _exit.o

cd ..

$PREFIX/bin/unixpc-gcc -o build/hello test/hello.c -O
$PREFIX/bin/unixpc-gcc -o build/testexit test/testexit.c -O
$PREFIX/bin/unixpc-gcc -o build/testmain test/testmain.c -O
