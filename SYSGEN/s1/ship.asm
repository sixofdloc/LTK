;ship.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	.include "../../include/kernal.asm"

	*=LTK_DOSOverlay ; $95e0, $4000 for sysgen
 
START
	jsr LTK_GetPortNumber
	beq Is_Port_Zero

	;Print "Only port 0 is allowed" message
	ldx #<str_OnlyPort0
	ldy #>str_OnlyPort0
	jsr LTK_Print
	jsr BeepIfAllowed
	rts
                    
Is_Port_Zero               
	lda #$0a
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01

	jsr Ship_Drive
	;print "Ship Complete" Message
	ldx #<str_ShipComplete
	ldy #>str_ShipComplete
	jsr LTK_Print
	
	;Lock up the machine and prevent NMIs etc...
	lda #<Lockup
	sta NMI_LO
	lda #>Lockup
	sta NMI_HI
Lockup ;$9611         
	jmp Lockup
                    
Ship_Drive
	lda SD_Counter
	sta SD_AdcValue+$01
	asl a
	asl a
	clc
SD_AdcValue
	adc #$00
	tay
	lda LTK_LU_Param_Table,y
	bmi L9664
	and #$fc
	sta LTK_LU_Param_Table,y
	and #$1c
	beq L963f
	asl a
	sec
	sbc #$08
	tax
	lda $92e5,x
	pha
	lda $92e4,x
	tax
	pla
	jmp L9645
                    
L963f
	lda LTK_FileHeaderBlock+LTK_FHB_RecsInFile+$01 ;$91f7
	ldx LTK_FileHeaderBlock+LTK_FHB_RecsInFile ;$91f6
L9645
	sec
	sbc #$11
	sta LTK_LU_Param_Table+$01,y
	txa
	sbc #$00
	and #$03
	ora LTK_LU_Param_Table,y
	sta LTK_LU_Param_Table,y

	lda SD_Counter
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L9664
	inc SD_Counter
	lda SD_Counter
	cmp #$0a
	bne Ship_Drive
	rts
                    
                                                                 
SD_Counter
	.byte $00  ;SD_Counter
	
str_ShipComplete ; $9670               
	.text "{return}ship preparation complete.{return}power down system{return}"
	.byte $00
	
str_OnlyPort0 ;$969f               
	.text "{return}{return}sorry, only port {rvs on}0{rvs off} can ship the drive !{return}"
	.byte $00
	
BeepIfAllowed               
	lda LTK_BeepOnErrorFlag
	beq BeepNoneOrDone
	ldy #$18
	lda #$00
L96d5
	sta SID_V1_FreqLo,y
	dey
	bpl L96d5
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L96e7
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beepdelay
	iny
	tya
	cmp #$10
	bne L96e7
	ldx #$50
	jsr beepdelay
	ldy #$10
	sta SID_V1_Control
L96ff
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beepdelay
	tya
	bne L96ff
BeepNoneOrDone
	rts
                    
beepdelay
	dec beeptimer
	bne beepdelay
	dex
	bne beepdelay
	rts
                    
beeptimer	
	.byte $00 