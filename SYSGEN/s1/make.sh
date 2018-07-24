#!/bin/bash

#pre-build housekeeping 
rm output/*
./build.sh go64boot_cd00

# Call with 'check' to stop building when an error is encountered.

for file in *.asm
do
	./build.sh $file || fail=1
	[[ "x$1" = "xcheck" ]] && [[ "x$fail" = "x1" ]] && break # error stop
done


