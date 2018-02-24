	;LTK rom re-source
	;Six/DLoC 2018

	.include "../include/misc_equates.asm"
	
	
	*= $8000
firstROM	
	.byte <romStart,>romStart,<romStart,>romStart
	.byte $c3,$c2,$cd,$38,$30 ;CBM80
	.byte $00
	
	.include "serialnumber.asm"
	
romStart
	sei
	lda #$00
	sta $d011
	lda $2f
	pha
	lda $30
	pha
	lda #$6e
	sta $31
	lda #$80
	sta $32
	lda #$00
	sta $33
	lda #$cd
	sta $34
	lda #$a7
	sta $2f
	lda #$02
	sta $30
	jsr S8044
	pla
	sta $30
	pla
	sta $2f
	jmp $cd00
                    
S8044               
	ldy #$00
L8046
	lda ($31),y
	sta ($33),y
	inc $31
	bne L8050
	inc $32
L8050
	inc $33
	bne L8056
	inc $34
L8056
	lda $2f
	bne L8065
	lda $30
	beq L806d
	dec $30
	dec $2f
	jmp L8046
L8065
	dec $2f
	bne L8046
	lda $30
	bne L8046
L806d
	rts

	.include "ltkbootstub.asm"

copyrightText       
	.screen "COPYRIGHT 1985, FII "
dosName
	.screen "LT. KERNAL DOS"
bootWarn
	.screen "THIS BOOT FOR REV. 6.0 AND LATER"
bootVer
	.screen "BOOT ROM VERSION 2 CREATED ON 08/05/87"

firstBlankBloc
	.repeat $0c83,$ff

secondROM
	sei
	jmp $8014
	nop
	nop
	php
	.byte $43,$42,$4d,$38,$37 ;CBM87
	.include "serialnumber.asm"
	

	*=$937e
secondBlankBloc
	.repeat $0352,$ff
	
promOS
	.binary "promos.bin"
