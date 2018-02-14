;user.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_DOSOverlay ;$4000 for sysgen
 
START
	pha
	ldx $c8
	lda LTK_Var_CPUMode
	beq c64_mode
	ldx $ea
c64_mode
	stx $9655
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
	ldx $9655
	lda #$ff
	sta LTK_Command_Buffer,x
	iny
	cpy $9655
	bcc L9620
	lda $8fec
	bit $8008
	bpl L9631
	lda $8fed
	jmp L9631
                    
L9620
	lda #$00
	ldx #$02
	jsr S966e
	txa
	bcc L9631
	lda $8ffd
	lsr a
	lsr a
	lsr a
	lsr a
L9631
	cmp #$10
	bcc L963f
	ldx #<str_InvalidUser
	ldy #>str_InvalidUser
	jsr LTK_ErrorHandler
	jmp L9642
                    
L963f
	sta LTK_Var_Active_User
L9642
	lda #$ff
	jsr LTK_SetLuActive
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9e45
	rts

L9655	.byte $00

str_InvalidUser ;$9656
	.text "invalid user number !!{return}"
	.byte $00
S966e
	sta L967f + 1
	stx L967f + 2
	lda #$00
	sta L96e9
	sta L96ea
	sta L96eb
L967f 
	lda L967f,y
	cmp #$30
	bcc L96d7
	cmp #$3a
	bcc L969c
	ldx $96a8
	cpx #$0a
	beq L96d7
	cmp #$41
	bcc L96d7
	cmp #$47
	bcs L96d7
	sec
	sbc #$07
L969c
	ldx L96e9
	beq L96c0
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L96a9
	clc
	adc L96eb
	pha
	txa
	adc L96ea
	tax
	pla
	dey
	bne L96a9
	sta L96eb
	stx L96ea
	pla
	tay
	pla
L96c0
	inc L96e9
	sec
	sbc #$30
	clc
	adc L96eb
	sta L96eb
	bcc L96d4
	inc L96ea
	beq L96e1
L96d4
	iny
	bne L967f
L96d7
	cmp #$20
	beq L96d4
	clc
	ldx L96e9
	bne L96e2
L96e1
	sec
L96e2
	lda L96ea
	ldx L96eb
	rts
                    
L96e9
	.byte $00 
L96ea               
	.byte $00 
L96eb
	.byte $00 