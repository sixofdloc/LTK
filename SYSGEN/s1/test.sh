#!/bin/bash

# add test_file as a function
test_file() {
	# we need a temporary file
	tmpfile=$(mktemp)
	# make difference list and get file status
	cmp -l $1 $2 2 2 >$tmpfile || {
		# show differences if there's an error
		gawk '{printf "%d %d %d\n", $1-1, strtonum(0$2), strtonum(0$3)}' <$tmpfile
		echo $1 and $2 differ >/dev/stderr
	}
	# clean up
	rm $tmpfile
}

for pathandfile in output/*.prg
do
	filename=$(basename -- "$pathandfile")
	filename="${filename%.*}"
	if \
		[ "$filename" != "sector18-18" ] \
		&& [ "$filename" != "go64boot_cd00" ]
		then
			if \
				[ "$filename" == "b" ] \
				|| [ "$filename" == "sb2" ] \
				|| [ "$filename" == "setup" ] \
				|| [ "$filename" == "sysboot" ]
			then
				test_file $pathandfile original/${pathandfile##*/}
			else
				test_file $pathandfile original/$filename.r.prg
			fi
		fi
done


