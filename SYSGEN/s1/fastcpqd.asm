;fastcpqd.r.prg
	.include "../../include/kernal.asm"
	*=$1c20 ; $4000 for sysgen 
L1c20               sta L1d1f
                    lda $9e43
                    sta $1cfe
                    jsr S1cfa
                    lda L1d1f
                    jsr LISTEN
                    lda #$6f
                    jsr SECOND
                    bmi L1c6a
                    lda #$55
                    jsr CIOUT
                    lda #$4a
                    jsr CIOUT
                    jsr UNLSN
                    ldx #$00
L1c48               dex
                    bne L1c48
                    bit $dd00
                    bpl L1c5d
                    lda $dd00
                    ora #$08
                    sta $dd00
                    jsr S1d00
                    bcs L1c6a
L1c5d               lda $dd00
                    and #$f7
                    sta $dd00
                    jsr S1d03
                    bcc L1c6d
L1c6a               jmp L1cf2
                    
L1c6d               lda L1d1f
                    jsr TALK
                    lda #$6f
                    jsr TKSA
                    ldy #$00
                    sty L1d20
                    sty L1d21
L1c80               jsr IECIN
                    ldy L1d20
                    sta $2000,y
                    inc L1d20
                    cmp #$0d
                    bne L1c80
                    jsr UNTLK
                    ldy L1d20
                    lda $1ff5,y
                    cmp #$31
                    bne L1c6a
                    lda $1ff6,y
                    cmp #$35
                    bne L1c6a
                    lda $1ff8,y
                    cmp #$31
                    bne L1c6a
                    lda $1ff7,y
                    cmp #$34
                    beq L1ce8
                    cmp #$37
                    bne L1ce4
                    dec L1d21
                    lda L1d1f
                    jsr LISTEN
                    lda #$6f
                    jsr SECOND
                    lda #$55
                    jsr CIOUT
                    lda #$30
                    jsr CIOUT
                    lda #$3e
                    jsr CIOUT
                    lda #$4d
                    jsr CIOUT
                    lda #$30
                    jsr CIOUT
                    jsr UNLSN
                    lda #$37
                    bne L1ce8
L1ce4               cmp #$38
                    bne L1c6a
L1ce8               pha
                    jsr S1cf7
                    pla
                    ldx L1d21
                    clc
                    rts
                    
L1cf2               jsr S1cf7
                    sec
                    rts
                    
S1cf7               lda #$34
                    .byte $2c 
S1cfa               lda #$3c
                    sta $df03
                    rts
                    
S1d00               lda #$10
                    .byte $2c 
S1d03               lda #$30
                    sta $1d11
                    lda #$00
                    tax
                    ldy #$02
L1d0d               bit $dd00
                    clc
                    bpl L1d1e
                    adc #$01
                    bne L1d0d
                    inx
                    bne L1d0d
                    dey
                    bne L1d0d
                    sec
L1d1e               rts
                    
L1d1f               .byte $00 
L1d20               .byte $00 
L1d21               .byte $00 