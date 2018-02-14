
;fileprot.r.prg
	*=$9f00 ;$4000 for the sysgen disk
 
L9f00               jmp L9f13
                    
L9f03               jmp S9f07
                    
L9f06               14 
S9f07               lda $9e43
                    sta $9f0f
                    lda $df04
                    and #$0f
                    rts
                    
L9f13               jsr S9f07
                    tax
                    clc
                    rts
                    
L9f19               ea ea 
L9f1b               ldx #$ee
                    lda #$00
                    beq L9f25
                    ldx #$f0
                    lda #$11
L9f25               cpy #$0a
                    beq L9f2a
                    tax
L9f2a               stx $9f86
                    jsr S9f07
                    sta L9f44 + 1
                    lda L9f06
                    sta L9f90
L9f39               lda #$80
                    clc
                    jsr S9f82
                    plp
                    bcc L9f51
                    ldy #$0f
L9f44               cpy #$00
                    beq L9f4e
                    lda $9100,y
                    clc
                    bmi L9f59
L9f4e               dey
                    bpl L9f44
L9f51               tya
                    sec
                    ldy L9f44 + 1
                    sta $9100,y
L9f59               lda #$40
                    php
                    sty L9f7f + 1
                    jsr S9f82
                    plp
                    bcs L9f7e
                    lda #$00
                    tax
                    ldy #$01
L9f6a               sec
                    adc #$00
                    bne L9f6a
                    inx
                    bne L9f6a
                    dey
                    bne L9f6a
                    sec
                    dec L9f90
                    beq L9f7f
                    php
                    bcs L9f39
L9f7e               clc
L9f7f               ldx #$00
                    rts
                    
S9f82               ora $8000
                    ldx #$00
                    ldy #$00
                    jsr $8045
                    e0 8f 01 
L9f8f               rts
                    
L9f90               00 