;indxmod4.r.prg

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
	jmp L97db
	
L9619
	ldx #$1d
	lda #$00
L961d
	sta L95e3,x
	dex
	bpl L961d
	clc
	jsr S977c
	ldy $9e83
	bne L962f
L962c
	jmp L97cc
	
L962f
	dey
	cpy $9230
	bcs L962c
	sty $9e83
	lda $9231,y
	sta L9861
	tax
	inx
	inx
	stx L9862
	lda $9e84
	beq L964e
	cmp L9861
	bcs L9651
L964e
	jmp L97cf
	
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
	cpy L9861
	bne L965d
	clc
	jsr S9763
	lda $8fe4
	bne L9675
	jmp L97d8
	
L9675
	ldx #$e5
	ldy #$8f
	jsr S979f
	ldy L9861
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9791
	bne L9690
	jmp L97d2
	
L9690
	ldx #$e5
	ldy #$8f
	jsr S979f
	ldy L9861
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9791
	ldx #$e5
	ldy #$8f
	jsr S979f
	bcs L96cb
	bne L96d9
	lda L9862
	clc
	adc $31
	sta $31
	bcc L96bd
	inc $32
L96bd
	dex
	bne L96d9
	ldx $8fe1
	ldy LTK_MiscWorkspace
	bne L96ce
	txa
	bne L96ce
L96cb
	jmp L97d8
	
L96ce
	jsr S9791
	lda #$e5
	sta $31
	lda #$8f
	sta $32
L96d9
	lda $31
	sta $33
	lda $32
	sta $34
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy L9861
	dey
L96ef
	lda ($33),y
	jsr $fc6b
	dey
	bpl L96ef
	bit $9ec3
	bpl L9729
	ldy L9861
	lda ($33),y
	sta L975b + 1
	pha
	iny
	lda ($33),y
	sta L9759 + 1
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
	jsr S984c
	clc
	ldx #$00
	beq L9753
L9729
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	ldy L9861
	lda ($33),y
	sta $974a
	iny
	lda ($33),y
	sta L9744 + 1
	jsr S984c
L9744
	lda #$00
	jsr S981e
	lda #$00
	jsr S981e
	lda #$00
	jsr S981e
L9753
	bit $9ec3
	bpl L9760
	txa
L9759
	ldx #$00
L975b
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L9760
	jmp LTK_SysRet_OldRegs 
	
S9763
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
L977b
	rts
	
S977c
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9790
	rts
	
S9791
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L979b
	lda $8fe4
	rts
	
S979f
	stx $31
	sty $32
	tax
L97a4
	ldy #$00
L97a6
	lda ($31),y
	cmp L95e3,y
	bne L97b5
	iny
	cpy L9861
	bne L97a6
	beq L97c8
L97b5
	bcs L97c8
	dex
	beq L97ca
	lda L9862
	clc
	adc $31
	sta $31
	bcc L97a4
	inc $32
	bne L97a4
L97c8
	clc
	rts
	
L97ca
	sec
	rts
	
L97cc
	lda #$01
	.byte $2c 
L97cf
	lda #$02
	.byte $2c 
L97d2
	lda #$03
	.byte $2c
	lda #$04
	.byte $2c 
L97d8
	lda #$05
	.byte $2c
L97db
	lda #$06
	sta L97e3 + 1
	jsr S984c
L97e3
	lda #$00
	jsr S97ec
	sec
	jmp L9753
	
S97ec
	tax
	bit $9ec3
	bmi L981d
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S9834
	jsr $0073
	jsr S9834
	jsr $0073
	jsr S983a
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S9840
L981d
	rts
	
S981e
	pha
	jsr $0073
	jsr S983a
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S9840
	rts
	
S9834
	ldx #$9e
	ldy #$ad
	bne L9844
S983a
	ldx #$8b
	ldy #$b0
	bne L9844
S9840
	ldx #$d0
	ldy #$bb
L9844
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S984c
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
	
L9861
	.byte $00
L9862
	.byte $00
