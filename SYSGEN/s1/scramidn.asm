
;scramidn.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	; FIXME:  This needs to be re-disassembled as it runs at $1000 during sysgen
	;  Ref: sysgen.asm label L8d75
	*=LTK_MiniSubExeArea ; $93e0, $4000 for sysgen
 
START
	lda #$14
	sta $31
	lda #$74
	sta $1025
	lda #$10
	sta $1026
	lda #$20
	sta $102d
	lda #$11
	sta $102e
	lda #$00
L93fa
	ldx #$08
	stx $32
L93fe
	tax
	pha
	lda #$00
	ldy #$08
L9404
	asl L9404,x
	ror a
	inx
	dey
	bne L9404
	sta $940c,y
	inc $102d
	pla
	dec $32
	bne L93fe
	txa
	dec $31
	bne L93fa
	rts
                    
L941d
	.byte $ff 
L941e
	lda #$14
	sta L9452
	lda #$00
L9425
	ldx #$08
	stx L9452+$01
L942a
	tax
	pha
	lda #$00
	ldy #$08
L9430
	lsr $9500,x
	rol a
	inx
	dey
	bne L9430
	sta str_CopyrightMessage
	inc $9439
	pla
	dec L9452+$01
	bne L942a
	txa
	dec L9452
	bne L9425
	ldx #<str_CopyrightMessage
	ldy #>str_CopyrightMessage
	jsr LTK_Print
	rts
                    
L9452
	.byte $00,$00 

str_CopyrightMessage ;$9454
	.text "{clr}{return}copyright(c) 1985 fiscal information inc{return}        designed and written by:{return}{return}           roy e. southwick{return}{return}                 and{return}{return}         lloyd e. sponenburgh{return}{return}"
	.byte $00
