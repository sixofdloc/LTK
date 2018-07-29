echo -en "\x00\x40" > relocated/$1.r.prg
dd bs=1 skip=2 if=output/$1.prg >> relocated/$1.r.prg

