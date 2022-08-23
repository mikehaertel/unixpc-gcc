This is rudimentary semi-ancient GCC cross compiler for the AT&T Unix PC
(a.k.a. the PC 7300, a.k.a. the 3B1).

# To install:

On a 32-bit system:

	PREFIX=/some/path ./build-install.sh

On a 64-bit system, make sure `libc6-dev-i386` is installed, then:

	PREFIX=/some/path CC='gcc -m32' ./build-install.sh

# To run:

	$PREFIX/bin/unixpc-gcc filename.c

# To clean up this directory after installing:

	./clean.sh

# To remove everything installed:

	rm -fr $PREFIX

# Caveats

This has been tested only with a simple "hello, world" program (included, and
built by the build script).  The resulting `hello` executable was copied into
a Unix 3.51m installation in the FreeBee emulator, where it indeed printed
"hello, world".

This must be built in 32-bit mode.  It doesn't work when built to run
in 64-bit mode, due to super-sketchy code in both binutils and gcc.
My dim recollection of those ancient days is that binutils and gcc support
for cross-compiling really only worked well between machines of the same
word size.

There is, as yet, no support for the Unix PC shared library.

Non-default linker modes, like -n and -N, may appear to work, but don't do
what they're supposed to.

In order to support GNU-style static constructors and destructors,
this port bundles its own version of the C library runtime startup
crt0.o, which includes homebrew implementations of atexit() and exit().
This isn't implemented yet for the other versions of C library startup
(profiling and shared library variants of C start up).  The profiling
version should be fairly straightforward, but a shared library version
may require replacing the shared library itself.

# Future plans (maybe)

* add support for profiling C library startup

* add support for the Unix PC's shared library

* cross-compile the compiler itself for a Unix PC native version of GCC
  (this might require moving to an even older version of GCC to fit the
  Unix PC's available address space)

* support some ancient dialect of C++ (enough to build ancient groff?)
  (I actually had groff running on my Unix PC 30 years ago, using
  GCC/G++ 1.42, so it *is* possible!)

# Provenance

The binutils and gcc distribution tar files are original FSF releases,
recompressed with `xz`.

The header and library files in `dist/unixpc-xenv.tar.xz` are copied
from a Unix 3.51m installation, with the development tools installed,
running under the FreeBee emulator.

The patches are all my own.
