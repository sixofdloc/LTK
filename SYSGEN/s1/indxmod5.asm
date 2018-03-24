;indxmod5.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$4000 for sysgen 
	
L95e0
	jmp L9603
	
L95e3	    
	.repeat $20,$00
L9603
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda $9e64
	cmp #$ff
	bne L9619
	jmp L97e8
	
L9619
	ldx #$1d
	lda #$00
L961d
	sta L95e3,x
	dex
	bpl L961d
	clc
	jsr S977f
	ldy $9e83
	bne L962f
L962c
	jmp L97dc
	
L962f
	dey
	cpy $9230
	bcs L962c
	sty $9e83
	lda $9231,y
	sta L986e
	tax
	inx
	inx
	stx L986f
	lda $9e84
	beq L964e
	cmp L986e
	bcs L9651
L964e
	jmp L97df
	
L9651
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy #$00
L965d
	jsr $fc6e
	sta L95e3,y
	iny
	cpy L986e
	bne L965d
	clc
	jsr S9766
	lda $8fe4
	bne L9675
	jmp L97e5
	
L9675
	ldx #$e5
	ldy #$8f
	jsr S97af
	jsr S97a2
	jsr S9794
	bne L9687
	jmp L97e2
	
L9687
	ldx #$e5
	ldy #$8f
	jsr S97af
	jsr S97a2
	jsr S9794
	ldx #$e5
	ldy #$8f
	jsr S97af
	bcs L96dc
	lda $31
	sec
	sbc L986f
	sta $31
	lda $32
	sbc #$00
	sta $32
	cpx $8fe4
	bne L96dc
	ldx $8fe3
	ldy $8fe2
	bne L96be
	txa
	bne L96be
	jmp L97e5
	
L96be
	jsr S9794
	tax
	lda #$00
	tay
	dex
	beq L96d2
L96c8
	clc
	adc L986f
	bcc L96cf
	iny
L96cf
	dex
	bne L96c8
L96d2
	clc
	adc #$e5
	sta $31
	tya
	adc #$8f
	sta $32
L96dc
	lda $31
	sta $33
	lda $32
	sta $34
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy L986e
	dey
L96f2
	lda ($33),y
	jsr $fc6b
	dey
	bpl L96f2
	bit $9ec3
	bpl L972c
	ldy L986e
	lda ($33),y
	sta $975f
	pha
	iny
	lda ($33),y
	sta $975d
	pha
	lda $9ec5
	sta $31
	lda $9ec4
	sta $32
	ldy #$06
	pla
	jsr $fc6b
	iny
	pla
	jsr $fc6b
	jsr S9859
	clc
	ldx #$00
	beq L9756
L972c
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	ldy L986e
	lda ($33),y
	sta $974d
	iny
	lda ($33),y
	sta $9748
	jsr S9859
	lda #$00
	jsr S982b
	lda #$00
	jsr S982b
	lda #$00
	jsr S982b
L9756
	bit $9ec3
	bpl L9763
	txa
	ldx #$00
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L9763
	jmp LTK_SysRet_OldRegs 
	
S9766
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
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$02; $8fe0 
L977e
	rts
	
S977f
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9793
	rts
	
S9794
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L979e
	lda $8fe4
	rts
	
S97a2
	ldy L986e
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	rts
	
S97af
	stx $31
	sty $32
	tax
L97b4
	ldy #$00
L97b6
	lda ($31),y
	cmp L95e3,y
	bne L97c5
	iny
	cpy L986e
	bne L97b6
	beq L97d8
L97c5
	bcs L97d8
	dex
	beq L97da
	lda L986f
	clc
	adc $31
	sta $31
	bcc L97b4
	inc $32
	bne L97b4
L97d8
	clc
	rts
	
L97da
	sec
	rts
	
L97dc
	lda #$01
	.byte $2c 
L97df
	lda #$02
	.byte $2c 
L97e2
	lda #$03
	.byte $2c 
L97e5
	lda #$05
	.byte $2c 
L97e8
	lda #$06
	sta $97f1
	jsr S9859
	lda #$00
	jsr S97f9
	sec
	jmp L9756
	
S97f9
	tax
	bit $9ec3
	bmi L982a
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S9841
	jsr $0073
	jsr S9841
	jsr $0073
	jsr S9847
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S984d
L982a
	rts
	
S982b
	pha
	jsr $0073
	jsr S9847
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S984d
	rts
	
S9841
	ldx #$9e
	ldy #$ad
	bne L9851
S9847
	ldx #$8b
	ldy #$b0
	bne L9851
S984d
	ldx #$d0
	ldy #$bb
L9851
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S9859
	pla
	tax
	pla
	tay
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	tya
	pha
	txa
	pha
	rts
	
L986e
	.byte $00
L986f
	.byte $00
