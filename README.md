# Simple-MSIL-Compiler

This is a version of the Orange C compiler that does MSIL code generation.

This is a WIP.  At present it mostly supports the C language.  

This version supports common RTL variables such as stdin, stdout, stderr, errno, and the variables used for the macros in
ctype.h.   It also supports command line arguments.
 
This version supports marshalling of function pointers.  A small helper dll called 'occmsil.dll' is involved in creating thunks for this.  occmsil is built when you build the compiler. 

Calling unprototyped functions now results in an error.

The results are undefined if you try to use some extension such as alloca.

There may be a variety of bugs.

The sources for this version build independently from the main Orange C branch, except that you may want to use the Orange C includes directory when compiling files with a compiler you build.   All sources in this package have a VS2015 community edition solution.

Run the compiler 'occil' on a simple C program (test.c is included as an example).

occil automatically loads symbols from mscorlib
------------------------------------
Additions to the language to support .net

__unmanaged is used to clarify that a pointer in a structure is a pointer to an unmanaged function.   Usually the compiler
	can figure out whether a function pointer is managed or unmanaged, but in this case the definition is ambiguous
	and it defaults to managed.
__string declare an MSiL string.  Constant strings will be loaded with the .net LDSTR instruction instead of being treated 	as C language strings.  Note that this means they are wide character strings.  You can nagitively concatenate
	strings, pass them to functions, and return them.  You could also use mscorlib functions to perform other
	functions.  The same syntax as used for 'C' language strings is used for these strings.   Usually the string usage
	can be auto detected from context, but in rare situations the compiler will consider such a string ambiguous and
	you have to cast it:   (__string)"hi"
__object declare an msil object.  Has minimal use for the moment.   If you cast to 'object' you it will box the result
__cpblk invokes the cpblk msil function.   It is invoked with arguments similar to memcpy
__initblk invokes the initblk msil function.   It is invoked with arguments similar to memset

native int is a new type to support the 'native' int size of MSIL

C++ & operator: when used on a function parameter, makes the parameter a 'ref' parameter.  No other current use is
	possible.   For example int myfunc(int &a);
C++ namespace qualifiers may be used to reference a function in a loaded assembly.  Since mscorlib is always preloaded,
	the following is always possible:   System::Console::WriteLine("hello, world!");.   It is also possible to use the
	using directive:  using namespace System;
basic types will automatically be converted to their 'boxed' type for various purposes.   For example:
	using namespace System;
	int aa = 5;
	Console::WriteLine(aa.ToString());
Instance members may also be called:   aa.ToString();
Managed arrays: when the array indexes appear before the variable name, the array is allocated as either an msil array or
	a multidimensional array of objects.   Such arrays can only be used or passed to functions; you cannot do anything
	that would be equivalent to taking the address of the related managed objects.   For example:

	int [5]aa; // managed
	int bb[5]; // standard C array
C++ constructors:   will use newobj to call a managed version of the constructor and create an object


Set the environment variable OCCIL_ROOT to the orange c path for it to find include files

e.g.

set OCCIL_ROOT=c:\orangec

------------------------------------
implementation notes:

this compiler will generate either a .EXE or .DLL file, or alternately a .il file suitable for viewing or compiling with ilasm.   Additionally, the compiler is capable of generating object files in the familiar object-file-per-module paradigm that can be linked with a linker called netlink.   This linker is also part of the package.   The compiler uses an independent library 'dotnetpelib' to create the output.

on the technical aspects, there are several MSIL limitations

1) extended precision found in 'long double' type is missing  in MSIL - 'long double' is synonomous with 'double'
2) you can't put variable length argument lists on variables which are pointers to functions and then pass them to
unmanaged code.   You can however use veriable length argument lists on pointers to functions if you keep them managed
3) initialization of static non-const variables must be done programmatically rather than 'in place' the way a normal C compiler does it - so there are initialization functions generated for each module.   This impacts startup performance.

This compiler will compile either an EXE or a DLL.  The package generally defaults to compiling everything into the unnamed MSIL namespace, however, for interoperability with C# it is necessary to wrap the code into a namespace and an outer class.  A command line switch conveniently specifies this wrapper.   

This compiler is capable of auto-detecting DLL entry points for unmanaged DLLs, so for example you can specify on the command line that the compiler should additionally import from things like kernel32.dll and/or user32.dll.   This still requires header support so that prototypes can be specified correctly however.   This compiler is designed to work with the same headers that Orange C for the x86 uses.  

This compiler is capable of importing static functions from .net assemblies.

By default the compiler automatically imports the entry points for msvcrt.dll, and the occmsil.dll used for function pointer thunking.  A .net assembly 'lsmsilcrtl' is used for runtime support - mostly it performs malloc and free in managed code and exports some functions useful for handling variable length argument lists and command lines.   MSCORLIB
is also automatically loaded and its static functions are available for use.

It is possible to have the compiler combine multiple files into a single output; in this way it performs as a psuedo-linker as well.   Simply specify all the input files on the command line.   The compiler takes wildcards on the command line so you can do something like this for example to compile all the files, linking against several WIN32 DLLs, and giving it an outer namespace and class to be able to reference from C#.   The /Wd switch means make a DLL.  /Wg means windows GUI.   /Wc (the default) means windows console.   Adding l on the end of a /W switch (e.g. /Wcl) means load
lscrtlil.dll as the unmanaged runtime, instead of msvcrt.dll.   You might want to do this to get access to C99 and C11
functions.


occil /omyoutputfile *.c /Wd /Lkernel32;user32;gdi32 /Nmynamespace.myclass

The compiler will create structures and enumerations for things found in the C code, that can be used from C#.   Unlike older versions, in this version pointers are mostly typed instead of being pointers to void.   

This compiler will also enable C# to call managed functions with variable length argument lists.  

the /L switch may now also be used to specify .net assemblies to load.  mscorlib.dll is automatically loaded by the compiler


Beyond that this is a C11 compiler, but some things currently aren't implemented or are implemented in a limited fashion

1) Complex numbers aren't implemented
2) Atomics aren't implemented
3) thread and thread local storage aren't implemented
4) runtime library is msvcrtl.dll, and doesn't support C11 or C99 additions to the CRTL
5) arrays aren't implemented as managed arrays but as pointers to unmanaged memory.
6) array types are actually implemented as .net classes
7) variable length argument lists are done in the C# style rather than in the C style - except during calls to unmanaged functions
8) variable length argument lists get marshalling performed when being passed to unmanaged code, but this only handles simple types.
9) thunks are generated for pointers-to-functions passed between managed and unmanaged code (e.g. for qsort and for WNDPROC style functions) but when the pointers are placed in a structure you need to give the compiler a hint.  use CALLBACK in the function pointer definition and make the callback a stdcall function.
10) in the thunks for the transition from unmanaged to managed code used by function pointers passed to unmanaged code marshalling is performed, but this only handles simple types.
11) variable length arrays and 'alloca' are implemented with a managed memory allocator instead of with the 'localalloc' msil function.
12) structures passed by value to functions get copied to temporary variables before the call
13) many compiler optimizations found in the native version of the compiler are currently turned off.
14) The compiler will not allow use of unprototyped functions.