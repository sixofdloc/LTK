;savetodv.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen

L95e0
	lda LTK_Save_Accu
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
	stx $ae
	sty $af
	tax
	lda $00,x
	sta $c1
	tay
	lda $01,x
	sta $c2
	cmp $af
	bcc L961a
	bne L9601
	cpy $ae
	bcc L961a
L9601
	sta $af
	sty $ae
	ldy #$00
L9607
	ldx #$00
L9609
	lda ($ae),y
	pha
	inc $ae
	bne L9612
	inc $af
L9612
	pla
	bne L9607
	inx
	cpx #$03
	bne L9609
L961a
	lda #$ff
	sta LTK_ReadChanFPTPtr
	ldy #$00
	ldx #$5b
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L962c
	lda #$00
	
	sta L9b23
	sta L9b2e
	sta L9b2f
	lda #$0a
	sta $9d4e
	lda LTK_Var_ActiveLU
	sta L9b30
	sta L9b32
	lda LTK_Var_Active_User
	sta L9b31
	jsr LTK_ClearHeaderBlock 
	ldy $b7
	bne L9655
L9652
	jmp LTK_SysRet_LKRT_OldRegs 
	
L9655
	cpy #$1e
	bcs L9652
	lda $31
	pha
	lda $32
	pha
	lda $bb
	sta $31
	lda $bc
	sta $32
	dey
L9668
	lda LTK_Var_CPUMode
	bne L9673
	jsr $fc6e
	jmp L9686
	
L9673
	tya
	pha
	sec
	ldx #$74
	ldy #$ff
	jsr LTK_KernalTrapSetup
	pla
	tay
	lda #$bb
	ldx $c7
	jsr LTK_KernalCall 
L9686
	sta L9b95,y
	dey
	bpl L9668
	pla
	sta $32
	pla
	sta $31
	ldy #$00
	lda L9b95,y
	cmp #$3c
	beq L969e
	jmp L9743
	
L969e
	iny
	cpy $b7
	bcc L96a6
	jmp L9743
	
L96a6
	lda L9b95,y
	cmp #$24
	bne L96ba
	lda #$10
	sta $9d4e
	iny
	cpy $b7
	bcc L96ba
	jmp L9743
	
L96ba
	lda #$95
	ldx #$9b
	jsr S9d14
	bcc L96c6
	jmp L9743
	
L96c6
	sta L9b1e
	stx L9b1f
	lda L9b95,y
	cmp #$2d
	beq L96d6
	jmp L9743
	
L96d6
	iny
	cpy $b7
	bcc L96de
	jmp L9743
	
L96de
	lda #$95
	ldx #$9b
	jsr S9d14
	bcc L96ea
	jmp L9743
	
L96ea
	sta L9b20
	inx
	stx L9b21
	bne L96f6
	inc L9b20
L96f6
	lda L9b95,y
	cmp #$3e
	beq L9700
	jmp L9743
	
L9700
	lda L9b1e
	cmp L9b20
	beq L970d
	bcc L971d
	jmp L9b69
	
L970d
	lda L9b1f
	cmp L9b21
	bne L9718
	jmp L9b69
	
L9718
	bcc L971d
	jmp L9b69
	
L971d
	lda L9b1f
	sta $c1
	lda L9b1e
	sta $c2
	lda L9b21
	sta $ae
	lda L9b20
	sta $af
	lda #$ff
	sta L9b2f
	iny
	cpy $b7
	bcc L973e
	jmp L9b63
	
L973e
	sty L9b23
	bcc L975a
L9743
	lda $c1
	sta L9b1f
	ldx $c2
	stx L9b1e
	lda $ae
	sta L9b21
	lda $af
	sta L9b20
	ldy L9b23
L975a
	lda $ba
	cmp LTK_HD_DevNum
	beq L978f
	ldx #$ed
	ldy #$f5
	lda LTK_Var_CPUMode
	beq L976e
	ldx #$4e
	ldy #$f5
L976e
	sec
	jsr LTK_KernalTrapSetup
	lda $b7
	sec
	sbc L9b23
	sta $b7
	lda L9b23
	clc
	adc $bb
	sta $bb
	bcc L9786
	inc $bc
L9786
	lda LTK_Save_Accu
	sta LTK_Save_XReg
	jmp LTK_SysRet_AbsJmp 
	
L978f
	sec
	lda L9b21
	sbc L9b1f
	sta $91f1
	sta $91fc
	bcs L97a1
	dec L9b20
L97a1
	lda L9b20
	sec
	sbc L9b1e
	sta $91f0
	and #$01
	sta $91f9
	ldx #$09
L97b2
	lsr $91f0
	ror $91f1
	dex
	bne L97b2
	lda $91f9
	bne L97c5
	lda $91fc
	beq L97cd
L97c5
	inc $91f1
	bne L97cd
	inc $91f0
L97cd
	inc $91f1
	bne L97d5
	inc $91f0
L97d5
	tya
	pha
	lda #$0c
	ldx L9b2f
	bne L97f7
	ldx $2b
	ldy $2c
	bit LTK_Var_CPUMode
	bpl L97eb
	ldx $2d
	ldy $2e
L97eb
	cpx L9b1f
	bne L97f7
	cpy L9b1e
	bne L97f7
	lda #$0b
L97f7
	sta L9b22
	sta $91f8
	lda L9b1e
	sta $91fa
	lda L9b1f
	sta $91fb
	pla
	tay
	sty L9b23
	ldx #$ff
	lda L9b95,y
	cmp #$40
	bne L981b
	stx L9b2e
	iny
L981b
	lda L9b95,y
	ldx L9b32
	cmp #$3a
	beq L9846
	lda #$0a
	sta $9d4e
	lda #$95
	ldx #$9b
	jsr S9d14
	lda L9b95,y
	cmp #$3a
	beq L9846
	lda #$00
	sta L9b2e
	ldx L9b32
	ldy L9b23
	jmp L985c
	
L9846
	iny
	lda L9b2e
	beq L985c
	lda L9b2f
	beq L9854
	jmp L9b33
	
L9854
	cpx L9b32
	beq L985c
	jmp L9b39
	
L985c
	stx L9b32
	ldx #$00
	cpy $b7
	bcc L9868
	jmp L9b63
	
L9868
	lda L9b95,y
	sta LTK_FileHeaderBlock ,x
	iny
	cpy $b7
	bcs L987b
	inx
	cpx #$10
	bne L9868
	jmp L9b5d
	
L987b
	lda L9b32
	jsr LTK_SetLuActive 
	bcc L9886
	jmp L9b3f
	
L9886
	jsr LTK_AllocateRandomBlks 
	bcc L9898
	cpx #$80
	bne L9895
	tax
	ldy #$04
	jmp L9b6d
	
L9895
	jmp L9b45
	
L9898
	ldy $9200
	sty L9b26
	ldx $9201
	stx L9b27
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98ae
	lda #$02
	sec
	jsr $9f00
	bcc L98c2
	txa
	pha
	jsr S9af9
	pla
	tax
	ldy #$05
	jmp L9b6d
	
L98c2
	jsr LTK_FindFile 
	php
	sta L9b2a
	stx L9b25
	sty L9b24
	lda $9200
	sta L9b28
	lda $9201
	sta L9b29
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	lda #$00
	plp
	rol a
	sta L9b2b
	bne L990a
	lda $91f8
	cmp #$0b
	beq L98ff
	cmp #$0c
	beq L98ff
	jsr S9af9
	jmp L9b57
	
L98ff
	lda L9b2e
	bne L991c
	jsr S9af9
	jmp L9b51
	
L990a
	lda #$00
	sta L9b2e
	lda L9b31
	sta LTK_Var_Active_User
	cpx #$ff
	bne L991c
	jmp L9b57
	
L991c
	lda L9b2a
	bne L992a
	txa
	bne L992a
	tya
	bne L992a
	jmp L9b4b
	
L992a
	lda LTK_Var_ActiveLU
	ldx L9b27
	ldy L9b26
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L993a
	lda L9b2a
	pha
	ldx L9b25
	ldy L9b24
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx L9b27
	ldy L9b26
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9959
	ldx #$00
	
	stx L9b2c
	inx
	stx L9b2d
	lda LTK_Var_ActiveLU
	sta LTK_Var_SAndRData
	lda $9200
	sta $8026
	lda $9201
	sta $8027
	lda $31
	pha
	lda $32
	pha
	lda $91fa
	sta $32
	lda $91fb
	sta $31
	lda $91f0
	bne L9993
	lda $91f1
	cmp #$01
	bne L9993
	jmp L9a52
	
L9993
	lda $ff00
	pha
	lda $31
	sta L9a27
	ldy $32
	sty L9a28
	lda LTK_Var_CPUMode
	beq L99bb
	cpy #$a0
	bcs L99c2
	cpy #$80
	bcs L99b4
	iny
	iny
	cpy #$80
	bcc L99ff
L99b4
	ldx $c6
	lda $f7f0,x
	and #$ce
L99bb
	ldx #$00
	stx LTK_Krn_BankControl
	beq L9a08
L99c2
	ldy L9a28
	cpy #$e0
	bcs L99ff
	cpy #$d0
	bcs L99d3
	iny
	iny
	cpy #$d0
	bcc L99ff
L99d3
	ldx $c6
	lda $f7f0,x
	tax
	lsr a
	bcc L99ff
	ldy #$00
	stx $ff00
L99e1
	lda ($31),y
	sta LTK_MiscWorkspace,y
	iny
	bne L99e1
	inc $32
L99eb
	lda ($31),y
	sta $90e0,y
	iny
	bne L99eb
	dec $32
	lda #$e0
	sta L9a27
	lda #$8f
	sta L9a28
L99ff
	ldx $c6
	lda $f7f0,x
	and #$fe
	ldx #$ff
L9a08
	stx LTK_DiskRWControl
	ldx LTK_Var_CPUMode
	beq L9a13
	sta $ff00
L9a13
	lda L9b2d
	asl a
	tax
	lda $9200,x
	tay
	lda $9201,x
	tax
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
L9a27
	.byte $00
	
L9a28
	.byte $00
L9a29
	.byte $01 
L9a2a
	pla
	ldx LTK_Var_CPUMode
	beq L9a33
	sta $ff00
L9a33
	inc $32
	inc $32
	inc L9b2d
	bne L9a3f
	inc L9b2c
L9a3f
	lda L9b2d
	cmp $91f1
	bne L9a4f
	lda L9b2c
	cmp $91f0
	beq L9a52
L9a4f
	jmp L9993
	
L9a52
	lda #$00
	sta LTK_DiskRWControl
	pla
	sta $32
	pla
	sta $31
	lda L9b2e
	beq L9a84
	ldy L9b28
	ldx L9b29
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9a72
	jsr LTK_DeallocateRndmBlks 
	bcc L9a84
	cpx #$80
	bne L9a81
	tax
	ldy #$04
	jmp L9b6d
	
L9a81
	jsr LTK_FatalError 
L9a84
	lda LTK_Var_CPUMode
	beq L9a97
	lda $3e
	cmp $2e
	bcc L9aa3
	bne L9ae0
	lda $3d
	bne L9ae0
	beq L9aa3
L9a97
	lda $7b
	cmp $2c
	bcc L9aa3
	bne L9ae0
	lda $7a
	bne L9ae0
L9aa3
	ldx #$10
	ldy #$9d
	jsr LTK_Print 
	lda L9b32
	jsr S9b87
	stx L9bb3
	sta L9bb4
	lda LTK_Var_Active_User
	jsr S9b87
	stx L9bb6
	sta L9bb7
	ldx #$b3
	ldy #$9b
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$d8
	ldy #$9b
	lda L9b2e
	beq L9add
	ldx #$36
	ldy #$9c
L9add
	jsr LTK_Print 
L9ae0
	ldy #$00
	jsr LTK_ErrorHandler 
	lda L9b2f
	beq L9af5
	lda #$ff
	sta LTK_Var_SAndRData
	sta $8026
	sta $8027
L9af5
	clc
	jmp L9b70
	
S9af9
	ldy L9b26
	ldx L9b27
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9b09
	jsr LTK_DeallocateRndmBlks 
	bcc L9b1d
	cpx #$80
	bne L9b1a
	tax
	pla
	pla
	ldy #$04
	jmp L9b6d
	
L9b1a
	jsr LTK_FatalError 
L9b1d
	rts
	
L9b1e
	.byte $00
L9b1f
	.byte $00
L9b20
	.byte $00
L9b21
	.byte $00
L9b22
	.byte $00
L9b23
	.byte $00
L9b24
	.byte $00
L9b25
	.byte $00
L9b26
	.byte $00
L9b27
	.byte $00
L9b28
	.byte $00
L9b29
	.byte $00
L9b2a
	.byte $00
L9b2b
	.byte $00
L9b2c
	.byte $00
L9b2d
	.byte $00
L9b2e
	.byte $00
L9b2f
	.byte $00
L9b30
	.byte $00
L9b31
	.byte $00
L9b32
	.byte $00
L9b33
	ldx #$e8
	ldy #$9c
	bne L9b6d
L9b39
	ldx #$be
	ldy #$9c
	bne L9b6d
L9b3f
	ldx #$a5
	ldy #$9c
	bne L9b6d
L9b45
	ldx #$1c
	ldy #$9c
	bne L9b6d
L9b4b
	ldx #$86
	ldy #$9c
	bne L9b6d
L9b51
	ldx #$ba
	ldy #$9b
	bne L9b6d
L9b57
	ldx #$6b
	ldy #$9c
	bne L9b6d
L9b5d
	ldx #$4f
	ldy #$9c
	bne L9b6d
L9b63
	ldx #$e4
	ldy #$9b
	bne L9b6d
L9b69
	ldx #$fe
	ldy #$9b
L9b6d
	jsr LTK_ErrorHandler 
L9b70
	php
	lda #$02
	clc
	jsr $9f00
	lda L9b30
	sta LTK_Var_ActiveLU
	lda L9b31
	sta LTK_Var_Active_User
	plp
	jmp LTK_SysRet_AsIs  
	
S9b87
	ldx #$30
L9b89
	cmp #$0a
	bcc L9b92
	sbc #$0a
	inx
	bne L9b89
L9b92
	adc #$30
	rts
	
L9b95	
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00 
L9bb3
	.byte $00
L9bb4
	.byte $00
L9bb5
	.text ":"
L9bb6
	.byte $00
L9bb7
	.byte $00
L9bb8
	.text ":"
	.byte $00
L9bba
	.text "63,file already exists,00,00{return}"
	.byte $00
L9bd8
	.text "{rvs off}   saved.{return}"
	.byte $00
L9be4
	.text "31,invalid command,00,00{return}"
	.byte $00
L9bfe
	.text "30,address range error,00,00{return}"
	.byte $00
L9c1c
	.text "72,disk is full !!,00,00{return}"
	.byte $00
L9c36
	.text "{rvs off}   saved & replaced !!{return}"
	.byte $00
L9c4f
	.text "33,filename too long,00,00{return}"
	.byte $00
L9c6b
	.text "33,illegal filename,00,00{return}"
	.byte $00
L9c86
	.text "72,system index is full,00,00{return}"
	.byte $00
L9ca5
	.text "invalid logical unit !!{return}"
	.byte $00
L9cbe
	.text "cannot save & replace to different lu !!{return}"
	.byte $00
L9ce8
	.text "cannot do range type save & replace !!{return}"
	.byte $00
L9d10
	.text "{return}{return}{rvs on}"
	.byte $00
S9d14
	sta L9d25 + 1
	stx L9d25 + 2
	lda #$00
	sta L9d8f
	sta L9d90
	sta L9d91
L9d25
	lda L9d25,y
	cmp #$30
	bcc L9d7d
	cmp #$3a
	bcc L9d42
	ldx $9d4e
	cpx #$0a
	beq L9d7d
	cmp #$41
	bcc L9d7d
	cmp #$47
	bcs L9d7d
	sec
	sbc #$07
L9d42
	ldx L9d8f
	beq L9d66
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9d4f
	clc
	adc L9d91
	pha
	txa
	adc L9d90
	tax
	pla
	dey
	bne L9d4f
	sta L9d91
	stx L9d90
	pla
	tay
	pla
L9d66
	inc L9d8f
	sec
	sbc #$30
	clc
	adc L9d91
	sta L9d91
	bcc L9d7a
	inc L9d90
	beq L9d87
L9d7a
	iny
	bne L9d25
L9d7d
	cmp #$20
	beq L9d7a
	clc
	ldx L9d8f
	bne L9d88
L9d87
	sec
L9d88
	lda L9d90
	ldx L9d91
	rts
	
L9d8f
	.byte $00
L9d90
	.byte $00
L9d91
	.byte $00
