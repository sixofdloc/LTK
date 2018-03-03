;convrtio.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_MiniSubExeArea ;$95e0, $4000 for sysgen
L93e0               
	jmp L9492
                    
	.byte $af 
L93e4
	pha
	txa
	pha
	tya
	pha
	tsx
	lda $0104,x
	and #$10
	beq L93f4
	jmp ($0316)
                    
L93f4
	lda #$fa
	pha
	lda #$4b
	pha
	php
	pha
	lda $c5
	pha
	pha
	jmp $ea31
                    
L9403
	sei
	ldy #$00
	lda $cb
	cmp #$40
	bne L946e
	lda #$ff
	sta $dc00
	sty $d02f
	lda $dc01
	cmp #$ff
	beq L946e
	stx $c5
	lda #$fe
L941f
	pha
	ldx #$08
	sta $d02f
L9425
	lda $dc01
	cmp $dc01
	bne L9425
L942d
	lsr a
	bcs L9439
	pha
	lda $fac1,y
	beq L9438
	sta $cb
L9438
	pla
L9439
	iny
	dex
	bne L942d
	pla
	sec
	rol a
	cpy #$17
	bcc L941f
	lda $cb
	cmp #$40
	beq L946e
	ldx #$81
	ldy #$00
	bcc L9458
	and #$7f
	sta $cb
	ldx #$c2
	ldy #$01
L9458
	lda #$eb
   	sty $028d
   	stx $f5
   	sta $f6
   	jsr $eae0
   	ldy #$00
   	ldx #$10
L9468 
	iny
	bne L9468
	dex
	bne L9468
L946e
	lda #$ff
	sta $d02f
	jsr $eb42
	jmp $ea81
                    
L9479                                          
	.byte $00,$1b,$10,$00,$3b,$0b,$18,$38
	.byte $00,$28,$2b,$00,$01,$13,$20,$08
	.byte $00,$23,$2c,$87,$07,$82,$02,$00 
	.byte $00

L9492
	ldy #$00
	jsr S94d7
	ldx #$06
L9499
	cmp L94db,x
	beq L94a3
	dex
	bpl L9499
	bmi L94c4
L94a3
	jsr S94d7
	cmp #$04
	bcs L94c4
	jsr S94d7
	cmp #$df
	bne L94c4
	lda #$de
	dey
	sta ($31),y
	lda $31
	clc
	adc #$03
	sta $31
	bcc L94c1
	inc $32
L94c1
	clc
	bcc L9492
L94c4
	inc $31
	bne L94ca
	inc $32
L94ca
	lda $32
	cmp $34
	bne L9492
	lda $31
	cmp $33
	bcc L9492
	rts
                    
S94d7               
	lda ($31),y
	iny
	rts
                    
L94db
	.byte $8c,$8d,$8e,$ac,$ad,$ae,$2c 