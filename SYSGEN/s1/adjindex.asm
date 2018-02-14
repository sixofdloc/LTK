	*=$4000
;adjindex.r.prg
 
L4000               lda $9201
                    sec
                    sbc $9001
                    sta $95ad
                    lda $9200
                    sbc $9000
                    sta $95ac
                    lda #$00
                    sta $95aa
                    sta $95b0
L401b               lda $95aa
                    cmp $9230
                    beq L403d
                    asl a
                    tay
                    lda $9203,y
                    clc
                    adc $95ad
                    sta $9203,y
                    lda $9202,y
                    adc $95ac
                    sta $9202,y
                    inc $95aa
                    bne L401b
L403d               ldx $920d
                    ldy $920c
                    bne L4048
                    txa
                    beq L4054
L4048               jsr $957b
                    stx $920d
                    sty $920c
                    jsr $94f6
L4054               ldx $9219
                    ldy $9218
                    bne L405f
                    txa
                    beq L406b
L405f               jsr $957b
                    stx $9219
                    sty $9218
                    jsr $94f6
L406b               lda #$00
                    sta $95aa
L4070               ldy $95aa
                    lda $9231,y
                    sta $95ab
                    tax
                    inx
                    inx
                    stx $95af
                    clc
                    jsr $94dd
                    lda $8de4
                    beq L40ac
                    jsr $94a8
                    sec
                    jsr $94dd
                    dec $95b0
                    ldx $95ab
                    lda $8de5,x
                    tay
                    lda $8de6,x
                    tax
                    jsr $94f6
                    inc $95b0
                    ldx $95b3
                    ldy $95b2
                    jsr $94f6
L40ac               inc $95aa
                    lda $95aa
                    cmp $9230
                    bne L4070
                    lda $8000
                    ldx $9201
                    ldy $9200
                    sec
                    jsr $8045
                    cpx #$91
                    ora ($60,x)
                    sta $95ae
                    lda #$e5
                    sta $9588
                    sta $958d
                    lda #$8d
                    sta $9589
                    sta $958e
L40db               ldx $95ab
                    jsr $9587
                    tay
                    jsr $9587
                    tax
                    jsr $957b
                    tya
                    ldy $95ab
                    jsr $958c
                    txa
                    jsr $958c
                    jsr $9591
                    dec $95ae
                    bne L40db
                    rts
                    
L40fd               php
L40fe               lda $95aa
                    asl a
                    tax
                    lda $9202,x
                    tay
                    lda $9203,x
                    tax
                    lda $8000
                    plp
                    jsr $8045
                    cpx #$8d
L4114               .byte $02 
L4115               .byte $60 
L4116               lda #$00
                    sta $95b1
                    clc
                    lda $8000
                    jsr $8045
                    cpx #$8d
                    ora ($8a,x)
                    pha
                    tya
                    pha
                    lda $95b0
                    beq L414d
                    lda $8de4
                    beq L414d
                    jsr $94a8
                    lda $95b1
                    bne L414d
                    ldx $95ab
                    lda $8de5,x
                    sta $95b2
                    lda $8de6,x
                    sta $95b3
                    dec $95b1
L414d               ldx $8de3
                    ldy $8de2
                    bne L4158
                    txa
                    beq L4161
L4158               jsr $957b
                    stx $8de3
                    sty $8de2
L4161               ldx $8de1
                    ldy $8de0
                    bne L416c
                    txa
                    beq L418c
L416c               jsr $957b
                    stx $8de1
                    sty $8de0
                    pla
                    tay
                    pla
                    tax
                    lda $8000
                    sec
                    jsr $8045
                    cpx #$8d
                    ora ($ae,x)
                    sbc ($8d,x)
                    ldy $8de0
                    jmp $94fb
                    
L418c               pla
                    tay
                    pla
                    tax
                    lda $8000
                    sec
                    jsr $8045
                    cpx #$8d
                    ora ($60,x)
                    txa
                    clc
                    adc $95ad
                    tax
                    tya
                    adc $95ac
                    tay
                    rts
                    
L41a7               lda $9587,x
                    inx
                    rts
                    
L41ac               sta $958c,y
                    iny
                    rts
                    
L41b1               lda $9588
                    clc
                    adc $95af
                    sta $9588
                    sta $958d
                    lda $9589
                    adc #$00
                    sta $9589
                    sta $958e
                    rts
                    
                    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 