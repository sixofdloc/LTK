;indxmod2.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$4000 for sysgen 
	
L95e0
	jmp L9603
	
L95e3	    
	.repeat $20,$00
L9603
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
	bne L9622
	jmp L99c7
	
L9622
	ldx #$1d
	lda #$00
L9626
	sta L95e3,x
	dex
	bpl L9626
	lda #$00
	sta L9a30
	sta L9a31
	clc
	jsr S9969
	ldy $9e83
	bne L9640
L963d
	jmp L99b8
	
L9640
	dey
	cpy $9230
	bcs L963d
	sty $9e83
	lda $9231,y
	sta L9a2b
	tax
	inx
	inx
	stx L9a38
	tya
	asl a
	tay
	lda $9202,y
	sta L9960 + 1
	lda $9203,y
	sta L995e + 1
	ldy $9e84
	bne L966c
	jmp L99bb
	
L966c
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy #$00
L9678
	jsr $fc6e
	sta L95e3,y
	iny
	cpy L9a2b
	beq L9689
	cpy $9e84
	bne L9678
L9689
	ldy L9a2b
	lda $9ea4
	sta L95e3,y
	lda $9ea5
	sta $95e4,y
	clc
	jsr S995b
	lda $8fe4
	bne L96a4
	jmp L99c4
	
L96a4
	ldx #$e5
	ldy #$8f
	jsr S998b
	dex
	stx L9a36
	lda $31
	sta L9a33
	lda $32
	sta L9a32
	ldy L9a2b
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	sty L9a2c
	stx L9a2d
	clc
	jsr S997e
	bne L96d4
	jmp L99be
	
L96d4
	ldx #$e5
	ldy #$8f
	jsr S998b
	dex
	stx L9a37
	bcc L96e4
	dec L9a30
L96e4
	lda $31
	sta L9a35
	lda $32
	sta L9a34
	ldy L9a2b
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	sty L9a2e
	stx L9a2f
	clc
	jsr S997e
	ldx #$e5
	ldy #$8f
	jsr S998b
	bcs L9721
	bne L9721
	ldy L9a2b
	lda ($31),y
	cmp L95e3,y
	bne L9721
	iny
	lda ($31),y
	cmp L95e3,y
	beq L9724
L9721
	jmp L99c4
	
L9724
	dex
	bne L972a
	dec L9a31
L972a
	jsr S9855
	jsr S994e
	dec $8fe4
	bne L9797
	lda #$00
	sta L9a31
	jsr S9889
	jsr S98da
	clc
	ldx L9a2d
	ldy L9a2c
	jsr S997e
	lda L9a35
	sta $31
	lda L9a34
	sta $32
	ldx L9a37
	jsr S9855
	jsr S994e
	dec $8fe4
	bne L978e
	lda #$00
	sta L9a30
	jsr S9889
	jsr S9914
	clc
	jsr S995b
	lda L9a33
	sta $31
	lda L9a32
	sta $32
	ldx L9a36
	jsr S9855
	jsr S994e
	dec $8fe4
	sec
	jsr S995b
	jmp L97a4
	
L978e
	ldx L9a2d
	ldy L9a2c
	jmp L979d
	
L9797
	ldx L9a2f
	ldy L9a2e
L979d
	sec
	jsr S997e
	jsr S97f9
L97a4
	clc
	jsr S9969
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
	jsr S9969
	ldx #$00
	clc
	jmp L99ca
	
S97c8
	ldx $8fe4
	dex
	jsr S97e7
	clc
	adc #$e5
	sta $2f
	tya
	adc #$8f
	sta $30
	ldy #$00
L97db
	lda ($2f),y
	sta L95e3,y
	iny
	cpy L9a2b
	bne L97db
	rts
	
S97e7
	lda #$00
	tay
	cpx #$00
	beq L97f8
L97ee
	clc
	adc L9a38
	bcc L97f5
	iny
L97f5
	dex
	bne L97ee
L97f8
	rts
	
S97f9
	jsr S97c8
	lda L9a31
	beq L9854
	clc
	ldx L9a2d
	ldy L9a2c
	jsr S997e
	lda L9a35
	sta $981f
	lda L9a34
	sta $9820
	ldx L9a2b
	dex
L981b
	lda L95e3,x
	sta $981e,x
	dex
	bpl L981b
	sec
	ldx L9a2d
	ldy L9a2c
	jsr S997e
	lda L9a30
	beq L9854
	clc
	jsr S995b
	lda L9a33
	sta $984b
	lda L9a32
	sta $984c
	ldx L9a2b
	dex
L9847
	lda L95e3,x
	sta $984a,x
	dex
	bpl L9847
	sec
	jsr S995b
L9854
	rts
	
S9855
	txa
	beq L9888
	lda $31
	clc
	adc L9a38
	sta $33
	lda $32
	adc #$00
	sta $34
L9866
	ldy #$00
L9868
	lda ($33),y
	sta ($31),y
	iny
	cpy L9a38
	bne L9868
	lda $33
	sta $31
	ldy $34
	sty $32
	clc
	adc L9a38
	sta $33
	tya
	adc #$00
	sta $34
	dex
	bne L9866
L9888
	rts
	
S9889
	lda LTK_MiscWorkspace
	sta L9a39
	lda $8fe1
	sta L9a3a
	ldx $8fe3
	stx L9a3c
	ldy $8fe2
	sty L9a3b
	bne L98a6
	txa
	beq L98ba
L98a6
	clc
	jsr S997e
	lda L9a39
	sta LTK_MiscWorkspace
	lda L9a3a
	sta $8fe1
	sec
	jsr S997e
L98ba
	ldx L9a3a
	ldy L9a39
	bne L98c5
	txa
	beq L98d9
L98c5
	clc
	jsr S997e
	lda L9a3b
	sta $8fe2
	lda L9a3c
	sta $8fe3
	sec
	jsr S997e
L98d9
	rts
	
S98da
	clc
	jsr S9969
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
	bne L98ff
	inc $921a,x
L98ff
	ldx L9a2f
	stx $9219
	ldy L9a2e
	sty $9218
	sec
	jsr S997e
	sec
	jsr S9969
	rts
	
S9914
	clc
	jsr S9969
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
	bne L9939
	inc $920e,x
L9939
	ldx L9a2d
	stx $920d
	ldy L9a2c
	sty $920c
	sec
	jsr S997e
	sec
	jsr S9969
	rts
	
S994e
	ldy #$00
	lda #$ff
L9952
	sta ($31),y
	iny
	cpy L9a38
	bne L9952
	rts
	
S995b
	lda $9e63
L995e
	ldx #$00
L9960
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$02; $8fe0 
L9968
	rts
	
S9969
	ldx $9e64
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L997d
	rts
	
S997e
	lda $9e63
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9987
	lda $8fe4
	rts
	
S998b
	stx $31
	sty $32
	tax
L9990
	ldy #$00
L9992
	lda ($31),y
	cmp L95e3,y
	bne L99a1
	iny
	cpy L9a2b
	bne L9992
	beq L99b4
L99a1
	bcs L99b4
	dex
	beq L99b6
	lda L9a38
	clc
	adc $31
	sta $31
	bcc L9990
	inc $32
	bne L9990
L99b4
	clc
	rts
	
L99b6
	sec
	rts
	
L99b8
	ldx #$01
	.byte $2c 
L99bb
	ldx #$02
	.byte $2c 
L99be
	ldx #$03
	.byte $2c 
L99c1
	ldx #$04
	.byte $2c 
L99c4
	ldx #$05
	.byte $2c 
L99c7
	ldx #$06
	sec
L99ca
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
	bmi L9a10
	pha
	lda $9ec5
	sta $7a
	lda $9ec4
	sta $7b
	jsr $0073
	jsr S9a13
	jsr $0073
	jsr S9a13
	jsr $0073
	jsr S9a19
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S9a1f
	jmp LTK_SysRet_OldRegs 
	
L9a10
	jmp LTK_SysRet_AsIs  
	
S9a13
	ldx #$9e
	ldy #$ad
	bne L9a23
S9a19
	ldx #$8b
	ldy #$b0
	bne L9a23
S9a1f
	ldx #$d0
	ldy #$bb
L9a23
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
L9a2b
	.byte $00
L9a2c
	.byte $00
L9a2d
	.byte $00
L9a2e
	.byte $00
L9a2f
	.byte $00
L9a30
	.byte $00
L9a31
	.byte $00
L9a32
	.byte $00
L9a33
	.byte $00
L9a34
	.byte $00
L9a35
	.byte $00
L9a36
	.byte $00
L9a37
	.byte $00
L9a38
	.byte $00
L9a39
	.byte $00
L9a3a
	.byte $00
L9a3b
	.byte $00
L9a3c
	.byte $00
