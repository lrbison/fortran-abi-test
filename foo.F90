
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

module libmod
interface
subroutine f90_abi_test_f(origin_addr,origin_count,ierror) &
BIND(C, name="f90_abi_test_f")
implicit none
SOMETYPE, INTENT(IN) :: origin_addr
INTEGER, INTENT(IN) :: origin_count
INTEGER, INTENT(OUT) :: ierror
end subroutine f90_abi_test_f
end interface
end module libmod

subroutine f90_abi_test(origin_addr,origin_count,ierror)
   use libmod
   implicit none
   SOMETYPE, INTENT(IN) MAYBE_ASYNC :: origin_addr
   INTEGER, INTENT(IN) :: origin_count
   INTEGER, INTENT(OUT), OPTIONAL :: ierror
   integer :: c_ierror
   call f90_abi_test_f(origin_addr,origin_count,c_ierror)
   if (present(ierror)) ierror = c_ierror
end subroutine f90_abi_test

