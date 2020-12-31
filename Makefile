EXE     = correlate
RDF2BIN = rdf2bin

data:
	tar -xJvf data/H-RDF.tar.xz     -C data
	tar -xJvf data/Na-RDF-P1.tar.xz -C data
	tar -xJvf data/Na-RDF-P2.tar.xz -C data
	tar -xJvf data/Na-RDF-P3.tar.xz -C data
	tar -xJvf data/Na-RDF-P4.tar.xz -C data

bindata:
	for i in data/*.RDF; do ./$(RDF2BIN) $${i}; done

ifort:
	ifort     -O3 -xHost -no-prec-div -fp-model precise correlate.f90 -o $(EXE)
	ifort     -O3                                       rdf2bin.f90   -o $(RDF2BIN)

aocc:
	flang     -O3 -march=native                         correlate.f90 -o $(EXE)
	flang     -O3                                       rdf2bin.f90   -o $(RDF2BIN)

pgfortran:
	pgfortran -O4 -tp=host -Kieee                       correlate.f90 -o $(EXE)
	pgfortran -O3                                       rdf2bin.f90   -o $(RDF2BIN)

sun:
	sunf90    -O5 -native                               correlate.f90 -o $(EXE)
	sunf90    -O3                                       rdf2bin.f90   -o $(RDF2BIN)

gfortran:
	gfortran  -O3 -march=native                         correlate.f90 -o $(EXE)
	gfortran  -O3                                       rdf2bin.f90   -o $(RDF2BIN)

lfortran:
	gfortran  -O4 -march=native -fforce-loop-apb        correlate.f90 -o $(EXE)
	gfortran  -O4                                       rdf2bin.f90   -o $(RDF2BIN)

run-H:
	time ./$(EXE) data/1-*.1.RDF.bin  data/1-*.4-*.RDF.bin  > /dev/null

run-Na:
	time ./$(EXE) data/11-*.1.RDF.bin data/11-*.4-*.RDF.bin > /dev/null

.PHONY: data bindata