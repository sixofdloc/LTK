;errorhan.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	
	*= LTK_MiniSubExeArea ;$93e0 , $4000 for sysgen
	
START               
	sty L9521
	stx L9471 + 1
	cpy #$ff
	bne L93ee
	jsr BeepIfAllowed
	rts
                    
L93ee 
	tya
	bne L93f7
	ldx #<str_OK
	ldy #>str_OK
	bne L9435
L93f7
	bmi L9435
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$e6
	sta L9528
	ldx #$00
	stx L9527
	tya
	and #$0f
	tax
	lda #$e0
	ldy #$8f
	cpx #$00
	beq L941d
L9414
	clc
	adc #$20
	bcc L941a
	iny
L941a
	dex
	bne L9414
L941d
	sta CopySource + 1
	sty CopySource + 2
	lda #$0a
	ldx L9528
	ldy L9527
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
L9432
	jmp L943b
                    
L9435
	stx CopySource + 1
	sty CopySource + 2
L943b
	ldy #$00
	ldx L9521
CopySource
	lda CopySource,y
	pha
	sta LTK_ErrMsgBuffer,y ;$9ee0
	iny
	pla
	beq L945b
	cpx #$01
	bne L9457
	cpy #$13
	bne CopySource
	ldy #$1a
	bne L945b
L9457               
	cpy #$20
	bne CopySource
L945b
	sty L9524
	sty $9ed6
	lda #$00
	sta $9ecf
	sta $9edc
	cpx #$04
	beq L9471
	cpx #$05
	bne L9489
L9471
	lda #$00
	ldx #$30
L9475
	cmp #$0a
	bcc L947e
	sbc #$0a
	inx
	bne L9475
L947e
	clc
	adc #$30
	stx $9ef7
	sta $9ef8
	bne L948f
L9489
	txa
	bne L948f
	jmp L9510
                    
L948f
	lda LTK_Var_CPUMode
	bne L94a6
	lda $9d
	bpl L9510
	lda $7b
	cmp #$08
	bcc L94b6
	bne L9510
	lda $7a
	bne L9510
	beq L94b6
L94a6
	lda $7f
	bmi L9510
	lda $3e
	cmp #$1c
	bcc L94b6
	bne L9510
	lda $3d
	bne L9510
L94b6
	lda LTK_ErrorTrapFlag
	beq L94c3
	cmp #$04
	bcs L9517
	cmp #$01
	bne L9510
L94c3
	lda $9a
	pha
	lda #$03
	sta $9a
	jsr S9519
	lda #$28
	ldx LTK_Var_CPUMode
	beq L94d9
	ldx $d7
	beq L94d9
	asl a
L94d9     
	pha
	tax
	lda #$20
	ldy #$00
L94df
	sta Message_Buffer,y ;$9529
	iny
	dex
	bne L94df
	pla
	sec
	sbc L9524
	lsr a
	tay
	lda #$00
	sta Message_Buffer,y ;$9529
	ldx #<Message_Buffer
	ldy #>Message_Buffer
	jsr LTK_Print
	ldx #$25
	ldy #$95
	jsr LTK_Print
	ldx #$e0
	ldy #$9e
	jsr LTK_Print
	jsr S9519
	jsr BeepIfAllowed
	pla
	sta $9a
L9510
	lda LTK_ErrorTrapFlag
	lsr a
	lda #$00
	rts
                    
L9517
	bcs L94c3
S9519
	ldx #$22
	ldy #$95
	jsr LTK_Print
	rts
                    
L9521
	.byte $00 
L9522
	.text "{return}"
	.byte $00 
L9524
	.byte $00 
L9525
	.text "{rvs on}"
	.byte $00 
L9527
	.byte $00 
L9528
	.byte $00 
Message_Buffer ;$9529
	.repeat 81,$0
                    
str_OK ;$957a
	.text "00, ok,00,00{return}"
	.byte $00 
	
BeepIfAllowed               
	lda LTK_BeepOnErrorFlag
	beq L95c7
	ldy #$18
	lda #$00
L9591
	sta SID_V1_FreqLo,y
	dey
	bpl L9591
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L95a3
	sty SID_VolumeAndFilter
	ldx #$01
	jsr BeepDelay
	iny
	tya
	cmp #$10
	bne L95a3
	ldx #$50
	jsr BeepDelay
	ldy #$10
	sta SID_V1_Control
L95bb
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr BeepDelay
	tya
	bne L95bb
L95c7
	rts
                    
BeepDelay
	dec BeepDelayCounter
	bne BeepDelay
	dex
	bne BeepDelay
	rts
                    
BeepDelayCounter               
	.byte $00 