;diag.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"

 	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
L95e0               
	jsr LTK_ClearHeaderBlock
	ldy #$00
	sty L97da
L95e8
	lda L99dc,y
	beq L95f3
	sta LTK_FileHeaderBlock,y ;$91e0
	iny
	bne L95e8
L95f3 
	lda #$02
	sec
	jsr $9f00
	bcc L95fe
	jmp L9851
                    
L95fe
	jsr LTK_FindFile
	bcs L9606
	jmp L9859
                    
L9606
	cpx #$ff
	bne L960d
	jmp L985f
                    
L960d
	cmp #$00
	bne L961c
	cpx #$00
	bne L961c
	cpy #$00
	bne L961c
	jmp L9865
                    
L961c
	sta $97e6
	stx $98b3
	sty $98b4
	stx $98b6
	sty $98b7
L962b
	ldx #$ec
	ldy #$99
	jsr LTK_Print
	ldy #$06
	lda #$00
L9636
	sta L9914,y
	dey
	bpl L9636
L963c
	ldy #$0a
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall
	ldy L97da
	sta L9914,y
	iny
	sty L97da
	cpy #$07
	bne L9655
	jmp L9875
                    
L9655
	cmp #$0d
	bne L963c
	cpy #$01
	bne L9660
	jmp L9875
                    
L9660
	lda #$14
	ldx #$99
	ldy #$00
	jsr S9a10
	bcc L966e
	jmp L9875
                    
L966e
	tay
	bne L9675
	cpx #$09
	bcc L962b
L9675
	sta $91f0
	sta $97db
	stx $91f1
	stx $97dc
	lda #$05
	sta $91f8
	jsr LTK_AllocContigBlks
	bcc L9696
	cpx #$80
	bne L9693
	tax
	jmp L984e
                    
L9693
	jmp L986b
                    
L9696
	lda $97e6
	pha
	ldx $98b3
	ldy $98b4
	lda #$24
	jsr LTK_ExeExtMiniSub
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L96b5
	inx
	bne L96b9
	iny
L96b9
	stx $97de
	sty $97dd
	sec
	ldx $97db
	lda $97dc
	sbc #$02
	bcs L96cb
	dex
L96cb
	clc
	adc $97de
	sta $97e0
	txa
	adc $97dd
	sta $97df
	ldx #$1c
	ldy #$99
	jsr LTK_Print
L96e0
	lda $97dd
	sta $97e1
	lda $97de
	sta $97e2
	lda $97df
	sta $97e3
	lda $97e0
	sta $97e4
L96f8
	ldx #$02
	ldy #$00
	lda #$e0
	sta S987f + 1
	lda #$8f
	sta S987f + 2
L9706
	lda #$aa
	jsr S987f
	lda #$55
	jsr S987f
	iny
	iny
	bne L9706
	dex
	bne L9706
	lda LTK_Var_ActiveLU
	ldx $97e2
	ldy $97e1
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L9727               
	ldy $97e3
	ldx $97e4
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L9734
	jsr S9817
	lda LTK_Var_ActiveLU
	ldy $97e1
	ldx $97e2
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L9747
	jsr S97f1
	beq L974f
	jmp L97e7
                    
L974f
	jsr S9817
	lda LTK_Var_ActiveLU
	ldy $97e3
	ldx $97e4
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L9762
	jsr S97f1
	beq L976a
	jmp L97e7
                    
L976a
	lda $97e1
	cmp $97df
	bne L977d
	lda $97e2
	cmp $97e0
	bne L977d
	jmp L9827
                    
L977d
	lda $97e3
	cmp $97dd
	bne L9790
	lda $97e4
	cmp $97de
	bne L9790
	jmp L9827
                    
L9790
	inc $97e2
	bne L9798
	inc $97e1
L9798
	dec $97e4
	lda #$ff
	cmp $97e4
	bne L97a5
	dec $97e3
L97a5
	inc BORDER
	lda LTK_Var_CPUMode
	beq L97c1
	lda BORDER
	cmp $f1
	beq L97c1
	ldx #$1a
	stx $d600
L97b9
	bit $d600
	bpl L97b9
	sta $d601
L97c1
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall
	cmp #$00
	beq L97d7
	jsr S9897
L97d0
	lda #$02
	clc
	jsr $9f00
	rts
                    
L97d7
	jmp L96f8
                    
L97da               
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00 
L97e7
	ldx #$54
	ldy #$99
	jsr LTK_Print
	jmp L97d0
                    
S97f1
	lda #$e0
	sta S988b + 1
	lda #$8f
	sta S988b + 2
	ldy #$00
	ldx #$02
L97ff
	jsr S988b
	cmp #$aa
	beq L9807
	rts
                    
L9807
	jsr S988b
	cmp #$55
	beq L980f
	rts
                    
L980f
	iny
	iny
	bne L97ff
	dex
	bne L97ff
	rts
                    
S9817
	lda #$00
	tay
L981a               
	sta LTK_MiscWorkspace,y ;$8fe0
	iny
	bne L981a
L9820
	sta $90e0,y
	iny
	bne L9820
	rts
                    
L9827
	inc $984d
	bne L982f
	inc L984c
L982f
	sec
	lda #$00
	ldx $984d
	ldy L984c
	jsr S9a8e
	ldx #$20
	ldy #$99
	jsr LTK_Print
	ldx #$21
	ldy #$9b
	jsr LTK_Print
	jmp L96e0
                    
L984c               
	.byte $00,$00 
L984e
	ldy #$04
	.byte $2c 
L9851
	ldy #$05
	jsr $8051
	jmp L97d0
                    
L9859               
	ldx #$70
	ldy #$99
	bne L986f
L985f
	ldx #$b1
	ldy #$99
	bne L986f
L9865
	ldx #$c8
	ldy #$99
	bne L986f
L986b
	ldx #$8e
	ldy #$99
L986f
	jsr LTK_Print
	jmp L97d0
                    
L9875
	ldx #$38
	ldy #$99
	jsr LTK_Print
	jmp L95e0
                    
S987f
	sta S987f
	inc S987f + 1
	bne L988a
	inc S987f + 2
L988a
	rts
                    
S988b
	lda S988b
	inc S988b + 1
	bne L9896
	inc S988b + 2
L9896
	rts
                    
S9897
	jsr LTK_FindFile
	bcc L989f
L989c
	jsr LTK_FatalError
L989f
	cmp $97e6
	bne L989c
	cpx $98b3
	bne L989c
	cpy $98b4
	bne L989c
	lda #$80
	ldy #$1d
	ora $98b2,y
	sta $98b5,y
	ldx #$00
	dec $8ffc
	bne L98c0
	dex
L98c0               
	stx $97e5
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L98ce
	lda #$11
L98ce
	sec
	pha
	ldy #$00
	adc $97e6
	tax
	bcc L98d9
	iny
L98d9
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L98e3
	pla
	tax
	lda $97e5
	beq L990b
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L98f6
	pha
	tya
	pha
	ldy $97e6
	lda #$00
	sta $9002,y
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0 
L990b
	jsr LTK_DeallocContigBlks
	bcc L9913
	jsr LTK_FatalError
L9913
	rts
                    
L9914
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	
L991c               
	.text "{clr}"
	.byte $00 

L991e               
	.text "{return}"
	.byte $00 

L9920               
	.text "{return}completed pass number "
	.byte $00 

L9938               
	.text "{return}{return}input error - try again !"
	.byte $00 

L9954               
	.text "{return}{return}error in data compare !!!"
	.byte $00 

L9970               
	.text "{return}{return}filename already exists !!{return}"
	.byte $00 

L998e               
	.text "{return}{return}not enough contiguous blocks !!{return}"
	.byte $00 

L99b1               
	.text "{return}{return}illegal filename !!{return}"
	.byte $00 

L99c8               
	.text "{return}{return}index is full !!{return}"
	.byte $00 
	
L99dc               
	.text "diagnostic file"
	.byte $00 
L99ec               
	.text "{return}{return}number of blocks to use (10 min) "
	.byte $00 
S9a10               
	sta L9a21 + 1
	stx L9a21 + 2
	lda #$00
	sta L9a8b
	sta $9a8c
	sta $9a8d
L9a21
	lda L9a21,y
	cmp #$30
	bcc L9a79
	cmp #$3a
	bcc L9a3e
	ldx $9a4a
	cpx #$0a
	beq L9a79
	cmp #$41
	bcc L9a79
	cmp #$47
	bcs L9a79
	sec
	sbc #$07
L9a3e
	ldx L9a8b
	beq L9a62
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9a4b
	clc
	adc $9a8d
	pha
	txa
	adc $9a8c
	tax
	pla
	dey
	bne L9a4b
	sta $9a8d
	stx $9a8c
	pla
	tay
	pla
L9a62
	inc L9a8b
	sec
	sbc #$30
	clc
	adc $9a8d
	sta $9a8d
	bcc L9a76
	inc $9a8c
	beq L9a83
L9a76
	iny
	bne L9a21
L9a79
	cmp #$20
	beq L9a76
	clc
	ldx L9a8b
	bne L9a84
L9a83
	sec
L9a84
	lda $9a8c
	ldx $9a8d
	rts
                    
L9a8b
	.byte $00,$00,$00 
S9a8e
	stx $9b20
	sty L9b1f
	php
	pha
	lda #$30
	ldy #$04
L9a9a
	sta $9b21,y
	dey
	bpl L9a9a
	pla
	beq L9abe
	lda $9b20
	jsr S9b0a
	sta $9b24
	stx $9b25
	lda L9b1f
	jsr S9b0a
	sta $9b22
	stx $9b23
	jmp L9af3
                    
L9abe
	iny
L9abf
	lda L9b1f
	cmp $9b27,y
	bcc L9aee
	bne L9ad1
	lda $9b20
	cmp $9b2c,y
	bcc L9aee
L9ad1
	lda $9b20
	sbc $9b2c,y
	sta $9b20
	lda L9b1f
	sbc $9b27,y
	sta L9b1f
	lda $9b21,y
	clc
	adc #$01
	sta $9b21,y
	bne L9abf
L9aee
	iny
	cpy #$05
	bne L9abf
L9af3
	plp
	bcc L9b09
	ldy #$00
L9af8
	lda $9b21,y
	cmp #$30
	bne L9b09
	lda #$20
	sta $9b21,y
	iny
	cpy #$04
	bne L9af8
L9b09
	rts
                    
S9b0a
	pha
	and #$0f
	jsr S9b16
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
S9b16
	cmp #$0a
	bcc L9b1c
	adc #$06
L9b1c
	adc #$30
	rts
                    
L9b1f
	.byte $ff,$ff,$00,$00,$00,$00,$00,$00
	.byte $27,$03,$00,$00,$00,$10,$e8,$64
	.byte $0a,$01 