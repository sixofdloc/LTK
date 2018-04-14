;gocpmode.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	jmp L93ea
	
L93e3
	.byte $00
L93e4
	.byte $00
L93e5
	.byte $00
L93e6
	.byte $00
L93e7
	.byte $00
L93e8
	.byte $00
L93e9
	.byte $00
L93ea
	lda #$00
	cpx #$aa
	bne L93f6
	cpy #$bb
	bne L93f6
	lda #$ff
L93f6
	sta L9512
	lda $9e43
	cmp #$de
	beq L9403
	jmp L94de
	
L9403
	lda $de04
	and #$0f
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L941a
	lda $9002
	cmp #$0a
	beq L944e
	pha
	lda #$0a
	ldx #$1a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L942f
	ldy #$31
L9431
	lda $8fe4,y
	sta $80a8,y
	dey
	bpl L9431
	pla
	sta $94a8
	asl a
	asl a
	clc
	adc $94a8
	tay
	lda $8fe4,y
	bpl L944e
	cmp #$ff
	bne L9451
L944e
	jmp L94e4
	
L9451
	tax
	and #$60
	sta L93e9
	txa
	and #$1c
	lsr a
	lsr a
	tax
	lda #$fe
L945f
	dex
	bmi L9466
	sec
	rol a
	bne L945f
L9466
	sta L93e8
	tya
	pha
	lda $8fe7,y
	pha
	lda $8fe8,y
	sta $94d9
	lda $8fe6,y
	pha
	and #$07
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	sta S94d3 + 1
	pla
	jsr S94d3
	sta L93e7
	stx L93e6
	lda #$00
	sta L93e3
	pla
	tay
	lda $8fe4,y
	and #$03
	tax
	lda $8fe5,y
	jsr S94d3
	sta L93e5
	stx L93e4
	lda #$00
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94b4
	lda LTK_MiscWorkspace
	clc
	bit L9512
	bmi L94f2
	cmp #$2f
	bne L94ea
	pla
	pla
	lda #$0a
	ldx #$d6
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte $e0,$3e,$10 
L94d0
	jmp $3ee0
	
S94d3
	ldy #$00
	jsr S94f3
	ldy #$00
	jsr S94f3
	rts
	
L94de
	ldx #$13
	ldy #$95
	bne L94ee
L94e4
	ldx #$60
	ldy #$95
	bne L94ee
L94ea
	ldx #$95
	ldy #$95
L94ee
	jsr LTK_Print 
	sec
L94f2
	rts
	
S94f3
	sta $9502
	stx $9506
	lda #$00
	tax
	cpy #$00
	beq L9511
L9500
	clc
	adc #$00
	pha
	txa
	adc #$00
	tax
	bcc L950d
	inc L93e3
L950d
	pla
	dey
	bne L9500
L9511
	rts
	
L9512
	.byte $00
L9513
	.text "{clr}sorry, to run cp/m, your host adapter{return}{rvs on}must{rvs off} be wired for the i/o 1 page.{return}{return}"
	.byte $00
L9560
	.text "{clr}sorry, there is no cp/m lu defined{return}for your port.{return}{return}"
	.byte $00
L9595
	.text "{clr}sorry, your cp/m image file does{rvs on} not{return}exist on your cp/m lu.{return}{return}"
	.byte $00
