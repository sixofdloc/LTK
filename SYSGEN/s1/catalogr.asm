;catalogr.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for the sysgen disk
 
L93e0               
	stx S9507 + 1
	sty S9507 + 2
	stx L9420 + 1
	sty L9420 + 2
	pla
	tax
	pla
	tay
	pla
	sta L950c
	tya
	pha
	txa
	pha
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L9403
	lda #$11
L9403
	sec
	ldy #$00
	adc L950c
	tax
	bcc L940d
	iny
L940d
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L9417
	pha
	txa
	pha
	tya
	pha
	ldx #$00
	ldy #$1d
L9420
	lda L9420,y
	bmi L9426
	dex
L9426
	stx L950d
	lda $8ffc
	pha
	lda #$00
	tay
	ldx #$20
L9432
	jsr S9507
	dex
	bne L9432
	pla
	sta $8ffc
	ldy #$00
	ldx #$00
L9440
	lda LTK_FileHeaderBlock,x
	jsr S9507
	inx
	cpy #$10
	bne L9440
	lda LTK_FileHeaderBlock + LTK_FHB_NumBlocks 		;$91f0
	jsr S9507
	lda LTK_FileHeaderBlock + LTK_FHB_NumBlocks+$01		;$91f1
	jsr S9507
	lda LTK_FileHeaderBlock + LTK_FHB_BytesPerRec		;$91f4
	jsr S9507
	lda LTK_FileHeaderBlock + LTK_FHB_BytesPerRec+$01	;$91f5
	jsr S9507
 	lda LTK_FileHeaderBlock + LTK_FHB_RecsInFile		;$91f6
 	jsr S9507
 	lda LTK_FileHeaderBlock + LTK_FHB_RecsInFile+$01	;$91f7
 	jsr S9507
 	lda LTK_FileHeaderBlock + LTK_FHB_FileType 		;$91f8
 	jsr S9507
 	lda LTK_FileHeaderBlock + LTK_FHB_LoadAddress		;$91fa
 	jsr S9507
 	lda LTK_FileHeaderBlock + LTK_FHB_LoadAddress+$01	;$91fb
 	jsr S9507
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta LTK_FileHeaderBlock + LTK_FHB_UserAndLU		;$91fd
	jsr S9507
	lda #$80
	jsr S9507
	ldy #$1e
	lda LTK_FileHeaderBlock + LTK_FHB_BLMiLo		;$9200
	jsr S9507
        lda LTK_FileHeaderBlock + LTK_FHB_BLMiLo+$01		;$9201
	jsr S9507
	lda L950d
	bne L94ac
	inc $8ffc
L94ac
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L94b8
	lda $8ffc
	pha
	lda LTK_Var_ActiveLU
	ldx #$f0
	cmp #$0a
	beq L94c7
	ldx #$11
L94c7
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L94d0
	pla
	bit L950d
	bmi L94f0
	cmp #$01
	bne L94f0
	tya
	pha
	ldy L950c
	lda #$ff
	sta $9002,y
	pla
	tay
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L94f0
	lda $8ffe
	sta $91fe
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01
L9506
	rts
                    
S9507
	sta S9507,y
	iny
	rts
                    
L950c
	.byte $00 
L950d
	.byte $00 