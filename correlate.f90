program main
  implicit none
  integer,  parameter :: fp = 8
  integer,  parameter :: maxMoment = 25, npointmoment = 10
  integer,  parameter :: moments = maxMoment * npointmoment + 1
  real(fp), parameter :: deltaMoment = 1._fp / npointmoment
  integer,  parameter :: LU_density = 10, LU_orbital = 11
  ! arguments
  integer :: arguments_count
  integer :: stat
  logical :: existance
  character(len=:), allocatable :: program_name, density_file, orbital_file
  ! reader
  integer  :: radial_points, tmp_rp
  real(fp) :: start, shift, tmp_st, tmp_sh
  ! internal variables
  integer :: i, j, n
  ! work tables
  real(fp), dimension(moments) :: powN
  real(fp), dimension(:), allocatable :: radius, density, radius2
  real(fp), dimension(:), allocatable :: correlation, orbital
  real(fp), dimension(:,:), allocatable :: density_table
  arguments_count = command_argument_count()
  if (arguments_count .le. 1) then
    allocate(character(len=1024) :: program_name)
    call get_command_argument(0, program_name, status=stat)
    print *, "Run this program as '" // trim(program_name) // " density.1.RDF orbital.4-XXX.RDF'"
    print *, "Stopping..."
    stop
  end if
  allocate(character(len=1024) :: density_file)
  call get_command_argument(1, density_file, status=stat)
  inquire(file=density_file, exist=existance)
  if(.not.existance) then
    print *, "Density file '" // trim(density_file) // "' is not exist!"
    print *, "Please, check your input!"
    print *, "Stopping..."
    stop
  end if
  open(LU_density, file=density_file, form='unformatted', access='sequential')
  read(LU_density) radial_points
  allocate(radius(radial_points), density(radial_points), radius2(radial_points))
  allocate(correlation(moments), orbital(radial_points))
  allocate(density_table(radial_points, moments))
  allocate(character(len=1024) :: orbital_file)
  ! read density
  read(LU_density) start
  read(LU_density) shift
  read(LU_density) density
  close(LU_density)
  ! prepare constant arrays
  do i = 1, radial_points
    radius(i) = start + shift*(i-1)
  end do
  radius2 = radius * radius
  do n = 1, moments
    powN(n) = deltaMoment*(n-1)
  end do
  ! r^n weighing and normalizing density
  do n = 1, moments
    density_table(:,n) = density * radius ** powN(n)
    density_table(:,n) = density_table(:,n)/sum(density_table(:,n))
  end do
  ! orbitals
  do j = 2, arguments_count
    call get_command_argument(j, orbital_file, status=stat)
    inquire(file=orbital_file, exist=existance)
    if(.not.existance) then
      print *, "Orbital file '" // trim(orbital_file) // "' is not exist!"
      print *, "Please, check your input!"
      print *, "Stopping..."
      stop
    end if
    ! read orbitals
    open(LU_orbital, file=orbital_file, form='unformatted', access='sequential')
    read(LU_orbital) tmp_rp
    read(LU_orbital) tmp_st
    read(LU_orbital) tmp_sh
    read(LU_orbital) orbital
    close(LU_orbital)
    ! r^2 weighing and normalizing orbital
    orbital = radius2 * orbital * orbital
    orbital = orbital/sum(orbital)
    do n = 1, moments
      correlation(n) = sum(abs(orbital-density_table(:,n)))
    end do
    do n = 1, moments
      write(6, "(A,A1,F4.1,A1,E18.12)") trim(orbital_file), ";", powN(n), ";", correlation(n)
    end do
  end do
end program main