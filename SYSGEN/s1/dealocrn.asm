;dealocrn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	lda #$01
	sec
	jsr $9f00
	bcc L93ec
	txa
	ldx #$80
	rts
	
L93ec
	ldx #$00
	stx L958f
	stx $91fe
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9404
	clc
	jsr S9571
	lda $8ff3
	sta $9ec3
	lda $8ff5
	sta $9ec4
	lda $8ff9
	sta $9ec5
	lda $91f0
	bne L9426
	lda $91f1
	cmp #$f1
	bcc L942b
L9426
	lda #$1e
	jmp LTK_ExeExtMiniSub 
	
L942b
	lda #$00
	sta L9592
L9430
	jsr S954d
	ldy #$00
	sty L95ce
	ldy $9ec5
	lda L9591
	ldx L9590
	jsr S9594
	sty L958a
	ldy #$00
	sty L95ce
	ldy $9ec3
	jsr S9594
	sty L958c
	sec
	adc L9593
	sta L958d
	lda L9592
	beq L9475
	cmp L958d
	beq L9487
	lda LTK_Var_ActiveLU
	ldx L9592
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9475
	ldx L958d
	stx L9592
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9487
	lda L958a
	ldx #$00
	
	stx L95ce
	ldy #$08
	jsr S9594
	sta L958e
	sty L958a
	lda $9ec4
	ldx #$00
	ldy L958c
	jsr LTK_TPMultiply 
	clc
	adc L958e
	bcc L94ac
	inx
L94ac
	clc
	adc #$e3
	bcc L94b2
	inx
L94b2
	sta L94e2 + 1
	sta L94d2 + 1
	txa
	clc
	adc #$8f
	sta L94e2 + 2
	sta L94d2 + 2
	lda #$80
	sta L958b
	ldy L958a
	beq L94d2
L94cc
	lsr L958b
	dey
	bne L94cc
L94d2
	lda L94d2
	tay
	and L958b
	bne L94de
	sec
	bcs L94f4
L94de
	tya
	eor L958b
L94e2
	sta L94e2
	inc L958f
	ldx L958f
	cpx $91f1
	beq L94f3
	jmp L9430
	
L94f3
	clc
L94f4
	php
	lda LTK_Var_ActiveLU
	ldx L9592
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9504
	clc
	jsr S9571
	ldx #$ff
	lda $9075
	sec
	sbc L958f
	sta $9075
	bcs L9521
	dec $9074
	cpx $9074
	bne L9521
	dec $9073
L9521
	lda L958f
	clc
	adc $9072
	sta $9072
	bcc L9535
	inc $9071
	bne L9535
	inc $9070
L9535
	lda $9200
	sta $9076
	lda $9201
	sta $9077
	sec
	jsr S9571
	lda #$01
	clc
	jsr $9f00
	plp
	rts
	
S954d
	lda #$00
	sta S956d + 1
	ldy #$92
	lda L958f
	asl a
	tax
	bcc L955c
	iny
L955c
	sty S956d + 2
	jsr S956d
	sta L9590
	inx
	jsr S956d
	sta L9591
	rts
	
S956d
	lda S956d,x
	rts
	
S9571
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L957d
	ldx #$00
L957d
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9586
	stx L9593
	rts
	
L958a
	.byte $00
L958b
	.byte $00
L958c
	.byte $00
L958d
	.byte $00
L958e
	.byte $00
L958f
	.byte $00
L9590
	.byte $00
L9591
	.byte $00
L9592
	.byte $00
L9593
	.byte $00
S9594
	sta L95d0
	stx L95cf
	sty L95d1
	lda #$00
	ldx #$18
L95a1
	clc
	rol L95d0
	rol L95cf
	rol L95ce
	rol a
	bcs L95b3
	cmp L95d1
	bcc L95c3
L95b3
	sbc L95d1
	inc L95d0
	bne L95c3
	inc L95cf
	bne L95c3
	inc L95ce
L95c3
	dex
	bne L95a1
	tay
	ldx L95cf
	lda L95d0
	rts
	
L95ce
	.byte $00
L95cf
	.byte $00
L95d0
	.byte $00
L95d1
	.byte $00
