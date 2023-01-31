FC = gfortran
FFLAGS = -fPIC -DLIBVER=$(LIBVER)

CLEAN_LIST := *.o *.mod *.a *.so

%.o: %.F90
	$(FC) $(FFLAGS) -c -cpp -o $@ $<

lib%.so: %.o
	gcc $< -shared -o $@

	