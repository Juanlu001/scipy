program main

    ! To build and run:
    !
    ! $ cd integrate/
    ! $ python setup.py build_ext -i
    ! $ cd tests/
    ! $ gfortran -c -std=f95 test_lsoda.f90
    ! $ gfortran -o test_lsoda test_lsoda.f90 ../_odepack.cpython-33m.so
    ! $ ./test_lsoda

    implicit none

    external fex

    ! Parameters of lsoda
    double precision, dimension(3) :: y
    double precision :: t, tout
    double precision :: rtol
    double precision, dimension(3) :: atol
    integer :: itask, istate, iopt
    double precision, dimension(70) :: rwork
    integer, dimension(23) :: iwork
    integer :: jt

    ! Internal variables of the program
    integer :: ii

    y = (/1.0d0, 0.0d0, 0.0d0/)  ! Initial conditions
                                 ! (later values of y)
    t = 0.0d0  ! Initial value of the independent variable
               ! (later values of t)

    tout = 0.4d0  ! First point where output is desired (.ne. t)

    rtol = 1.0d-4  ! Relative tolerance
    atol = (/1.0d-6, 1.0d-10, 1.0d-6/)  ! Absolute tolerance

    itask = 1  ! Normal computation of output values of y(t) at
               ! t = tout (by overshooting and interpolating)
    istate = 1  ! First call for the problem (initializations will be done)

    iopt = 0  ! No optional inputs

    jt = 2  ! Internally generated full jacobian (not user given)

    rwork = 0.0d0
    iwork = 0

    do ii = 1, 12
        call lsoda(fex, size(y), y, t, tout, 2, rtol, atol, itask, istate, &
                   iopt, rwork, size(rwork), iwork, size(iwork), 0, jt)

        write(*, 20) t, y(1), y(2), y(3)
    20  format(' at t =', es12.4, '   y =', 3es14.6)

        if (istate < 0) then
            write(*, 90) istate
    90      format(///' error halt.. istate =',i3)
            stop
        end if

        tout = tout * 10.0d0
    end do

    write(*, 60) iwork(11), iwork(12), iwork(13), iwork(19), rwork(15)
60  format(/' no. steps =', i4, '  no. f-s =', i4, '  no. j-s =', i4/ &
           ' method last used =', i2, '   last switch was at t =', es12.4)

end program main


subroutine fex(neq, t, y, ydot)

    implicit none

    integer :: neq
    double precision :: t
    double precision, dimension(3) :: y, ydot

    ydot(1) = -0.04d0 * y(1) + 1.0d4 * y(2) * y(3)
    ydot(3) = 3.0d7 * y(2) * y(2)
    ydot(2) = -ydot(1) - ydot(3)

    return

end subroutine fex
