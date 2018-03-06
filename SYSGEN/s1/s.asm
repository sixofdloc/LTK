;s.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen

L95e0
	sta L9b24
	lda #$ff
	sta LTK_ReadChanFPTPtr
	lda LTK_Var_ActiveLU
	sta L9b31
	sta L9b33
	lda LTK_Var_Active_User
	sta L9b32
	lda #$00
	sta L9b2f
	sta L9b30
	lda #$0a
	sta $9d28
	ldx $2b
	ldy $2c
	lda LTK_Var_CPUMode
	beq L9611
	ldx $2d
	ldy $2e
L9611
	stx $c1
	sty $c2
	ldx $2d
	ldy $2e
	pha
	pla
	beq L9623
	ldx $1210
	ldy $1211
L9623
	stx $ae
	sty $af
	ldx $c8
	pha
	pla
	beq L962f
	ldx $ea
L962f
	stx L9b35
	ldy $c1
	lda $c2
	cmp $af
	bcc L9659
	bne L9640
	cpy $ae
	bcc L9659
L9640
	sta $af
	sty $ae
	ldy #$00
L9646
	ldx #$00
L9648
	lda ($ae),y
	pha
	inc $ae
	bne L9651
	inc $af
L9651
	pla
	bne L9646
	inx
	cpx #$03
	bne L9648
L9659
	jsr LTK_ClearHeaderBlock 
	ldy L9b24
	cpy L9b35
	bcc L9667
	jmp L9743
	
L9667
	iny
	cpy L9b35
	bcc L9670
	jmp L9743
	
L9670
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L9678
	iny
L9678
	ldx L9b35
	lda $01ff,x
	cmp #$22
	bne L9685
	dec L9b35
L9685
	cpy L9b35
	bcc L968d
	jmp L9743
	
L968d
	sty L9b24
	lda LTK_Command_Buffer,y
	cmp #$3c
	beq L969a
	jmp L9787
	
L969a
	iny
	cpy L9b35
	bcc L96a3
	jmp L9787
	
L96a3
	lda LTK_Command_Buffer,y
	cmp #$24
	bne L96b8
	lda #$10
	sta $9d28
	iny
	cpy L9b35
	bcc L96b8
	jmp L9787
	
L96b8
	lda #$00
	ldx #$02
	jsr S9cee
	bcc L96c4
	jmp L9787
	
L96c4
	sta L9b1f
	stx $9b20
	lda LTK_Command_Buffer,y
	cmp #$2d
	beq L96d4
	jmp L9787
	
L96d4
	iny
	cpy L9b35
	bcc L96dd
	jmp L9787
	
L96dd
	lda #$00
	ldx #$02
	jsr S9cee
	bcc L96e9
	jmp L9787
	
L96e9
	sta $9b21
	inx
	stx $9b22
	bne L96f5
	inc $9b21
L96f5
	lda LTK_Command_Buffer,y
	cmp #$3e
	beq L96ff
	jmp L9787
	
L96ff
	lda L9b1f
	cmp $9b21
	beq L970c
	bcc L971c
	jmp L9b7a
	
L970c
	lda $9b20
	cmp $9b22
	bne L9717
	jmp L9b7a
	
L9717
	bcc L971c
	jmp L9b7a
	
L971c
	lda $9b20
	sta $c1
	lda L9b1f
	sta $c2
	lda $9b22
	sta $ae
	lda $9b21
	sta $af
	lda #$ff
	sta L9b30
	iny
	cpy L9b35
	bcc L973e
	jmp L9b74
	
L973e
	sty L9b24
	bcc L979e
L9743
	lda LTK_Var_SAndRData
	ldx $8027
	ldy $8026
	cmp #$ff
	bne L975b
	cpx #$ff
	bne L975b
	cpy #$ff
	bne L975b
	jmp L9b50
	
L975b
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9762
	lda $91f8
	cmp #$0b
	beq L9770
	cmp #$0c
	beq L9770
	jmp L9b68
	
L9770
	lda #$00
	tay
L9773
	sta $9200,y
	iny
	bne L9773
	ldx #$e0
L977b
	sta $9300,y
	iny
	dex
	bne L977b
	lda #$ff
	sta L9b2f
L9787
	lda $c1
	sta $9b20
	ldx $c2
	stx L9b1f
	lda $ae
	sta $9b22
	lda $af
	sta $9b21
	ldy L9b24
L979e
	sec
	lda $9b22
	sbc $9b20
	sta $91f1
	sta $91fc
	bcs L97b0
	dec $9b21
L97b0
	lda $9b21
	sec
	sbc L9b1f
	sta $91f0
	and #$01
	sta $91f9
	ldx #$09
L97c1
	lsr $91f0
	ror $91f1
	dex
	bne L97c1
	lda $91f9
	bne L97d4
	lda $91fc
	beq L97dc
L97d4
	inc $91f1
	bne L97dc
	inc $91f0
L97dc
	inc $91f1
	bne L97e4
	inc $91f0
L97e4
	tya
	pha
	lda #$0c
	ldx L9b30
	bne L9806
	ldx $2b
	ldy $2c
	bit LTK_Var_CPUMode
	bpl L97fa
	ldx $2d
	ldy $2e
L97fa
	cpx $9b20
	bne L9806
	cpy L9b1f
	bne L9806
	lda #$0b
L9806
	sta $9b23
	sta $91f8
	lda L9b1f
	sta $91fa
	lda $9b20
	sta $91fb
	pla
	tay
	lda $9b34
	bne L988e
	lda L9b2f
	beq L9827
	jmp L98a7
	
L9827
	sty L9b24
	ldx #$ff
	lda LTK_Command_Buffer,y
	cmp #$40
	bne L9837
	stx $9b34
	iny
L9837
	lda LTK_Command_Buffer,y
	ldx L9b33
	cmp #$3a
	beq L9862
	lda #$0a
	sta $9d28
	lda #$00
	ldx #$02
	jsr S9cee
	lda LTK_Command_Buffer,y
	cmp #$3a
	beq L9862
	lda #$00
	sta $9b34
	ldx L9b33
	ldy L9b24
	jmp L9878
	
L9862
	iny
	lda $9b34
	beq L9878
	lda L9b30
	beq L9870
	jmp L9b3e
	
L9870
	cpx L9b33
	beq L9878
	jmp L9b44
	
L9878
	stx L9b33
	cpy L9b35
	bcc L9883
	jmp L9b74
	
L9883
	sty L9b24
	lda $9b34
	beq L988e
	jmp L9743
	
L988e
	ldx #$00
	ldy L9b24
L9893
	lda LTK_Command_Buffer,y
	sta LTK_FileHeaderBlock ,x
	iny
	cpy L9b35
	bcs L98a7
	inx
	cpx #$10
	bne L9893
	jmp L9b6e
	
L98a7
	lda L9b33
	jsr LTK_SetLuActive 
	bcc L98b2
	jmp L9b4a
	
L98b2
	jsr LTK_AllocateRandomBlks 
	bcc L98c2
	cpx #$80
	bne L98bf
	tax
	jmp L9b36
	
L98bf
	jmp L9b56
	
L98c2
	ldy $9200
	sty $9b27
	ldx $9201
	stx $9b28
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98d8
	lda #$02
	sec
	jsr $9f00
	bcc L98ea
	txa
	pha
	jsr S9afc
	pla
	tax
	jmp L9b3a
	
L98ea
	jsr LTK_FindFile 
	php
	sta $9b2b
	stx $9b26
	sty $9b25
	lda $9200
	sta $9b29
	lda $9201
	sta $9b2a
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	lda #$00
	plp
	rol a
	sta $9b2c
	bne L9932
	lda $91f8
	cmp #$0b
	beq L9927
	cmp #$0c
	beq L9927
	jsr S9afc
	jmp L9b68
	
L9927
	lda L9b2f
	bne L9944
	jsr S9afc
	jmp L9b62
	
L9932
	lda #$00
	sta L9b2f
	lda L9b32
	sta LTK_Var_Active_User
	cpx #$ff
	bne L9944
	jmp L9b68
	
L9944
	lda $9b2b
	bne L9952
	txa
	bne L9952
	tya
	bne L9952
	jmp L9b5c
	
L9952
	lda LTK_Var_ActiveLU
	ldx $9b28
	ldy $9b27
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9962
	lda $9b2b
	pha
	ldx $9b26
	ldy $9b25
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx $9b28
	ldy $9b27
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9981
	ldx #$00
	
	stx $9b2d
	inx
	stx $9b2e
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
	bne L99bb
	lda $91f1
	cmp #$01
	bne L99bb
	jmp L9a7a
	
L99bb
	lda $ff00
	pha
	lda $31
	sta L9a4f
	ldy $32
	sty $9a50
	lda LTK_Var_CPUMode
	beq L99e3
	cpy #$a0
	bcs L99ea
	cpy #$80
	bcs L99dc
	iny
	iny
	cpy #$80
	bcc L9a27
L99dc
	ldx $c6
	lda $f7f0,x
	and #$ce
L99e3
	ldx #$00
	stx LTK_Krn_BankControl
	beq L9a30
L99ea
	ldy $9a50
	cpy #$e0
	bcs L9a27
	cpy #$d0
	bcs L99fb
	iny
	iny
	cpy #$d0
	bcc L9a27
L99fb
	ldx $c6
	lda $f7f0,x
	tax
	lsr a
	bcc L9a27
	ldy #$00
	stx $ff00
L9a09
	lda ($31),y
	sta LTK_MiscWorkspace,y
	iny
	bne L9a09
	inc $32
L9a13
	lda ($31),y
	sta $90e0,y
	iny
	bne L9a13
	dec $32
	lda #$e0
	sta L9a4f
	lda #$8f
	sta $9a50
L9a27
	ldx $c6
	lda $f7f0,x
	and #$fe
	ldx #$ff
L9a30
	stx LTK_DiskRWControl
	ldx LTK_Var_CPUMode
	beq L9a3b
	sta $ff00
L9a3b
	lda $9b2e
	asl a
	tax
	lda $9200,x
	tay
	lda $9201,x
	tax
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
L9a4f
	.byte $00,$00,$01 
L9a52
	pla
	ldx LTK_Var_CPUMode
	beq L9a5b
	sta $ff00
L9a5b
	inc $32
	inc $32
	inc $9b2e
	bne L9a67
	inc $9b2d
L9a67
	lda $9b2e
	cmp $91f1
	bne L9a77
	lda $9b2d
	cmp $91f0
	beq L9a7a
L9a77
	jmp L99bb
	
L9a7a
	lda #$00
	sta LTK_DiskRWControl
	pla
	sta $32
	pla
	sta $31
	lda L9b2f
	beq L9aaa
	ldy $9b29
	ldx $9b2a
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9a9a
	jsr LTK_DeallocateRndmBlks 
	bcc L9aaa
	cpx #$80
	bne L9aa7
	tax
	jmp L9b36
	
L9aa7
	jsr LTK_FatalError 
L9aaa
	ldx #$ea
	ldy #$9c
	jsr LTK_Print 
	lda L9b33
	jsr S9b94
	stx $9ba2
	sta $9ba3
	lda LTK_Var_Active_User
	jsr S9b94
	stx $9ba5
	sta $9ba6
	ldx #$a2
	ldy #$9b
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$c1
	ldy #$9b
	lda L9b2f
	beq L9ae4
	ldx #$0a
	ldy #$9c
L9ae4
	jsr LTK_Print 
	lda L9b30
	beq L9af7
	lda #$ff
	sta LTK_Var_SAndRData
	sta $8026
	sta $8027
L9af7
	ldy #$00
	jmp L9b7e
	
S9afc
	ldy $9b27
	ldx $9b28
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9b0c
	jsr LTK_DeallocateRndmBlks 
	bcc L9b1e
	cpx #$80
	bne L9b1b
	tax
	pla
	pla
	jmp L9b36
	
L9b1b
	jsr LTK_FatalError 
L9b1e
	rts
	
L9b1f			
	.byte $00,$00,$00,$00,$00 
L9b24
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
L9b2f
	.byte $00 
L9b30
	.byte $00 
L9b31
	.byte $00 
L9b32
	.byte $00 
L9b33
	.byte $00,$00 
L9b35
	.byte $00 
L9b36
	ldy #$04
	bne L9b7e
L9b3a
	ldy #$05
	bne L9b7e
L9b3e
	ldx #$c2
	ldy #$9c
	bne L9b7e
L9b44
	ldx #$98
	ldy #$9c
	bne L9b7e
L9b4a
	ldx #$7f
	ldy #$9c
	bne L9b7e
L9b50
	ldx #$25
	ldy #$9c
	bne L9b7e
L9b56
	ldx #$f9
	ldy #$9b
	bne L9b7e
L9b5c
	ldx #$66
	ldy #$9c
	bne L9b7e
L9b62
	ldx #$a9
	ldy #$9b
	bne L9b7e
L9b68
	ldx #$51
	ldy #$9c
	bne L9b7e
L9b6e
	ldx #$3b
	ldy #$9c
	bne L9b7e
L9b74
	ldx #$cd
	ldy #$9b
	bne L9b7e
L9b7a
	ldx #$e1
	ldy #$9b
L9b7e
	jsr LTK_ErrorHandler 
	lda #$02
	clc
	jsr $9f00
	lda L9b31
	sta LTK_Var_ActiveLU
	lda L9b32
	sta LTK_Var_Active_User
	rts
	
S9b94
	ldx #$30
L9b96
	cmp #$0a
	bcc L9b9f
	sbc #$0a
	inx
	bne L9b96
L9b9f
	adc #$30
	rts
	
L9a2
	.byte $00,$00 
L9ba4
	.text ":"
	.byte $00,$00 
L9ba7
	.text ":"
	.byte $00
L9ba9
	.text "file already exists !!{return}"
	.byte $00
L9bc1
	.text "{rvs off}   saved.{return}"
	.byte $00
L9bcd
	.text "invalid command !!{return}"
	.byte $00
L9be1
	.text "address range error !!{return}"
	.byte $00
L9bf9
	.text "disk is full !!{return}"
	.byte $00
L9c0a
	.text "{rvs off}   saved and replaced !!{return}"
	.byte $00
L9c25
	.text "no filename given !!{return}"
	.byte $00
L9c3b
	.text "filename too long !!{return}"
	.byte $00
L9c51
	.text "illegal filename !!{return}"
	.byte $00
L9c66
	.text "system index is full !!{return}"
	.byte $00
L9c7f
	.text "invalid logical unit !!{return}"
	.byte $00
L9c98
	.text "cannot save & replace to different lu !!{return}"
	.byte $00
L9cc2
	.text "cannot do range type save & replace !!{return}"
	.byte $00
L9cea
	.text "{return}{return}{rvs on}"
	.byte $00
S9cee
	sta L9cff + 1
	stx L9cff + 2
	lda #$00
	sta L9d69
	sta L9d6a
	sta L9d6b
L9cff
	lda L9cff,y
	cmp #$30
	bcc L9d57
	cmp #$3a
	bcc L9d1c
	ldx $9d28
	cpx #$0a
	beq L9d57
	cmp #$41
	bcc L9d57
	cmp #$47
	bcs L9d57
	sec
	sbc #$07
L9d1c
	ldx L9d69
	beq L9d40
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9d29
	clc
	adc L9d6b
	pha
	txa
	adc L9d6a
	tax
	pla
	dey
	bne L9d29
	sta L9d6b
	stx L9d6a
	pla
	tay
	pla
L9d40
	inc L9d69
	sec
	sbc #$30
	clc
	adc L9d6b
	sta L9d6b
	bcc L9d54
	inc L9d6a
	beq L9d61
L9d54
	iny
	bne L9cff
L9d57
	cmp #$20
	beq L9d54
	clc
	ldx L9d69
	bne L9d62
L9d61
	sec
L9d62
	lda L9d6a
	ldx L9d6b
	rts
	
L9d69
	
	.byte $00 
L9d6a
	
	.byte $00 
L9d6b
	
	.byte $00 
