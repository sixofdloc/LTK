;openfile.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen 
L95e0
	ldy $b7
	lda $31
	pha
	lda $32
	pha
	lda $bb
	sta $31
	lda $bc
	sta $32
	dey
L95f1
	jsr $fc6e
	sta LTK_MiscWorkspace,y
	dey
	bpl L95f1
	pla
	sta $32
	pla
	sta $31
	lda #$00
	sta $90
	sta L9b36
	sta L9b37
	sta L9b39
	sta L9b3a
	sta $9e04
	sta L9b3e
	lda LTK_Var_ActiveLU
	sta $9de3
	lda LTK_Var_Active_User
	sta L9b3f
	ldx $b8
	bne L9631
	ldx #$0a
	ldy #$f7
L962a
	sec
	jsr LTK_KernalTrapSetup
	jmp LTK_SysRet_AbsJmp 
	
L9631
	sec
	ldx #$0f
	ldy #$f3
	jsr LTK_KernalTrapSetup
	ldx $b8
	jsr LTK_KernalCall 
	bne L9646
	ldx #$fe
	ldy #$f6
	bne L962a
L9646
	ldx $98
	cpx #$0a
	bcc L9652
L964c
	ldx #$fb
	ldy #$f6
	bne L962a
L9652
	lda $b9
	and #$0f
	cmp #$0f
	bne L965e
	ldx #$e0
	bne L9671
L965e
	ldy #$07
	ldx #$00
L9662
	lda LTK_FileParamTable,x
	beq L9671
	txa
	clc
	adc #$20
	tax
	dey
	bne L9662
	beq L964c
L9671
	stx $9de4
	lda #$00
	cpx #$e0
	bne L967d
	lda $9df6,x
L967d
	pha
	ldy #$03
	lda #$00
L9682
	sta LTK_FileParamTable,x
	inx
	dey
	bne L9682
	ldy #$1a
L968b
	sta $9de3,x
	inx
	dey
	bne L968b
	ldx $9de4
	pla
	sta $9df6,x
	cpx #$e0
	beq L96a3
	dec $9de9,x
	dec $9dea,x
L96a3
	ldy $98
	inc $98
	lda $b8
	sta $0259,y
	lda $b9
	pha
	ora #$60
	sta $b9
	sta $026d,y
	lda $ba
	sta $0263,y
	pla
	sta $9dff,x
	cpx #$e0
	bne L96cb
	lda #$aa
	sta $9dfe,x
	jmp L9a74
	
L96cb
	jsr LTK_ClearHeaderBlock 
	tax
	lda $b9
	cmp #$60
	beq L96db
	cmp #$61
	bne L96e0
	ldx #$80
L96db
	ldy #$0b
	dec L9b3e
L96e0
	stx L9b38
	sty L9b3d
	ldy #$00
	sty L9b3c
L96eb
	cpy $b7
	bcs L970d
	lda LTK_MiscWorkspace,y
	cmp #$3a
	beq L9709
	cmp #$20
	beq L9706
	cmp #$40
	beq L9706
	cmp #$30
	bcc L970d
	cmp #$3a
	bcs L970d
L9706
	iny
	bne L96eb
L9709
	iny
	sty L9b3c
L970d
	ldy L9b3c
	bne L971f
	lda LTK_MiscWorkspace,y
	cmp #$24
	beq L9734
	cmp #$23
	bne L9781
	beq L973d
L971f
	dey
	bmi L9749
	lda LTK_MiscWorkspace,y
	cmp #$20
	bne L9730
	lda #$30
	sta LTK_MiscWorkspace,y
	bne L971f
L9730
	cmp #$24
	bne L9739
L9734
	dec L9b39
	bne L9749
L9739
	cmp #$23
	bne L9742
L973d
	dec L9b3a
	bne L9749
L9742
	cmp #$40
	bne L971f
	dec L9b36
L9749
	iny
	cpy $b7
	bcs L9762
	lda #$e0
	ldx #$8f
	jsr S9b42
	bcs L9762
	cpx $9de3
	beq L9762
	txa
	jsr LTK_SetLuActive 
	bcs L9790
L9762
	ldx $9de4
	lda L9b39
	beq L9777
	lda #$24
	sta $9dfe,x
	lda #$01
	sta L9b3d
	jmp L987f
	
L9777
	lda L9b3a
	beq L9781
	ldy #$72
	jmp L981d
	
L9781
	ldy L9b3c
	ldx #$00
	stx L9b39
	stx L9b3a
	cpy $b7
	bcc L9793
L9790
	jmp L984f
	
L9793
	lda LTK_MiscWorkspace,y
	cmp #$2c
	beq L97a5
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	cpy $b7
	bcc L9793
	bcs L97e9
L97a5
	lda LTK_MiscWorkspace,y
	iny
	cpy $b7
	bcs L97e9
	cmp #$2c
	bne L97a5
	lda LTK_MiscWorkspace,y
	ldx #$0b
	cmp #$50
	beq L97ec
	ldx #$0c
	cmp #$4d
	beq L97ec
	ldx #$0d
	cmp #$53
	beq L97ec
	ldx #$0e
	cmp #$55
	beq L97ec
	ldx #$0f
	cmp #$4c
	beq L97f9
	ldx L9b3e
	bne L97a5
	ldx #$00
	cmp #$52
	beq L97f4
	ldx #$80
	cmp #$57
	beq L97f4
	cmp #$41
	beq L97f1
	bne L97a5
L97e9
	jmp L9831
	
L97ec
	stx L9b3d
	beq L97a5
L97f1
	sta L9b37
L97f4
	stx L9b38
	beq L97a5
L97f9
	lda LTK_MiscWorkspace,y
	cmp #$2c
	beq L9807
	iny
	cpy $b7
	bcc L97f9
	bcs L981b
L9807
	iny
	lda LTK_MiscWorkspace,y
	sta $9e03
	lda #$00
	iny
	cpy $b7
	bcs L9818
	lda LTK_MiscWorkspace,y
L9818
	sta $9de5
L981b
	ldy #$48
L981d
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
	
L9831
	lda #$02
	sec
	jsr $9f00
	bcc L983d
	ldy #$05
	bne L9851
L983d
	jsr LTK_FindFile 
	sta $9e04
	stx L9b41
	sty L9b40
	bcc L9896
	cpx #$ff
	bne L985f
L984f
	ldy #$21
L9851
	jsr LTK_ErrorHandler 
	ldx $9de4
	lda #$00
	sta $9dff,x
	jmp L9aa7
	
L985f
	pha
	pla
	bne L986d
	txa
	bne L986d
	tya
	bne L986d
	ldy #$48
	bne L9851
L986d
	ldy #$3e
	lda L9b38
	beq L9851
	lda L9b37
L9877
	bne L9851
	sta L9b36
	jmp L9abe
	
L987f
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L988a
	ldx #$11
L988a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9893
	jmp L98fb
	
L9896
	lda $91f8
	cmp #$04
	bcc L984f
	cmp #$04
	bne L98a4
	jmp L9b00
	
L98a4
	lda L9b38
	beq L98b7
	lda L9b37
	bne L98b7
	lda L9b36
	bne L98b7
	ldy #$3f
	bne L9851
L98b7
	lda $91f8
	cmp #$0f
	bne L98c1
	jmp L981b
	
L98c1
	lda L9b38
	beq L98fb
	lda L9b37
	bne L98fb
	jsr LTK_DeallocateRndmBlks 
	bcc L98dc
	cpx #$80
	bne L98d9
	tax
	ldy #$04
	bne L9877
L98d9
	jsr LTK_FatalError 
L98dc
	lda #$00
	tay
L98df
	sta $9200,y
	iny
	bne L98df
	ldx #$e0
L98e7
	sta $9300,y
	iny
	dex
	bne L98e7
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	jmp L9abe
	
L98fb
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
	bne L9935
	tya
	bne L9935
	lda #$40
	sta $9dfc,x
L9935
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
	sty $996c
	dey
	sty $9966
	dey
	lda $91f1
	ldx $91f0
	bne L9964
	cmp #$f1
	bcc L997e
L9964
	iny
	cpx #$00
	bcc L997e
	bne L9971
	cmp #$00
	bcc L997e
	beq L997e
L9971
	inc $996c
	bne L9979
	inc $9966
L9979
	inc $9966
	bne L9964
L997e
	iny
	iny
	sty $9998
	ldx $9de4
	lda $9df1,x
	ldy $9df0,x
	bne L9996
	cmp #$01
	beq L99d6
	cmp #$02
	beq L99b1
L9996
	sec
	sbc #$00
	sta $9df6,x
	bcs L999f
	dey
L999f
	tya
	sta $9df5,x
	ldy #$09
L99a5
	asl $9df6,x
	rol $9df5,x
	rol $9df4,x
	dey
	bne L99a5
L99b1
	ldy $91fc
	lda $91f9
	and #$01
	bne L99c1
	cpy #$00
	bne L99c1
	lda #$02
L99c1
	pha
	tya
	clc
	adc $9df6,x
	sta $9df6,x
	pla
	adc $9df5,x
	sta $9df5,x
	bcc L99d6
	inc $9df4,x
L99d6
	lda $91f4
	sta $9df7,x
	lda $91f5
	sta $9df8,x
	lda $91f8
	cmp #$0d
	beq L9a12
	cmp #$0e
	beq L9a12
	cmp #$0f
	beq L9a12
	cmp #$10
	beq L9a12
	ldy L9b38
	beq L9a26
	lda $9df4,x
	bne L9a12
	lda $9df5,x
	bne L9a12
	lda $9df6,x
	beq L9a17
	cmp #$01
	bne L9a12
	inc $9dfe,x
	bne L9a17
L9a12
	lda #$aa
	sta $9dfe,x
L9a17
	lda L9b3d
	beq L9a26
	cmp $91f8
	beq L9a26
	ldy #$40
	jmp L9851
	
L9a26
	clc
	lda $91f8
	adc L9b38
	sta $9df9,x
	lda $91f9
	sta $9dfa,x
	lda $91fc
	sta $9dfb,x
	lda L9b37
	beq L9a74
	lda #$fe
	sta $9dea,x
	lda #$ff
	sta $9de9,x
	lda $91f0
	bne L9a5a
	lda $91f1
	cmp #$02
	bcs L9a5a
	inc $9dea,x
L9a5a
	lda $9df4,x
	sta $9ded,x
	lda $9df5,x
	sta $9dee,x
	lda $9df6,x
	sta $9def,x
	lda #$00
	sta $9deb,x
	sta $9dec,x
L9a74
	lda $b8
	sta LTK_FileParamTable,x
	cpx #$e0
	bne L9a8a
	lda $b7
	beq L9aa6
	lda #$95
	pha
	lda #$df
	pha
	jmp LTK_CmdChnProcess 
	
L9a8a
	lda L9b39
	beq L9aa1
	ldy #$00
	lda $b7
	sta LTK_DirPtnMatchBuffer
L9a96
	lda LTK_MiscWorkspace,y
	sta $9fe1,y
	iny
	cpy $b7
	bcc L9a96
L9aa1
	ldy #$00
	jsr LTK_ErrorHandler 
L9aa6
	clc
L9aa7
	php
	lda #$02
	clc
	jsr $9f00
	plp
	lda $9de3
	sta LTK_Var_ActiveLU
	lda L9b3f
	sta LTK_Var_Active_User
	jmp LTK_SysRet_AsIs  
	
L9abe
	lda L9b3d
	sta $91f8
	ldx #$00
	stx $91f0
	inx
	stx $91f1
	jsr LTK_AllocateRandomBlks 
	bcc L9ade
	ldy #$48
	cpx #$80
	bne L9adb
	tax
	ldy #$04
L9adb
	jmp L9851
	
L9ade
	lda $9e04
	pha
	ldx L9b41
	ldy L9b40
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9afd
	jmp L98fb
	
L9b00
	lda #$00
	ldy #$0a
	ldx $9de4
L9b07
	sta $9de9,x
	inx
	dey
	bne L9b07
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
	jmp L9aa1
	
L9b36
	.byte $00
L9b37
	.byte $00
L9b38
	.byte $00
L9b39
	.byte $00
L9b3a
	.byte $00
L9b3b
	.byte $00
L9b3c
	.byte $00
L9b3d
	.byte $00
L9b3e
	.byte $00
L9b3f
	.byte $00
L9b40
	.byte $00
L9b41
	.byte $00
S9b42
	sta L9b53 + 1
	stx L9b53 + 2
	lda #$00
	sta L9bbd
	sta L9bbe
	sta L9bbf
L9b53
	lda L9b53,y
	cmp #$30
	bcc L9bab
	cmp #$3a
	bcc L9b70
	ldx $9b7c
	cpx #$0a
	beq L9bab
	cmp #$41
	bcc L9bab
	cmp #$47
	bcs L9bab
	sec
	sbc #$07
L9b70
	ldx L9bbd
	beq L9b94
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b7d
	clc
	adc L9bbf
	pha
	txa
	adc L9bbe
	tax
	pla
	dey
	bne L9b7d
	sta L9bbf
	stx L9bbe
	pla
	tay
	pla
L9b94
	inc L9bbd
	sec
	sbc #$30
	clc
	adc L9bbf
	sta L9bbf
	bcc L9ba8
	inc L9bbe
	beq L9bb5
L9ba8
	iny
	bne L9b53
L9bab
	cmp #$20
	beq L9ba8
	clc
	ldx L9bbd
	bne L9bb6
L9bb5
	sec
L9bb6
	lda L9bbe
	ldx L9bbf
	rts
	
L9bbd
	.byte $00
L9bbe
	.byte $00
L9bbf
	.byte $00
