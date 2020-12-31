EXE=correlate

data:
	tar -xJvf data/H-RDF.tar.xz     -C data
	tar -xJvf data/Na-RDF-P1.tar.xz -C data
	tar -xJvf data/Na-RDF-P2.tar.xz -C data
	tar -xJvf data/Na-RDF-P3.tar.xz -C data
	tar -xJvf data/Na-RDF-P4.tar.xz -C data

ifort:
	ifort     -O3 -xHost -no-prec-div -fp-model precise correlate.f90 -o $(EXE)

aocc:
	flang     -O3 -march=native                         correlate.f90 -o $(EXE)

pgfortran:
	pgfortran -O4 -tp=host -Kieee                       correlate.f90 -o $(EXE)

sun:
	sunf90    -O5 -native                               correlate.f90 -o $(EXE)

gfortran:
	gfortran  -O3 -march=native                         correlate.f90 -o $(EXE)

lfortran:
	gfortran  -O4 -march=native -fforce-loop-apb        correlate.f90 -o $(EXE)

run-H:
	time ./$(EXE) data/1-*.1.RDF  data/1-*.4-*.RDF  > /dev/null

run-Na:
	time ./$(EXE) data/11-*.1.RDF data/11-*.4-*.RDF > /dev/null

.PHONY: data