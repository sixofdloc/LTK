;new.r.prg
	*=$4000
	lda #$ff
	sta $8025
	sta $8026
	sta $8027
	pla
	pla
	jmp $805a
