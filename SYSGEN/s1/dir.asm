	.include "../../include/ltk_sysdefs.asm"
;dir.r.prg
	*=$c000 ;rewrite start address to $4000 for sysgen disk 
Lc000               pha
                    ldx #$01
                    ldy #$08
                    lda LTK_Var_CPUMode
                    beq Lc00e
                    ldx #$01
                    ldy #$1c
Lc00e               stx Lc63e
                    stx Lc5f1 + 1
                    sty Lc63d
                    sty Lc5f1 + 2
                    ldx $c8
                    pha
                    pla
                    beq Lc022
                    ldx $ea
Lc022               stx Lc63c
                    jsr LTK_GetPortNumber
                    clc
                    adc #$9e
                    tax
                    lda #$02
                    adc #$00
                    tay
                    lda #$0a
                    clc
                    jsr LTK_HDDiscDriver
                    .byte $e0 
                    .byte $91 
                    .byte $01 
Lc03c = * + 2       
Lc03a               lda $91e2
                    ldx $91e0
                    ldy $91e1
                    bit LTK_Var_CPUMode
                    bpl Lc05b
                    lda $91e7
                    ldy $91e6
                    bit $d7
                    bmi Lc05b
                    lda $91e5
                    ldx $91e3
                    ldy $91e4
Lc05b               sta Lc626
                    stx Lc627
                    sty Lc628
                    ldx $91f0
                    ldy $91f2
                    bit LTK_Var_CPUMode
                    bpl Lc075
                    ldx $91f1
                    ldy $91f3
Lc075               stx Lc629
                    sty Lc62a
                    pla
                    tay
                    ldx Lc63c
                    lda #$ff
                    sta LTK_Command_Buffer,x
                    lda LTK_Var_ActiveLU
                    sta Lc62e
                    lda LTK_Var_Active_User
                    sta Lc633
                    cpy Lc63c
                    bcs Lc0da
                    iny
                    cpy Lc63c
                    bcs Lc0da
                    sty Lc62f
                    lda LTK_Command_Buffer,y
                    cmp #$3a
                    beq Lc0c9
                    lda #$00
                    ldx #$02
                    jsr Scb21
                    bcs Lc0c9
                    lda LTK_Command_Buffer,y
                    cmp #$3a
                    bne Lc0c9
                    sty Lc62f
                    txa
                    jsr $8099
                    bcc Lc0c9
                    ldx #$77
                    ldy #$c7
Lc0c3               jsr LTK_ErrorHandler
                    jmp Lc5e9
                    
Lc0c9               ldy Lc62f
                    lda LTK_Command_Buffer,y
                    cmp #$3a
                    beq Lc0d6
                    jmp Lc16e
                    
Lc0d6               iny
                    cpy Lc63c
Lc0da               bcs Lc14c
                    lda LTK_Command_Buffer,y
                    cmp #$3a
                    beq Lc107
                    cmp #$20
                    bne Lc0ea
                    jmp Lc16d
                    
Lc0ea               lda #$00
                    ldx #$02
                    jsr Scb21
                    bcs Lc107
                    lda LTK_Command_Buffer,y
                    cmp #$3a
                    bne Lc107
                    cpx #$10
                    bcc Lc104
                    ldx #$90
                    ldy #$c7
                    bne Lc0c3
Lc104               stx Lc633
Lc107               dey
Lc108               iny
                    cpy Lc63c
                    bcs Lc14c
Lc10e               lda LTK_Command_Buffer,y
                    cmp #$20
                    beq Lc16d
                    cmp #$53
                    bne Lc11e
                    dec Lc62b
                    bne Lc108
Lc11e               cmp #$41
                    bne Lc129
                    lda #$ff
                    sta Lc633
                    bne Lc108
Lc129               cmp #$43
                    bne Lc132
                    dec Lc634
                    bne Lc108
Lc132               cmp #$47
                    bne Lc13b
                    dec Lc635
                    bne Lc108
Lc13b               cmp #$50
                    bne Lc144
                    dec Lc631
                    bne Lc108
Lc144               cmp #$54
                    bne Lc108
                    iny
                    cpy Lc63c
Lc14c               bcs Lc176
                    lda #$00
                    ldx #$02
                    jsr Scb21
                    bcs Lc176
                    stx Lc630
                    lda LTK_Command_Buffer,y
                    cmp #$20
                    beq Lc168
                    cpy Lc63c
                    bcs Lc176
                    bcc Lc10e
Lc168               cpy Lc63c
                    bcs Lc176
Lc16d               iny
Lc16e               cpy Lc63c
                    bcs Lc176
                    sty Lc632
Lc176               lda Lc635
                    beq Lc188
                    lda #$ff
                    sta Lc633
                    sta LTK_Var_ActiveLU
Lc183               jsr Sc47a
                    bcs Lc1bd
Lc188               lda Lc62b
                    beq Lc1cf
                    lda $8025
                    cmp #$ff
                    bne Lc1a2
                    lda $8026
                    cmp #$ff
                    bne Lc1a2
                    lda $8027
                    cmp #$ff
                    beq Lc1cf
Lc1a2               ldx #<str_SortWarning
                    ldy #>str_SortWarning
                    jsr LTK_Print
                    
                    ldy #$ff
                    jsr LTK_ErrorHandler
                    ldy #$10
                    jsr LTK_KernalTrapRemove
Lc1b3               jsr LTK_KernalCall
                    tax
                    beq Lc1b3
                    cmp #$59
                    bne Lc1c0
Lc1bd               jmp Lc61c
                    
Lc1c0               cmp #$4e
                    bne Lc1b3
                    lda #$ff
                    sta $8025
                    sta $8026
                    sta $8027
Lc1cf               lda #$00
                    sta Lc636
                    sta Lcb1c
                    sta Lcb1d
                    sta Lc63f
                    sta Lc640
                    sta Lc638
                    lda #$fe
                    sta Lc637
                    lda #$12
                    ldx LTK_Var_CPUMode
                    beq Lc1f4
                    ldx $d7
                    beq Lc1f4
                    asl a
Lc1f4               sta Lc63a
                    sta Lc641
                    lda Lc62b
                    bne Lc20d
                    lda Lc631
                    beq Lc207
                    jsr Sc874
Lc207               jsr Sc4bd
                    jmp Lc214
                    
Lc20d               ldx #<str_SortingInProgress
                    ldy #>str_SortingInProgress
                    jsr LTK_Print
                    
Lc214               lda LTK_Var_ActiveLU
                    ldx #$f0
                    cmp #$0a
                    beq Lc21f
                    ldx #$11
Lc21f               ldy #$00
                    clc
                    jsr LTK_HDDiscDriver
                    .byte $e0 
                    .byte $91 
                    .byte $01 
Lc228               lda Lc637
                    beq Lc240
                    ldy Lc638
                    lda #$00
                    sta Lc62c
Lc235               lda $9202,y
                    bne Lc243
                    iny
                    dec Lc637
                    bne Lc235
Lc240               jmp Lc2d7
                    
Lc243               iny
                    tya
                    sta Lc638
                    dec Lc637
                    lda #$f0
                    ldx LTK_Var_ActiveLU
                    cpx #$0a
                    beq Lc256
                    lda #$11
Lc256               clc
                    adc Lc638
                    sta Lc62d
                    bcc Lc262
                    inc Lc62c
Lc262               lda #$e0
                    sta Sc6de + 1
                    sta Sc6e2 + 1
                    lda #$8f
                    sta Sc6de + 2
                    sta Sc6e2 + 2
                    lda Lc62b
                    beq Lc27e
                    
                    ldx #<str_Period
                    ldy #>str_Period
                    jsr LTK_Print
                    
Lc27e               lda LTK_Var_ActiveLU
                    ldx Lc62d
                    ldy Lc62c
                    clc
                    jsr LTK_HDDiscDriver
                    .byte $e0 
                    .byte $8f 
                    .byte $01 
Lc28e               lda $8ffc
                    sta Lc639
Lc294               ldy #$1d
                    jsr Sc6de
                    bpl Lc2a8
                    bmi Lc2a2
Lc29d               dec Lc639
                    beq Lc228
Lc2a2               jsr Sc49a
                    jmp Lc294
                    
Lc2a8               jsr Sc64a
                    bcs Lc29d
                    lda #$ff
                    sta Lc636
                    ldx Sc6de + 1
                    ldy Sc6de + 2
                    lda Lc62b
                    beq Lc2d1
                    jsr Sc930
                    bcc Lc29d
                    
                    ldx #<str_SortTableFull
                    ldy #>str_SortTableFull
                    jsr LTK_Print
                    
                    ldy #$ff
                    jsr LTK_ErrorHandler
                    jmp Lc2d7
                    
Lc2d1               jsr Sc32d
                    jmp Lc29d
                    
Lc2d7               lda Lc62b
                    bne Lc2df
                    jmp Lc5a0
                    
Lc2df               lda Lcb1c
                    bne Lc2ec
                    lda Lcb1d
                    bne Lc2ec
                    jmp Lc5a0
                    
Lc2ec               lda Lc63e
                    sta Sc6de + 1
                    sta Sc6e2 + 1
                    lda Lc63d
                    sta Sc6de + 2
                    sta Sc6e2 + 2
                    lda Lc631
                    beq Lc309
                    jsr Sc874
                    jsr Sc642
Lc309               jsr Sc4bd
Lc30c               jsr Sc32d
                    jsr Sc49a
                    ldx Lcb1c
                    ldy Lcb1d
                    dey
                    cpy #$ff
                    bne Lc31e
                    dex
Lc31e               stx Lcb1c
                    sty Lcb1d
                    txa
                    bne Lc30c
                    tya
                    bne Lc30c
                    jmp Lc5a0
                    
Sc32d               lda #$20
                    ldy #$0f
Lc331               sta str_FilenameBuffer,y
                    dey
                    bpl Lc331
                    ldy #$10
                    jsr Sc6de
                    pha
                    lda #$00
                    jsr Sc6e2
                    ldy #$00
Lc344               jsr Sc6de
                    beq Lc34f
                    sta str_FilenameBuffer,y
                    iny
                    bne Lc344
Lc34f               jsr Sc907

                    ldx #<str_FilenameBuffer
                    ldy #>str_FilenameBuffer
                    jsr LTK_Print
                    
                    jsr Sc91a
                    ldx #$01
                    jsr Sc4af
                    ldy #$11
                    jsr Sc6de
                    tax
                    pla
                    tay
                    lda #$00
                    jsr Sc4b5
                    ldx #$2e
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldx #$01
                    jsr Sc4af
                    ldy #$16
                    jsr Sc6de
                    pha
                    tax
                    lda #$00
                    tay
                    jsr Sc4b5
                    ldx #$31
                    ldy #$cc
                    jsr LTK_Print
                    
                    pla
                    cmp #$01
                    beq Lc39b
                    cmp #$02
                    beq Lc39b
                    cmp #$03
                    bne Lc3a3
Lc39b               ldx #$0e
                    jsr Sc4af
                    jmp Lc40b
                    
Lc3a3               ldx #$01
                    jsr Sc4af
                    ldy #$18
                    jsr Sc6de
                    tax
                    dey
                    jsr Sc6de
                    tay
                    lda #$ff
                    jsr Sc4b5
                    ldx #$2f
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldx #$01
                    jsr Sc4af
                    ldy #$1f
                    jsr Sc6de
                    tax
                    dey
                    jsr Sc6de
                    tay
                    lda #$ff
                    jsr Sc4b5
                    ldx #$2f
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldx #$01
                    jsr Sc4af
                    ldy #$19
                    jsr Sc6de
                    lsr a
                    lsr a
                    lsr a
                    lsr a
                    tax
                    lda #$00
                    tay
                    jsr Sc4b8
                    ldx #$31
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldy #$1a
                    jsr Sc6de
                    php
                    ldx #$5f
                    ldy #$c8
                    plp
                    bpl Lc408
                    ldx #$5d
                    ldy #$c8
Lc408               jsr LTK_Print
Lc40b               ldy #$7c
                    lda Lc631
                    bne Lc41c
                    iny
                    lda LTK_Var_CPUMode
                    beq Lc42b
                    lda $d7
                    beq Lc42b
Lc41c               lda Lc640
                    lsr a
                    bcs Lc42b
                    ldx #$01
                    tya
                    jsr Sc861
                    jmp Lc42e
                    
Lc42b               jsr Sc642
Lc42e               inc Lc640
                    bne Lc436
                    inc Lc63f
Lc436               lda Lc631
                    beq Lc451
                    ldy #$10
                    jsr LTK_KernalTrapRemove
                    jsr LTK_KernalCall
                    cmp #$03
                    bne Lc464
Lc447               pla
                    pla
                    lda #$00
                    sta Lc635
                    jmp Lc5e9
                    
Lc451               dec Lc63a
                    bne Lc464
                    jsr Sc465
                    beq Lc447
                    lda Lc641
                    sta Lc63a
                    jsr Sc4bd
Lc464               rts
                    
Sc465               ldx #$1c
                    ldy #$c7
                    jsr LTK_Print
                    ldy #$10
                    jsr LTK_KernalTrapRemove
Lc471               jsr LTK_KernalCall
                    tax
                    beq Lc471
                    cmp #$03
                    rts
                    
Sc47a               ldx LTK_Var_ActiveLU
                    inx
                    cpx #$0b
                    beq Lc498
                    stx LTK_Var_ActiveLU
                    cpx #$0a
                    beq Lc496
                    txa
                    asl a
                    asl a
                    clc
                    adc LTK_Var_ActiveLU
                    tay
                    lda $80a8,y
                    bmi Sc47a
Lc496               clc
                    rts
                    
Lc498               sec
                    rts
                    
Sc49a               clc
                    lda Sc6de + 1
                    adc #$20
                    sta Sc6de + 1
                    sta Sc6e2 + 1
                    bcc Lc4ae
                    inc Sc6de + 2
                    inc Sc6e2 + 2
Lc4ae               rts
                    
Sc4af               lda #$20
                    jsr Sc861
                    rts
                    
Sc4b5               sec
                    bcs Lc4b9
Sc4b8               clc
Lc4b9               jsr Scb9b
                    rts
                    
Sc4bd               lda Lc631
                    bne Lc4fe
                    lda Lc626
                    ldx LTK_Var_CPUMode
                    beq Lc4d6
                    lda $f1
                    and #$f0
                    ora Lc626
                    sta $f1
                    jmp Lc4d9
                    
Lc4d6               sta $0286
Lc4d9               lda Lc627
                    sta $d020
                    lda Lc628
                    sta $d021
                    ldx LTK_Var_CPUMode
                    beq Lc4f7
                    ldx #$1a
                    stx $d600
Lc4ef               bit $d600
                    bpl Lc4ef
                    sta $d601
Lc4f7               ldx #$6f
                    ldy #$c7
                    jsr LTK_Print
Lc4fe               jsr Sc555
                    ldy #$7c
                    lda Lc631
                    bne Lc512
                    iny
                    lda LTK_Var_CPUMode
                    beq Lc51b
                    lda $d7
                    beq Lc51b
Lc512               ldx #$01
                    tya
                    jsr Sc861
                    jsr Sc555
Lc51b               jsr Sc642
                    lda #$a3
                    ldy Lc631
                    beq Lc527
                    lda #$2d
Lc527               ldx #$27
                    jsr Sc861
                    ldy #$7c
                    ldx Lc631
                    bne Lc53d
                    iny
                    ldx LTK_Var_CPUMode
                    beq Lc551
                    ldx $d7
                    beq Lc551
Lc53d               ldx #$01
                    tya
                    jsr Sc861
                    lda #$a3
                    ldy Lc631
                    beq Lc54c
                    lda #$2d
Lc54c               ldx #$27
                    jsr Sc861
Lc551               jsr Sc642
                    rts
                    
Sc555               ldx #<str_Name
                    ldy #>str_Name
                    jsr LTK_Print
                    
                    ldx #<str_RevsOn
                    ldy #>str_RevsOn
                    jsr LTK_Print
                    
                    ldx #<str_Lu
                    ldy #>str_Lu
                    jsr LTK_Print
                    
                    ldx LTK_Var_ActiveLU
                    lda #$00
                    tay
                    jsr Sc4b8
                    ldx #$31
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldx #<str_Slash
                    ldy #>str_Slash
                    jsr LTK_Print
                    
                    ldx LTK_Var_Active_User
                    lda #$00
                    tay
                    jsr Sc4b8
                    ldx #$31
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldx #<str_RevsOff
                    ldy #>str_RevsOff
                    jsr LTK_Print
                    
                    ldx #<str_DirHeader
                    ldy #>str_DirHeader
                    jsr LTK_Print
                    rts
                    
Lc5a0               lda LTK_Var_ActiveLU
                    ldx #$ee
                    cmp #$0a
                    beq Lc5ab
                    ldx #$00
Lc5ab               ldy #$00
                    clc
                    jsr LTK_HDDiscDriver
                    .byte $e0 
                    .byte $8f 
                    .byte $01 
Lc5b4               ldy $9071
                    ldx $9072
                    lda #$00
                    jsr Sc4b5
                    ldx #<str_BlocksAvail
                    ldy #>str_BlocksAvail
                    jsr LTK_Print
                    
                    ldx #$2e
                    ldy #$cc
                    jsr LTK_Print
                    
                    ldy $9074
                    ldx $9075
                    lda #$00
                    jsr Sc4b5
                    
                    ldx #<str_BlocksUsed
                    ldy #>str_BlocksUsed
                    jsr LTK_Print
                    
                    ldx #$2e
                    ldy #$cc
                    jsr LTK_Print
                    jsr Sc642
Lc5e9               lda Lc62b
                    beq Lc5f7
                    lda #$00
                    tay
Lc5f1               sta Lc5f1,y
                    iny
                    bne Lc5f1
Lc5f7               lda Lc631
                    beq Lc605
                    jsr Sc642
                    jsr Sc642
                    jsr Sc8e9
Lc605               lda Lc635
                    beq Lc61c
                    lda Lc631
                    bne Lc619
                    lda Lc636
                    beq Lc619
                    jsr Sc465
                    beq Lc61c
Lc619               jmp Lc183
                    
Lc61c               lda Lc62e
                    sta LTK_Var_ActiveLU
                    clc
                    jmp $8096
                    
Lc626               .byte $00 
Lc627               .byte $00 
Lc628               .byte $00 
Lc629               .byte $00 
Lc62a               .byte $00 
Lc62b               .byte $00 
Lc62c               .byte $00 
Lc62d               .byte $00 
Lc62e               .byte $00 
Lc62f               .byte $00 
Lc630               .byte $00 
Lc631               .byte $00 
Lc632               .byte $00 
Lc633               .byte $00 
Lc634               .byte $00 
Lc635               .byte $00 
Lc636               .byte $00 
Lc637               .byte $fe 
Lc638               .byte $00 
Lc639               .byte $00 
Lc63a               .byte $12 
Lc63b               .byte $00 
Lc63c               .byte $00 
Lc63d               .byte $00 
Lc63e               .byte $00 
Lc63f               .byte $00 
Lc640               .byte $00 
Lc641               .byte $00 

Sc642               ldx #$6d
                    ldy #$c7
                    jsr LTK_Print
                    rts
                    
Sc64a               lda Lc633
                    bmi Lc65d
                    ldy #$19
                    jsr Sc6de
                    lsr a
                    lsr a
                    lsr a
                    lsr a
                    cmp Lc633
                    bne Lc678
Lc65d               lda Lc634
                    beq Lc669
                    ldy #$1a
                    jsr Sc6de
                    bpl Lc678
Lc669               lda Lc630
                    beq Lc67a
                    ldy #$16
                    jsr Sc6de
                    cmp Lc630
                    beq Lc67a
Lc678               sec
                    rts
                    
Lc67a               ldy #$00
                    sty $c6dd
                    sty $c6db
                    sty $c6dc
                    ldx Lc632
                    bne Lc68c
Lc68a               clc
                    rts
                    
Lc68c               jsr Sc6de
                    sta $c6da
                    beq Lc678
                    lda LTK_Command_Buffer,x
                    cmp #$3f
                    beq Lc6cd
                    cmp #$2a
                    bne Lc6a4
                    sta $c6dd
                    beq Lc6cd
Lc6a4               cmp $c6da
                    beq Lc6bd
                    lda $c6dd
                    bne Lc6d3
                    ldy $c6dc
                    ldx $c6db
                    beq Lc678
                    lda #$2a
                    sta $c6dd
                    bne Lc6d3
Lc6bd               lda $c6dd
                    beq Lc6cd
                    stx $c6db
                    sty $c6dc
                    lda #$00
                    sta $c6dd
Lc6cd               inx
                    cpx Lc63c
                    bcs Lc68a
Lc6d3               iny
                    cpy #$10
                    bne Lc68c
                    beq Lc678
                    .byte $00
                    
                    .byte $00 
                    .byte $00 
                    .byte $00 
Sc6de               lda Sc6de,y
                    rts
                    
Sc6e2               sta Sc6e2,y
                    rts
                    
                                      
str_FilenameBuffer ;$c6e6
		    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
                    .byte $00 
str_Name ;$c6f7               
	.text "name  "
	.byte $00 
	
str_Lu ;$c6fe
	.text "l/u= "
	.byte $00 
	
str_DirHeader ;$c704
	.text "  size tp ladr hadr usr"
	.byte $00 
	
Lc71c               .text "{return}{rvs on}press any key to continue (or stop)"
                    .byte $00 
str_BlocksAvail ;$c742               
	.text "{return}{return}blocks available = "
	.byte $00 
	
str_BlocksUsed ;$c758
	.text "{return}blocks used      = "
	.byte $00 
Lc76d               .text "{return}"
                    .byte $00 
Lc76f               .text "{clr}"
                    .byte $00 
str_Slash ;$c771
	.text "/"
	.byte $00 
	
str_RevsOn ;$c773               
	.text "{rvs on}"
	.byte $00 
	
str_RevsOff ;$c775
	.text "{rvs off}"
	.byte $00 
	
Lc777               .text "invalid logical unit !!{return}"
                    .byte $00 
Lc790               .text "invalid user number !!{return}"
                    .byte $00 
str_SortWarning ;$c7a8
	.text "{clr}{return}{rvs on}warning - sort option uses the     {return}{rvs on}{$22}basic{$22} program area for sorting !!{return}{return}{return}should you save it first(y or n) ?"
	.byte $00 
str_SortingInProgress ;$c819
	.text "{return}{return}{rvs on}please wait - sorting in progress !{return}"
	.byte $00 
str_SortTableFull ;$c841
	.text "{return}{return}{rvs on}sort table is full !!{return}"
	.byte $00 
str_Period ;$c85b
	.text "."
	.byte $00 
Lc85d               .text "!"
                    .byte $00 
Lc85f               .text " "
                    .byte $00 
Sc861               sta $c92e
                    stx $c92d
Lc867               ldx #$2e
                    ldy #$c9
                    jsr LTK_Print
                    dec $c92d
                    bne Lc867
                    rts
                    
Sc874               ldy #$12
                    jsr Sc8c4
                    ldx #$00
                    stx $b7
                    inx
                    stx $b8
                    lda Lc629
                    sta $ba
                    lda Lc62a
                    ora #$60
                    sta $b9
                    ldy #$00
                    jsr Sc8c4
Sc891               bit LTK_Var_CPUMode
                    bpl Lc89b
                    ldx #$60
                    jsr Sc8cd
Lc89b               ldy #$06
                    lda #$01
                    jsr Sc8c4
                    bit LTK_Var_CPUMode
                    bpl Lc8ac
                    ldx #$4c
                    jsr Sc8cd
Lc8ac               lda $9a
                    cmp Lc629
                    beq Lc8b8
                    inc Lc631
                    beq Lc8fc
Lc8b8               lda #$00
                    sta str_RevsOff
                    sta str_RevsOn
                    jsr Sc642
                    rts
                    
Sc8c4               pha
                    jsr LTK_KernalTrapRemove
                    pla
                    tax
                    jmp LTK_KernalCall
                    
Sc8cd               ldy #$14
Lc8cf               lda Lc8db,y
                    sta $8fe0,y
                    dey
                    bpl Lc8cf
                    jmp $8fe0
                    
Lc8db               ldy #$0e
                    sty $ff00
                    stx $f140
                    ldy #$3e
                    sty $ff00
                    rts
                    
Sc8e9               jsr Sc891
                    ldx #$01
                    jsr Sc4af
                    ldy #$02
                    jsr LTK_KernalTrapRemove
                    lda #$01
                    clc
                    jsr LTK_KernalCall
Lc8fc               lda #$03
                    sta $9a
                    lda #$00
                    sta $99
                    sta $90
                    rts
                    
Sc907               lda LTK_Var_CPUMode
                    bne Lc913
                    lda $d4
                    ora #$01
                    sta $d4
                    rts
                    
Lc913               lda $f4
                    ora #$01
                    sta $f4
                    rts
                    
Sc91a               lda LTK_Var_CPUMode
                    bne Lc926
                    lda $d4
                    and #$fe
                    sta $d4
                    rts
                    
Lc926               lda $f4
                    and #$fe
                    sta $f4
                    rts
                    
                    .byte $00 
                    .byte $00 
                    .byte $00 
Sc930               stx Lcb02 + 1
                    stx Lcaea + 1
                    sty Lcb02 + 2
                    sty Lcaea + 2
                    ldx Lcb1c
                    ldy Lcb1d
                    bne Lc973
                    txa
                    bne Lc973
                    lda Lc63d
                    sta Lcb12
                    sta Lcb14
                    sta Lc96b + 2
                    lda Lc63e
                    sta Lcb13
                    sta Lc96b + 1
                    clc
                    adc #$1f
                    sta Lcb15
                    bcc Lc967
                    inc Lcb14
Lc967               lda #$ff
                    ldx #$20
Lc96b               sta Lc96b,x
                    dex
                    bpl Lc96b
                    bmi Lc97e
Lc973               cpx #$03
                    bcc Lc97e
                    bne Lc97d
                    cpy #$1f
                    bcc Lc97e
Lc97d               rts
                    
Lc97e               lda Lcb1c
                    lsr a
                    tax
                    lda Lcb1d
                    ror a
                    ldy #$20
                    jsr $8072
                    clc
                    adc Lcb13
                    sta Lcb17
                    sta $cb06
                    txa
                    adc Lcb12
                    sta Lcb16
                    sta $cb07
                    ldx #$00
                    stx Lcb20
                    stx Lcb1e
                    inx
                    stx Lcb1f
Lc9ac               lda Lcb1c
                    cmp Lcb1e
                    bcc Lc9ca
                    bne Lc9be
                    lda Lcb1f
                    cmp Lcb1d
                    bcs Lc9ca
Lc9be               inc Lcb20
                    asl Lcb1f
                    rol Lcb1e
                    jmp Lc9ac
                    
Lc9ca               lda Lcb20
                    bne Lc9d2
                    jmp Lca7a
                    
Lc9d2               jsr Scafe
                    ldx #$00
                    bcc Lc9da
                    inx
Lc9da               stx Lcb18
                    dec Lcb20
                    lda Lcb20
                    sta Lcb19
                    lda #$00
                    sta Lcb1a
                    lda #$01
                    sta Lcb1b
                    ldx Lcb19
                    beq Lca02
                    bne Lc9fd
Lc9f7               asl Lcb1b
                    rol Lcb1a
Lc9fd               dec Lcb19
                    bne Lc9f7
Lca02               lda Lcb1b
                    ldx Lcb1a
                    ldy #$20
                    jsr $8072
                    sta Lcb1b
                    stx Lcb1a
                    lda Lcb18
                    beq Lca2e
                    lda Lcb17
                    clc
                    adc Lcb1b
                    sta Lcb1b
                    lda Lcb16
                    adc Lcb1a
                    sta Lcb1a
                    jmp Lca41
                    
Lca2e               lda Lcb17
                    sec
                    sbc Lcb1b
                    sta Lcb1b
                    lda Lcb16
                    sbc Lcb1a
                    sta Lcb1a
Lca41               lda Lcb1a
                    cmp Lcb12
                    bcc Lca77
                    bne Lca53
                    lda Lcb1b
                    cmp Lcb13
                    bcc Lca77
Lca53               lda Lcb14
                    cmp Lcb1a
                    bcc Lca77
                    bne Lca65
                    lda Lcb15
                    cmp Lcb1b
                    bcc Lca77
Lca65               lda Lcb1a
                    sta Lcb16
                    sta $cb07
                    lda Lcb1b
                    sta Lcb17
                    sta $cb06
Lca77               jmp Lc9ca
                    
Lca7a               jsr Scafe
                    bcc Lca8d
                    clc
                    lda #$20
                    adc $cb06
                    sta $cb06
                    bcc Lca8d
                    inc $cb07
Lca8d               lda Lcb14
                    sta Lcac3 + 2
                    sta $cac8
                    lda #$00
                    sta Lcac3 + 1
                    sta $cac7
                    lda Lcb15
                    tax
                    clc
                    adc #$20
                    sta Lcb15
                    tay
                    bcc Lcab1
                    inc Lcb14
                    inc $cac8
Lcab1               lda $cb06
                    sta $caca
                    sta $caee
                    lda $cb07
                    sta $cad1
                    sta $caef
Lcac3               lda Lcac3,x
                    sta $cac6,y
                    cpx #$00
                    bne Lcad4
                    lda Lcac3 + 2
                    cmp #$00
                    beq Lcae6
Lcad4               dex
                    cpx #$ff
                    bne Lcadc
                    dec Lcac3 + 2
Lcadc               dey
                    cpy #$ff
                    bne Lcac3
                    dec $cac8
                    bne Lcac3
Lcae6               ldx #$20
                    ldy #$00
Lcaea               lda Lcaea,y
                    sta $caed,y
                    iny
                    dex
                    bne Lcaea
                    inc Lcb1d
                    bne Lcafc
                    inc Lcb1c
Lcafc               clc
                    rts
                    
Scafe               ldx #$10
                    ldy #$00
Lcb02               lda Lcb02,y
                    cmp $cb05,y
                    bcc Lcb11
                    bne Lcb11
                    iny
                    dex
                    bne Lcb02
                    sec
Lcb11               rts
                    
Lcb12               .byte $00 
Lcb13               .byte $00 
Lcb14               .byte $00 
Lcb15               .byte $00 
Lcb16               .byte $00 
Lcb17               .byte $00 
Lcb18               .byte $00 
Lcb19               .byte $00 
Lcb1a               .byte $00 
Lcb1b               .byte $00 
Lcb1c               .byte $00 
Lcb1d               .byte $00 
Lcb1e               .byte $00 
Lcb1f               .byte $00 
Lcb20               .byte $00 
Scb21               sta Lcb32 + 1
                    stx Lcb32 + 2
                    lda #$00
                    sta $cb98
                    sta $cb99
                    sta $cb9a
Lcb32               lda Lcb32,y
                    cmp #$30
                    bcc Lcb8a
                    cmp #$3a
                    bcc Lcb4f
                    ldx $cb5b
                    cpx #$0a
                    beq Lcb8a
                    cmp #$41
                    bcc Lcb8a
                    cmp #$47
                    bcs Lcb8a
                    sec
                    sbc #$07
Lcb4f               ldx $cb98
                    beq Lcb73
                    pha
                    tya
                    pha
                    lda #$00
                    tax
                    ldy #$0a
Lcb5c               clc
                    adc $cb9a
                    pha
                    txa
                    adc $cb99
                    tax
                    pla
                    dey
                    bne Lcb5c
                    sta $cb9a
                    stx $cb99
                    pla
                    tay
                    pla
Lcb73               inc $cb98
                    sec
                    sbc #$30
                    clc
                    adc $cb9a
                    sta $cb9a
                    bcc Lcb87
                    inc $cb99
                    beq Lcb90
Lcb87               iny
                    bne Lcb32
Lcb8a               clc
                    ldx $cb98
                    bne Lcb91
Lcb90               sec
Lcb91               lda $cb99
                    ldx $cb9a
                    rts
                    
                    .byte $00 
                    .byte $00 
                    .byte $00 
Scb9b               stx Lcc2d
                    sty Lcc2c
                    php
                    pha
                    lda #$30
                    ldy #$04
Lcba7               sta Lcc2e,y
                    dey
                    bpl Lcba7
                    pla
                    beq Lcbcb
                    lda Lcc2d
                    jsr Scc17
                    sta Lcc31
                    stx Lcc32
                    lda Lcc2c
                    jsr Scc17
                    sta Lcc2f
                    stx Lcc30
                    jmp Lcc00
                    
Lcbcb               iny
Lcbcc               lda Lcc2c
                    cmp Lcc34,y
                    bcc Lcbfb
                    bne Lcbde
                    lda Lcc2d
                    cmp Lcc39,y
                    bcc Lcbfb
Lcbde               lda Lcc2d
                    sbc Lcc39,y
                    sta Lcc2d
                    lda Lcc2c
                    sbc Lcc34,y
                    sta Lcc2c
                    lda Lcc2e,y
                    clc
                    adc #$01
                    sta Lcc2e,y
                    bne Lcbcc
Lcbfb               iny
                    cpy #$05
                    bne Lcbcc
Lcc00               plp
                    bcc Lcc16
                    ldy #$00
Lcc05               lda Lcc2e,y
                    cmp #$30
                    bne Lcc16
                    lda #$20
                    sta Lcc2e,y
                    iny
                    cpy #$04
                    bne Lcc05
Lcc16               rts
                    
Scc17               pha
                    and #$0f
                    jsr Scc23
                    tax
                    pla
                    lsr a
                    lsr a
                    lsr a
                    lsr a
Scc23               cmp #$0a
                    bcc Lcc29
                    adc #$06
Lcc29               adc #$30
                    rts
                    
Lcc2c               .byte $ff 
Lcc2d               .byte $ff 

Lcc2e               .byte $00 
Lcc2f               .byte $00 
Lcc30               .byte $00 

Lcc31               .byte $00 
Lcc32               .byte $00 
Lcc33               .byte $00 
Lcc34               .byte $27 
Lcc35               .byte $03 
Lcc36               .byte $00 
Lcc37               .byte $00 
Lcc38               .byte $00 
Lcc39               .byte $10 
Lcc3a               .byte $e8 
Lcc3b               .byte $64 
Lcc3c               .byte $0a 
Lcc3d               .byte $01 