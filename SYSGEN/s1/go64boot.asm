;go64boot.r.prg $8000 section
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/misc_equates.asm"

	*=$8000 
L8000               
	.byte <Boot_1,>Boot_1
	.byte <Boot_2,>Boot_2
	.byte $c3,$c2,$cd,$38,$30,$00  ;CBM80
Boot_2               
	sei
	lda #$0c
	sta $ff00
	lda #$00
	sta $d030
	lda $06
	cmp #$df
	beq L806e
	lda #$00
	sta $31
	sta $33
	lda #$80
	sta $32
	clc
	adc #$04
	sta $34
ChangeIoAddr_loop
	ldy #$00
	jsr $814f ;Lda_and_inc_y from go64boot_cd00.asm
	ldx #$06
opcode_checkloop
	cmp $8153,x ;Opcode_Table From go64boot_cd00.asm
	beq Opcode_Found
	dex
	bpl opcode_checkloop
	bmi not_an_opcode
Opcode_Found
	jsr $814f ;Lda_and_inc_y from go64boot_cd00.asm
	cmp #$04
	bcs not_an_opcode
	jsr $814f ;Lda_and_inc_y from go64boot_cd00.asm
	cmp #$df
	bne not_an_opcode
	lda #$de
	dey
	sta ($31),y
	lda $31
	clc
	adc #$03
	sta $31
	bcc L8059
	inc $32
L8059
	clc
	bcc ChangeIoAddr_loop
not_an_opcode               
	inc $31
	bne L8062
	inc $32
L8062
	lda $32
	cmp $34
	bne ChangeIoAddr_loop
	lda $31
	cmp $33
	bcc ChangeIoAddr_loop
L806e 
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$e7
	sta $01
	lda #$2f
	sta $00
	lda #$f7
	sta $d505
	jmp (COLDSTART_VEC)
                    
Boot_1               
	sei
	lda #$e7
	sta $01
	lda #$2f
	sta $00
	lda #$00
	sta $d011
	lda $2f
	pha
	lda $30
	pha
	lda #$ea
	sta $31
	lda #$80
	sta $32
	lda #$00
	sta $33
	lda #$cd
	sta $34
	lda #$6a
	sta $2f
	lda #$01
	sta $30
	jsr S80c0
	pla
	sta $30
	pla
	sta $2f
	jmp $cd00
                    
S80c0
	ldy #$00
L80c2
	lda ($31),y
	sta ($33),y
	inc $31
	bne L80cc
	inc $32
L80cc
	inc $33
	bne L80d2
	inc $34
L80d2
	lda $2f
	bne L80e1
	lda $30
	beq L80e9
	dec $30
	dec $2f
	jmp L80c2
                    
L80e1
	dec $2f
	bne L80c2
	lda $30
	bne L80c2
L80e9
	rts

	.binary "output\go64boot_cd00.prg",2
L8254
	.text "copyright 1985, fii lt. kernal dos"
L8276
	.text "this boot for rev. 6.0 and later"