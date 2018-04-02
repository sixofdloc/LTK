;dealoccn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"

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
	stx L957c
	stx L957d
	stx L9577
	stx $91fe
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L940a
	lda BORDER
	sta L957e
	clc
	jsr S9557
	lda $8ff3
	sta L9579
	lda $8ff5
L941e = * + 1       
	sta L957a
	lda $8ff9
	sta L957b
	lda $9200
	sta L9575
	lda $9201
	sta L9576
L9432
	ldy #$00
	sty L95b9
	ldy L957b
	lda L9576
	ldx L9575
	jsr S957f
	sty L9570
	ldy #$00
	sty L95b9
	ldy L9579
	jsr S957f
	sty L9572
	sec
	adc L9578
	sta L9573
	lda L9577
	beq L9474
	cmp L9573
	beq L9486
	lda LTK_Var_ActiveLU
	ldx L9577
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9474
	ldx L9573
	stx L9577
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9486
	lda L9570
	ldx #$00
	stx L95b9
	ldy #$08
	jsr S957f
	sta L9574
	sty L9570
	lda L957a
	ldx #$00
	ldy L9572
	jsr LTK_TPMultiply 
	clc
	adc L9574
	bcc L94ab
	inx
L94ab
	clc
	adc #$e3
	bcc L94b1
	inx
L94b1
	sta $94e2
	sta L94d1 + 1
	txa
	clc
	adc #$8f
	sta $94e3
	sta L94d1 + 2
	lda #$80
	sta L9571
	ldy L9570
	beq L94d1
L94cb
	lsr L9571
	dey
	bne L94cb
L94d1
	lda L94d1
	tay
	and L9571
	bne L94dd
	sec
	bcs L950b
L94dd
	tya
	eor L9571
	sta $94e1
	inc L9576
	bne L94ec
	inc L9575
L94ec
	inc L957d
	bne L94f7
	inc L957c
	inc BORDER
L94f7
	lda L957c
	cmp $91f0
	bne L9507
	lda L957d
	cmp $91f1
	beq L950a
L9507
	jmp L9432
	
L950a
	clc
L950b
	php
	lda LTK_Var_ActiveLU
	ldx L9577
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L951b
	clc
	jsr S9557
	lda $9075
	sec
	sbc L957d
	sta $9075
	lda $9074
	sbc L957c
	sta $9074
	lda L957d
	clc
	adc $9072
	sta $9072
	lda L957c
	adc $9071
	sta $9071
	sec
	jsr S9557
	lda #$01
	clc
	jsr $9f00
	lda L957e
	sta BORDER
	plp
	rts
	
S9557
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L9563
	ldx #$00
L9563
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L956c
	stx L9578
	rts
	
L9570
	.byte $00
	
L9571
	.byte $00
L9572
	.byte $00
L9573
	.byte $00
L9574
	.byte $00
L9575
	.byte $00
L9576
	.byte $00
L9577
	.byte $00
L9578
	.byte $00
L9579
	.byte $00
L957a
	.byte $00
L957b
	.byte $00
L957c
	.byte $00
L957d
	.byte $00
L957e
	.byte $00
S957f
	sta L95bb
	stx L95ba
	sty L95bc
	lda #$00
	ldx #$18
L958c
	clc
	rol L95bb
	rol L95ba
	rol L95b9
	rol a
	bcs L959e
	cmp L95bc
	bcc L95ae
L959e
	sbc L95bc
	inc L95bb
	bne L95ae
	inc L95ba
	bne L95ae
	inc L95b9
L95ae
	dex
	bne L958c
	tay
	ldx L95ba
	lda L95bb
	rts
	
L95b9
	.byte $00
L95ba
	.byte $00
L95bb
	.byte $00
L95bc
	.byte $00
