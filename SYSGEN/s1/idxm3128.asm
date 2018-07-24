;idxm3128.r.prg

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
	sta L965d + 1
	lda $31
	pha
	lda $32
	pha
	lda $9e64
	cmp #$ff
	bne L9616
	jmp L97b2
	
L9616
	ldx #$1d
	lda #$00
L961a
	sta L95e3,x
	dex
	bpl L961a
	clc
	jsr S9753
	ldy $9e83
	bne L962c
L9629
	jmp L97a3
	
L962c
	dey
	cpy $9230
	bcs L9629
	sty $9e83
	lda $9231,y
	sta L9849
	tax
	inx
	inx
	stx L984a
	ldy $9e84
	bne L9649
	jmp L97a6
	
L9649
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L965d
	ldx #$01
	lda #$31
	jsr LTK_KernalCall 
	sta L95e3,y
	iny
	cpy L9849
	beq L9672
	cpy $9e84
	bne L965d
L9672
	clc
	jsr S973a
	lda $8fe4
	bne L967e
	jmp L97af
	
L967e
	ldx #$e5
	ldy #$8f
	jsr S9776
	ldy L9849
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9768
	bne L9699
	jmp L97a9
	
L9699
	ldx #$e5
	ldy #$8f
	jsr S9776
	ldy L9849
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S9768
	ldx #$e5
	ldy #$8f
	jsr S9776
	bcs L9737
	bne L9737
	bit $9ec3
	bpl L96fd
	ldy L9849
	lda ($31),y
	sta L972f + 1
	pha
	iny
	lda ($31),y
	sta L972d + 1
	pha
	lda $9ec5
	sta $31
	lda $9ec4
	sta $32
	ldx #$77
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	lda #$31
	sta $02b9
	ldy #$06
	pla
	ldx #$00
	jsr LTK_KernalCall 
	iny
	pla
	ldx #$00
	jsr LTK_KernalCall 
	jsr S983a
	clc
	ldx #$00
	beq L9727
L96fd
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	ldy L9849
	lda ($31),y
	sta L971d + 1
	iny
	lda ($31),y
	sta L9718 + 1
	jsr S983a
L9718
	lda #$00
	jsr S97fe
L971d
	lda #$00
	jsr S97fe
	lda #$00
	jsr S97fe
L9727
	bit $9ec3
	bpl L9734
	txa
L972d
	ldx #$00
L972f
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L9734
	jmp LTK_SysRet_OldRegs 
	
L9737
	jmp L97af
	
S973a
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
L9752
	rts
	
S9753
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9767
	rts
	
S9768
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9772
	lda $8fe4
	rts
	
S9776
	stx $31
	sty $32
	tax
L977b
	ldy #$00
L977d
	lda ($31),y
	cmp L95e3,y
	bne L978c
	iny
	cpy L9849
	bne L977d
	beq L979f
L978c
	bcs L979f
	dex
	beq L97a1
	lda L984a
	clc
	adc $31
	sta $31
	bcc L977b
	inc $32
	bne L977b
L979f
	clc
	rts
	
L97a1
	sec
	rts
	
L97a3
	lda #$01
	.byte $2c 
L97a6
	lda #$02
	.byte $2c 
L97a9
	lda #$03
	.byte $2c 
L97ac
	lda #$04
	.byte $2c 
L97af
	lda #$05
	.byte $2c 
L97b2
	lda #$06
	sta L97ba + 1
	jsr S983a
L97ba
	lda #$00
	jsr S97c3
	sec
	jmp L9727
	
S97c3
	tax
	bit $9ec3
	bmi L97f6
	pha
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	jsr S97f7
	jsr S97f7
	jsr S981c
	jsr S9828
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
	jsr S982e
L97f6
	rts
	
S97f7
	jsr S981c
	jsr S9822
	rts
	
S97fe
	pha
	jsr S981c
	jsr S9828
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
	jsr S982e
	rts
	
S981c
	ldx #$80
	ldy #$03
	bne L9832
S9822
	ldx #$ef
	ldy #$77
	bne L9832
S9828
	ldx #$af
	ldy #$7a
	bne L9832
S982e
	ldx #$fa
	ldy #$53
L9832
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S983a
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
	
L9849
	.byte $00
L984a
	.byte $00
