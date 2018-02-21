;activate.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"


 	*=$c000 ;$4000 for sysgen
START               
	lda LTK_Var_ActiveLU
	sta $c534
	lda LTK_Var_Active_User
	sta $c535
	jsr $9f03
	beq Lc01e
	ldx #<str_OnlyPort0 
	ldy #>str_OnlyPort0 ;$c773
	jsr LTK_Print
	jsr Sc84e
	jmp Lc417
                    
Lc01e
	jsr Sc84e
	ldx #$5e
	ldy #$c5
	jsr Sc427
	bcs START
	cpy #$01
	bne Lc031
	jmp Lc417
                    
Lc031
	sec
	sta $c68f
	sbc #$30
	cmp #$0a
	bcs START
	sta $c530
	lda #$00
	sta LTK_BLKAddr_MiniSub
   	ldx #$05
Lc045
	clc
	adc $c530
	dex
	bne Lc045
	sta $c531
	tay
	lda #$f7
	and LTK_LU_Param_Table+$02,y
	sta LTK_LU_Param_Table+$02,y
	lda #$0a
	ldx #$1a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
Lc065
	ldy $c531
	lda LTK_MiniSubExeArea+$04,y
	bpl Lc081
	cmp #$ff
	beq Lc074
	jmp Lc47f
                    
Lc074
	ldx #$57
	ldy #$c6
	jsr LTK_Print
	jsr Sc84e
	jmp Lc417
                    
Lc081
	lda LTK_MiniSubExeArea+$06,y
	and #$07
	sta $c532
	lda LTK_MiniSubExeArea+$07,y
	sta $c533
Lc08f
	ldx #$7e
	ldy #$c6
	jsr Sc427
	bcs Lc0b4
	cpy #$01
	bne Lc09f
	jmp START
                    
Lc09f
	cmp #$59
	bne Lc0b4
	ldx #$a8
	ldy #$c6
	jsr Sc427
	bcs Lc08f
	cpy #$01
	beq Lc08f
	cmp #$59
	beq Lc0b7
Lc0b4
	jmp Lc417
                    
Lc0b7
	lda $c530
	sta LTK_Var_ActiveLU
	ldx #$d2
	ldy #$c6
	jsr LTK_Print
	ldy $c531
	lda LTK_MiniSubExeArea+$08,y
	pha
	lda LTK_MiniSubExeArea+$06,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	ldx #$00
	pla
	jsr LTK_TPMultiply
	sta $c521
	ldy #$00
	sty Lc84a
	ldy #$08
	jsr Sc810
	cpy #$00
	clc
	beq Lc0ec
	sec
Lc0ec
	adc #$03
	sta $c522
	tay
	ldx #$02
	lda #$00
	sta Lc84a
	jsr Sc810
	sta $c523
	jsr LTK_ClearHeaderBlock
	ldx #$09
Lc104
	lda Lc539,x
	sta LTK_FileHeaderBlock,x
	dex
	bpl Lc104
	lda $c523
	sta $91f3
	lda $c522
	sta $91f5
	lda #$11
	sta $91f1
	lda $c533
	sta $91f7
	lda $c532
	sta $91f6
	lda #$01
	sta $91f8
	lda $c521
	sta $91f9
	ldx $c532
	ldy $c533
Lc13b
	lda $c521
	clc
	adc $9272
	sta $9272
	bcc Lc14f
	inc $9271
	bne Lc14f
	inc $9270
Lc14f
	dey
	bne Lc13b
	cpx #$00
	beq Lc15a
	dex
	jmp Lc13b
                    
Lc15a
	ldx #$00
	stx $c525
	ldy #$00
	sty $c524
	lda #$ff
	sta $9276
	sta $9277
	lda LTK_Var_ActiveLU
	sta $91fd
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
Lc179
	lda #$00
	
	sta $c526
	sta $c527
	sta $c528
	lda $c532
	sta $c529
	lda $c533
	sta $c52a
Lc190
	inc $c525
	ldx #$0c
	ldy #$c8
	jsr LTK_Print
	lda #$e0
	sta $c52c
	lda #$91
	sta $c52b
	lda $c523
	sta $c52d
	jsr LTK_ClearHeaderBlock
Lc1ad
	lda $c52c
	sta Sc449 + 1
	lda $c52b
	sta Sc449 + 2
	lda $c526
	jsr Sc449
	lda $c527
	jsr Sc449
	lda $c528
	jsr Sc449
	clc
Lc1cc
	lda $c52c
	adc $c522
Lc1d3 = * + 1       
Lc1d2
	sta $c52c
	bcc Lc1da
	inc $c52b
Lc1da
	lda $c528
	clc
	adc $c521
	sta $c528
	bcc Lc1ee
	inc $c527
	bne Lc1ee
	inc $c526
Lc1ee
	dec $c52a
	bne Lc1fb
	lda $c529
	beq Lc212
	dec $c529
Lc1fb
	dec $c52d
	bne Lc1ad
	lda LTK_Var_ActiveLU
	ldx $c525
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
Lc20f
	jmp Lc190
                    
Lc212
	lda $c52b
	sta Sc449 + 2
	lda $c52c
	sta Sc449 + 1
	lda #$ff
	jsr Sc449
	jsr Sc449
	jsr Sc449
	lda LTK_Var_ActiveLU
	ldx $c525
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc238
	lda #$12
	sta $c525
	lda #$00
	sta $c524
	lda LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc250   
	jsr LTK_AllocContigBlks
	lda LTK_Var_ActiveLU
	ldx #$11
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
Lc261
	lda $91fe
	pha
	jsr LTK_ClearHeaderBlock
	ldx #$0a
Lc26a
	lda Lc543,x
	sta LTK_FileHeaderBlock,x
	dex
	bpl Lc26a
	ldx #$ff
	stx $91f1
	dex
	stx $c52e
	ldx #$01
	stx $91f8
	ldx #$11
	stx $9201
	pla
	ldy #$ac
	cmp #$af
	beq Lc293
	cmp #$ac
	bne Lc293
	ldy #$af
Lc293
	sty $91fe
	dec $9237
	lda LTK_Var_ActiveLU
	sta $91fd
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc2a8
	jsr LTK_AllocContigBlks
	lda #$10
	sta $c52f
	jsr LTK_ClearHeaderBlock
	lda #$fd
	sta Lc2c1 + 1
	lda #$91
	sta Lc2c1 + 2
Lc2bd	
	ldx #$03
	lda #$ff
Lc2c1
	sta Lc2c1
	inc Lc2c1 + 1
	bne Lc2cc
	inc Lc2c1 + 2
Lc2cc
	dex
	bne Lc2c1
	clc
	lda Lc2c1 + 1
	adc #$1d
	sta Lc2c1 + 1
	bcc Lc2dd
	inc Lc2c1 + 2
Lc2dd
	dec $c52f
	bne Lc2bd
Lc2e2
	lda LTK_Var_ActiveLU
	ldx $c525
	ldy $c524
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc2f2
	inc $c525
	bne Lc2fa
	inc $c524
Lc2fa
	ldx #$0e
	ldy #$c8
	jsr LTK_Print
	dec $c52e
	bne Lc2e2
	lda LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc314	
	lda #$00
	sta LTK_Var_Active_User
	jsr Sc455
	lda LTK_Var_ActiveLU
	ldx #$11
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
Lc32a
	jsr Sc455
Lc32d
	ldx #$fc
	ldy #$c6
	jsr Sc427
	bcs Lc32d
	cpy #$01
	beq Lc32d
	cmp #$4e
	bne Lc343
	dec $c536
	bne Lc3a2
Lc343
	cmp #$59
	bne Lc32d
	ldx #$36
	ldy #$c7
	jsr LTK_Print
	jsr Sc84e
	jsr LTK_ClearHeaderBlock
	ldx #$0f
Lc356
	lda Lc54e,x
	sta LTK_FileHeaderBlock,x
	dex
	bpl Lc356
	lda #$01
	sta $91f8
	lda #$de
	sta $91f1
	jsr LTK_AllocContigBlks
	jsr Sc455
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; LTK_FileHeaderBlock 
	
Lc37f
	lda #$31
	ldx #$11
	jsr Sc45f
	lda #$31
	ldx #$42
	jsr Sc45f
	lda #$31
	ldx #$73
	jsr Sc45f
	lda #$31
	ldx #$a4
	jsr Sc45f
	lda #$19
	ldx #$d5
	jsr Sc45f
Lc3a2
	lda #$0a
	ldx #$1a
	ldy #$00
	sty LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
	
Lc3b2
	ldy $c531
	lda $c536
	beq Lc3c5
	lda #$f7
	and LTK_MiniSubExeArea+$06,y
	sta LTK_MiniSubExeArea+$06,y
	jmp Lc3cd
                    
Lc3c5
	lda #$08
	ora LTK_MiniSubExeArea+$06,y
	sta LTK_MiniSubExeArea+$06,y
Lc3cd
	lda #$e0
	sta $c3e1
	lda #$93
	sta $c3e2
	lda #$00
	tay
	sta $95df
	ldx #$02
Lc3df
	clc
	adc $c3e0,y
	iny
	bne Lc3df
	inc $c3e2
	dex
	bne Lc3df
	sta $95df
	sec
	lda #$1a
	tax
	sbc $95df
	sta $95df
	lda #$0a
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01, $b2, $c2, $d2 ;$93e0 b2 c2 d2 
	
Lc407
	ldy $c531
	lda LTK_MiniSubExeArea+$06,y
	sta LTK_LU_Param_Table+$02,y
	ldx #$55
	ldy #$c7
	jsr LTK_Print
Lc417
	lda $c534
	sta LTK_Var_ActiveLU
	lda $c535
	sta LTK_Var_Active_User
	clc
	jmp LTK_MemSwapOut
                    
Sc427               
	jsr LTK_Print
	ldy #$0a
	jsr $803c
	ldy #$00
Lc431
	jsr LTK_KernalCall
	sta Lc445,y
	iny
	cpy #$03
	bcs Lc444
	cmp #$0d
	bne Lc431
	lda Lc445
	clc
Lc444
	rts
                    
Lc445
	.byte $00,$00,$00,$00 
Sc449
	sta LTK_FileHeaderBlock
	inc Sc449 + 1
	bne Lc454
	inc Sc449 + 2
Lc454
	rts
                    
Sc455
	jsr LTK_FindFile
	pha
	lda #$24
	jsr LTK_ExeExtMiniSub
	rts
                    
Sc45f
	sta $c46f
	sta $c47a
	lda #$0a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte $00,$1e,$00 
Lc470
	lda LTK_Var_ActiveLU
	iny
	sec
	jsr LTK_HDDiscDriver
	.byte $00,$1e,$00,$b2,$c2,$d2 
Lc47e
	rts
                    
Lc47f
	ldx #$a1
	ldy #$c7
	jsr Sc427
	bcs Lc4a4
	cpy #$01
	bne Lc48f
	jmp START
                    
Lc48f
	cmp #$59
	bne Lc4a4
	ldx #$a8
	ldy #$c6
	jsr Sc427
	bcs Lc47f
	cpy #$01
	beq Lc47f
	cmp #$59
	beq Lc4a7
Lc4a4
	jmp Lc51e
                    
Lc4a7
	ldx #$d2
	ldy #$c6
	jsr LTK_Print
	ldy #$00
	lda #$e5
Lc4b2
	sta $8fe0,y
	iny
	bne Lc4b2
Lc4b8
	sta $90e0,y
	iny
	bne Lc4b8
	ldy $c531
	lda LTK_MiniSubExeArea+$07,y
	pha
	lda LTK_MiniSubExeArea+$08,y
	sta $c4dd
	lda LTK_MiniSubExeArea+$06,y
	pha
	and #$07
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	pla
	jsr LTK_TPMultiply
	ldy #$00
	jsr LTK_TPMultiply
	sta $c538
	stx $c537
	lda $c530
	ldx #$00
	ldy #$00
Lc4ee
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01, $b2, $c2, $d2 ;$8fe0
	
Lc4f8
	inx
	bne Lc50d
	iny
	pha
	txa
	pha
	tya
	pha
	ldx #$0e
	ldy #$c8
	jsr LTK_Print
	pla
	tay
	pla
	tax
	pla
Lc50d
	cpy $c537
	bne Lc4ee
	cpx $c538
	bne Lc4ee
	ldx #$ef
	ldy #$c7
	jsr LTK_Print
Lc51e
	jmp Lc417
                    
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
Lc539
	.text "discbitmap"
Lc543
	.text "systemindex"
Lc54e               
	.text "ltkernal"
Lc556               
	.text "dosimage"
Lc55e               
	.text "{clr}{return}{return}{rvs on}important{rvs off} - the purpose of this routine{return}            is to initialize a new or{return}            existing logical unit.{return}            activating an existing lu{return}            will {rvs on}remove{rvs off} all files from{return}            it !!!{return}{return}{return}enter lu number (0-9) or <cr> "
	.byte $00 
Lc657
	.text "{return}{return}invalid lu parameter(s) detected !!!"
	.byte $00 
Lc67e
	.text "{return}{return}are you sure {rvs on} "
	.byte $00 
Lc690
	.text " {rvs off} is the correct lu ? "
	.byte $00 
Lc6a8
	.text "{return}{return}{return}last chance - ok to proceed(y or n) ? "
	.byte $00 
Lc6d2
	.text "{clr}please wait . . . activation in process "
	.byte $00 
Lc6fc
	.text "{return}{return}{rvs on}activation complete{return}{return}{return}install dos image file (y or n) "
	.byte $00 
Lc736
	.text "{return}{return}{rvs on}please wait, copying dos !!"
	.byte $00 
Lc755
	.text "{return}{return}{rvs on}lu is now ready for use.{return}{return}"
	.byte $00 

str_OnlyPort0 ;$c773               
	.text "{clr}{return}{return}sorry, only port{rvs on} 0 {rvs off}can activate an lu !{return}"
	.byte $00 

Lc7a1
	.text "{return}{return}warning - this is a {rvs on} cp/m {rvs off} lu !!!{return}{return}{return}are you sure you want it cleared ? n{left}"
	.byte $00 

Lc7ef
	.text "{return}{return} your cp/m lu is cleared.{return}"
	.byte $00 

Lc80c
	.text "*"
	.byte $00 

Lc80e
	.text "."
	.byte $00 

Sc810
	sta Lc84c
	stx Lc84b
	sty Lc84d
	lda #$00
	ldx #$18
Lc81d
	clc
	rol Lc84c
	rol Lc84b
	rol Lc84a
	rol a
	bcs Lc82f
	cmp Lc84d
	bcc Lc83f
Lc82f
	sbc Lc84d
	inc Lc84c
	bne Lc83f
	inc Lc84b
	bne Lc83f
	inc Lc84a
Lc83f
	dex
	bne Lc81d
	tay
	ldx Lc84b
	lda Lc84c
	rts
                    
Lc84a
	.byte $00 
Lc84b
	.byte $00 
Lc84c
	.byte $00 
Lc84d
	.byte $00 

Sc84e
	lda LTK_BeepOnErrorFlag
	beq Lc88d
	ldy #$18
	lda #$00
Lc857
	sta SID_V1_FreqLo,y
	dey
	bpl Lc857
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lc869
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_timer
	iny
	tya
	cmp #$10
	bne Lc869
	ldx #$50
	jsr beep_timer
	ldy #$10
	sta SID_V1_Control
Lc881
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_timer
	tya
	bne Lc881
Lc88d
	rts
                    
beep_timer
	dec beep_delay
	bne beep_timer
	dex
	bne beep_timer
	rts
                    
beep_delay
	.byte $00 