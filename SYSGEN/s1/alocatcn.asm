;alocatcn.r.prg

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
	stx L95b9
	stx L95ba
	stx L95b8
	stx L95b7
	lda $31
	pha
	lda $32
	pha
	clc
	jsr S95bb
	lda $8ff3
	sta $9ea3
	lda $8ff5
	sta $9ea4
	lda $8ff6
	sta $9ea5
	lda $8ff7
	sta $9ec3
	lda $8ff9
	sta $9e85
L9422
	inc L95da
	clc
	jsr S95cb
	lda #$8f
	sta $32
	lda #$e0
	sta $31
	lda $9ea3
	sta $9e65
L9437
	lda #$00
	sta $9e84
	ldy #$02
L943e
	iny
	lda #$80
	sta $9e83
L9444
	lda ($31),y
L9446
	bit $9e83
	beq L94a2
	ldx #$00
	stx L95b9
	stx L95ba
	stx L95b7
L9456
	inc $9e84
	ldx $9e84
	cpx $9e85
	beq L9468
	lsr $9e83
	bne L9446
	beq L943e
L9468
	lda $9ea4
	clc
	adc $31
	sta $31
	bcc L9474
	inc $32
L9474
	lda $9ec3
	sec
	sbc #$01
	sta $9ec3
	tax
	lda $9ea5
	sbc #$00
	sta $9ea5
	bne L9491
	txa
	bne L9491
	ldx #$fd
	sec
	jmp L9556
	
L9491
	dec $9e65
	bne L9437
	lda L95b8
	beq L949f
	sec
	jsr S95cb
L949f
	jmp L9422
	
L94a2
	ldx L95b8
	beq L94ac
	ora $9e83
	sta ($31),y
L94ac
	ldx L95b7
	bne L94b4
	jsr S9565
L94b4
	inc L95ba
	bne L94bc
	inc L95b9
L94bc
	ldx L95b9
	cpx $91f0
	bne L94d6
	ldx L95ba
	cpx $91f1
	bne L94d6
	lda L95b8
	bne L951b
	dec L95b8
	bne L94db
L94d6
	lda ($31),y
	jmp L9456
	
L94db
	lda L95b0
	sta L95da
	clc
	jsr S95cb
	lda L95b1
	sta $9e65
	lda $9ec4
	sta $9ea5
	lda $9ec5
	sta $9ec3
	lda L95b3
	sta $31
	lda L95b2
	sta $32
	lda L95b4
	sta $9e84
	ldy L95b5
	lda L95b6
	sta $9e83
	lda #$00
	sta L95b9
	sta L95ba
	jmp L9444
	
L951b
	sec
	jsr S95cb
	clc
	jsr S95bb
	lda $9072
	sec
	sbc $91f1
	sta $9072
	lda $9071
	sbc $91f0
	sta $9071
	lda $91f1
	clc
	adc $9075
	sta $9075
	lda $91f0
	adc $9074
	sta $9074
	lda #$ff
	sta $9076
	sta $9077
	sec
	jsr S95bb
	clc
L9556
	pla
	sta $32
	pla
	sta $31
	php
	lda #$01
	clc
	jsr $9f00
	plp
	rts
	
S9565
	lda L95da
	sta L95b0
	lda $9e65
	sta L95b1
	lda $9ea5
	sta $9ec4
	lda $9ec3
	sta $9ec5
	lda $31
	sta L95b3
	lda $32
	sta L95b2
	lda $9e84
	sta L95b4
	sty L95b5
	lda $9e83
	sta L95b6
	ldy #$02
	lda ($31),y
	clc
	adc $9e84
	sta $9201
	dey
	lda ($31),y
	adc #$00
	sta $9200
	ldy L95b5
	dec L95b7
	rts
	
L95b0
	.byte $00
L95b1
	.byte $00
L95b2
	.byte $00
L95b3
	.byte $00
L95b4
	.byte $00
L95b5
	.byte $00
L95b6
	.byte $00
L95b7
	.byte $00
L95b8
	.byte $00
L95b9
	.byte $00
L95ba
	.byte $00
S95bb
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L95c7
	ldx #$00
L95c7
	stx L95da
	plp
S95cb
	ldx L95da
	ldy #$00
	lda LTK_Var_ActiveLU
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95d9
	rts
	
L95da
	.byte $00
