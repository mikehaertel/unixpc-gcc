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

# Some texinfo files in the build are incompatible with modern makeinfo.
# Hide modern makeinfo by putting a fake version first in $PATH.
# Reported by Arnold Robbins and Alain Knaff; hack suggested by Arnold Robbins.
mkdir bin
cat << 'EOF' > bin/makeinfo
#!/bin/sh
exit 0
EOF
chmod +x bin/makeinfo
PATH=`pwd`/bin:$PATH
export PATH

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
$PREFIX/bin/unixpc-gcc -c -O2 -Wall raise.c -o ../build/raise.o

cd ../libgcc
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/divsi3.o divsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/modsi3.o modsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/mulsi3.o mulsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/udivsi3.o udivsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/umodsi3.o umodsi3.c


cd ../build
$PREFIX/bin/unixpc-ar r $PREFIX/unixpc/lib/libc.a atexit.o exit.o _exit.o raise.o
$PREFIX/bin/unixpc-ar r $PREFIX/lib/gcc-lib/unixpc/3.3.6/libgcc.a divsi3.o modsi3.o mulsi3.o udivsi3.o umodsi3.o

cd ..

$PREFIX/bin/unixpc-gcc -o build/hello test/hello.c -O
$PREFIX/bin/unixpc-gcc -o build/testexit test/testexit.c -O
$PREFIX/bin/unixpc-gcc -o build/testmain test/testmain.c -O
$PREFIX/bin/unixpc-gcc -DNATIVE -o build/testmath test/testmath.c -O
