;openrela.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen
L95e0
	lda $91f8
	beq L95ee
	lda $9e04
	sta L967f
	jmp L9681
	
L95ee
	lda #$02
	sec
	jsr $9f00
	bcc L95f9
	jmp L973d
	
L95f9
	jsr LTK_FindFile 
	sta L967f
	stx L967e
	sty L967d
	lda #$00
	rol a
	sta L9680
	bne L9610
	jmp L9681
	
L9610
	cpx #$ff
	bne L9617
	jmp L9740
	
L9617
	lda L967f
	bne L9625
	txa
	bne L9625
	tya
	bne L9625
	jmp L9743
	
L9625
	ldx #$00
	stx $91f0
	stx $91f6
	stx $91f7
	inx
	stx $91f1
	lda $9de5
	cmp #$0d
	bcc L963d
	lda #$00
L963d
	sta $91f4
	lda $9e03
	sta $91f5
	lda #$0f
	sta $91f8
	jsr LTK_AllocateRandomBlks 
	bcc L965b
	cpx #$80
	bne L9658
	tax
	jmp L973a
	
L9658
	jmp L9746
	
L965b
	lda L967f
	pha
	ldx L967e
	ldy L967d
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L967a
	jmp L9681
	
L967d
	.byte $00
	
L967e
	.byte $00
L967f
	.byte $00
L9680
	.byte $00
L9681
	lda $91f8
	cmp #$0f
	beq L968b
	jmp L9749
	
L968b
	ldx $9de4
	lda $9200
	sta $9de7,x
	lda $9201
	sta $9de8,x
	lda $91f0
	sta $9df0,x
	tay
	lda $91f1
	sta $9df1,x
	cmp #$01
	bne L96b3
	tya
	bne L96b3
	lda #$40
	sta $9dfc,x
L96b3
	lda $91f6
	sta $9df2,x
	lda $91f7
	sta $9df3,x
	lda $91fd
	sta $9de6,x
	lda $91f4
	sta $9df7,x
	sta $9dee,x
	lda $91f5
	sta $9df8,x
	sta $9def,x
	lda $9def,x
	clc
	adc $9df8,x
	sta $9df6,x
	lda $9dee,x
	adc $9df7,x
	sta $9df5,x
	lda $9ded,x
	adc #$00
	sta $9df4,x
	lda $9df2,x
	bne L9703
	lda #$01
	cmp $9df3,x
	bcc L9703
	lda #$40
	sta $9dfa,x
L9703
	lda #$aa
	sta $9dfe,x
	lda $91f8
	sta $9df9,x
	lda #$00
	sta $9de1,x
	lda #$01
	sta $9de2,x
	lda L967f
	sta $9dfd,x
	lda $b8
	sta LTK_FileParamTable,x
	ldy #$00
	jsr LTK_ErrorHandler 
	clc
L9729
	php
	lda #$02
	clc
	jsr $9f00
	lda $9de3
	sta LTK_Var_ActiveLU
	plp
	jmp LTK_SysRet_AsIs  
	
L973a
	ldy #$04
	.byte $2c 
L973d
	ldy #$05
	.byte $2c 
L9740
	ldy #$21
	.byte $2c 
L9743
	ldy #$48
	.byte $2c 
L9746
	ldy #$48
	.byte $2c 
L9749
	ldy #$40
	jsr LTK_ErrorHandler 
	sec
	bcs L9729
