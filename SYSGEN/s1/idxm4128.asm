;idxm4128.r.prg

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
	sta L9708 + 1
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
	jmp L97f8
	
L961f
	ldx #$1d
	lda #$00
L9623
	sta L95e3,x
	dex
	bpl L9623
	clc
	jsr S9799
	ldy $9e83
	bne L9635
L9632
	jmp L97e9
	
L9635
	dey
	cpy $9230
	bcs L9632
	sty $9e83
	lda $9231,y
	sta L9895
	tax
	inx
	inx
	stx L9896
	lda $9e84
	beq L9654
	cmp L9895
	bcs L9657
L9654
	jmp L97ec
	
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
	cpy L9895
	bne L966b
	clc
	jsr S9780
	lda $8fe4
	bne L9687
	jmp L97f5
	
L9687
	ldx #$e5
	ldy #$8f
	jsr S97bc
	ldy L9895
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S97ae
	bne L96a2
	jmp L97ef
	
L96a2
	ldx #$e5
	ldy #$8f
	jsr S97bc
	ldy L9895
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S97ae
	ldx #$e5
	ldy #$8f
	jsr S97bc
	bcs L96dd
	bne L96eb
	lda L9896
	clc
	adc $31
	sta $31
	bcc L96cf
	inc $32
L96cf
	dex
	bne L96eb
	ldx $8fe1
	ldy LTK_MiscWorkspace
	bne L96e0
	txa
	bne L96e0
L96dd
	jmp L97f5
	
L96e0
	jsr S97ae
	lda #$e5
	sta $31
	lda #$8f
	sta $32
L96eb
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
	ldy L9895
	dey
L9706
	lda ($31),y
L9708
	ldx #$01
	jsr LTK_KernalCall 
	dey
	bpl L9706
	bit $9ec3
	bpl L9746
	ldy L9895
	lda ($31),y
	sta L9778 + 1
	pha
	iny
	lda ($31),y
	sta L9776 + 1
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
	jsr S9880
	clc
	ldx #$00
	beq L9770
L9746
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	ldy L9895
	lda ($31),y
	sta L9766 + 1
	iny
	lda ($31),y
	sta L9761 + 1
	jsr S9880
L9761
	lda #$00
	jsr S9844
L9766
	lda #$00
	jsr S9844
	lda #$00
	jsr S9844
L9770
	bit $9ec3
	bpl L977d
	txa
L9776
	ldx #$00
L9778
	ldy #$00
	jmp LTK_SysRet_AsIs  
	
L977d
	jmp LTK_SysRet_OldRegs 
	
S9780
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
L9798
	rts
	
S9799
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L97ad
	rts
	
S97ae
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L97b8
	lda $8fe4
	rts
	
S97bc
	stx $31
	sty $32
	tax
L97c1
	ldy #$00
L97c3
	lda ($31),y
	cmp L95e3,y
	bne L97d2
	iny
	cpy L9895
	bne L97c3
	beq L97e5
L97d2
	bcs L97e5
	dex
	beq L97e7
	lda L9896
	clc
	adc $31
	sta $31
	bcc L97c1
	inc $32
	bne L97c1
L97e5
	clc
	rts
	
L97e7
	sec
	rts
	
L97e9
	lda #$01
	.byte $2c 
L97ec
	lda #$02
	.byte $2c 
L97ef
	lda #$03
	.byte $2c 
L97f2
	lda #$04
	.byte $2c 
L97f5
	lda #$05
	.byte $2c 
L97f8
	lda #$06
	sta L9800 + 1
	jsr S9880
L9800
	lda #$00
	jsr S9809
	sec
	jmp L9770
	
S9809
	tax
	bit $9ec3
	bmi L983c
	pha
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	jsr S983d
	jsr S983d
	jsr S9862
	jsr S986e
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
	jsr S9874
L983c
	rts
	
S983d
	jsr S9862
	jsr S9868
	rts
	
S9844
	pha
	jsr S9862
	jsr S986e
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
	jsr S9874
	rts
	
S9862
	ldx #$80
	ldy #$03
	bne L9878
S9868
	ldx #$ef
	ldy #$77
	bne L9878
S986e
	ldx #$af
	ldy #$7a
	bne L9878
S9874
	ldx #$fa
	ldy #$53
L9878
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S9880
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
	
L9895
	.byte $00
L9896
	.byte $00
