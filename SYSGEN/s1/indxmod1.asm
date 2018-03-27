;indxmod1.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$4000 for sysgen
 
L95e0
	jmp L9603
	
L95e3
	.byte $00
L95e4
	.byte $00
L95e5
	.byte $00
L95e6
	.byte $00
L95e7
	.byte $00
L95e8
	.byte $00
L95e9
	.byte $00
L95ea
	.byte $00
L95eb
	.byte $00
L95ec
	.byte $00
L95ed
	.byte $00
L95ee
	.byte $00
L95ef
	.byte $00
L95f0
	.byte $00
L95f1
	.byte $00
L95f2
	.byte $00
L95f3
	.byte $00
L95f4
	.byte $00
L95f5
	.byte $00
L95f6
	.byte $00
L95f7
	.byte $00
L95f8
	.byte $00
L95f9
	.byte $00
L95fa
	.byte $00
L95fb
	.byte $00
L95fc
	.byte $00
L95fd
	.byte $00
L95fe
	.byte $00
L95ff
	.byte $00
L9600
	.byte $00
L9601
	.byte $00
L9602
	.byte $00
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
	sta $99b4
	lda $9203,y
	sta $99b2
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
	sta L9b9d
	tay
	iny
	iny
	sty L9baf
	lda $9236,x
	sta L9b9e
	ldy $9e84
	bne L9661
	jmp L9b30
	
L9661
	lda #$00
	sta L9ba3
	ldy L9b9d
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
	sta L9ba6
	lda $32
	sta L9ba5
	jsr S99fb
	sty L9b9f
	stx L9ba0
	clc
	jsr S99d1
	sta L9ba4
	ldx #$e5
	ldy #$8f
	jsr S9a80
	bcc L96ae
	dec L9ba3
L96ae
	lda $31
	sta L9ba8
	lda $32
	sta L9ba7
	jsr S99fb
	sty L9ba1
	stx L9ba2
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
	cmp L9b9e
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
	lda L9ba4
	cmp L9b9e
	bne L9706
	lda $920e,y
	bne L9706
	lda $920f,y
	bne L9706
L9703
	jmp L9b33
	
L9706
	jsr S9a08
	lda L9ba1
	sta L9bb2
	lda L9ba2
	sta L9bb3
	jsr S9787
	jsr S9961
	jsr S98b7
	lda L9ba4
	cmp L9b9e
	beq L9729
	jmp L975a
	
L9729
	jsr S9a3b
	lda L9b9f
	sta L9bb2
	lda L9ba0
	sta L9bb3
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
	sta $97c0
	lda L9b9e
	lsr a
	adc #$00
	sta $93e4
	tax
	jsr S98e4
	sta L9bae
	sty L9bad
	clc
	adc $2f
	sta $31
	tya
	adc $30
	sta $32
	ldy #$00
	sty L9bb4
	sty L9bb5
	lda $30
	pha
L97bc
	lda ($2f),y
	sta $93e5,y
	iny
	bne L97c9
	inc $30
	inc $97c0
L97c9
	inc L9bb5
	bne L97d1
	inc L9bb4
L97d1
	lda L9bb4
	cmp L9bad
	bne L97bc
	lda L9bb5
	cmp L9bae
	bne L97bc
	pla
	sta $30
	lda $8fe2
	sta $93e2
	lda $8fe3
	sta $93e3
	lda L9bb2
	sta LTK_MiniSubExeArea 
	lda L9bb3
	sta $93e1
	lda L9bb0
	sta $8fe2
	lda L9bb1
	sta $8fe3
	lda L9b9e
	sec
	sbc $93e4
	sta $8fe4
	tax
	jsr S98e4
	sta L9bae
	sta L9bad
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
	dec L9bae
	bne L982a
	lda #$ff
	ldy #$00
L9838
	sta ($33),y
	iny
	dec L9bad
L983e
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
	sta L9ba9
	inc $93e4
L986d
	lda $9e63
	ldx L9bb1
	ldy L9bb0
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L987d
	ldx L9bb3
	ldy L9bb2
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
	lda L9bb0
	sta LTK_MiscWorkspace
	lda L9bb1
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
	ldy L9b9d
	lda L9bb0
	sta ($2f),y
	iny
	lda L9bb1
	sta ($2f),y
	ldy #$00
L98d8
	lda ($2f),y
	sta L95e3,y
	iny
	cpy L9baf
	bne L98d8
	rts
	
S98e4
	lda #$00
	tay
L98e7
	clc
	adc L9baf
	bcc L98ee
	iny
L98ee
	dex
	bne L98e7
	rts
	
L98f2
	jsr S9a3b
	stx L9ba0
	sty L9b9f
	tya
	pha
	txa
	pha
	clc
	jsr S99ae
	ldx L9b9d
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
	stx L9ba2
	sty L9ba1
	txa
	ldx L9b9d
	sta $8fe6,x
	tya
	sta $8fe5,x
	sec
	jsr S99d1
	ldx L9b9d
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
	lda L9ba9
	beq L99ad
	clc
	jsr S99d1
	lda L9ba8
	sta L997d + 1
	lda L9ba7
	sta L997d + 2
	ldx L9b9d
	dex
L997a
	lda L95e3,x
L997d
	sta L997d,x
	dex
	bpl L997a
	sec
	jsr S99d1
	lda L9ba3
	beq L99ad
	clc
	jsr S99ae
	lda L9ba6
	sta L99a3 + 1
	lda L9ba5
	sta L99a3 + 2
	ldx L9b9d
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
	ldx #$00
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
	ldx L9ba0
	ldy L9b9f
	jmp L99e0
	
S99da
	ldx L9ba2
	ldy L9ba1
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
	ldy L9b9d
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
	stx L9bb1
	sty L9bb0
	sec
	jsr S99bc
	ldx L9bb1
	ldy L9bb0
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
	cpy L9b9d
	bne L9a87
	beq L9aa9
L9a96
	bcs L9aa9
	dex
	beq L9aab
	lda L9baf
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
	sta L9baa
	stx L9bac
	sty L9bab
	ldx #$ff
	stx L9ba9
	sec
	sbc #$01
	ldy #$00
	tax
	beq L9ac6
	jsr S98e4
L9ac6
	clc
	adc L9bac
	sta $31
	tya
	adc L9bab
	sta $32
	lda L9baf
	clc
	adc $31
	sta $33
	lda #$00
	adc $32
	sta $34
L9ae0
	ldx L9b9d
	ldy #$00
L9ae5
	lda L95e3,y
	cmp ($31),y
	bne L9af5
	iny
	dex
	bne L9ae5
	stx L9ba9
	beq L9b1f
L9af5
	bcs L9b1f
	ldy #$00
	sty L9ba9
L9afc
	lda ($31),y
	sta ($33),y
	iny
	cpy L9baf
	bne L9afc
	lda $31
	sta $33
	lda $32
	sta $34
	lda $31
	sec
	sbc L9baf
	sta $31
	bcs L9b1a
	dec $32
L9b1a
	dec L9baa
	bne L9ae0
L9b1f
	ldy #$00
L9b21
	lda L95e3,y
	sta ($33),y
	iny
	cpy L9baf
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
L9b36 = * + 1       
	bit $05a2
L9b39 = * + 1       
	bit $06a2
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
	bmi L9b82
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S9b85
	jsr $0073
	jsr S9b85
	jsr $0073
	jsr S9b8b
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S9b91
	jmp LTK_SysRet_OldRegs 
	
L9b82
	jmp LTK_SysRet_AsIs  
	
S9b85
	ldx #$9e
	ldy #$ad
	bne L9b95
S9b8b
	ldx #$8b
	ldy #$b0
	bne L9b95
S9b91
	ldx #$d0
	ldy #$bb
L9b95
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
L9b9d
	.byte $00
L9b9e
	.byte $00
L9b9f
	.byte $00
L9ba0
	.byte $00
L9ba1
	.byte $00
L9ba2
	.byte $00
L9ba3
	.byte $00
L9ba4
	.byte $00
L9ba5
	.byte $00
L9ba6
	.byte $00
L9ba7
	.byte $00
L9ba8
	.byte $00
L9ba9
	.byte $00
L9baa
	.byte $00
L9bab
	.byte $00
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
