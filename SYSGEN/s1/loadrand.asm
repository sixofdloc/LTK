;loadrand.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea 
 
L93e0
	lda LTK_Var_CPUMode
	beq L93ea
	lda #$27
	jmp LTK_ExeExtMiniSub 
	
L93ea
	lda #$00
	sta L958d
	ldx $91fb
	ldy $91fa
	lda $91f8
	cmp #$04
	bcc L9406
	lda $b9
	bne L9406
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
L9406
	stx L9590
	stx L9488
	sty L958f
	sty L9489
	ldx $91f1
	dex
	bne L941a
	sec
	rts
	
L941a
	stx L958e
	jsr S9596
	bcc L9427
	lda #$26
	jmp LTK_ExeExtMiniSub 
	
L9427
	lda $91f9
	ldx L958e
	lsr a
	bcs L9435
	lda $91fc
	beq L9436
L9435
	dex
L9436
	stx L9591
L9439
	lda #$01
	sta L948a
	jsr S95bd
	sty L9594
	sty L9592
	sta L9595
	sta L9593
L944d
	lda L9591
	beq L94bb
	cmp L948a
	beq L9474
	inc L958d
	inc L9593
	bne L9462
	inc L9592
L9462
	jsr S95bd
	cpy L9592
	bne L9474
	cmp L9593
	bne L9474
	inc L948a
	bne L944d
L9474
	lda $91fd
	and #$0f
	ldx #$00
	stx LTK_Krn_BankControl
	ldx L9595
	ldy L9594
	clc
	jsr LTK_HDDiscDriver 
L9488
	.byte $00
	
L9489
	.byte $00
L948a
	.byte $00
L948b
	lda L9591
	cmp L948a
	beq L94a7
	sec
	sbc L948a
	sta L9591
	lda L948a
	asl a
	clc
	adc L9489
	sta L9489
	bne L9439
L94a7
	lda L958d
	cmp L958e
	beq L951a
	inc L958d
	jsr S95bd
	sty L9594
	sta L9595
L94bb
	lda #$8f
	sta L950a + 2
	lda #$e0
	sta L950a + 1
	lda $91fd
	and #$0f
	ldx L9595
	ldy L9594
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94d7
	lda $31
	pha
	lda $32
	pha
	lda L9590
	sta $31
	lda L958d
	asl a
	clc
	adc L958f
	sta $32
	lda $91f9
	and #$01
	beq L9503
	ldy #$00
L94f5
	lda LTK_MiscWorkspace,y
	jsr $fc6b
	iny
	bne L94f5
	inc $32
	inc L950a + 2
L9503
	ldx $91fc
	beq L9514
	ldy #$00
L950a
	lda L950a,y
	jsr $fc6b
	iny
	dex
	bne L950a
L9514
	pla
	sta $32
	pla
	sta $31
L951a
	ldx $91f1
	dex
	lda $91f9
	lsr a
	bcs L9529
	lda $91fc
	beq L952a
L9529
	dex
L952a
	txa
	asl a
	clc
	adc L958f
	tay
	lda $91f9
	lsr a
	bcc L9538
	iny
L9538
	lda $91fc
	clc
	adc L9590
	bcc L9542
	iny
L9542
	tax
	lda $91f8
	cmp #$04
	bcs L954f
	lda #$ff
	sta LTK_BLKAddr_DosOvl
L954f
	lda $91f8
	cmp #$0b
	bne L956a
	lda $91fd
	and #$0f
	sta LTK_Var_SAndRData
	lda $9200
	sta $8026
	lda $9201
	sta $8027
L956a
	lda $91f8
	cmp #$04
	bcc L9575
	stx $ae
	sty $af
L9575
	lda LTK_Var_CurRoutine
	cmp #$f0
	bne L958b
	txa
	pha
	tya
	pha
	ldx #$cd
	ldy #$95
	jsr LTK_Print 
	pla
	tay
	pla
	tax
L958b
	clc
	rts
	
L958d
	.byte $00
L958e
	.byte $00
L958f
	.byte $00
L9590
	.byte $00
L9591
	.byte $00
L9592
	.byte $00
L9593
	.byte $00
L9594
	.byte $00
L9595
	.byte $00
S9596
	ldx L9590
	ldy L958f
	jsr S95ad
	bcs L95ac
	lda L958e
	asl a
	adc L958f
	tay
	jsr S95ad
L95ac
	rts
	
S95ad
	cpy #$02
	bcc L95bb
	cpy #$fe
	bcc L95bc
	bne L95bb
	cpx #$ae
	bcc L95bc
L95bb
	sec
L95bc
	rts
	
S95bd
	lda L958d
	clc
	adc #$01
	asl a
	tax
	lda $9200,x
	tay
	lda $9201,x
	rts
	
L95cd
	.text "{Return}{Return}"
	.byte $00
