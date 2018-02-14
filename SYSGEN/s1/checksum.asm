;checksum.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	*=LTK_DOSOverlay ;$4000 for sysgen disk 
START
	ldx #<str_Checksumming
	ldy #>str_Checksumming
	jsr LTK_Print
	
	lda #$0a
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01
L95f4
	inx
L95f5
	lda #$0a
	stx $96a8
	sty L96a7
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L9604
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	ldy #$00
	ldx #$02
L9610
	lda ($31),y
	pha
	clc
	adc $96a9
	sta $96a9
	lda #$00
	adc $96aa
	sta $96aa
	pla
	clc
	adc $96ad
	asl a
	sta $96ad
	lda $96ae
	rol a
	bcc L9639
	
	inc $96ab
	bne L9639
	
	inc $96ac
L9639
	sta $96ae
	iny
	bne L9610
	
	inc $32
	dex
	bne L9610
	
	ldx $96a8
	ldy L96a7
	inx
	bne L964e
	
	iny
L964e
	tya
	bne L9660
	
	cpx #$1a
	bne L9656
	
	inx
L9656
	cpx #$ee
	bne L966c
	
	ldx #$ef
	ldy #$01
	bne L966c
	
L9660
	cpy #$02
	bne L966c
	
	cpx #$9e
	bne L966c
	
	ldx #$2e
	ldy #$03
L966c
	cpy $9274
	beq L9674
L9671
	jmp L95f5
                    
L9674
	cpx $9275
	bne L9671
	ldy #$05
L967b
	lda $9276,y
	cmp $96a9,y
	bne L969c
	dey
	bpl L967b
	
	dec $920a
	lda #$0a
	ldx #$00
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01
	
L9696
	ldx #<str_ChecksumsGood
	ldy #>str_ChecksumsGood
	bne L96a3
	
L969c
	jsr Beep_If_Allowed
	ldx #<str_ChecksumsBad
	ldy #>str_ChecksumsBad
L96a3
	jsr LTK_Print
	rts
                    
L96a7
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
str_Checksumming ;$96af
	.text "{clr}{return}{return}please wait... checksumming the dos."
	.byte $00
	
str_ChecksumsGood ;$96d7
	.text "{return}{return}all dos checksums on lu #10 are good.{return}{return}now reset your computer to force an{return}update of the dos on your other lu(s).{return}{return}{return}thank you."
	.byte $00
	
str_ChecksumsBad ;$9758
	.text "{return}{return}lu 10 has been corrupted !!!{return}{return}you must do a sysgen to correct it !!"
	.byte $00
	
Beep_If_Allowed ;$979e
	lda LTK_BeepOnErrorFlag
	beq No_Beep ;$97dd
	ldy #$18
	lda #$00
L97a7
	sta SID_V1_FreqLo,y
	dey
	bpl L97a7
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L97b9
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_delay_loop ;$97de
	iny
	tya
	cmp #$10
	bne L97b9
	ldx #$50
	jsr beep_delay_loop ;$97de
	ldy #$10
	sta SID_V1_Control
L97d1
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_delay_loop ;$97de
	tya
	bne L97d1
No_Beep ;$97dd 
	rts
                    
beep_delay_loop ;$97de               
	dec beep_delay_value ;$97e7
	bne beep_delay_loop ;$97de
	dex
	bne beep_delay_loop ;$97de
	rts
                    
beep_delay_value ;$97e7
	.byte $00 