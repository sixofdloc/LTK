#!/bin/bash

# fc /b output\%1.prg original\%2.prg
cmp -l $1 $2 | gawk '{printf "%d %d %d\n", $1-1, strtonum(0$2), strtonum(0$3)}'
