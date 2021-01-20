#!/bin/bash

RUNS=10

#run
for OPT in `ls objdir/division*`
do
  echo "Start of $OPT"
  for i in `seq 1 $RUNS`
  do
    taskset -c 1 ./$OPT
  done > ${OPT}.log
  echo "End of $OPT"
done