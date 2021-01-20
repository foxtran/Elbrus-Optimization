program main
  use prec, only: fp
  use proc_intrinsic, only: rdtsc
  use params, only: beta, mu
  use test, only: eval
  implicit none
  integer, parameter :: MAX = 10000
  real(fp) :: rho(2), energy(1)
  real(fp) :: A(54)
  integer(8) :: ticks_st, ticks_ed
  integer :: i
  character(len=:), allocatable :: program_name
  allocate(character(len=1024) :: program_name)
  call get_command_argument(0, program_name)
  do i = 1, 1024
    if(program_name(i:i) == "-") program_name(i:i) = ";"
  end do
  i = index(program_name, ';') + 1
  program_name = program_name(i:)
  program_name = trim(program_name)
  do i = 1, MAX
    call RANDOM_NUMBER(beta)
    call RANDOM_NUMBER(mu)
    call RANDOM_NUMBER(energy)
    call RANDOM_NUMBER(rho)
    call RANDOM_NUMBER(A)
    beta = -beta
    energy = -energy
    ticks_st = rdtsc()
    call eval(energy(1), rho(1), &
              A( 1), A( 2), A( 3), A( 4), A( 5), A( 6), A( 7), A( 8), A( 9), A(10), A(11), A(12), A(13), A(14), A(15), &
              A(16), A(17), A(18), A(19), A(20), A(21), A(22), A(23), A(24), A(25), A(26), A(27), A(28), A(29), A(30), &
              A(31), A(32), A(33), A(34), A(35), A(36), A(37), A(38), A(39), A(40), A(41), A(42), A(43), A(44), A(45), &
              A(46), A(47), A(48), A(49), A(50), A(51), A(52), A(53), A(54))
    ticks_ed = rdtsc()
    print "(A,';',I0)", program_name, ticks_ed - ticks_st
  end do
  deallocate(program_name)
end program main