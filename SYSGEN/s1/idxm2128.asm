;idxm2128.r.prg

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
	sta L9683 + 1
	lda $2f
	pha
	lda $30
	pha
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda #$ff
	sta LTK_BLKAddr_MiniSub
	cmp $9e64
	bne L9625
	jmp L99d6
	
L9625
	ldx #$1d
	lda #$00
L9629
	sta L95e3,x
	dex
	bpl L9629
	lda #$00
	sta L9a4e
	sta L9a4f
	clc
	jsr S9978
	ldy $9e83
	bne L9643
L9640
	jmp L99c7
	
L9643
	dey
	cpy $9230
	bcs L9640
	sty $9e83
	lda $9231,y
	sta L9a49
	tax
	inx
	inx
	stx L9a56
	tya
	asl a
	tay
	lda $9202,y
	sta L996f + 1
	lda $9203,y
	sta L996d + 1
	ldy $9e84
	bne L966f
	jmp L99ca
	
L966f
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L9683
	ldx #$01
	lda #$31
	jsr LTK_KernalCall 
	sta L95e3,y
	iny
	cpy L9a49
	beq L9698
	cpy $9e84
	bne L9683
L9698
	ldy L9a49
	lda $9ea4
	sta L95e3,y
	lda $9ea5
	sta L95e4,y
	clc
	jsr S996a
	lda $8fe4
	bne L96b3
	jmp L99d3
	
L96b3
	ldx #$e5
	ldy #$8f
	jsr S999a
	dex
	stx L9a54
	lda $31
	sta L9a51
	lda $32
	sta L9a50
	ldy L9a49
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	sty L9a4a
	stx L9a4b
	clc
	jsr S998d
	bne L96e3
	jmp L99cd
	
L96e3
	ldx #$e5
	ldy #$8f
	jsr S999a
	dex
	stx L9a55
	bcc L96f3
	dec L9a4e
L96f3
	lda $31
	sta L9a53
	lda $32
	sta L9a52
	ldy L9a49
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	sty L9a4c
	stx L9a4d
	clc
	jsr S998d
	ldx #$e5
	ldy #$8f
	jsr S999a
	bcs L9730
	bne L9730
	ldy L9a49
	lda ($31),y
	cmp L95e3,y
	bne L9730
	iny
	lda ($31),y
	cmp L95e3,y
	beq L9733
L9730
	jmp L99d3
	
L9733
	dex
	bne L9739
	dec L9a4f
L9739
	jsr S9864
	jsr S995d
	dec $8fe4
	bne L97a6
	lda #$00
	sta L9a4f
	jsr S9898
	jsr S98e9
	clc
	ldx L9a4b
	ldy L9a4a
	jsr S998d
	lda L9a53
	sta $31
	lda L9a52
	sta $32
	ldx L9a55
	jsr S9864
	jsr S995d
	dec $8fe4
	bne L979d
	lda #$00
	sta L9a4e
	jsr S9898
	jsr S9923
	clc
	jsr S996a
	lda L9a51
	sta $31
	lda L9a50
	sta $32
	ldx L9a54
	jsr S9864
	jsr S995d
	dec $8fe4
	sec
	jsr S996a
	jmp L97b3
	
L979d
	ldx L9a4b
	ldy L9a4a
	jmp L97ac
	
L97a6
	ldx L9a4d
	ldy L9a4c
L97ac
	sec
	jsr S998d
	jsr S9808
L97b3
	clc
	jsr S9978
	lda $9e83
	asl a
	tax
	sec
	lda $9227,x
	sbc #$01
	sta $9227,x
	lda $9226,x
	sbc #$00
	sta $9226,x
	sec
	jsr S9978
	ldx #$00
	clc
	jmp L99d9
	
S97d7
	ldx $8fe4
	dex
	jsr S97f6
	clc
	adc #$e5
	sta $2f
	tya
	adc #$8f
	sta $30
	ldy #$00
L97ea
	lda ($2f),y
	sta L95e3,y
	iny
	cpy L9a49
	bne L97ea
	rts
	
S97f6
	lda #$00
	tay
	cpx #$00
	beq L9807
L97fd
	clc
	adc L9a56
	bcc L9804
	iny
L9804
	dex
	bne L97fd
L9807
	rts
	
S9808
	jsr S97d7
	lda L9a4f
	beq L9863
	clc
	ldx L9a4b
	ldy L9a4a
	jsr S998d
	lda L9a53
	sta L982d + 1
	lda L9a52
	sta L982d + 2
	ldx L9a49
	dex
L982a
	lda L95e3,x
L982d
	sta L982d,x
	dex
	bpl L982a
	sec
	ldx L9a4b
	ldy L9a4a
	jsr S998d
	lda L9a4e
	beq L9863
	clc
	jsr S996a
	lda L9a51
	sta L9859 + 1
	lda L9a50
	sta L9859 + 2
	ldx L9a49
	dex
L9856
	lda L95e3,x
L9859
	sta L9859,x
	dex
	bpl L9856
	sec
	jsr S996a
L9863
	rts
	
S9864
	txa
	beq L9897
	lda $31
	clc
	adc L9a56
	sta $33
	lda $32
	adc #$00
	sta $34
L9875
	ldy #$00
L9877
	lda ($33),y
	sta ($31),y
	iny
	cpy L9a56
	bne L9877
	lda $33
	sta $31
	ldy $34
	sty $32
	clc
	adc L9a56
	sta $33
	tya
	adc #$00
	sta $34
	dex
	bne L9875
L9897
	rts
	
S9898
	lda LTK_MiscWorkspace
	sta L9a57
	lda $8fe1
	sta L9a58
	ldx $8fe3
	stx L9a5a
	ldy $8fe2
	sty L9a59
	bne L98b5
	txa
	beq L98c9
L98b5
	clc
	jsr S998d
	lda L9a57
	sta LTK_MiscWorkspace
	lda L9a58
	sta $8fe1
	sec
	jsr S998d
L98c9
	ldx L9a58
	ldy L9a57
	bne L98d4
	txa
	beq L98e8
L98d4
	clc
	jsr S998d
	lda L9a59
	sta $8fe2
	lda L9a5a
	sta $8fe3
	sec
	jsr S998d
L98e8
	rts
	
S98e9
	clc
	jsr S9978
	lda #$00
	sta $8fe2
	sta $8fe3
	lda $9218
	sta LTK_MiscWorkspace
	lda $9219
	sta $8fe1
	lda $9e83
	asl a
	tax
	inc $921b,x
	bne L990e
	inc $921a,x
L990e
	ldx L9a4d
	stx $9219
	ldy L9a4c
	sty $9218
	sec
	jsr S998d
	sec
	jsr S9978
	rts
	
S9923
	clc
	jsr S9978
	lda #$00
	sta $8fe2
	sta $8fe3
	lda $920c
	sta LTK_MiscWorkspace
	lda $920d
	sta $8fe1
	lda $9e83
	asl a
	tax
	inc $920f,x
	bne L9948
	inc $920e,x
L9948
	ldx L9a4b
	stx $920d
	ldy L9a4a
	sty $920c
	sec
	jsr S998d
	sec
	jsr S9978
	rts
	
S995d
	ldy #$00
	lda #$ff
L9961
	sta ($31),y
	iny
	cpy L9a56
	bne L9961
	rts
	
S996a
	lda $9e63
L996d
	ldx #$00
L996f
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$02; $8fe0 
L9977
	rts
	
S9978
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L998c
	rts
	
S998d
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9996
	lda $8fe4
	rts
	
S999a
	stx $31
	sty $32
	tax
L999f
	ldy #$00
L99a1
	lda ($31),y
	cmp L95e3,y
	bne L99b0
	iny
	cpy L9a49
	bne L99a1
	beq L99c3
L99b0
	bcs L99c3
	dex
	beq L99c5
	lda L9a56
	clc
	adc $31
	sta $31
	bcc L999f
	inc $32
	bne L999f
L99c3
	clc
	rts
	
L99c5
	sec
	rts
	
L99c7
	ldx #$01
	.byte $2c 
L99ca
	ldx #$02
	.byte $2c 
L99cd
	ldx #$03
	.byte $2c 
L99d0
	ldx #$04
	.byte $2c 
L99d3
	ldx #$05
	.byte $2c 
L99d6
	ldx #$06
	sec
L99d9
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	pla
	sta $30
	pla
	sta $2f
	txa
	bit $9ec3
	bmi L9a21
	pha
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	jsr S9a24
	jsr S9a24
	jsr S9a2b
	jsr S9a37
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
	jsr S9a3d
	jmp LTK_SysRet_OldRegs 
	
L9a21
	jmp LTK_SysRet_AsIs  
	
S9a24
	jsr S9a2b
	jsr S9a31
	rts
	
S9a2b
	ldx #$80
	ldy #$03
	bne L9a41
S9a31
	ldx #$ef
	ldy #$77
	bne L9a41
S9a37
	ldx #$af
	ldy #$7a
	bne L9a41
S9a3d
	ldx #$fa
	ldy #$53
L9a41
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
L9a49
	.byte $00
L9a4a
	.byte $00
L9a4b
	.byte $00
L9a4c
	.byte $00
L9a4d
	.byte $00
L9a4e
	.byte $00
L9a4f
	.byte $00
L9a50
	.byte $00
L9a51
	.byte $00
L9a52
	.byte $00
L9a53
	.byte $00
L9a54
	.byte $00
L9a55
	.byte $00
L9a56
	.byte $00
L9a57
	.byte $00
L9a58
	.byte $00
L9a59
	.byte $00
L9a5a
	.byte $00
