;lu.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=$95e0 ; relocate to $4000 for sysgen 
L95e0
	pha
	ldx $c8
	lda LTK_Var_CPUMode
	beq is_in_c64_mode
	ldx $ea
is_in_c64_mode
	stx L9653
	jsr LTK_GetPortNumber
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L9602               
	pla
	tay
	ldx L9653
	lda #$ff
	sta LTK_Command_Buffer,x
	iny
	cpy L9653
	bcc L9620
	lda $8fea
	bit LTK_Var_CPUMode
	bpl L962f
	lda $8feb
	jmp L962f
                    
L9620
	lda #$00
	ldx #$02
	jsr S9674
	txa
	bcc L962f
	lda $8ffd
	and #$0f
L962f
	cmp $8000
	beq L9640
	jsr $8099
	bcc L9640
	ldx #$54
	ldy #$96
	jsr $8051
L9640
	lda #$ff
	jsr $8099
	lda $8001
	asl a
	asl a
	asl a
	asl a
	ora $8000
	sta $9e45
	rts
                    
L9653
	.byte $00 
L9654
	.text "invalid logical unit number !!{return}"
	.byte $00 
S9674   
	sta L9685 + 1
	stx L9685 + 2
	lda #$00
	sta L96ef
	sta L96f0
	sta L96f1
L9685
	lda L9685,y
	cmp #$30
	bcc L96dd
	cmp #$3a
	bcc L96a2
	ldx $96ae
	cpx #$0a
	beq L96dd
	cmp #$41
	bcc L96dd
	cmp #$47
	bcs L96dd
	sec
	sbc #$07
L96a2
	ldx L96ef
	beq L96c6
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L96af
	clc
	adc L96f1
	pha
	txa
	adc L96f0
	tax
	pla
	dey
	bne L96af
	sta L96f1
	stx L96f0
	pla
	tay
	pla
L96c6
	inc L96ef
	sec
	sbc #$30
	clc
	adc L96f1
	sta L96f1
	bcc L96da
	inc L96f0
	beq L96e7
L96da
	iny
	bne L9685
L96dd
	cmp #$20
	beq L96da
	clc
	ldx L96ef
	bne L96e8
L96e7               
	sec
L96e8               
	lda L96f0
	ldx L96f1
	rts
                    
L96ef
	.byte $00 
L96f0
	.byte $00 
L96f1
	.byte $00 