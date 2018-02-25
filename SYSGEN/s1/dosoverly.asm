;dosovrly.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"
	.include "../../include/sid_regs.asm"

;dosovrly.r.prg
	*=LTK_DOSOverlay ;$9530 - $4000 for sysgen
L95e0
	lda #$00
	sta L9a72
	lda LTK_AutobootFlag
	bne L95ed
	jmp L9785

L95ed
	jsr S99ce
	ldy $c8
	jsr S98f7
	lda #$00
	sta LTK_Command_Buffer,y
	cpy #$05
	bcc L9619
	bne L960d
	ldx #$03
L9602
	dey
	bmi L962c
	lda LTK_Command_Buffer,y
	cmp L9a73,y
	beq L9602
L960d
	lda LTK_Command_Buffer
	cmp #$47
	bne L9691
	lda LTK_Command_Buffer+$01
	cmp #$4f
L9619
	bne L9691
	ldy #$02
	lda #$00
	ldx #$02
	jsr S9b46
	bcs L9691
	cpx #$80
	bne L9691
	ldx #$00
L962c
	stx $9683
	ldx #<str_AreYouSure ;$9aeb
	ldy #>str_AreYouSure ;$9aeb
	jsr LTK_Print
	ldy #$0a
	jsr $803c
	ldy #$00
L963d
	jsr LTK_KernalCall
	sta L9a9a,y
	iny
	cpy #$03
	bcs L968e
	cmp #$0d
	bne L963d
	lda L9a9a
	cmp #$59
	bne L968e
	lda #$0a
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0 
L9660
	lda $9e43
	sta $98ef
	sta L98f2 + 2
	ldx #$0d
	ldy #$00
L966d
	lda L98ea,y
	sta $033c,y
	iny
	dex
	bne L966d
	lda #$ff
	sta $9de0
	sta $9de1
	sta $9de2
	ldy #$00
L9684
	tya
	sta $9de0,y
	iny
	bne L9684
	jmp $033c

L968e
	jmp L987b

L9691
	lda LTK_Command_Buffer
	cmp #$20
	beq L96b0
	cmp #$3f
	beq L96b0
	cmp #$30
	bcc L96b3
	cmp #$3a
	bcs L96b3
	lda #$3a
	cmp LTK_Command_Buffer+$01
	beq L96b3
	cmp $0202
	beq L96b3
L96b0
	jmp L9753

L96b3
	bit L9a72
	bmi L96bb
	jsr S988b
L96bb
	jsr S98b0
	beq L96b0
	lda #$00
	sta $98ab
	sta $98ac
	lda #$3f
	sta $98ad
	jsr S98c5
	bcc L96d8
	cmp #$3a
	bne L96ed
	beq L96e1
L96d8
	txa
	jsr LTK_SetLuActive
	bcc L96e1
	jmp L9775

L96e1
	jsr S98c5
	bcs L96ff
	cpx #$10
	bcc L96fc
	jmp L977b

L96ed
	lda #$0a
	sta LTK_Var_ActiveLU
	lda #$00
	sta LTK_Var_Active_User
	dec $98ac
	bne L96ff
L96fc
	stx LTK_Var_Active_User
L96ff
	jsr LTK_ClearHeaderBlock
	ldx #$00
	ldy $98ab
L9707
	cpy $c8
	bcs L9725
	lda LTK_Command_Buffer,y
	bit $98ac
	bpl L971c
	bit $98ad
	bvs L971c
	cmp #$20
	beq L9725
L971c
	sta LTK_FileHeaderBlock,x
	iny
	inx
	cpx #$10
	bne L9707
L9725
	sty LTK_CTPOffsetCounter
	jsr LTK_FindFile
	bcc L9759
	bit $98ac
	bpl L9753
	bit $98ad
	bmi L9753
	bvc L974e
	bit $9fac
	bmi L974b
	bit L9a72
	bmi L974b
	jsr S9a52
	bcs L974b
	jmp L95ed

L974b
	jsr S9899
L974e
	asl $98ad
	bne L96ff
L9753
	jsr S9899
	jmp LTK_SysRet_OldRegs

L9759
	jsr S9899
	lda $91f8
	cmp #$02
	beq L9785
	cmp #$03
	beq L9785
	cmp #$0b
	beq L9785
	cmp #$0c
	beq L9785
	ldx #<str_NotExe 
	ldy #>str_NotExe ;$9a9f
	bne L977f
L9775
	ldx #<str_InvalidLU 
	ldy #>str_InvalidLU ;$9aba
	bne L977f
L977b
	ldx #<str_InvalidUser 
	ldy #>str_InvalidUser ;$9ad3
L977f
	jsr LTK_ErrorHandler
	jmp L9753

L9785
	ldx #$00
	lda $91f8
	cmp #$0b
	beq L978f
	inx
L978f
	stx $b9
	lda $91f8
	cmp #$04
	bcs L97a9
	lda #$80
	sta $9d
	lda #$00
	sta LTK_ErrorTrapFlag
	lda LTK_HD_DevNum
	sta $ba
	jmp LTK_DosWedgeReturn

L97a9
	lda $91f8
	cmp #$0a
	bcs L97b6
	jsr LTK_LoadContigFile
	jmp L97db

L97b6
	lda LTK_Save_XReg
	sta $98ae
	lda LTK_Save_YReg
	sta $98af
	lda $2b
	sta LTK_Save_XReg
	lda $2c
	sta LTK_Save_YReg
	jsr LTK_LoadRandFile
	lda $98af
	sta LTK_Save_YReg
	lda $98ae
	sta LTK_Save_XReg
L97db
	lda $91f8
	cmp #$04
	bcc L9801
	stx $2d
	stx $2f
	stx $31
	sty $2e
	sty $30
	sty $32
	ldx $37
	stx $33
	ldx $38
	stx $34
	ldx #$33
	ldy #$a5
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall
L9801
	ldy #$00
	jsr LTK_ErrorHandler
	ldy $91fa
	ldx $91fb
	lda $91f8
	cmp #$0b
	bne L9853
	lda LTK_HD_DevNum
	sta $ba
	ldx #$00
L981a
	lda L9a8c,x
	beq L9825
	sta LTK_Command_Buffer,x
	inx
	bne L981a
L9825
	lda LTK_AutobootFlag
	bne L9848
	lda #$ff
	sta LTK_AutobootFlag
	lda #$a7
	pha
	lda #$e9
	pha
	sec
	ldx #$71
	ldy #$a8
	jsr LTK_KernalTrapSetup
	lda #$02
	sta LTK_ErrorTrapFlag
	lda #$00
	clc
	jmp LTK_SysRet_AbsJmp

L9848
	lda #$02
	sta LTK_ErrorTrapFlag
	lda #$0d
	clc
	jmp LTK_SysRet_AsIs

L9854 = * + 1	   
L9853
	lda #$ff
	sta LTK_AutobootFlag
	sec
	jsr LTK_KernalTrapSetup
	lda #$00
	ldx $c8
	sta $c8
	sta LTK_Command_Buffer
	lda #$80
	pha
	lda #$86
	pha
	lda #$02
	sta LTK_ErrorTrapFlag
	lda LTK_HD_DevNum
	sta $ba
	lda LTK_CTPOffsetCounter
	jmp LTK_KernalCall

L987b
	lda #$00
	sta $c8
	sta LTK_Command_Buffer
	jsr LTK_LoadRegs
	clc
	lda #$0d
	jmp LTK_SysRet_AsIs

S988b
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9e45
	rts

S9899
	lda $9e45
	pha
	and #$0f
	sta LTK_Var_ActiveLU
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	rts

	.byte $00,$00,$00,$00,$00 
S98b0
	ldy #$13
L98b2
	lda LTK_Command_Buffer,y
	cmp L9a78,y
	bne L98c4
	dey
	bpl L98b2
	lda #$22
	jsr LTK_ExeExtMiniSub
	lda #$00
L98c4
	rts

S98c5
	ldy $98ab
	lda #$00
	ldx #$02
	cpy $c8
	bcs L98e8
	jsr S9b46
	php
	bcs L98da
	pha
	pla
	bne L98e7
L98da
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L98e7
	iny
	sty $98ab
	plp
	rts

L98e7
	plp
L98e8
	sec
	rts

L98ea
	sei
	lda #$00
	sta $df02
	lda #$3c
L98f2
	sta $df03
	bne L98f2
S98f7
	lda $fffe
	cmp #$2c
	bne L9908
	lda $ffff
	cmp #$fa
	bne L9908
	jmp L9969

L9908
	lda $fa2c
	cmp #$48
	beq L9912
	jsr S9a30
L9912
	cpy #$01
	bne L994b
	lda LTK_Command_Buffer
	cmp #$3d
	bne L9969
	lda #$00
	sta $d3
	ldx #$ae
	ldy #$9f
	jsr LTK_Print
	lda #$00
	sta $ca
	ldx #$5f
	ldy #$f1
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L9936
	jsr LTK_KernalCall
	cmp #$0d
	beq L9943
	sta LTK_Command_Buffer,y
	iny
	bne L9936
L9943
	sty $c8
	sty LTK_Save_XReg
	sty LTK_Save_YReg
L994b
	tya
	pha
	cpy #$32
	bcc L9953
	ldy #$31
L9953
	lda #$00
	sta $9fae,y
L9958
	dey
	bmi L9963
	lda LTK_Command_Buffer,y
	sta $9fae,y
	bne L9958
L9963
	pla
	tay
	cpy #$02
	beq L996a
L9969
	rts

L996a
	lda #$5e
	cmp LTK_Command_Buffer
	bne L9969
	cmp LTK_Command_Buffer+$01
	bne L9969
	jsr $9f03
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L998b
	lda LTK_FileHeaderBlock
	ldx $91e1
	ldy $91e2
	sta BORDER
	stx BACKGROUND
	lda $0286
	sty $0286
	and #$f0
	ora $0286
	sta $0286
	ldx $91e8
	stx LTK_HD_DevNum
	ldx $91ea
	stx LTK_Var_ActiveLU
	ldx $91ec
	stx LTK_Var_Active_User
	jsr S988b
L99bd
	pla
	pla
	lda #$ff
	jsr LTK_SetLuActive
	lda #$00
	sta LTK_Command_Buffer
	sta $c8
	jmp LTK_SysRet_OldRegs

S99ce
	ldy $c8
	cpy #$04
	bne L99e0
	dey
L99d5
	dey
	bmi L99e1
	lda LTK_Command_Buffer,y
	cmp $9a2d,y
	beq L99d5
L99e0
	rts

L99e1
	lda LTK_Command_Buffer+$03
	cmp #$45
	bne L99f3
	lda $9fac
	cmp #$ff
	beq L99bd
	and #$7f
	bne L99fc
L99f3
	cmp #$44
	bne L99e0
	lda $9fac
	ora #$80
L99fc
	sta $9fac
	cmp #$ff
	beq L99bd
	and #$7f
	tay
	lda $9fad
	sec
	sbc #$05
	bcs L9a0f
	dey
L9a0f
	tax
	lda #$0a
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9a19
	lda $9fac
	and #$80
	sta $91fc
	lda #$0a
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9a2a
	jmp L99bd

	.byte $41 
S9a30 = * + 2	   
	jmp L9854

	pha
	lda #$0a
	ldx #$28
	ldy #$00
	sty LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0
L9a42
	ldx LTK_MiniSubExeArea+$03
L9a45
	lda LTK_MiniSubExeArea+$04,y
	sta $fa2c,y
	iny
	dex
	bne L9a45
	pla
	tay
	rts

S9a52
	dec L9a72
	ldx #$2f
	cpx LTK_ReadChanFPTPtr
	bne L9a61
	cpx $9be3
	beq L9a6f
L9a61
	lda #$0a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ; $9be0 
L9a6c
	stx LTK_ReadChanFPTPtr
L9a6f
	jmp $9be0

L9a72
	.byte $00
L9a73
	.byte $47,$4f,$43,$50,$4d 
L9a78						
	.byte $bb,$a2,$ae,$bc,$b0,$b6,$a2,$aa 
	.byte $bb,$b9,$b2,$a7,$b0,$a3,$a2,$b9
	.byte $aa,$a2,$aa,$bc 
L9a8c
	.text "poke157,0:run"
L9a99
	.byte $00
L9a9a
	.byte $00
L9a9b
	.byte $00
L9a9c
	.byte $00
L9a9d
	.byte $00
L9a9e
	.byte $00
str_NotExe ;$9a9f
	.text "not an executable file !!{return}"
	.byte $00
str_InvalidLU ;$9aba
	.text "invalid logical unit !!{return}"
	.byte $00
str_InvalidUser ;$9ad3
	.text "invalid user number !!{return}"
	.byte $00
str_AreYouSure ;$9aeb
	.text "{return}are you sure ? "
	.byte $00
L9afc
	lda LTK_BeepOnErrorFlag
	beq L9b3b
	ldy #$18
	lda #$00
L9b05
	sta SID_V1_FreqLo,y
	dey
	bpl L9b05
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L9b17
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9b3c
	iny
	tya
	cmp #$10
	bne L9b17
	ldx #$50
	jsr S9b3c
	ldy #$10
	sta SID_V1_Control
L9b2f
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9b3c
	tya
	bne L9b2f
L9b3b
	rts

S9b3c
	dec L9b45
	bne S9b3c
	dex
	bne S9b3c
	rts

L9b45
	.byte $00
S9b46
	sta L9b57 + 1
	stx L9b57 + 2
	lda #$00
	sta L9bc1
	sta $9bc2
	sta $9bc3
L9b57
	lda L9b57,y
	cmp #$30
	bcc L9baf
	cmp #$3a
	bcc L9b74
	ldx $9b80
	cpx #$0a
	beq L9baf
	cmp #$41
	bcc L9baf
	cmp #$47
	bcs L9baf
	sec
	sbc #$07
L9b74
	ldx L9bc1
	beq L9b98
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b81
	clc
	adc $9bc3
	pha
	txa
	adc $9bc2
	tax
	pla
	dey
	bne L9b81
	sta $9bc3
	stx $9bc2
	pla
	tay
	pla
L9b98
	inc L9bc1
	sec
	sbc #$30
	clc
	adc $9bc3
	sta $9bc3
	bcc L9bac
	inc $9bc2
	beq L9bb9
L9bac
	iny
	bne L9b57
L9baf
	cmp #$20
	beq L9bac
	clc
	ldx L9bc1
	bne L9bba
L9bb9
	sec
L9bba
	lda $9bc2
	ldx $9bc3
	rts

L9bc1
	.byte $00,$00,$00 