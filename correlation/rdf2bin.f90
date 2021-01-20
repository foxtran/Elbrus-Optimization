module reader
    implicit none
contains
    subroutine line_count(unit,lines)
        integer, intent(in)  :: unit
        integer, intent(out) :: lines
        integer :: io
        rewind(unit)
        lines = 0
        do
            read(unit,*,iostat=io)
            if(io /= 0) exit
            lines = lines + 1
        end do
        rewind(unit)
    end subroutine line_count
end module reader

program rdf2bin
    use reader
    implicit none
    character(len=255) :: filename_arg
    character(len=:), allocatable :: filename
    character(len=:), allocatable :: filename_bin
    logical :: existence
    integer :: i, stat
    integer :: unitin, nlines
    integer :: unitout
    real(8), dimension(:), allocatable :: rpoint, edpoint
    unitin = 12
    filename = ''
    call get_command_argument(1, filename_arg, status=stat)
    filename = trim(filename_arg)
    filename_bin = filename // '.bin'
    if(stat /= 0) then
        call get_command_argument(0, filename, status=stat)
        print *, stat
        print *, 'Run this program as ', trim(filename), ' filename.RDF!'
        print *, 'Stopping...'
        stop
    end if
    print *, 'Checking, that file is exist...'
    inquire(file=filename,exist=existence)
    if(.not.existence) then
        print *, 'File ', filename, ' is not exist!'
        print *, 'Stopping...'
        stop
    end if
    print *, 'Reading ', filename, '...'
    open(unitin,file=filename)
    call line_count(unitin,nlines)
    print *, 'Total number of lines: ', nlines
    print *, 'Allocating memory...'
    if(.not.allocated(rpoint)) then
        allocate(rpoint(nlines))
    end if
    if(.not.allocated(edpoint)) then
        allocate(edpoint(nlines))
    end if
    print *, 'Reading file...'
    print *, 'First and last five lines:'
    do i = 1, nlines
        read(unitin, '(F8.4,E22.15)') rpoint(i), edpoint(i)
        if(i < 5 .or. i>nlines - 5) then
            write(*, '(F8.4,E22.15)') rpoint(i), edpoint(i)
        end if
    end do
    print *, 'File was read!'
    print *, 'Closing input file...'
    close(unitin)
    print *, 'Opening output file...'
    open(unitout, file=filename_bin, form='unformatted',access='sequential')
    print *, 'Output binary file is ', filename_bin
    print *, 'Writing output binary file...'
    write(unitout) nlines
    write(unitout) rpoint(1)
    write(unitout) rpoint(2)
    write(unitout) edpoint
    close(unitout)
    print *, 'Binary file was successfully written!'
    print *, 'Deallocating memory...'
    deallocate(rpoint)
    deallocate(edpoint)
    deallocate(filename)
    deallocate(filename_bin)
    print *, 'Stopping program...'
    stop
end program rdf2bin