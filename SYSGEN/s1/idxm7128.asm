;idxm7128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

     *=LTK_DOSOverlay 

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
	sta L9b47
	sta L9b48
	sta L9b49
	sta L9b4a
	sta L9b43
	sta L9b44
	sta L9b45
	sta L9b46
	sta L9b4e
	sec
	jsr S9b15
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
	sta L9b3c
	tax
	inx
	inx
	stx L9b42
	lda $9236,y
	sta L9b3d
	clc
	jsr S996a
	lda $2004
	bne L965c
	jmp L9961
	
L965c
	ldy L9b3c
	lda $2006,y
	tax
	lda $2005,y
	tay
	sty L9b3e
	stx L9b3f
L966d
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$24,$01 
L9677
	inc L9b48
	bne L967f
	inc L9b47
L967f
	lda $2404
	clc
	adc L9b44
	sta L9b44
	bcc L968e
	inc L9b43
L968e
	ldy $2400
	ldx $2401
	bne L966d
	tya
	bne L966d
	lda $9e63
	ldx L9b3f
	ldy L9b3e
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L96a9
	ldy L9b3c
	lda $2806,y
	tax
	lda $2805,y
	tay
	stx L9b41
	sty L9b40
L96ba
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L96c4
	inc L9b4a
	bne L96cc
	inc L9b49
L96cc
	lda $2604
	clc
	adc L9b46
	sta L9b46
	bcc L96db
	inc L9b45
L96db
	ldy $2600
	ldx $2601
	bne L96ba
	tya
	bne L96ba
	ldy #$00
L96e8
	lda L9b43
	cmp L9b47
	bcc L9710
	bne L96fa
	lda L9b44
	cmp L9b48
	bcc L9710
L96fa
	lda L9b44
	sec
	sbc L9b48
	sta L9b44
	lda L9b43
	sbc L9b47
	sta L9b43
	iny
	bne L96e8
L9710
	iny
	cpy L9b3d
	bcc L971b
	beq L971b
	ldy L9b3d
L971b
	sty L9b4b
	ldy #$00
L9720
	lda L9b45
	cmp L9b49
	bcc L9748
	bne L9732
	lda L9b46
	cmp L9b4a
	bcc L9748
L9732
	lda L9b46
	sec
	sbc L9b4a
	sta L9b46
	lda L9b45
	sbc L9b49
	sta L9b45
	iny
	bne L9720
L9748
	iny
	cpy L9b3d
	bcc L9753
	beq L9753
	ldy L9b3d
L9753
	sty L9b4c
	lda L9b41
	sta $2601
	sta $2801
	lda L9b40
	sta $2600
	sta $2800
	lda L9b3f
	sta $2401
	lda L9b3e
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
	jsr S99ee
	bcc L97c2
	lda $9e63
	ldx L9b52
	ldy L9b51
	stx L9b41
	sty L9b40
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
	cpy L9b42
	bne L97c4
	inc $2604
	ldx $2604
	lda #$ff
	sta L9b4f
	lda L9b4d
	bne L97f0
	cpx L9b4c
	bne L97f0
	dec L9b4d
	lda L9b4e
	beq L97f0
	bmi L97f0
	jmp L981f
	
L97f0
	dec $2804
	bne L9816
	lda L9b4d
	beq L980b
	jsr S9a41
	jsr S99ee
	bcs L97bf
	jsr S9a12
	jsr S9998
	jmp L97c2
	
L980b
	jsr S99ee
	bcs L97bf
	jsr S9aba
	jmp L97c2
	
L9816
	jsr S9aad
	jsr S9aba
	jmp L97c2
	
L981f
	jsr S9a41
	lda L9b41
	sta L9b52
	lda L9b40
	sta L9b51
	jsr S9a12
	jsr S9998
	jsr S9aad
	dec $2804
	bne L97c2
	jmp L97a4
	
L983f
	lda L9b4f
	beq L9847
	jsr S9a41
L9847
	lda L9b50
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
	jsr S9a12
	jsr S9a2b
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
	stx L9b41
	sty L9b40
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
    .byte $00,$28,$01 
L98a1
	lda $9218
	sta $2600
	lda $9219
	sta $2601
	lda L9b41
	sta $9219
	lda L9b40
	sta $9218
	jsr S9a12
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
	stx L9b41
	sty L9b40
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$28,$01 
L98eb
	lda $920c
	sta $2600
	lda $920d
	sta $2601
	lda L9b41
	sta $920d
	lda L9b40
	sta $920c
	jsr S9a12
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
	sta L9951 + 1
	php
	pla
	sta L994d + 1
	clc
	jsr S9b15
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
L9951
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
L9982
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
	stx L9b41
	sty L9b40
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
	sta L9b4d
	rts
	
L99c2
	ldx $2401
	ldy $2400
	stx L9b3f
	sty L9b3e
	bne L99d3
	txa
	beq L99ed
L99d3
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$24,$01 
L99dd
	ldx #$05
	stx $31
	ldy #$24
	sty $32
	jsr S9ac7
	lda #$00
	sta $2404
L99ed
	rts
	
S99ee
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
	inc L9b4e
	lda #$05
	sta $2d
	lda #$28
	sta $2e
	clc
	rts
	
S9a12
	ldx L9b41
	ldy L9b40
	bne L9a1d
	txa
	beq L9a2a
L9a1d
	lda $9e63
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$26,$01 
L9a27
	dec L9b4e
L9a2a
	rts
	
S9a2b
	ldx L9b3f
	ldy L9b3e
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
	
S9a41
	ldy #$00
	sty L9b4f
L9a46
	lda ($2d),y
	sta ($31),y
	iny
	cpy L9b3c
	bne L9a46
	lda L9b40
	sta ($31),y
	iny
	lda L9b41
	sta ($31),y
	inc $2404
	lda $31
	clc
	adc L9b42
	sta $31
	bcc L9a6a
	inc $32
L9a6a
	lda $2404
	ldx #$ff
	stx L9b50
	cmp L9b4b
	bne L9a80
	jsr S9a81
	jsr S9a2b
	jsr L99c2
L9a80
	rts
	
S9a81
	ldy #$00
L9a83
	lda ($2d),y
	sta ($33),y
	iny
	cpy L9b3c
	bne L9a83
	lda L9b3e
	sta ($33),y
	iny
	lda L9b3f
	sta ($33),y
	inc $2004
	lda $33
	clc
	adc L9b42
	sta $33
	bcc L9aa7
	inc $34
L9aa7
	lda #$00
	sta L9b50
	rts
	
S9aad
	lda $2d
	clc
	adc L9b42
	sta $2d
	bcc L9ab9
	inc $2e
L9ab9
	rts
	
S9aba
	lda $2f
	clc
	adc L9b42
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
	sta $3d
	lda $9ec4
	sta $3e
	jsr S9b0e
	jsr S9b0e
	jsr S9b1e
	jsr S9b2a
	sta $4b
	sty $4c
	ldx #$c9
	ldy #$84
	sec
	jsr LTK_KernalTrapSetup
	pla
	tay
	lda #$00
	jsr LTK_KernalCall 
	jsr S9b30
	jmp LTK_SysRet_OldRegs 
	
S9b0e
	jsr S9b1e
	jsr S9b24
	rts
	
S9b15
	lda #$05
	ldx #$00
	ldy #$20
	jmp LTK_MemSwapOut 
	
S9b1e
	ldx #$80
	ldy #$03
	bne L9b34
S9b24
	ldx #$ef
	ldy #$77
	bne L9b34
S9b2a
	ldx #$af
	ldy #$7a
	bne L9b34
S9b30
	ldx #$fa
	ldy #$53
L9b34
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
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
L9b44
	.byte $00
L9b45
	.byte $00
L9b46
	.byte $00
L9b47
	.byte $00
L9b48
	.byte $00
L9b49
	.byte $00
L9b4a
	.byte $00
L9b4b
	.byte $00
L9b4c
	.byte $00
L9b4d
	.byte $00
L9b4e
	.byte $00
L9b4f
	.byte $00
L9b50
	.byte $00
L9b51
	.byte $00
L9b52
	.byte $00
