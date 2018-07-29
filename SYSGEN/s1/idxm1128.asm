;idxm1128.r.prg

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
	lda #$ff
	cmp $9e64
	bne L960d
	jmp L9b39
	
L960d
	clc
	jsr S99bc
	ldy $9e83
	bne L9619
L9616
	jmp L9b2d
	
L9619
	dey
	cpy $9230
	bcs L9616
	sty $9e83
	tya
	tax
	asl a
	tay
	lda $9202,y
	sta L99b3 + 1
	lda $9203,y
	sta L99b1 + 1
	lda $9226,y
	cmp $9224
	bcc L9647
	bne L9644
	lda $9227,y
	cmp $9225
	bcc L9647
L9644
	jmp L9b33
	
L9647
	lda $9231,x
	sta L9bac
	tay
	iny
	iny
	sty L9bbe
	lda $9236,x
	sta L9bad
	ldy $9e84
	bne L9661
	jmp L9b30
	
L9661
	lda #$00
	sta L9bb2
	ldy L9bac
	lda $9ea4
	sta L95e3,y
	lda $9ea5
	sta L95e4,y
	clc
	jsr S99ae
	lda $8fe4
	bne L9681
	jmp L98f2
	
L9681
	ldx #$e5
	ldy #$8f
	jsr S9a80
	lda $31
	sta L9bb5
	lda $32
	sta L9bb4
	jsr S99fb
	sty L9bae
	stx L9baf
	clc
	jsr S99d1
	sta L9bb3
	ldx #$e5
	ldy #$8f
	jsr S9a80
	bcc L96ae
	dec L9bb2
L96ae
	lda $31
	sta L9bb7
	lda $32
	sta L9bb6
	jsr S99fb
	sty L9bb0
	stx L9bb1
	clc
	jsr S99da
	ldx #$e5
	ldy #$8f
	jsr S9a80
	bcs L96d3
	bne L96d3
	jmp L9b36
	
L96d3
	lda $8fe4
	cmp L9bad
	beq L96de
	jmp L994d
	
L96de
	clc
	jsr S99bc
	lda $9e83
	asl a
	tay
	lda $921a,y
	bne L96f1
	lda $921b,y
	beq L9703
L96f1
	lda L9bb3
	cmp L9bad
	bne L9706
	lda $920e,y
	bne L9706
	lda $920f,y
	bne L9706
L9703
	jmp L9b33
	
L9706
	jsr S9a08
	lda L9bb0
	sta L9bc1
	lda L9bb1
	sta L9bc2
	jsr S9787
	jsr S9961
	jsr S98b7
	lda L9bb3
	cmp L9bad
	beq L9729
	jmp L975a
	
L9729
	jsr S9a3b
	lda L9bae
	sta L9bc1
	lda L9baf
	sta L9bc2
	clc
	jsr S99d1
	jsr S9787
	jsr S98b7
	clc
	jsr S99ae
	ldx #$e5
	ldy #$8f
	lda $8fe4
	jsr S9aad
	inc $8fe4
	sec
	jsr S99ae
	jmp L976c
	
L975a
	clc
	jsr S99d1
	ldx #$e5
	ldy #$8f
	jsr S9aad
	inc $8fe4
	sec
	jsr S99d1
L976c
	clc
	jsr S99bc
	lda $9e83
	asl a
	tax
	inc $9227,x
	bne L977d
	inc $9226,x
L977d
	sec
	jsr S99bc
	ldx #$00
	clc
	jmp L9b3c
	
S9787
	lda #$e5
	sta $2f
	lda #$8f
	sta $30
	lda #$93
	sta L97be + 2
	lda L9bad
	lsr a
	adc #$00
	sta $93e4
	tax
	jsr S98e4
	sta L9bbd
	sty L9bbc
	clc
	adc $2f
	sta $31
	tya
	adc $30
	sta $32
	ldy #$00
	sty L9bc3
	sty L9bc4
	lda $30
	pha
L97bc
	lda ($2f),y
L97be
	sta $93e5,y
	iny
	bne L97c9
	inc $30
	inc L97be + 2
L97c9
	inc L9bc4
	bne L97d1
	inc L9bc3
L97d1
	lda L9bc3
	cmp L9bbc
	bne L97bc
	lda L9bc4
	cmp L9bbd
	bne L97bc
	pla
	sta $30
	lda $8fe2
	sta $93e2
	lda $8fe3
	sta $93e3
	lda L9bc1
	sta LTK_MiniSubExeArea 
	lda L9bc2
	sta $93e1
	lda L9bbf
	sta $8fe2
	lda L9bc0
	sta $8fe3
	lda L9bad
	sec
	sbc $93e4
	sta $8fe4
	tax
	jsr S98e4
	sta L9bbd
	sta L9bbc
	ldx $30
	clc
	adc $2f
	bcc L9824
	inx
L9824
	sta $33
	stx $34
	ldy #$00
L982a
	lda ($31),y
	sta ($2f),y
	iny
	dec L9bbd
	bne L982a
	lda #$ff
	ldy #$00
L9838
	sta ($33),y
	iny
	dec L9bbc
	bne L9838
	lda $93e4
	ldx #$e5
	ldy #$93
	jsr S9a80
	bcc L985b
	lda $8fe4
	ldx $2f
	ldy $30
	jsr S9aad
	inc $8fe4
	bne L986d
L985b
	lda $93e4
	ldx #$e5
	ldy #$93
	jsr S9aad
	lda #$00
	sta L9bb8
	inc $93e4
L986d
	lda $9e63
	ldx L9bc0
	ldy L9bbf
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L987d
	ldx L9bc2
	ldy L9bc1
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L988a
	ldx $93e3
	ldy $93e2
	txa
	bne L9896
	tya
	beq L98b6
L9896
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L98a0
	lda L9bbf
	sta LTK_MiscWorkspace
	lda L9bc0
	sta $8fe1
	lda $9e63
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L98b6
	rts
	
S98b7
	ldx $93e4
	dex
	jsr S98e4
	clc
	adc #$e5
	sta $2f
	tya
	adc #$93
	sta $30
	ldy L9bac
	lda L9bbf
	sta ($2f),y
	iny
	lda L9bc0
	sta ($2f),y
	ldy #$00
L98d8
	lda ($2f),y
	sta L95e3,y
	iny
	cpy L9bbe
	bne L98d8
	rts
	
S98e4
	lda #$00
	tay
L98e7
	clc
	adc L9bbe
	bcc L98ee
	iny
L98ee
	dex
	bne L98e7
	rts
	
L98f2
	jsr S9a3b
	stx L9baf
	sty L9bae
	tya
	pha
	txa
	pha
	clc
	jsr S99ae
	ldx L9bac
	pla
	sta $8fe6,x
	pla
	sta $8fe5,x
	dex
L990f
	lda L95e3,x
	sta $8fe5,x
	dex
	bpl L990f
	inc $8fe4
	sec
	jsr S99ae
	jsr S9a08
	stx L9bb1
	sty L9bb0
	txa
	ldx L9bac
	sta $8fe6,x
	tya
	sta $8fe5,x
	sec
	jsr S99d1
	ldx L9bac
	lda L95e3,x
	sta $8fe5,x
	lda L95e4,x
	sta $8fe6,x
	sec
	jsr S99da
	jmp L976c
	
L994d
	ldx #$e5
	ldy #$8f
	jsr S9aad
	inc $8fe4
	sec
	jsr S99da
	jsr S9961
	jmp L976c
	
S9961
	lda L9bb8
	beq L99ad
	clc
	jsr S99d1
	lda L9bb7
	sta L997d + 1
	lda L9bb6
	sta L997d + 2
	ldx L9bac
	dex
L997a
	lda L95e3,x
L997d
	sta L997d,x
	dex
	bpl L997a
	sec
	jsr S99d1
	lda L9bb2
	beq L99ad
	clc
	jsr S99ae
	lda L9bb5
	sta L99a3 + 1
	lda L9bb4
	sta L99a3 + 2
	ldx L9bac
	dex
L99a0
	lda L95e3,x
L99a3
	sta L99a3,x
	dex
	bpl L99a0
	sec
	jsr S99ae
L99ad
	rts
	
S99ae
	lda $9e63
L99b1
	ldx #$00
L99b3
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$02; $8fe0
L99bb
	rts
	
S99bc
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L99d0
	rts
	
S99d1
	ldx L9baf
	ldy L9bae
	jmp L99e0
	
S99da
	ldx L9bb1
	ldy L9bb0
L99e0
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L99e9
	lda $8fe4
	rts
	
S99ed
	lda $9e63
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L99f7
	lda LTK_MiniSubExeArea 
	rts
	
S99fb
	ldy L9bac
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	rts
	
S9a08
	clc
	jsr S99bc
	ldx $9219
	ldy $9218
	bne L9a18
	sec
	txa
	beq L9a7f
L9a18
	jsr S99ed
	sta $9218
	lda $93e1
	sta $9219
	txa
	pha
	lda $9e83
	asl a
	tax
	lda $921b,x
	sec
	sbc #$01
	sta $921b,x
	bcs L9a6c
	dec $921a,x
	bcc L9a6c
S9a3b
	clc
	jsr S99bc
	ldx $920d
	ldy $920c
	bne L9a4b
	sec
	txa
	beq L9a7f
L9a4b
	jsr S99ed
	sta $920c
	lda $93e1
	sta $920d
	txa
	pha
	lda $9e83
	asl a
	tax
	lda $920f,x
	sec
	sbc #$01
	sta $920f,x
	bcs L9a6c
	dec $920e,x
L9a6c
	pla
	tax
	stx L9bc0
	sty L9bbf
	sec
	jsr S99bc
	ldx L9bc0
	ldy L9bbf
	clc
L9a7f
	rts
	
S9a80
	stx $31
	sty $32
	tax
L9a85
	ldy #$00
L9a87
	lda ($31),y
	cmp L95e3,y
	bne L9a96
	iny
	cpy L9bac
	bne L9a87
	beq L9aa9
L9a96
	bcs L9aa9
	dex
	beq L9aab
	lda L9bbe
	clc
	adc $31
	sta $31
	bcc L9a85
	inc $32
	bne L9a85
L9aa9
	clc
	rts
	
L9aab
	sec
	rts
	
S9aad
	sta L9bb9
	stx L9bbb
	sty L9bba
	ldx #$ff
	stx L9bb8
	sec
	sbc #$01
	ldy #$00
	tax
	beq L9ac6
	jsr S98e4
L9ac6
	clc
	adc L9bbb
	sta $31
	tya
	adc L9bba
	sta $32
	lda L9bbe
	clc
	adc $31
	sta $33
	lda #$00
	adc $32
	sta $34
L9ae0
	ldx L9bac
	ldy #$00
L9ae5
	lda L95e3,y
	cmp ($31),y
	bne L9af5
	iny
	dex
	bne L9ae5
	stx L9bb8
	beq L9b1f
L9af5
	bcs L9b1f
	ldy #$00
	sty L9bb8
L9afc
	lda ($31),y
	sta ($33),y
	iny
	cpy L9bbe
	bne L9afc
	lda $31
	sta $33
	lda $32
	sta $34
	lda $31
	sec
	sbc L9bbe
	sta $31
	bcs L9b1a
	dec $32
L9b1a
	dec L9bb9
	bne L9ae0
L9b1f
	ldy #$00
L9b21
	lda L95e3,y
	sta ($33),y
	iny
	cpy L9bbe
	bne L9b21
	rts
	
L9b2d
	ldx #$01
	.byte $2c 
L9b30
	ldx #$02
	.byte $2c 
L9b33
	ldx #$04
	.byte $2c 
L9b36
	ldx #$05
	.byte $2c 
L9b39
	ldx #$06
	sec
L9b3c
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
	bmi L9b84
	pha
	lda $9ec5
	sta $3d
	lda $9ec4
	sta $3e
	jsr S9b87
	jsr S9b87
	jsr S9b8e
	jsr S9b9a
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
	jsr S9ba0
	jmp LTK_SysRet_OldRegs 
	
L9b84
	jmp LTK_SysRet_AsIs  
	
S9b87
	jsr S9b8e
	jsr S9b94
	rts
	
S9b8e
	ldx #$80
	ldy #$03
	bne L9ba4
S9b94
	ldx #$ef
	ldy #$77
	bne L9ba4
S9b9a
	ldx #$af
	ldy #$7a
	bne L9ba4
S9ba0
	ldx #$fa
	ldy #$53
L9ba4
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
L9bac
	.byte $00
L9bad
	.byte $00
L9bae
	.byte $00
L9baf
	.byte $00
L9bb0
	.byte $00
L9bb1
	.byte $00
L9bb2
	.byte $00
L9bb3
	.byte $00
L9bb4
	.byte $00
L9bb5
	.byte $00
L9bb6
	.byte $00
L9bb7
	.byte $00
L9bb8
	.byte $00
L9bb9
	.byte $00
L9bba
	.byte $00
L9bbb
	.byte $00
L9bbc
	.byte $00
L9bbd
	.byte $00
L9bbe
	.byte $00
L9bbf
	.byte $00
L9bc0
	.byte $00
L9bc1
	.byte $00
L9bc2
	.byte $00
L9bc3
	.byte $00
L9bc4
	.byte $00
