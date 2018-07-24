;idxm5128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

     *=LTK_DOSOverlay 

L95e0
	jmp L9603
	
L95e3
	.byte $00
L95e4	       
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00 
L9603
	sta L970b + 1
	sta L966b + 1
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
	bne L961f
	jmp L9805
	
L961f
	ldx #$1d
	lda #$00
L9623
	sta L95e3,x
	dex
	bpl L9623
	clc
	jsr S979c
	ldy $9e83
	bne L9635
L9632
	jmp L97f9
	
L9635
	dey
	cpy $9230
	bcs L9632
	sty $9e83
	lda $9231,y
	sta L98a2
	tax
	inx
	inx
	stx L98a3
	lda $9e84
	beq L9654
	cmp L98a2
	bcs L9657
L9654
	jmp L97fc
	
L9657
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L966b
	ldx #$01
	lda #$31
	jsr LTK_KernalCall 
	sta L95e3,y
	iny
	cpy L98a2
	bne L966b
	clc
	jsr S9783
	lda $8fe4
	bne L9687
	jmp L9802
	
L9687
	ldx #$e5
	ldy #$8f
	jsr S97cc
	jsr S97bf
	jsr S97b1
	bne L9699
	jmp L97ff
	
L9699
	ldx #$e5
	ldy #$8f
	jsr S97cc
	jsr S97bf
	jsr S97b1
	ldx #$e5
	ldy #$8f
	jsr S97cc
	bcs L96ee
	lda $31
	sec
	sbc L98a3
	sta $31
	lda $32
	sbc #$00
	sta $32
	cpx $8fe4
	bne L96ee
	ldx $8fe3
	ldy $8fe2
	bne L96d0
	txa
	bne L96d0
	jmp L9802
	
L96d0
	jsr S97b1
	tax
	lda #$00
	tay
	dex
	beq L96e4
L96da
	clc
	adc L98a3
	bcc L96e1
	iny
L96e1
	dex
	bne L96da
L96e4
	clc
	adc #$e5
	sta $31
	tya
	adc #$8f
	sta $32
L96ee
	lda $9ea3
	sta $33
	lda $9e85
	sta $34
	ldx #$77
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	lda #$33
	sta $02b9
	ldy L98a2
	dey
L9709
	lda ($31),y
L970b
	ldx #$01
	jsr LTK_KernalCall 
	dey
	bpl L9709
	bit $9ec3
	bpl L9749
	ldy L98a2
	lda ($31),y
	sta L977b + 1
	pha
	iny
	lda ($31),y
	sta L9779 + 1
	pha
	lda $9ec5
	sta $33
	lda $9ec4
	sta $34
	ldy #$06
	ldx #$00
	pla
	jsr LTK_KernalCall 
	iny
	pla
	ldx #$00
	jsr LTK_KernalCall 
	jsr S988d
	clc
	ldx #$00
	beq L9773
L9749
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	ldy L98a2
	lda ($31),y
	sta L9769 + 1
	iny
	lda ($31),y
	sta L9764 + 1
	jsr S988d
L9764
	lda #$00
	jsr S9851
L9769
	lda #$00
	jsr S9851
	lda #$00
	jsr S9851
L9773
	bit $9ec3
	bpl L9780
	txa
L9779
	ldx #$00
L977b
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L9780
	jmp LTK_SysRet_OldRegs 
	
S9783
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
L979b
	rts
	
S979c
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L97b0
	rts
	
S97b1
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L97bb
	lda $8fe4
	rts
	
S97bf
	ldy L98a2
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	rts
	
S97cc
	stx $31
	sty $32
	tax
L97d1
	ldy #$00
L97d3
	lda ($31),y
	cmp L95e3,y
	bne L97e2
	iny
	cpy L98a2
	bne L97d3
	beq L97f5
L97e2
	bcs L97f5
	dex
	beq L97f7
	lda L98a3
	clc
	adc $31
	sta $31
	bcc L97d1
	inc $32
	bne L97d1
L97f5
	clc
	rts
	
L97f7
	sec
	rts
	
L97f9
	lda #$01
	.byte $2c 
L97fc
	lda #$02
	.byte $2c 
L97ff
	lda #$03
	.byte $2c 
L9802
	lda #$05
	.byte $2c 
L9805
	lda #$06
	sta L980d + 1
	jsr S988d
L980d
	lda #$00
	jsr S9816
	sec
	jmp L9773
	
S9816
	tax
	bit $9ec3
	bmi L9849
	pha
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	jsr S984a
	jsr S984a
	jsr S986f
	jsr S987b
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
	jsr S9881
L9849
	rts
	
S984a
	jsr S986f
	jsr S9875
	rts
	
S9851
	pha
	jsr S986f
	jsr S987b
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
	jsr S9881
	rts
	
S986f
	ldx #$80
	ldy #$03
	bne L9885
S9875
	ldx #$ef
	ldy #$77
	bne L9885
S987b
	ldx #$af
	ldy #$7a
	bne L9885
S9881
	ldx #$fa
	ldy #$53
L9885
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S988d
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
	
L98a2
	.byte $00
L98a3
	.byte $00
