;altserch.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_FileReadBuffer ;$9be0, $4000 for sysgen 
L9be0
	jmp L9be4
	
	.byte $2f 
L9be4
	lda #$c8
	ldx #$d3
	ldy #$ca
	bit LTK_Var_CPUMode
	bpl L9bf5
	lda #$ea
	ldx #$ec
	ldy #$e9
L9bf5
	sta $9c1d
	sta L9c34 + 1
	sta L9c8b + 1
	sta $9cac
	sta L9cf8 + 1
	stx $9cc0
	sty $9ccb
	ldy #$03
	lda #$20
L9c0e
	sta L9d49,y
	dey
	bpl L9c0e
	iny
L9c15
	lda LTK_Command_Buffer,y
	sta L9d49,y
	iny
	cpy $c8
	bcc L9c24
	ldy #$ff
	bne L9c2c
L9c24
	cmp #$20
	beq L9c2c
	cpy #$04
	bne L9c15
L9c2c
	sty L9d47
	ldx #$00
	tya
	bmi L9c4a
L9c34
	cpy $c8
	bcs L9c4a
	lda LTK_Command_Buffer,y
	cmp #$20
	bne L9c43
	cpx #$00
	beq L9c47
L9c43
	sta LTK_FileHeaderBlock ,x
	inx
L9c47
	iny
	bne L9c34
L9c4a
	stx L9d48
	lda $31
	pha
	lda $32
	pha
	ldx $9fad
	ldy $9fac
	jsr S9d0b
	beq L9c89
	jsr S9d18
	ldy #$1f
	lda ($31),y
	tax
	dey
	lda ($31),y
	tay
	jsr S9d0b
	jsr S9d18
	cpy #$04
	beq L9c77
	jmp L9d03
	
L9c77
	ldy #$1d
	ldx #$1a
L9c7b
	lda ($31),y
	beq L9c83
	cmp #$20
	bne L9c8b
L9c83
	dex
	dey
	cpy #$03
	bne L9c7b
L9c89
	beq L9d03
L9c8b
	stx $c8
	ldy #$04
L9c8f
	lda ($31),y
	sta $01fc,y
	iny
	dex
	bne L9c8f
	lda L9d48
	beq L9cb2
	lda #$20
	ldx #$ff
	bne L9ca6
L9ca3
	lda LTK_FileHeaderBlock ,x
L9ca6
	sta $01fc,y
	inx
	iny
	inc $c8
	dec L9d48
	bpl L9ca3
L9cb2
	lda #$00
	sta $01fc,y
	ldy #$1f
	lda ($31),y
	beq L9cf8
	lda #$00
	sta $d3
	ldx #$00
	ldy #$02
	jsr LTK_Print 
	lda #$00
	sta $ca
	ldx #$5f
	ldy #$f1
	bit LTK_Var_CPUMode
	bpl L9cd9
	ldx #$0e
	ldy #$ef
L9cd9
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L9cdf
	jsr LTK_KernalCall 
	cmp #$0d
	beq L9cec
	sta LTK_Command_Buffer,y
	iny
	bne L9cdf
L9cec
	lda #$00
	sta LTK_Command_Buffer,y
	bit LTK_Var_CPUMode
	bpl L9cf8
	inc $ea
L9cf8
	lda $c8
	sta LTK_Save_XReg
	sta LTK_Save_YReg
	clc
	bcc L9d04
L9d03
	sec
L9d04
	pla
	sta $32
	pla
	sta $31
	rts
	
S9d0b
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9d14
	lda $8fe4
	rts
	
S9d18
	ldx #$e5
	ldy #$8f
	stx $31
	sty $32
	tax
L9d21
	ldy #$00
L9d23
	lda ($31),y
	cmp L9d49,y
	bne L9d31
	iny
	cpy #$04
	bne L9d23
	beq L9d43
L9d31
	bcs L9d43
	dex
	beq L9d45
	lda #$20
	clc
	adc $31
	sta $31
	bcc L9d21
	inc $32
	bne L9d21
L9d43
	clc
	rts
	
L9d45
	sec
	rts
	
L9d47
	.byte $00
L9d48
	.byte $00
L9d49
	.byte $00
L9d4a
	.byte $00
	.byte $00 
L9d4c
	.byte $00
