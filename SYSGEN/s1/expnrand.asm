;expnrand.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	clc
	jsr S955f
	lda $31
	pha
	lda $32
	pha
	ldy #$00
L93ec
	lda $9202,y
	sta LTK_FileReadBuffer ,y
	lda #$00
	sta $9202,y
	iny
	bne L93ec
L93fa
	lda $9302,y
	sta $9ce0,y
	lda #$00
	sta $9302,y
	iny
	cpy #$de
	bne L93fa
	lda #$00
L940c
	sta $9ce0,y
	iny
	bne L940c
	jsr S944b
	bcs L9422
	sta $9203
	stx $9202
	jsr S944b
	bcc L9432
L9422
	pla
	sta $32
	pla
	sta $31
	lda #$01
	clc
	jsr $9f00
	ldx #$ff
	sec
	rts
	
L9432
	sta $9dbf
	stx $9dbe
	ldy $9202
	ldx $9203
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L9448
	jmp L9505
	
S944b
	ldy L957c
	beq L9455
	lda ($31),y
	jmp L949c
	
L9455
	inc L957d
	lda #$00
	sta L9578
	lda #$e0
	ldx #$8f
	sta $31
	stx $32
	clc
	jsr S9550
	lda $9ea5
	sta L9579
L946f
	lda #$00
	sta L957b
	ldy #$02
L9476
	iny
	lda #$80
	sta L957a
	lda ($31),y
	ldx L957a
	bpl L9497
	cmp #$ff
	bne L9497
	lda #$08
	clc
	adc L957b
	sta L957b
	cmp $9ea4
	bcc L9476
	bcs L94ae
L9497
	bit L957a
	beq L94e4
L949c
	inc L957b
	ldx L957b
	cpx $9ea4
	beq L94ae
	lsr L957a
	bne L9497
	beq L9476
L94ae
	lda $9ec3
	clc
	adc $31
	sta $31
	bcc L94ba
	inc $32
L94ba
	ldx #$ff
	dec $9ec5
	beq L94cc
	cpx $9ec5
	bne L94d3
	dec $9ec4
	jmp L94d3
	
L94cc
	lda $9ec4
	bne L94d3
	sec
	rts
	
L94d3
	dec L9579
	bne L946f
	lda L9578
	beq L94e1
	sec
	jsr S9550
L94e1
	jmp L9455
	
L94e4
	ora L957a
	sta ($31),y
	sty L957c
	ldy #$01
	lda ($31),y
	tax
	iny
	lda ($31),y
	clc
	adc L957b
	pha
	txa
	adc #$00
	tax
	pla
	ldy #$ff
	sty L9578
	clc
	rts
	
L9505
	sec
	jsr S9550
	clc
	jsr S955f
	lda $9072
	sec
	sbc #$02
	sta $9072
	bcs L951b
	dec $9071
L951b
	lda #$02
	clc
	adc $9075
	sta $9075
	bcc L9529
	inc $9074
L9529
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta $9076
	sta $9077
	sec
	jsr S955f
	pla
	sta $32
	pla
	sta $31
	lda #$f2
	sta $91f1
	lda #$01
	clc
	jsr $9f00
	ldx $9dbe
	ldy $9dbf
	rts
	
S9550
	lda LTK_Var_ActiveLU
	ldx L957d
	ldy #$00
	jsr LTK_HDDiscDriver 
L955b
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L955e
	rts
	
S955f
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L956b
	ldx #$00
L956b
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9574
	stx L957d
	rts
	
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
