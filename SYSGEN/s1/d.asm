;d.r.prg
	*=$4000 
L4000               pha
                    ldx $c8
                    lda $8008
                    beq L400a
                    ldx $ea
L400a               stx $962f
                    jsr $9f03
                    clc
                    adc #$9e
                    tax
                    lda #$02
                    adc #$00
                    tay
                    lda #$0a
                    clc
                    jsr $8045
                    .byte $e0,$8f,$01 
L4022               pla
                    tay
                    ldx $962f
                    lda #$ff
                    sta $0200,x
                    iny
                    cpy $962f
                    bcs L403b
                    lda #$00
                    ldx #$02
                    jsr $9630
                    bcc L4046
L403b               ldx $8fe8
                    bit $8008
                    bpl L4046
                    ldx $8fe9
L4046               stx $802a
                    lda #$ff
                    jsr $8099
                    rts
                    
                    .byte $00 
L4050               sta $9642
                    stx $9643
                    lda #$00
                    sta $96ab
                    sta $96ac
                    sta $96ad
L4061               lda $9641,y
                    cmp #$30
                    bcc L40b9
                    cmp #$3a
                    bcc L407e
                    ldx $966a
                    cpx #$0a
                    beq L40b9
                    cmp #$41
                    bcc L40b9
                    cmp #$47
                    bcs L40b9
                    sec
                    sbc #$07
L407e               ldx $96ab
                    beq L40a2
                    pha
                    tya
                    pha
                    lda #$00
                    tax
                    ldy #$0a
L408b               clc
                    adc $96ad
                    pha
                    txa
                    adc $96ac
                    tax
                    pla
                    dey
                    bne L408b
                    sta $96ad
                    stx $96ac
                    pla
                    tay
                    pla
L40a2               inc $96ab
                    sec
                    sbc #$30
                    clc
                    adc $96ad
                    sta $96ad
                    bcc L40b6
                    inc $96ac
                    beq L40c3
L40b6               iny
                    bne L4061
L40b9               cmp #$20
                    beq L40b6
                    clc
                    ldx $96ab
                    bne L40c4
L40c3               sec
L40c4               lda $96ac
                    ldx $96ad
                    rts
                    
	.byte $00,$00,$00