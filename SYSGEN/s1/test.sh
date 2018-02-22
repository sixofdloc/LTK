#!/bin/bash

# add test_file as a function
test_file() {
	# we need a temporary file
	tmpfile=$(mktemp)
	# make difference list and get file status
	cmp -l $1 $2 >$tmpfile || {
		# show differences if there's an error
		gawk '{printf "%d %d %d\n", $1-1, strtonum(0$2), strtonum(0$3)}' <$tmpfile
		echo $1 and $2 differ >/dev/stderr
	}
	# clean up
	rm $tmpfile
}

test_file activate activate.r
test_file adjindex adjindex.r
test_file b b
test_file catalogr catalogr.r
test_file creditsb creditsb.r
test_file checksum checksum.r
test_file convrtio convrtio.r
test_file d d.r
test_file dir dir.r
test_file errorhan errorhan.r
test_file fastcpqd fastcpqd.r
test_file fileprot fileprot.r
test_file initc064 initc064.r
test_file l l.r
test_file ltkernal ltkernal.r
test_file lu lu.r
test_file luchange luchange.r
test_file messfile messfile.r
test_file new new.r
test_file openrand openrand.r
test_file sb2 sb2
test_file scramidn scramidn.r
test_file setup setup
test_file ship ship.r
test_file sysboot sysbootr.r
test_file user user.r


