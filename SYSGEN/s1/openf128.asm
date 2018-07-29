;openf128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
 
    *=LTK_DOSOverlay 

L95e0
	lda LTK_AutobootFlag
	bmi L9605
	beq L95f8
	ldx $d5
	cpx #$58
	bne L95f8
	lsr a
	bne L95f3
	jmp (LTK_Var_Go64_Vec)
	
L95f3
	lda #$2a
	jsr LTK_ExeExtMiniSub 
L95f8
	lda #$95
	pha
	lda #$df
	pha
	lda #$c6
	ldx #$03
	jmp LTK_CallExtDosOvl 
	
L9605
	sec
	ldx #$74
	ldy #$ff
	jsr LTK_KernalTrapSetup
	ldy $b7
	dey
L9610
	lda #$bb
	ldx $c7
	jsr LTK_KernalCall 
	sta LTK_MiscWorkspace,y
	dey
	bpl L9610
	lda #$00
	sta $90
	sta L9b4e
	sta L9b4f
	sta L9b51
	sta L9b52
	sta $9e04
	sta L9b56
	lda LTK_Var_ActiveLU
	sta $9de3
	lda LTK_Var_Active_User
	sta L9b57
	jmp L9649
	
L9642
	sec
	jsr LTK_KernalTrapSetup
	jmp LTK_SysRet_AbsJmp 
	
L9649
	sec
	ldx #$02
	ldy #$f2
	jsr LTK_KernalTrapSetup
	ldx $b8
	jsr LTK_KernalCall 
	bne L965e
	ldx #$7f
	ldy #$f6
	bne L9642
L965e
	ldx $98
	cpx #$0a
	bcc L966a
L9664
	ldx #$7c
	ldy #$f6
	bne L9642
L966a
	lda $b9
	and #$0f
	cmp #$0f
	bne L9676
	ldx #$e0
	bne L9689
L9676
	ldy #$07
	ldx #$00
L967a
	lda $9dff,x
	beq L9689
	txa
	clc
	adc #$20
	tax
	dey
	bne L967a
	beq L9664
L9689
	stx $9de4
	lda #$00
	cpx #$e0
	bne L9695
	lda $9df6,x
L9695
	pha
	ldy #$03
	lda #$00
L969a
	sta LTK_FileParamTable,x
	inx
	dey
	bne L969a
	ldy #$1a
L96a3
	sta $9de3,x
	inx
	dey
	bne L96a3
	ldx $9de4
	pla
	sta $9df6,x
	cpx #$e0
	beq L96bb
	dec $9de9,x
	dec $9dea,x
L96bb
	ldy $98
	inc $98
	lda $b8
	sta $0362,y
	lda $b9
	pha
	ora #$60
	sta $b9
	sta $0376,y
	lda $ba
	sta $036c,y
	pla
	sta $9dff,x
	cpx #$e0
	bne L96e3
	lda #$aa
	sta $9dfe,x
	jmp L9a8a
	
L96e3
	jsr LTK_ClearHeaderBlock 
	tax
	lda $b9
	cmp #$60
	beq L96f3
	cmp #$61
	bne L96f8
	ldx #$80
L96f3
	ldy #$0b
	dec L9b56
L96f8
	stx L9b50
	sty L9b55
	ldy #$00
	sty L9b54
L9703
	cpy $b7
	bcs L9725
	lda LTK_MiscWorkspace,y
	cmp #$3a
	beq L9721
	cmp #$20
	beq L971e
	cmp #$40
	beq L971e
	cmp #$30
	bcc L9725
	cmp #$3a
	bcs L9725
L971e
	iny
	bne L9703
L9721
	iny
	sty L9b54
L9725
	ldy L9b54
	bne L9737
	lda LTK_MiscWorkspace,y
	cmp #$24
	beq L974c
	cmp #$23
	bne L9799
	beq L9755
L9737
	dey
	bmi L9761
	lda LTK_MiscWorkspace,y
	cmp #$20
	bne L9748
	lda #$30
	sta LTK_MiscWorkspace,y
	bne L9737
L9748
	cmp #$24
	bne L9751
L974c
	dec L9b51
	bne L9761
L9751
	cmp #$23
	bne L975a
L9755
	dec L9b52
	bne L9761
L975a
	cmp #$40
	bne L9737
	dec L9b4e
L9761
	iny
	cpy $b7
	bcs L977a
	lda #$e0
	ldx #$8f
	jsr S9b5a
	bcs L977a
	cpx $9de3
	beq L977a
	txa
	jsr LTK_SetLuActive 
	bcs L97a8
L977a
	ldx $9de4
	lda L9b51
	beq L978f
	lda #$24
	sta $9dfe,x
	lda #$01
	sta L9b55
	jmp L9895
	
L978f
	lda L9b52
	beq L9799
	ldy #$72
	jmp L9833
	
L9799
	ldy L9b54
	ldx #$00
	stx L9b51
	stx L9b52
	cpy $b7
	bcc L97ab
L97a8
	jmp L9865
	
L97ab
	lda LTK_MiscWorkspace,y
	cmp #$2c
	beq L97bd
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	cpy $b7
	bcc L97ab
	bcs L97ff
L97bd
	lda LTK_MiscWorkspace,y
	iny
	cpy $b7
	bcs L97ff
	cmp #$2c
	bne L97bd
	lda LTK_MiscWorkspace,y
	ldx #$0b
	cmp #$50
	beq L9802
	ldx #$0c
	cmp #$4d
	beq L9802
	ldx #$0d
	cmp #$53
	beq L9802
	ldx #$0e
	cmp #$55
	beq L9802
	ldx #$0f
	cmp #$4c
	beq L980f
	ldx L9b56
	bne L97bd
	cmp #$52
	beq L980a
	ldx #$80
	cmp #$57
	beq L980a
	cmp #$41
	beq L9807
	bne L97bd
L97ff
	jmp L9847
	
L9802
	stx L9b55
	beq L97bd
L9807
	sta L9b4f
L980a
	stx L9b50
	beq L97bd
L980f
	lda LTK_MiscWorkspace,y
	cmp #$2c
	beq L981d
	iny
	cpy $b7
	bcc L980f
	bcs L9831
L981d
	iny
	lda LTK_MiscWorkspace,y
	sta $9e03
	lda #$00
	iny
	cpy $b7
	bcs L982e
	lda LTK_MiscWorkspace,y
L982e
	sta $9de5
L9831
	ldy #$48
L9833
	ldx $9de4
	lda #$aa
	sta $9dfe,x
	lda #$95
	pha
	lda #$df
	pha
	tya
	ldx #$03
	jmp LTK_CallExtDosOvl 
	
L9847
	lda #$02
	sec
	jsr $9f00
	bcc L9853
	ldy #$05
	bne L9867
L9853
	jsr LTK_FindFile 
	sta $9e04
	stx L9b59
	sty L9b58
	bcc L98ac
	cpx #$ff
	bne L9875
L9865
	ldy #$21
L9867
	jsr LTK_ErrorHandler 
	ldx $9de4
	lda #$00
	sta $9dff,x
	jmp L9abd
	
L9875
	pha
	pla
	bne L9883
	txa
	bne L9883
	tya
	bne L9883
	ldy #$48
	bne L9867
L9883
	ldy #$3e
	lda L9b50
	beq L9867
	lda L9b4f
L988d
	bne L9867
	sta L9b4e
	jmp L9ad6
	
L9895
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L98a0
	ldx #$11
L98a0
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98a9
	jmp L9911
	
L98ac
	lda $91f8
	cmp #$04
	bcc L9865
	cmp #$04
	bne L98ba
	jmp L9b18
	
L98ba
	lda L9b50
	beq L98cd
	lda L9b4f
	bne L98cd
	lda L9b4e
	bne L98cd
	ldy #$3f
	bne L9867
L98cd
	lda $91f8
	cmp #$0f
	bne L98d7
	jmp L9831
	
L98d7
	lda L9b50
	beq L9911
	lda L9b4f
	bne L9911
	jsr LTK_DeallocateRndmBlks 
	bcc L98f2
	cpx #$80
	bne L98ef
	tax
	ldy #$04
	bne L988d
L98ef
	jsr LTK_FatalError 
L98f2
	lda #$00
	tay
L98f5
	sta $9200,y
	iny
	bne L98f5
	ldx #$e0
L98fd
	sta $9300,y
	iny
	dex
	bne L98fd
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	jmp L9ad6
	
L9911
	ldx $9de4
	lda $9e04
	sta $9dfd,x
	lda $9200
	sta $9de7,x
	lda $9201
	sta $9de8,x
	lda $91fa
	sta $9de1,x
	lda $91fb
	sta $9de2,x
	lda $91f0
	sta $9df0,x
	tay
	lda $91f1
	sta $9df1,x
	cmp #$01
	bne L994b
	tya
	bne L994b
	lda #$40
	sta $9dfc,x
L994b
	lda $91f6
	sta $9df2,x
	lda $91f7
	sta $9df3,x
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9de6,x
	ldy #$02
	sty L9981 + 1
	dey
	sty L997b + 1
	dey
	lda $91f1
	ldx $91f0
	bne L997a
	cmp #$f1
	bcc L9994
L997a
	iny
L997b
	cpx #$00
	bcc L9994
	bne L9987
L9981
	cmp #$00
	bcc L9994
	beq L9994
L9987
	inc L9981 + 1
	bne L998f
	inc L997b + 1
L998f
	inc L997b + 1
	bne L997a
L9994
	iny
	iny
	sty L99ad + 1
	ldx $9de4
	lda $9df1,x
	ldy $9df0,x
	bne L99ac
	cmp #$01
	beq L99ec
	cmp #$02
	beq L99c7
L99ac
	sec
L99ad
	sbc #$00
	sta $9df6,x
	bcs L99b5
	dey
L99b5
	tya
	sta $9df5,x
	ldy #$09
L99bb
	asl $9df6,x
	rol $9df5,x
	rol $9df4,x
	dey
	bne L99bb
L99c7
	ldy $91fc
	lda $91f9
	and #$01
	bne L99d7
	cpy #$00
	bne L99d7
	lda #$02
L99d7
	pha
	tya
	clc
	adc $9df6,x
	sta $9df6,x
	pla
	adc $9df5,x
	sta $9df5,x
	bcc L99ec
	inc $9df4,x
L99ec
	lda $91f4
	sta $9df7,x
	lda $91f5
	sta $9df8,x
	lda $91f8
	cmp #$0d
	beq L9a28
	cmp #$0e
	beq L9a28
	cmp #$0f
	beq L9a28
	cmp #$10
	beq L9a28
	ldy L9b50
	beq L9a3c
	lda $9df4,x
	bne L9a28
	lda $9df5,x
	bne L9a28
	lda $9df6,x
	beq L9a2d
	cmp #$01
	bne L9a28
	inc $9dfe,x
	bne L9a2d
L9a28
	lda #$aa
	sta $9dfe,x
L9a2d
	lda L9b55
	beq L9a3c
	cmp $91f8
	beq L9a3c
	ldy #$40
	jmp L9867
	
L9a3c
	clc
	lda $91f8
	adc L9b50
	sta $9df9,x
	lda $91f9
	sta $9dfa,x
	lda $91fc
	sta $9dfb,x
	lda L9b4f
	beq L9a8a
	lda #$fe
	sta $9dea,x
	lda #$ff
	sta $9de9,x
	lda $91f0
	bne L9a70
	lda $91f1
	cmp #$02
	bcs L9a70
	inc $9dea,x
L9a70
	lda $9df4,x
	sta $9ded,x
	lda $9df5,x
	sta $9dee,x
	lda $9df6,x
	sta $9def,x
	lda #$00
	sta $9deb,x
	sta $9dec,x
L9a8a
	lda $b8
	sta LTK_FileParamTable,x
	cpx #$e0
	bne L9aa0
	lda $b7
	beq L9abc
	lda #$95
	pha
	lda #$df
	pha
	jmp LTK_CmdChnProcess 
	
L9aa0
	lda L9b51
	beq L9ab7
	ldy #$00
	lda $b7
	sta LTK_DirPtnMatchBuffer
L9aac
	lda LTK_MiscWorkspace,y
	sta $9fe1,y
	iny
	cpy $b7
	bcc L9aac
L9ab7
	ldy #$00
	jsr LTK_ErrorHandler 
L9abc
	clc
L9abd
	php
	lda #$02
	clc
	jsr $9f00
	plp
	lda $9de3
	sta LTK_Var_ActiveLU
	lda L9b57
	sta LTK_Var_Active_User
	lda #$00
	jmp LTK_SysRet_AsIs  
	
L9ad6
	lda L9b55
	sta $91f8
	ldx #$00
	stx $91f0
	inx
	stx $91f1
	jsr LTK_AllocateRandomBlks 
	bcc L9af6
	ldy #$48
	cpx #$80
	bne L9af3
	tax
	ldy #$04
L9af3
	jmp L9867
	
L9af6
	lda $9e04
	pha
	ldx L9b59
	ldy L9b58
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9b15
	jmp L9911
	
L9b18
	lda #$00
	ldy #$0a
	ldx $9de4
L9b1f
	sta $9de9,x
	inx
	dey
	bne L9b1f
	ldx $9de4
	lda $b8
	sta LTK_FileParamTable,x
	lda $91fd
	sta $9de6,x
	lda $9200
	sta $9de7,x
	lda $9201
	sta $9de8,x
	lda #$04
	sta $9df9,x
	lda $9e04
	sta $9dfd,x
	jmp L9ab7
	
L9b4e
	.byte $00
L9b4f
	.byte $00
L9b50
	.byte $00
L9b51
	.byte $00
L9b52
	.byte $00
L9b53
	.byte $00
L9b54
	.byte $00
L9b55
	.byte $00
L9b56
	.byte $00
L9b57
	.byte $00
L9b58
	.byte $00
L9b59
	.byte $00
S9b5a
	sta L9b6b + 1
	stx L9b6b + 2
	lda #$00
	sta L9bd5
	sta L9bd6
	sta L9bd7
L9b6b
	lda L9b6b,y
	cmp #$30
	bcc L9bc3
	cmp #$3a
	bcc L9b88
	ldx $9b94
	cpx #$0a
	beq L9bc3
	cmp #$41
	bcc L9bc3
	cmp #$47
	bcs L9bc3
	sec
	sbc #$07
L9b88
	ldx L9bd5
	beq L9bac
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b95
	clc
	adc L9bd7
	pha
	txa
	adc L9bd6
	tax
	pla
	dey
	bne L9b95
	sta L9bd7
	stx L9bd6
	pla
	tay
	pla
L9bac
	inc L9bd5
	sec
	sbc #$30
	clc
	adc L9bd7
	sta L9bd7
	bcc L9bc0
	inc L9bd6
	beq L9bcd
L9bc0
	iny
	bne L9b6b
L9bc3
	cmp #$20
	beq L9bc0
	clc
	ldx L9bd5
	bne L9bce
L9bcd
	sec
L9bce
	lda L9bd6
	ldx L9bd7
	rts
	
L9bd5
	.byte $00
L9bd6
	.byte $00
L9bd7
	.byte $00
