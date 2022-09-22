This is rudimentary semi-ancient GCC cross compiler for the AT&T Unix PC
(a.k.a. the PC 7300, a.k.a. the 3B1).

# To install:

	PREFIX=/some/path ./build-install.sh

# To run:

	$PREFIX/bin/unixpc-gcc filename.c

# To clean up this directory after installing:

	./clean.sh

# To remove everything installed:

	rm -fr $PREFIX

# Caveats

This has been only lightly tested.

Floating point arithmetic support is TBD.

There is, as yet, no support for the Unix PC shared library.

Non-default linker modes, like -n and -N, may appear to work, but don't do
what they're supposed to.

In order to support GNU-style static constructors and destructors,
this port provides its own implementations of the C library functions
`atexit()`, `exit()`, and `_exit()`, and installs these in its private
copy of libc.a.

These new functions aren't implemented yet for the profiling version of
the C library, nor for the shared library /lib/shlib.  So currently this
cross compiler only creates statically linked, non-profiled programs.

# Future plans (maybe)

* add libgcc runtime support for floating point arithmetic

* add atexit() support to the profiling C library

* add atexit() support for the Unix PC's shared library /lib/shlib
  (this will require installation of a new /lib/shlib on the 3b1)

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
