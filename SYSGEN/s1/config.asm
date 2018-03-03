WFDis v1.4 Interactive 6502 Disassembler
Human Mode @Version 2017-11-04 Changelog

This standalone version disassembles binary code for the 6502 processor and variants.

All processing is client-side JavaScript. The analyzed file is not uploaded to the server.
Requires a modern HTML5/ES6 browser (tested in Firefox and Chromium).

CPU model: 

Select a file to disassemble (formats):  Restart

Help
Saves
config.r.prg
 
L95e0               lda $8008
                    beq L95e8
                    jsr S97e6
L95e8               lda #$31
                    sta L9841 + 5
                    ldx #$1e
                    ldy #$98
                    jsr $8048
                    ldx #$4c
                    ldy #$98
                    jsr $8048
                    lda #$19
                    sta $981d
L9600               ldx #$54
                    ldy #$98
                    jsr $8048
                    dec $981d
                    bne L9600
                    ldx #$56
                    ldy #$98
                    jsr $8048
                    jsr S97fa
                    ldx #$5d
                    ldy #$98
                    jsr $8048
                    jsr S97fa
                    ldx #$7c
                    ldy #$98
                    jsr $8048
                    jsr S97fa
                    ldx #$98
                    ldy #$98
                    jsr $8048
                    jsr S97fa
                    ldx #$b6
                    ldy #$98
                    jsr $8048
L963b               ldy #$10
                    jsr $803c
                    jsr $803f
                    tax
                    beq L963b
                    cmp #$85
                    bne L964d
                    jmp L97bb
                    
L964d               cmp #$86
                    bne L9654
                    jmp L9676
                    
L9654               cmp #$87
                    bne L965b
                    jmp L97be
                    
L965b               cmp #$88
                    bne L963b
                    lda $8008
                    beq L9667
                    jsr S97e6
L9667               pha
                    pla
                    beq L9671
                    lda #$00
                    sta $7f
                    beq L9675
L9671               lda #$80
                    sta $9d
L9675               rts
                    
L9676               lda $8025
                    ldx $8027
                    ldy $8026
                    cmp #$ff
                    beq L96de
                    clc
                    jsr $8045
                    e0 91 01 
L968a               ldx #$ca
                    ldy #$98
                    jsr $8048
                    lda $91fd
                    pha
                    and #$0f
                    jsr S9808
                    stx L9816
                    sta $9817
                    pla
                    lsr a
                    lsr a
                    lsr a
                    lsr a
                    jsr S9808
                    stx $9819
                    sta $981a
                    ldx #$16
                    ldy #$98
                    jsr $8048
                    lda #$00
                    sta $91f0
                    ldx #$e0
                    ldy #$91
                    jsr $8048
                    jsr S99c8
                    ldx #$77
                    ldy #$99
                    jsr $8048
                    ldy #$0a
                    jsr $803c
                    jsr $803f
                    cmp #$59
                    bne L96da
L96d7               jmp L95e8
                    
L96da               cmp #$4e
                    bne L9676
L96de               ldx #$00
                    stx $fc5f
                    dex
                    stx $8025
                    stx $8026
                    stx $8027
                    lda #$0a
                    ldx #$2e
                    ldy #$03
                    clc
                    jsr $8045
                    jsr $321c
                    lda #$6c
                    sta kCHROUT
                    sta kGETIN
                    lda #$26
                    sta $ffd3
                    lda #$2a
                    sta $ffe5
                    lda #$03
                    sta $ffd4
                    sta $ffe6
                    jsr $1c20
                    lda #$20
                    sta kCHROUT
                    sta kGETIN
                    lda #$59
                    sta $ffd3
                    sta $ffe5
                    lda #$fc
                    sta $ffd4
                    sta $ffe6
                    lda $8008
                    beq L96d7
                    ldx #$01
                    ldy #$1c
                    stx $1210
                    sty $1211
                    ldx #$4f
                    ldy #$4f
                    sec
                    jsr $8039
                    jsr $803f
                    clc
                    lda $2d
                    adc #$ff
                    sta $3d
                    lda $2e
                    adc #$ff
                    sta $3e
                    lda #$00
                    sta $98
                    ldx #$03
                    stx $9a
                    sta $99
                    ldy #$00
                    sty $7a
                    dey
                    sty $120c
                    sty $1209
                    sty $120a
                    sty $1208
                    lda $39
                    ldy $3a
                    sta $35
                    sty $36
                    lda #$ff
                    ldy #$09
                    sta $7d
                    sty $7e
                    lda $2f
                    ldy $30
                    sta $31
                    sty $32
                    sta $33
                    sty $34
                    ldx #$03
L978f               lda $97b7,x
                    sta $1204,x
                    dex
                    bpl L978f
                    sec
                    lda $2d
                    ldy $2e
                    sbc #$01
                    bcs L97a2
                    dey
L97a2               sta $43
                    sty $44
                    ldx #$1b
                    stx $18
                    lda #$00
                    sta $1203
                    sta $12
                    sta $03df
                    jmp L95e8
                    
                    20 2c 2e 24 
L97bb               lda #$3b
                    2c 
L97be               lda #$33
                    pha
                    ldx #$08
                    stx $97db
                    txa
                    ldx #$00
                    ldy #$c0
                    sec
                    jsr $8096
                    pla
                    tax
                    lda #$0a
                    ldy #$00
                    clc
                    jsr $8045
                    00 c0 00 
L97dc               jsr $c000
                    clc
L97e0               jsr $8096
                    jmp L95e8
                    
S97e6               ldy #$11
L97e8               lda L99b6,y
                    tax
                    lda $1000,y
                    sta L99b6,y
                    txa
                    sta $1000,y
                    dey
                    bpl L97e8
                    rts
                    
S97fa               ldx #$41
                    ldy #$98
                    jsr $8048
                    inc L9841 + 5
                    inc L9841 + 5
                    rts
                    
S9808               ldx #$30
L980a               cmp #$0a
                    bcc L9813
                    sbc #$0a
                    inx
                    bne L980a
L9813               adc #$30
                    rts
                    
L9816               00 00 3a 00 00 3a 00 00 
L981e               "{Clr}       SYSTEM CONFIGURATION MODE{Return}"
                    00 
L9841               "  {Rvs On} F1 {Rvs Off}  {00}       "
                    00 
L9854               "¯"
                    00 
L9856               "{Return}{Return}{Return}{Return}{Return}{Return}"
                    00 
L985d               "SET LOGICAL UNIT PARAMETERS{Return}{Return}{Return}"
                    00 
L987c               "SET ALL OTHER PARAMETERS{Return}{Return}{Return}"
                    00 
L9898               "SET THE SPREADSHEET COLORS{Return}{Return}{Return}"
                    00 
L98b6               "EXIT CONFIGURE MODE"
                    00 
L98ca               "{Clr}NOTE: THE MODULE YOU'RE ABOUT TO ENTER{Return}      REQUIRES THE USE OF NEARLY ALL OF{Return}      THE MEMORY WHERE BASIC PROGRAMS{Return}      RUN. CURRENTLY, A PROGRAM BY THE{Return}      NAME OF {Rvs On}"
                    00 
L9977               "{Return}      OCCUPIES THIS AREA.{Return}{Return}{Return}DO YOU NEED TO SAVE IT FIRST ? Y{Left}"
                    00 
L99b6               01 01 01 01 01 01 01 01 00 00 
L99c0               85 89 86 8a 87 8b 88 8c 
S99c8               lda $8029
                    beq L9a07
                    ldy #$18
                    lda #$00
L99d1               sta d400_sVoc1FreqLo,y
                    dey
                    bpl L99d1
                    sty d406_sVoc1SusRel
                    lda #$51
                    sta d401_sVoc1FreqHi
                    sta d404_sVoc1Control
                    iny
L99e3               sty d418_sFiltMode
                    ldx #$01
                    jsr S9a08
                    iny
                    tya
                    cmp #$10
                    bne L99e3
                    ldx #$50
                    jsr S9a08
                    ldy #$10
                    sta d404_sVoc1Control
L99fb               dey
                    sty d418_sFiltMode
                    ldx #$01
                    jsr S9a08
                    tya
                    bne L99fb
L9a07               rts
                    
S9a08               dec L9a11
                    bne S9a08
                    dex
                    bne S9a08
                    rts
                    
L9a11               00 
