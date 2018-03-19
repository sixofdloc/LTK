;clear.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"

 	*=LTK_DOSOverlay 

L95e0
	lda LTK_Var_ActiveLU
	sta L975e
	lda #$fe
	sta L975f
	ldx #$32
	ldy #$98
	jsr LTK_Print 
L95f2
	ldx #$96
	ldy #$97
	jsr S9740
	bcs L95f2
	cpy #$01
	bne L9602
	jmp L972b
	
L9602
	lda #$85
	ldx #$97
	ldy #$00
	jsr S9834
	bcs L95f2
	txa
	jsr LTK_SetLuActive 
	bcc L9620
	ldx #$17
	ldy #$98
	jsr LTK_Print 
	jsr S98b2
	jmp L95f2
	
L9620
	lda #$02
	sec
	jsr $9f00
	bcc L962b
	jmp L9738
	
L962b
	ldx #$b9
	ldy #$97
	jsr S9708
	bcs L9620
	stx L9762
L9637
	ldx #$dc
	ldy #$97
	jsr S9740
	bcs L9637
	cmp #$4e
	beq L95f2
	cmp #$59
	bne L9637
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L9653
	ldx #$11
L9653
	ldy #$00
	clc
	stx $9681
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L965f
	lda L975f
	beq L9672
	ldy L9760
L9667
	lda $9202,y
	bne L9675
	iny
	dec L975f
	bne L9667
L9672
	jmp L9724
	
L9675
	iny
	tya
	sta L9760
	ldy #$00
	dec L975f
	clc
	adc #$00
	tax
	bcc L9686
	iny
L9686
	lda #$e0
	sta S977d + 1
	sta S9781 + 1
	lda #$8f
	sta S977d + 2
	sta S9781 + 2
	lda #$00
	sta L9765
	lda LTK_Var_ActiveLU
	stx L9764
	sty L9763
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L96ab
	lda $8ffc
	sta L9761
L96b1
	ldy #$1d
	jsr S977d
	bpl L96dd
	bmi L96d7
L96ba
	dec L9761
	bne L96d7
	lda L9765
	beq L965f
	lda LTK_Var_ActiveLU
	ldx L9764
	ldy L9763
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L96d4
	jmp L965f
	
L96d7
	jsr S96f3
	jmp L96b1
	
L96dd
	jsr S9766
	bcs L96ba
	ldy #$1a
	jsr S977d
	bpl L96ba
	and #$7f
	jsr S9781
	inc L9765
	bne L96ba
S96f3
	clc
	lda S977d + 1
	adc #$20
	sta S977d + 1
	sta S9781 + 1
	bcc L9707
	inc S977d + 2
	inc S9781 + 2
L9707
	rts
	
S9708
	jsr S9740
	bcs L9723
	ldx #$ff
	cpy #$01
	beq L9722
	lda #$85
	ldx #$97
	ldy #$00
	jsr S9834
	bcs L9723
	cpx #$10
	bcs L9723
L9722
	clc
L9723
	rts
	
L9724
	ldx #$fb
	ldy #$97
	jsr LTK_Print 
L972b
	lda #$02
	clc
	jsr $9f00
	lda L975e
	sta LTK_Var_ActiveLU
	rts
	
L9738
	ldy #$05
	jsr LTK_ErrorHandler 
	jmp L972b
	
S9740
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L974a
	jsr LTK_KernalCall 
	sta L9785,y
	iny
	cpy #$10
	bcs L975a
	cmp #$0d
	bne L974a
	clc
L975a
	lda L9785
	rts
	
L975e
	.byte $00
L975f
	.byte $00
L9760
	.byte $00
L9761
	.byte $00
L9762
	.byte $00
L9763
	.byte $00
L9764
	.byte $00
L9765
	.byte $00
S9766
	lda L9762
	bmi L9779
	ldy #$19
	jsr S977d
	lsr a
	lsr a
	lsr a
	lsr a
	cmp L9762
	bne L977b
L9779
	clc
	rts
	
L977b
	sec
	rts
	
S977d
	lda S977d,y
	rts
	
S9781
	sta S9781,y
	rts
	
L9785
	.byte $00
L9786
	.byte $00
L9787
	.byte $00
L9788
	.byte $00
L9789
	.byte $00
L978a
	.byte $00
L978b
	.byte $00
L978c
	.byte $00
L978d
	.byte $00
L978e
	.byte $00
L978f
	.byte $00
L9790
	.byte $00
L9791
	.byte $00
L9792
	.byte $00
L9793
	.byte $00
L9794
	.byte $00
L9795
	.byte $00
L9796
	.text "{return}{return}enter lu# (0-10 or <cr>to exit) "
	.byte $00
L97b9
	.text "{return}{return}enter user(0-15 or <cr>for all) "
	.byte $00
L97dc
	.text "{return}{return}{return}ok to proceed (y or n) ? y{left}"
	.byte $00
L97fb
	.text "{return}{return}flags have been cleared.{return}"
	.byte $00
L9817
	.text "{return}{return}invalid logical unit !!{return}"
	.byte $00
L9832
	.text "{Clr}"
	.byte $00
S9834
	sta L9845 + 1
	stx L9845 + 2
	lda #$00
	sta L98af
	sta L98b0
	sta L98b1
L9845
	lda L9845,y
	cmp #$30
	bcc L989d
	cmp #$3a
	bcc L9862
	ldx $986e
	cpx #$0a
	beq L989d
	cmp #$41
	bcc L989d
	cmp #$47
	bcs L989d
	sec
	sbc #$07
L9862
	ldx L98af
	beq L9886
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L986f
	clc
	adc L98b1
	pha
	txa
	adc L98b0
	tax
	pla
	dey
	bne L986f
	sta L98b1
	stx L98b0
	pla
	tay
	pla
L9886
	inc L98af
	sec
	sbc #$30
	clc
	adc L98b1
	sta L98b1
	bcc L989a
	inc L98b0
	beq L98a7
L989a
	iny
	bne L9845
L989d
	cmp #$20
	beq L989a
	clc
	ldx L98af
	bne L98a8
L98a7
	sec
L98a8
	lda L98b0
	ldx L98b1
	rts
	
L98af
	.byte $00
L98b0
	.byte $00
L98b1
	.byte $00
S98b2
	lda LTK_BeepOnErrorFlag
	beq L98f1
	ldy #$18
	lda #$00
L98bb
	sta SID_V1_FreqLo,y
	dey
	bpl L98bb
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L98cd
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S98f2
	iny
	tya
	cmp #$10
	bne L98cd
	ldx #$50
	jsr S98f2
	ldy #$10
	sta SID_V1_Control
L98e5
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S98f2
	tya
	bne L98e5
L98f1
	rts
	
S98f2
	dec L98fb
	bne S98f2
	dex
	bne S98f2
	rts
	
L98fb
	.byte $00
