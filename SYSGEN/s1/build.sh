#!/bin/bash
infile=${1%.*}
exec tmpx $infile.asm -o output/$infile.prg -l lst/$infile.lst

