;adjindex.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	lda $9201
	sec
	sbc $9001
	sta L95ad
	lda $9200
	sbc $9000
	sta L95ac
	lda #$00
	sta L95aa
	sta L95b0
L93fb
	lda L95aa
	cmp $9230
	beq L941d
	asl a
	tay
	lda $9203,y
	clc
	adc L95ad
	sta $9203,y
	lda $9202,y
	adc L95ac
	sta $9202,y
	inc L95aa
	bne L93fb
L941d
	ldx $920d
	ldy $920c
	bne L9428
	txa
	beq L9434
L9428
	jsr S957b
	stx $920d
	sty $920c
	jsr S94f6
L9434
	ldx $9219
	ldy $9218
	bne L943f
	txa
	beq L944b
L943f
	jsr S957b
	stx $9219
	sty $9218
	jsr S94f6
L944b
	lda #$00
	sta L95aa
L9450
	ldy L95aa
	lda $9231,y
	sta L95ab
	tax
	inx
	inx
	stx L95af
	clc
	jsr S94dd
	lda $8de4
	beq L948c
	jsr S94a8
	sec
	jsr S94dd
	dec L95b0
	ldx L95ab
	lda $8de5,x
	tay
	lda $8de6,x
	tax
	jsr S94f6
	inc L95b0
	ldx L95b3
	ldy L95b2
	jsr S94f6
L948c
	inc L95aa
	lda L95aa
	cmp $9230
	bne L9450
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L94a7
	rts
	
S94a8
	sta L95ae
	lda #$e5
	sta S9587 + 1
	sta S958c + 1
	lda #$8d
	sta S9587 + 2
	sta S958c + 2
L94bb
	ldx L95ab
	jsr S9587
	tay
	jsr S9587
	tax
	jsr S957b
	tya
	ldy L95ab
	jsr S958c
	txa
	jsr S958c
	jsr S9591
	dec L95ae
	bne L94bb
	rts
	
S94dd
	php
	lda L95aa
	asl a
	tax
	lda $9202,x
	tay
	lda $9203,x
	tax
	lda LTK_Var_ActiveLU
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$02; $8de0 
L94f5
	rts
	
S94f6
	lda #$00
	sta L95b1
L94fb
	clc
	lda LTK_Var_ActiveLU
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L9505
	txa
	pha
	tya
	pha
	lda L95b0
	beq L952d
	lda $8de4
	beq L952d
	jsr S94a8
	lda L95b1
	bne L952d
	ldx L95ab
	lda $8de5,x
	sta L95b2
	lda $8de6,x
	sta L95b3
	dec L95b1
L952d
	ldx $8de3
	ldy $8de2
	bne L9538
	txa
	beq L9541
L9538
	jsr S957b
	stx $8de3
	sty $8de2
L9541
	ldx $8de1
	ldy LTK_FileWriteBuffer 
	bne L954c
	txa
	beq L956c
L954c
	jsr S957b
	stx $8de1
	sty LTK_FileWriteBuffer 
	pla
	tay
	pla
	tax
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L9563
	ldx $8de1
	ldy LTK_FileWriteBuffer 
	jmp L94fb
	
L956c
	pla
	tay
	pla
	tax
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L957a
	rts
	
S957b
	txa
	clc
	adc L95ad
	tax
	tya
	adc L95ac
	tay
	rts
	
S9587
	lda S9587,x
	inx
	rts
	
S958c
	sta S958c,y
	iny
	rts
	
S9591
	lda S9587 + 1
	clc
	adc L95af
	sta S9587 + 1
	sta S958c + 1
	lda S9587 + 2
	adc #$00
	sta S9587 + 2
	sta S958c + 2
	rts
	
L95aa
	.byte $00
L95ab
	.byte $00
L95ac
	.byte $00
L95ad
	.byte $00
L95ae
	.byte $00
L95af
	.byte $00
L95b0
	.byte $00
L95b1
	.byte $00
L95b2
	.byte $00
L95b3
	.byte $00
