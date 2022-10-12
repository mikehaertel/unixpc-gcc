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

Non-default linker modes, like -n and -N, may appear to work, but don't do
what they're supposed to.

The UnixPC shared library may be used by including "-shlib" in the compiler
command line for linking.

In order to support GNU-style static constructors and destructors,
this port provides its own implementations of the C library functions
`atexit()`, `exit()`, and `_exit()`, and installs these in its private
copy of libc.a.

When the shared library is linked, its exit() entry point is replaced by
a shim that calls registered atexits before jumping to the real exit().
However, there are a few functions within the shared library itself that
directly link to the "real" exit().  If these functions are used,
registered atexits may not be called.

Fortunately, all shlib functions that directly call exit() are part of
the very UnixPC-specific "libtam" ("terminal access methods") library,
not the ordinary C library.  Therefore programs that use only ordinary
libc functions will not have this problem.

Workaround: In the unlikely case that you need both atexit() and libtam
functions in the same program, link statically.

The atexit() support is not yet included in the profiling version of the
C library, so this cross-compiler doesn't support profiling (yet).

# Future plans (maybe)

* add atexit() support to the profiling C library

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

The build script and patches are my own work together with contributions
by Alain Knaff.
