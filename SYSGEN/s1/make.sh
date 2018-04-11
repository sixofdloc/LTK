#!/bin/bash

# Call with 'check' to stop building when an error is encountered.

for file in *.asm
do
	./build.sh $file || fail=1
	[[ "x$1" = "xcheck" ]] && [[ "x$fail" = "x1" ]] && break # error stop
done


