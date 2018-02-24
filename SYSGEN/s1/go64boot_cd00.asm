;go64boot.r.prg $cd00 section

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/misc_equates.asm"
	*=$cd00
                    
Lcd00               
	inc $ce5d
	lda #$e0
	sta $31
	lda #$91
	sta $32
	lda #$34
	sta $df03
	jsr Scd9a
	bne Lcd53
	ldy #$0a
Lcd17
	lda $ce5f,y
	cmp $91e0,y ;Looking for "SYSTEMTRACK"
	bne Lcd53
	dey
	bpl Lcd17
	ldy #$07
Lcd24               
	lda $93d4,y
	sta $8fd4,y
	dey
	bpl Lcd24
	lda #$e0
	sta $31
	lda #$93
	sta $32
	lda #$28
	sta $ce5c
	jsr Scd9a
	inc $ce5d
	lda #$0f
	sta $ce5c
	lda #$00
	sta $31
	lda #$04
	sta $32
	jsr Scd9a
	jmp $0400
                    
Lcd53
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$00
	sta $8004
	jmp RESET
                    
Lda_and_inc_y ;$814f If this moves, you'll need to change it in go64boot.asm
	lda ($31),y
	iny
	rts
                    
Opcode_Table ;If this moves, you'll need to change it in go64boot.asm
	.byte OPCODE_STY,OPCODE_STA,OPCODE_STX
	.byte OPCODE_LDY,OPCODE_LDA,OPCODE_LDX,OPCODE_BIT
	
Scd70
	lda #$00
	tax
	ldy #$02
Lcd75
	sec
	adc #$00
	bne Lcd75
	inx
	bne Lcd75
	dey
	bne Lcd75
	rts
                    
Lcd81
	lda #$01
	.byte $2c
Lcd84
	lda #$00
	sta CDB_Buffer
	jsr Scdcf
	bne Lcdce
	ldx #$06
	ldy #$00
	jsr Sce05
	jsr Sce42
	txa
	rts
                    
Scd9a
	lda #$08
	sta CDB_Buffer
	jsr Scdcf
	bne Lcdce
	ldx #$06
	ldy #$00
	jsr Sce05
	ldy #$00
	jsr Sce1b
	lda #$2c
	sta $df01
Lcdb5
	lda $df02
	bmi Lcdb5
	and #$04
	beq Lcdca
	lda $df00
	sta ($31),y
	iny
	bne Lcdb5
	inc $32
	bne Lcdb5
Lcdca
	jsr Sce42
     	txa
Lcdce
	rts
                    
Scdcf
	lda #$3c
	sta $34
	jsr Sce1e
	lda #$fe
	sta $df00
	lda #$50
	sta $df02
Lcde0
	ldx #$00
Lcde2
	lda $df02
	and #$08
	beq Lcdfd
	inx
	bne Lcde2
	dec $34
	bne Lcdf8
	lda #$40
	sta $df02
	jmp Lcd53
                    
Lcdf8
	jsr Scd70
	beq Lcde0
Lcdfd
	ora #$40
	sta $df02
	lda #$00
	rts
                    
Sce05
	jsr Sce2e
	lda CDB_Buffer,y
	eor #$ff
	sta $df00
	jsr Sce34
	iny
	dex
	bne Sce05
	jsr Sce2e
	rts
                    
Sce1b
	ldx #$00
	.byte $2c 
Sce1e
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
                    
Sce2e
	lda $df02
	bmi Sce2e
	rts
                    
Sce34
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
Sce42
	jsr Sce1b
	jsr Sce4b
	and #$9f
	tax
Sce4b
	jsr Sce2e
	lda $df00
	eor #$ff
	tay
	jsr Sce34
	tya
	rts
                    
CDB_Buffer
	.byte $00,$00,$00,$00,$00,$00 
Lce5f               
	.text "systemtrack"
