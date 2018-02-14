	;l.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=$95e0 ;overlay, change to $4000 for the sysgen disk
 	
L95e0
	sta $97d5
	ldx $c8
	lda LTK_Var_CPUMode
	beq L95ec
	ldx $ea
L95ec
	stx $97d6
	lda LTK_Var_ActiveLU
	sta Active_LU_Temp ;$97d7
	lda LTK_Var_Active_User
	sta Active_User_Temp ;$97d8
	lda LTK_Save_XReg
	sta XReg_Temp ;$97cf
	lda LTK_Save_YReg
	sta YReg_Temp ;$97d0
	jsr LTK_ClearHeaderBlock
	ldy $97d5
	cpy $97d6
	bcc L9615
	jmp L977d
                    
L9615
	iny
	cpy $97d6
	bcc L961e
	jmp L977d
                    
L961e 
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L9626
	iny
L9626
	ldx $97d6
	lda LTK_Command_Buffer-1,x
	cmp #$22
	bne L9633
	dec $97d6
L9633
	cpy $97d6
	bcc L963b
	jmp L977d
                    
L963b
	sty $97d5
	jsr S97a9
	bcc L9649
	cmp #$3a
	beq L9652
	bne L9661
L9649
	txa
	jsr LTK_SetLuActive
	bcc L9652
	jmp L9771
                    
L9652
	jsr S97a9
	bcs L9661
	cpx #$10
	bcc L965e
	jmp L9777
                    
L965e
	stx LTK_Var_Active_User
L9661
	ldy $97d5
	ldx #$00
L9666
	cpy $97d6
	bcs L9675
	lda LTK_Command_Buffer,y
	sta LTK_FileHeaderBlock,x
	inx
	iny
	bne L9666
L9675
	jsr LTK_FindFile
	bcc L967d
	jmp L9789
                    
L967d
	lda $91f8
	cmp #$0b
	bne L969e
	lda #$00
	sta $b9
	ldx $2b
	ldy $2c
	lda LTK_Var_CPUMode
	beq L9695
	ldx $2d
	ldy $2e
L9695
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	jmp L96a9
                    
L969e
	cmp #$0c
	beq L96a5
	jmp L9783
                    
L96a5
	lda #$01
	sta $b9
L96a9
	lda LTK_Var_CPUMode
	beq L96b2
	lda #$00
	sta $c6
L96b2
	jsr LTK_LoadRandFile
	lda LTK_Var_CPUMode
	bne L96d1
	stx $2d
	stx $2f
	stx $31
	sty $2e
	sty $30
	sty $32
	ldx $37
	stx $33
	ldx $38
	stx $34
	jmp L96d7
                    
L96d1
	stx $1210
	sty $1211
L96d7
	ldx #$33
	ldy #$a5
	pha
	pla
	beq L96e3
	ldx #$4f
	ldy #$4f
L96e3
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall
	lda LTK_Var_CPUMode
	beq L976d
	clc
	lda $2d
	adc #$ff
	sta $3d
	lda $2e
	adc #$ff
	sta $3e
	lda #$00
	sta $98
	ldx #$03
	stx $9a
	sta $99
	tay
	ldx #$08
L9709
	lda #$00
	sta LTK_FileParamTable,y
	sta $9dff,y
	tya
	clc
	adc #$20
	tay
	dex
	bne L9709
	ldy #$00
	sty $7a
	dey
	sty $120c
	sty $1209
	sty $120a
	sty $1208
	lda $39
	ldy $3a
	sta $35
	sty $36
	lda #$ff
	ldy #$09
	sta $7d
	sty $7e
	lda $2f
	ldy $30
	sta $31
	sty $32
	sta $33
	sty $34
	ldx #$03
L9748
	lda strSpecialChars,x
	sta $1204,x
	dex
	bpl L9748
	sec
	lda $2d
	ldy $2e
	sbc #$01
	bcs L975b
	dey
L975b
	sta $43
	sty $44
	ldx #$1b
	stx $18
	lda #$00
	sta $1203
	sta $12
	sta $03df
L976d
	ldy #$00
	beq L978d
L9771
	ldx #<strInvalidLU
	ldy #>strInvalidLU
	bne L978d
L9777
	ldx #<str_InvalidUser
	ldy #>str_InvalidUser
	bne L978d
L977d
	ldx #<strNoFilename
	ldy #>strNoFilename
	bne L978d
L9783
	ldx #<strIllegalFileType
	ldy #>strIllegalFileType
	bne L978d
L9789
	ldx #<strProgramNotExist
	ldy #>strProgramNotExist
L978d
	jsr LTK_ErrorHandler
	lda Active_LU_Temp ;$97d7
	sta LTK_Var_ActiveLU
	lda Active_User_Temp ;$97d8
	sta LTK_Var_Active_User
	lda XReg_Temp ;$97cf
	sta LTK_Save_XReg
	lda YReg_Temp ;$97d0
	sta LTK_Save_YReg
	rts
                    
S97a9
	ldy $97d5
	lda #$00
	ldx #$02
	cpy $97d6
	bcs L97cd
	jsr S984f
	php
	bcs L97bf
	pha
	pla
	bne L97cc
L97bf
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L97cc
	iny
	sty $97d5
	plp
	rts
                    
L97cc
	plp
L97cd
	sec
	rts
                    
XReg_Temp ;$97cf
	.byte $00
	
YReg_Temp ;$97d0
	.byte $00
	
strSpecialChars ;$97d1
	.text " ,.$"

        ;$97d5
        .byte $00

        ;$97d6
        .byte $00
        
Active_LU_Temp ;$97d7
        .byte $00
        
Active_User_Temp ;$97d8
        .byte $00
        
strIllegalFileType ;$97d9
	.text "illegal file type !!"
	.byte $00
	
strProgramNotExist ;$97ee
	.text "program does not exist !!"
	.byte $00
	
strNoFilename ;$9808
	.text "no filename given !!{return}"
	.byte $00
	
strInvalidLU ;$981e
	.text "invalid logical unit !!{return}"
	.byte $00
	
str_InvalidUser ;$9837
	.text "invalid user number !!{return}"
	.byte $00
	
S984f
	sta L9860 + 1
	stx L9860 + 2
	lda #$00
	sta $98ca
	sta $98cb
	sta $98cc
L9860
	lda L9860,y
	cmp #$30
	bcc L98b8
	cmp #$3a
	bcc L987d
	ldx $9889
	cpx #$0a
	beq L98b8
	cmp #$41
	bcc L98b8
	cmp #$47
	bcs L98b8
	sec
	sbc #$07
L987d
	ldx $98ca
	beq L98a1
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L988a
	clc
	adc $98cc
	pha
	txa
	adc $98cb
	tax
	pla
	dey
	bne L988a
	sta $98cc
	stx $98cb
	pla
	tay
	pla
L98a1
	inc $98ca
	sec
	sbc #$30
	clc
	adc $98cc
	sta $98cc
	bcc L98b5
	inc $98cb
	beq L98c2
L98b5
	iny
	bne L9860
L98b8
	cmp #$20
	beq L98b5
	clc
	ldx $98ca
	bne L98c3
L98c2
	sec
L98c3
	lda $98cb
	ldx $98cc
	rts

	;$98ca
	.byte $00
	;$98cb
	.byte $00
	;$98cc
	.byte $00                    
