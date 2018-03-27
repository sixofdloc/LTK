;indxmod7.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$4000 for sysgen 
L95e0
	lda $3b
	pha
	lda $3c
	pha
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda $2d
	pha
	lda $2e
	pha
	lda $2f
	pha
	lda $30
	pha
	lda #$00
	sta L9b38
	sta L9b39
	sta L9b3a
	sta L9b3b
	sta L9b34
	sta L9b35
	sta L9b36
	sta L9b37
	sta L9b3f
	sec
	jsr S9b0c
	lda $9e64
	cmp #$ff
	bne L9629
	jmp L9964
	
L9629
	clc
	jsr S9983
	ldy $9e83
	bne L9635
L9632
	jmp L995e
	
L9635
	dey
	cpy $9230
	bcs L9632
	sty $9e83
	lda $9231,y
	sta L9b2d
	tax
	inx
	inx
	stx L9b33
	lda $9236,y
	sta L9b2e
	clc
	jsr S996a
	lda $2004
	bne L965c
	jmp L9961
	
L965c
	ldy L9b2d
	lda $2006,y
	tax
	lda $2005,y
	tay
	sty L9b2f
	stx L9b30
L966d
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$24,$01 
L9677
	inc L9b39
	bne L967f
	inc L9b38
L967f
	lda $2404
	clc
	adc L9b35
	sta L9b35
	bcc L968e
	inc L9b34
L968e
	ldy $2400
	ldx $2401
	bne L966d
	tya
	bne L966d
	lda $9e63
	ldx L9b30
	ldy L9b2f
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L96a9
	ldy L9b2d
	lda $2806,y
	tax
	lda $2805,y
	tay
	stx L9b32
	sty L9b31
L96ba
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L96c4
	inc L9b3b
	bne L96cc
	inc L9b3a
L96cc
	lda $2604
	clc
	adc L9b37
	sta L9b37
	bcc L96db
	inc L9b36
L96db
	ldy $2600
	ldx $2601
	bne L96ba
	tya
	bne L96ba
	ldy #$00
L96e8
	lda L9b34
	cmp L9b38
	bcc L9710
	bne L96fa
	lda L9b35
	cmp L9b39
	bcc L9710
L96fa
	lda L9b35
	sec
	sbc L9b39
	sta L9b35
	lda L9b34
	sbc L9b38
	sta L9b34
	iny
	bne L96e8
L9710
	iny
	cpy L9b2e
	bcc L971b
	beq L971b
	ldy L9b2e
L971b
	sty L9b3c
	ldy #$00
L9720
	lda L9b36
	cmp L9b3a
	bcc L9748
	bne L9732
	lda L9b37
	cmp L9b3b
	bcc L9748
L9732
	lda L9b37
	sec
	sbc L9b3b
	sta L9b37
	lda L9b36
	sbc L9b3a
	sta L9b36
	iny
	bne L9720
L9748
	iny
	cpy L9b2e
	bcc L9753
	beq L9753
	ldy L9b2e
L9753
	sty L9b3d
	lda L9b32
	sta $2601
	sta $2801
	lda L9b31
	sta $2600
	sta $2800
	lda L9b30
	sta $2401
	lda L9b2f
	sta $2400
	jsr S9998
	jsr L99c2
	lda #$05
	sta $33
	lda #$20
	sta $34
	lda #$00
	sta $3b
	lda #$20
	sta $3c
	ldx #$04
	ldy #$00
	lda #$ff
L9790
	sta ($3b),y
	iny
	bne L9790
	inc $3c
	dex
	bne L9790
	ldx #$04
	lda #$00
L979e
	sta $2000,x
	dex
	bpl L979e
L97a4
	jsr L99ee
	bcc L97c2
	lda $9e63
	ldx L9b43
	ldy L9b42
	stx L9b32
	sty L9b31
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L97bf
	jmp L983f
	
L97c2
	ldy #$00
L97c4
	lda ($2d),y
	sta ($2f),y
	iny
	cpy L9b33
	bne L97c4
	inc $2604
	ldx $2604
	lda #$ff
	sta L9b40
	lda L9b3e
	bne L97f0
	cpx L9b3d
	bne L97f0
	dec L9b3e
	lda L9b3f
	beq L97f0
	bmi L97f0
	jmp L981f
	
L97f0
	dec $2804
	bne L9816
	lda L9b3e
	beq L980b
	jsr L9a41
	jsr L99ee
	bcs L97bf
	jsr L9a12
	jsr S9998
	jmp L97c2
	
L980b
	jsr L99ee
	bcs L97bf
	jsr L9aba
	jmp L97c2
	
L9816
	jsr L9aad
	jsr L9aba
	jmp L97c2
	
L981f
	jsr L9a41
	lda L9b32
	sta L9b43
	lda L9b31
	sta L9b42
	jsr L9a12
	jsr S9998
	jsr L9aad
	dec $2804
	bne L97c2
	jmp L97a4
	
L983f
	lda L9b40
	beq L9847
	jsr L9a41
L9847
	lda L9b41
	beq L984f
	jsr S9a81
L984f
	lda $2400
	pha
	lda $2401
	pha
	lda $2600
	pha
	lda $2601
	pha
	lda #$00
	sta $2600
	sta $2601
	sta $2400
	sta $2401
	jsr L9a12
	jsr L9a2b
	sec
	jsr S996a
	ldx #$05
	ldy #$26
	jsr S9ac7
	ldx #$04
	lda #$00
L9882
	sta $2600,x
	dex
	bpl L9882
	pla
	tax
	pla
L988b
	tay
	bne L9891
	txa
	beq L98d2
L9891
	stx L9b32
	sty L9b31
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L98a1
	lda $9218
	sta $2600
	lda $9219
	sta $2601
	lda L9b32
	sta $9219
	lda L9b31
	sta $9218
	jsr L9a12
	lda $9e83
	asl a
	tax
	inc $921b,x
	bne L98c9
	inc $921a,x
L98c9
	ldx $2801
	lda $2800
	jmp L988b
	
L98d2
	pla
	tax
	pla
L98d5
	tay
	bne L98db
	txa
	beq L991c
L98db
	stx L9b32
	sty L9b31
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L98eb
	lda $920c
	sta $2600
	lda $920d
	sta $2601
	lda L9b32
	sta $920d
	lda L9b31
	sta $920c
	jsr L9a12
	lda $9e83
	asl a
	tax
	inc $920f,x
	bne L9913
	inc $920e,x
L9913
	ldx $2801
	lda $2800
	jmp L98d5
	
L991c
	sec
	jsr S9983
	clc
	lda #$00
L9923
	sta $9952
	php
	pla
	sta L994d + 1
	clc
	jsr S9b0c
	pla
	sta $30
	pla
	sta $2f
	pla
	sta $2e
	pla
	sta $2d
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	pla
	sta $3c
	pla
	sta $3b
L994d
	lda #$00
	pha
	plp
	lda #$00
	bit $9ec3
	bpl L995b
	jmp LTK_SysRet_AsIs  
	
L995b
	jmp L9ade
	
L995e
	lda #$01
	.byte $2c 
L9961
	lda #$02
	.byte $2c 
L9964
	lda #$06
	sec
	jmp L9923
	
S996a
	php
	lda $9e83
	asl a
	tax
	lda $9202,x
	tay
	lda $9203,x
	tax
	lda $9e63
	plp
	jsr LTK_HDDiscDriver 
	.byte $00,$20,$02
	rts
	
S9983
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9997
	rts
	
S9998
	lda $9e63
	ldx $2601
	ldy $2600
	stx L9b32
	sty L9b31
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L99ae
	ldx #$05
	stx $2f
	ldy #$26
	sty $30
	jsr S9ac7
	lda #$00
	sta $2604
	sta L9b3e
	rts
	
L99c2
	ldx $2401
	ldy $2400
	stx L9b30
	sty L9b2f
	bne L99d3
	txa
	beq L99ed
L99d3
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$24,$01 
	ldx #$05
	stx $31
	ldy #$24
	sty $32
	jsr S9ac7
	lda #$00
	sta $2404
L99ed
	rts
	
L99ee
	ldx $2801
	ldy $2800
	bne L99fb
	txa
	bne L99fb
	sec
	rts
	
L99fb
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L9a05
	inc L9b3f
	lda #$05
	sta $2d
	lda #$28
	sta $2e
	clc
	rts
	
L9a12
	ldx L9b32
	ldy L9b31
	bne L9a1d
	txa
	beq L9a2a
L9a1d
	lda $9e63
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L9a27
	dec L9b3f
L9a2a
	rts
	
L9a2b
	ldx L9b30
	ldy L9b2f
	bne L9a36
	txa
	beq L9a40
L9a36
	lda $9e63
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$24,$01 
L9a40
	rts
	
L9a41
	ldy #$00
	sty L9b40
L9a46
	lda ($2d),y
	sta ($31),y
	iny
	cpy L9b2d
	bne L9a46
	lda L9b31
	sta ($31),y
	iny
	lda L9b32
	sta ($31),y
	inc $2404
	lda $31
	clc
	adc L9b33
	sta $31
	bcc L9a6a
	inc $32
L9a6a
	lda $2404
	ldx #$ff
	stx L9b41
	cmp L9b3c
	bne L9a80
	jsr S9a81
	jsr L9a2b
	jsr L99c2
L9a80
	rts
	
S9a81
	ldy #$00
L9a83
	lda ($2d),y
	sta ($33),y
	iny
	cpy L9b2d
	bne L9a83
	lda L9b2f
	sta ($33),y
	iny
	lda L9b30
	sta ($33),y
	inc $2004
	lda $33
	clc
	adc L9b33
	sta $33
	bcc L9aa7
	inc $34
L9aa7
	lda #$00
	sta L9b41
	rts
	
L9aad
	lda $2d
	clc
	adc L9b33
	sta $2d
	bcc L9ab9
	inc $2e
L9ab9
	rts
	
L9aba
	lda $2f
	clc
	adc L9b33
	sta $2f
	bcc L9ac6
	inc $30
L9ac6
	rts
	
S9ac7
	stx $3b
	sty $3c
	lda #$ff
	ldy #$00
L9acf
	sta ($3b),y
	iny
	bne L9acf
	inc $3c
L9ad6
	sta ($3b),y
	iny
	cpy #$fb
	bne L9ad6
	rts
	
L9ade
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S9b15
	jsr $0073
	jsr S9b15
	jsr $0073
	jsr S9b1b
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S9b21
	jmp LTK_SysRet_OldRegs 
	
S9b0c
	lda #$05
	ldx #$00
	ldy #$20
	jmp LTK_MemSwapOut 
	
S9b15
	ldx #$9e
	ldy #$ad
	bne L9b25
S9b1b
	ldx #$8b
	ldy #$b0
	bne L9b25
S9b21
	ldx #$d0
	ldy #$bb
L9b25
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
L9b2d
	.byte $00
L9b2e
	.byte $00
L9b2f
	.byte $00
L9b30
	.byte $00
L9b31
	.byte $00
L9b32
	.byte $00
L9b33
	.byte $00
L9b34
	.byte $00
L9b35
	.byte $00
L9b36
	.byte $00
L9b37
	.byte $00
L9b38
	.byte $00
L9b39
	.byte $00
L9b3a
	.byte $00
L9b3b
	.byte $00
L9b3c
	.byte $00
L9b3d
	.byte $00
L9b3e
	.byte $00
L9b3f
	.byte $00
L9b40
	.byte $00
L9b41
	.byte $00
L9b42
	.byte $00
L9b43
	.byte $00
