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

# Rename <sys/types.h>'s old size_t to segsz_t and update all uses (following 4.4BSD)
for h in proc.h types.h user.h vmparam.h
do
	chmod u+w $PREFIX/unixpc/include/sys/$h
	ed $PREFIX/unixpc/include/sys/$h << 'EOF' > /dev/null 2>&1
	g/size_t/s//segsz_t/g
	w
	q
EOF
done
# Add new ISO/POSIX-conforming definition of size_t to <sys/types.h>
ed $PREFIX/unixpc/include/sys/types.h << 'EOF' > /dev/null 2>&1
$i
#undef __need_size_t
#define __need_size_t
#include <stddef.h>

.
w
q
EOF

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
$PREFIX/bin/unixpc-gcc -c -O2 -Wall raise.c -o ../build/raise.o
objs=raise.o

cd ../libgcc
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/divsi3.o divsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/modsi3.o modsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/mulsi3.o mulsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/udivsi3.o udivsi3.c
$PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/umodsi3.o umodsi3.c

# Conversion operators
for i in floatsidf floatsisf fixdfsi fixsfsi truncdfsf2 extendsfdf2 ; do
    $PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -Dop=$i -o ../build/$i.o convert.c
    objs="$objs $i.o"
done

# Arithmetic operators
for op in add sub div mul; do
    $PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -Dop=$op -o ../build/${op}df3.o df3.c
    objs="$objs ${op}df3.o"
done

# Misc operators
for i in subsf3; do
    $PREFIX/bin/unixpc-gcc -c -O3 -Os -fomit-frame-pointer -o ../build/$i.o $i.c
    objs="$objs $i.o"
done

cd ../build
$PREFIX/bin/unixpc-ar r $PREFIX/lib/gcc-lib/unixpc/3.3.6/libgcc.a divsi3.o modsi3.o mulsi3.o udivsi3.o umodsi3.o $objs

# Convert $PREFIX/unixpc/lib/shlib.ifile to a form usable by binutils ld, replacing exit()
# Note this does not patch functions in /lib/shlib that directly link to the old version of exit(),
# but AFAIK all such cases are functions that are part of the UnixPC-specific "libtam".
# In the unlikely case that both atexit() and libtam functions are needed, use static linking.
fgrep '=' $PREFIX/unixpc/lib/shlib.ifile | fgrep -v user_mem | (
    sed 's/^exit /_cuexit /' |
    sed 's/^\s*\(.*\)\s*=\s*\(.*\);/.equ \1, \2\n.globl \1/' ;
    echo ".section .lib"
)  >shlib.ifile.s
$PREFIX/bin/unixpc-as -o $PREFIX/unixpc/lib/shlib.ifile.o shlib.ifile.s

cd ..

$PREFIX/bin/unixpc-gcc -o build/hello test/hello.c -O
$PREFIX/bin/unixpc-gcc -o build/testexit test/testexit.c -O
$PREFIX/bin/unixpc-gcc -o build/testmain test/testmain.c -O
$PREFIX/bin/unixpc-gcc -s -shlib -o build/hello-shlib test/hello.c -O
$PREFIX/bin/unixpc-gcc -s -shlib -o build/testexit-shlib test/testexit.c -O
$PREFIX/bin/unixpc-gcc -s -shlib -o build/testmain-shlib test/testmain.c -O
