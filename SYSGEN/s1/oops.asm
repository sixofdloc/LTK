;oops.r.prg
 
 	.include "../../include/ltk_dos_addresses.asm"
 	.include "../../include/ltk_equates.asm"
 
 	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen

L95e0
	lda #$31
	sta L97cb
	lda #$02
	sec
	jsr $9f00
	bcc L95f0
	jmp L9751
	
L95f0
	jsr S977d
	jsr LTK_FindFile 
	bcs L9605
	ldx L97cb
	inc L97cb
	cpx #$39
	bne L95f0
	jmp L9755
	
L9605
	sta L97aa
	stx L97b0
	sty L97af
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L9619
	ldx #$00
L9619
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9622
	ldy $9076
	ldx $9077
	cpy #$ff
	bne L9633
	cpx #$ff
	bne L9633
	jmp L975b
	
L9633
	sty L97ad
	stx L97ae
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9640
	lda LTK_FileHeaderBlock 
	bne L9648
	jmp L975b
	
L9648
	lda $91f8
	cmp #$0a
	bcc L965b
	cmp #$0d
	beq L965e
	cmp #$0c
	beq L965e
	cmp #$0b
	beq L965e
L965b
	jmp L975b
	
L965e
	ldy #$00
L9660
	lda LTK_FileHeaderBlock ,y
	sta L97b2,y
	iny
	cpy #$10
	bne L9660
	lda #$00
	tay
L966e
	sta $9200,y
	iny
	bne L966e
	ldx #$e0
L9676
	sta $9300,y
	iny
	dex
	bne L9676
	lda $91fd
	sta L97b1
	jsr S9780
	jsr LTK_AllocateRandomBlks 
	bcc L9696
	cpx #$80
	bne L9693
	tax
	jmp L974d
	
L9693
	jmp L9761
	
L9696
	lda L97aa
	pha
	ldx L97b0
	ldy L97af
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy L97ad
	ldx L97ae
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L96b5
	lda #$00
	
	sta LTK_BLKAddr_MiniSub
	sta L97ab
	sta L97ac
	jsr S979c
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L96cd
	jmp L96ea
	
L96d0
	jsr S978e
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L96dd
	jsr S979c
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L96ea
	inc L97ac
	bne L96f2
	inc L97ab
L96f2
	lda $91f0
	cmp L97ab
	bne L96d0
	lda $91f1
	cmp L97ac
	bne L96d0
	ldx #$57
	ldy #$98
	jsr LTK_Print 
	lda L97b1
	pha
	and #$0f
	jsr S976f
	stx L97d3
	sta L97d4
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	jsr S976f
	stx $97d6
	sta L97d7
	ldx #$d3
	ldy #$97
	jsr LTK_Print 
	ldx #$b2
	ldy #$97
	jsr LTK_Print 
	ldx #$41
	ldy #$98
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$54
	ldy #$98
	jsr LTK_Print 
	ldy #$00
	beq L9765
L974d
	ldy #$04
	bne L9765
L9751
	ldy #$05
	bne L9765
L9755
	ldx #$da
	ldy #$97
	bne L9765
L975b
	ldx #$fd
	ldy #$97
	bne L9765
L9761
	ldx #$1c
	ldy #$98
L9765
	jsr LTK_ErrorHandler 
	lda #$02
	clc
	jsr $9f00
	rts
	
S976f
	ldx #$30
L9771
	cmp #$0a
	bcc L977a
	sbc #$0a
	inx
	bne L9771
L977a
	adc #$30
	rts
	
S977d
	jsr LTK_ClearHeaderBlock 
S9780
	ldy #$00
L9782
	lda L97c3,y
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne L9782
	rts
	
S978e
	lda L97ac
	asl a
	tax
	lda $9000,x
	tay
	lda $9001,x
	tax
	rts
	
S979c
	lda L97ac
	asl a
	tax
	lda $9200,x
	tay
	lda $9201,x
	tax
	rts
	
L97aa
	.byte $00
L97ab
	.byte $00
L97ac
	.byte $00
L97ad
	.byte $00
L97ae
	.byte $00
L97af
	.byte $00
L97b0
	.byte $00
L97b1
	.byte $00
L97b2
	.byte $00
L97b3
	.byte $00
L97b4
	.byte $00
L97b5
	.byte $00
L97b6
	.byte $00
L97b7
	.byte $00
L97b8
	.byte $00
L97b9
	.byte $00
L97ba
	.byte $00
L97bb
	.byte $00
L97bc
	.byte $00
L97bd
	.byte $00
L97be
	.byte $00
L97bf
	.byte $00
L97c0
	.byte $00
L97c1
	.byte $00
L97c2
	.byte $00
L97c3
	.text "oopsfile"
L97cb
	.text "1"
	.byte $00
L97cd
	.byte $00
L97ce
	.byte $00
L97cf
	.byte $00
L97d0
	.byte $00
L97d1
	.byte $00
L97d2
	.byte $00
L97d3
	.byte $00
L97d4
	.byte $00
L97d5
	.text ":"
	.byte $00
L97d7
	.byte $00
L97d8
	.text ":"
	.byte $00
L97da
	.text "all nine oops files are in use !!{return}"
	.byte $00
L97fd
	.text "invalid header-cannot recover{return}"
	.byte $00
L981c
	.text "not enough disk space to recover !!{return}"
	.byte $00
L9841
	.text "{rvs off} - recovered in {$22}"
	.byte $00
L9854
	.text "{$22}{Return}"
	.byte $00
L9857
	.text "{Return}{Return}{Rvs On}"
	.byte $00
