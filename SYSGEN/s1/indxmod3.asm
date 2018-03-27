;indxmod3.r.prg

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
	lda $9e64
	cmp #$ff
	bne L9613
	jmp L9792
	
L9613
	ldx #$1d
	lda #$00
L9617
	sta L95e3,x
	dex
	bpl L9617
	clc
	jsr S9733
	ldy $9e83
	bne L9629
L9626
	jmp L9783
	
L9629
	dey
	cpy $9230
	bcs L9626
	sty $9e83
	lda $9231,y
	sta L9812
	tax
	inx
	inx
	stx L9813
	ldy $9e84
	bne L9646
	jmp L9786
	
L9646
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy #$00
L9652
	jsr $fc6e
	sta L95e3,y
	iny
	cpy L9812
	beq L9663
	cpy $9e84
	bne L9652
L9663
	clc
	jsr S971a
	lda $8fe4
	bne L966f
	jmp L978f
	
L966f
	ldx #$e5
	ldy #$8f
	jsr S9756
	ldy L9812
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9748
	bne L968a
	jmp L9789
	
L968a
	ldx #$e5
	ldy #$8f
	jsr S9756
	ldy L9812
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9748
	ldx #$e5
	ldy #$8f
	jsr S9756
	bcs L9717
	bne L9717
	bit $9ec3
	bpl L96dd
	ldy L9812
	lda ($31),y
	sta L970f + 1
	pha
	iny
	lda ($31),y
	sta L970d + 1
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
	jsr S9803
	clc
	ldx #$00
	beq L9707
L96dd
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	ldy L9812
	lda ($31),y
	sta $96fe
	iny
	lda ($31),y
	sta L96f8 + 1
	jsr S9803
L96f8
	lda #$00
	jsr S97d5
	lda #$00
	jsr S97d5
	lda #$00
	jsr S97d5
L9707
	bit $9ec3
	bpl L9714
	txa
L970d
	ldx #$00
L970f
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L9714
	jmp LTK_SysRet_OldRegs 
	
L9717
	jmp L978f
	
S971a
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
L9732
	rts
	
S9733
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9747
	rts
	
S9748
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9752
	lda $8fe4
	rts
	
S9756
	stx $31
	sty $32
	tax
L975b
	ldy #$00
L975d
	lda ($31),y
	cmp L95e3,y
	bne L976c
	iny
	cpy L9812
	bne L975d
	beq L977f
L976c
	bcs L977f
	dex
	beq L9781
	lda L9813
	clc
	adc $31
	sta $31
	bcc L975b
	inc $32
	bne L975b
L977f
	clc
	rts
	
L9781
	sec
	rts
	
L9783
	lda #$01
	.byte $2c 
L9786
	lda #$02
	.byte $2c 
L9789
	lda #$03
	.byte $2c 
L978c
	lda #$04
	.byte $2c 
L978f
	lda #$05
	.byte $2c 
L9792
	lda #$06
	sta $979b
	jsr S9803
	lda #$00
	jsr S97a3
	sec
	jmp L9707
	
S97a3
	tax
	bit $9ec3
	bmi L97d4
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S97eb
	jsr $0073
	jsr S97eb
	jsr $0073
	jsr S97f1
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S97f7
L97d4
	rts
	
S97d5
	pha
	jsr $0073
	jsr S97f1
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S97f7
	rts
	
S97eb
	ldx #$9e
	ldy #$ad
	bne L97fb
S97f1
	ldx #$8b
	ldy #$b0
	bne L97fb
S97f7
	ldx #$d0
	ldy #$bb
L97fb
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S9803
	pla
	tax
	pla
	tay
	pla
	sta $32
	pla
	sta $31
	tya
	pha
	txa
	pha
	rts
	
L9812
	.byte $00
L9813
	.byte $00
