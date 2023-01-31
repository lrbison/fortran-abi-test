# Test for Fortran ABI Stability

This repository is a quick sanity check if a particular compiler changes the
library ABI when argument types, intents, and asynchronous attributes are
changed.

# Example Usage and Output

```
$ make check
make -C v1
make[1]: Entering directory `/home/lrbison/fortran-abi-test/v1'
gfortran -fPIC -DLIBVER=1 -c -cpp -o foo.o foo.F90
gcc foo.o -shared -o libfoo.so
rm foo.o
make[1]: Leaving directory `/home/lrbison/fortran-abi-test/v1'
make -C v2
make[1]: Entering directory `/home/lrbison/fortran-abi-test/v2'
gfortran -fPIC -DLIBVER=2 -c -cpp -o foo.o foo.F90
gcc foo.o -shared -o libfoo.so
rm foo.o
make[1]: Leaving directory `/home/lrbison/fortran-abi-test/v2'
The two mod files should be different, as they have different interfaces:
    ==> Binary files v1/libmod.mod and v2/libmod.mod differ
The two .so files should be identical if the ABI is stable
    ==> Files v1/libfoo.so and v2/libfoo.so are identical
FC is gfortran
gfortran --version
GNU Fortran (GCC) 7.3.1 20180712 (Red Hat 7.3.1-15)
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
```

From these results we see that gfortran 7.3.1 does not change ABI in this test.

It is clear from the top-level foo.F90 what is changing:
```
#if LIBVER == 1 
#define SOMETYPE real
#define SOMEINTENT INTENT(IN)
#define MAYBE_ASYNC
#endif

#if LIBVER == 2
#define SOMETYPE type(*), dimension(*)
#define SOMEINTENT INTENT(INOUT)
#define MAYBE_ASYNC , ASYNCHRONOUS
#endif
```