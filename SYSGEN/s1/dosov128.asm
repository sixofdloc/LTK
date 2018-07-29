;dosov128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	.include "../../include/vic_regs.asm"
 
    *=LTK_DOSOverlay 
L95e0
	inc $ea
	lda #$00
	sta L9a0a
	lda LTK_AutobootFlag
	bne L95ef
	jmp L974e
	
L95ef
	jsr S9988
	jsr S98a6
	ldy $ea
	cpy #$05
	bne L9606
L95fb
	dey
	bmi L962c
	lda LTK_Command_Buffer,y
	cmp L9a0b,y
	beq L95fb
L9606
	lda $d505
	ora #$80
	sta $d505
	lda $d505
	bmi L9619
	lda $d7
	bpl L961d
	bmi L9620
L9619
	lda $d7
	bpl L9620
L961d
	jsr $ff5f
L9620
	lda $9d
	cmp #$c0
	bne L9658
	lda #$80
	sta $7f
	bne L9677
L962c
	ldx #$7e
	ldy #$9a
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L963a
	jsr LTK_KernalCall 
	sta L9a8f,y
	iny
	cpy #$03
	bcs L9655
	cmp #$0d
	bne L963a
	lda L9a8f
	cmp #$59
	bne L9655
	lda #$2a
	jsr LTK_ExeExtMiniSub 
L9655
	jmp L9837
	
L9658
	lda LTK_Command_Buffer
	cmp #$20
	beq L9677
	cmp #$3f
	beq L9677
	cmp #$30
	bcc L967a
	cmp #$3a
	bcs L967a
	lda #$3a
	cmp $0201
	beq L967a
	cmp $0202
	beq L967a
L9677
	jmp L971a
	
L967a
	bit L9a0a
	bmi L9682
	jsr S9847
L9682
	jsr S986c
	beq L9677
	lda #$00
	sta L9867
	sta L9868
	lda #$3f
	sta L9869
	jsr S9881
	bcc L969f
	cmp #$3a
	bne L96b4
	beq L96a8
L969f
	txa
	jsr LTK_SetLuActive 
	bcc L96a8
	jmp L973e
	
L96a8
	jsr S9881
	bcs L96c6
	cpx #$10
	bcc L96c3
	jmp L9744
	
L96b4
	lda #$0a
	sta LTK_Var_ActiveLU
	lda #$00
	sta LTK_Var_Active_User
	dec L9868
	bne L96c6
L96c3
	stx LTK_Var_Active_User
L96c6
	jsr LTK_ClearHeaderBlock 
	ldx #$00
	ldy L9867
L96ce
	cpy $ea
	bcs L96ec
	lda LTK_Command_Buffer,y
	bit L9868
	bpl L96e3
	bit L9869
	bvs L96e3
	cmp #$20
	beq L96ec
L96e3
	sta LTK_FileHeaderBlock ,x
	iny
	inx
	cpx #$10
	bne L96ce
L96ec
	sty LTK_CTPOffsetCounter
	jsr LTK_FindFile 
	bcc L9722
	bit L9868
	bpl L971a
	bit L9869
	bmi L971a
	bvc L9715
	bit $9fac
	bmi L9712
	bit L9a0a
	bmi L9712
	jsr S99ea
	bcs L9712
	jmp L95ef
	
L9712
	jsr S9855
L9715
	asl L9869
	bne L96c6
L971a
	jsr S9855
	dec $ea
	jmp LTK_SysRet_OldRegs 
	
L9722
	jsr S9855
	lda $91f8
	cmp #$02
	beq L974e
	cmp #$03
	beq L974e
	cmp #$0b
	beq L974e
	cmp #$0c
	beq L974e
	ldx #$32
	ldy #$9a
	bne L9748
L973e
	ldx #$4d
	ldy #$9a
	bne L9748
L9744
	ldx #$66
	ldy #$9a
L9748
	jsr LTK_ErrorHandler 
	jmp L971a
	
L974e
	ldx #$00
	lda $91f8
	cmp #$0b
	beq L9758
	inx
L9758
	stx $b9
	cmp #$04
	bcs L976f
	lda #$00
	sta $7f
	lda #$00
	sta LTK_ErrorTrapFlag
	lda LTK_HD_DevNum
	sta $ba
	jmp LTK_DosWedgeReturn 
	
L976f
	lda #$00
	sta $c6
	lda $91f8
	cmp #$0a
	bcs L9780
	jsr LTK_LoadContigFile 
	jmp L97a5
	
L9780
	lda LTK_Save_XReg
	sta L986a
	lda LTK_Save_YReg
	sta L986b
	lda $2d
	sta LTK_Save_XReg
	lda $2e
	sta LTK_Save_YReg
	jsr LTK_LoadRandFile 
	lda L986b
	sta LTK_Save_YReg
	lda L986a
	sta LTK_Save_XReg
L97a5
	lda $91f8
	cmp #$04
	bcc L97bd
	stx $1210
	sty $1211
	ldx #$4f
	ldy #$4f
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
L97bd
	ldy #$00
	jsr LTK_ErrorHandler 
	ldy $91fa
	ldx $91fb
	lda $91f8
	cmp #$0b
	bne L980f
	lda LTK_HD_DevNum
	sta $ba
	ldx #$00
L97d6
	lda L9a24,x
	beq L97e1
	sta LTK_Command_Buffer,x
	inx
	bne L97d6
L97e1
	lda LTK_AutobootFlag
	bne L9804
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
	
L9804
	lda #$02
	sta LTK_ErrorTrapFlag
	lda #$0d
	clc
	jmp LTK_SysRet_AsIs  
	
L980f
	lda #$ff
	sta LTK_AutobootFlag
	sec
	jsr LTK_KernalTrapSetup
	lda #$00
	ldx $ea
	sta $ea
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
	
L9837
	lda #$00
	sta $ea
	sta LTK_Command_Buffer
	jsr LTK_LoadRegs 
	clc
	lda #$0d
	jmp LTK_SysRet_AsIs  
	
S9847
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9e45
	rts
	
S9855
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
	
L9867
	.byte $00
L9868
	.byte $00
L9869
	.byte $00
L986a
	.byte $00
L986b
	.byte $00
S986c
	ldy #$13
L986e
	lda LTK_Command_Buffer,y
	cmp L9a10,y
	bne L9880
	dey
	bpl L986e
	lda #$22
	jsr LTK_ExeExtMiniSub 
	lda #$00
L9880
	rts
	
S9881
	ldy L9867
	lda #$00
	ldx #$02
	cpy $ea
	bcs L98a4
	jsr S9ade
	php
	bcs L9896
	pha
	pla
	bne L98a3
L9896
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L98a3
	iny
	sty L9867
	plp
	rts
	
L98a3
	plp
L98a4
	sec
	rts
	
S98a6
	lda $fffe
	cmp #$00
	bne L98b4
	lda $ffff
	cmp #$ec
	beq L990d
L98b4
	ldy $ea
	cpy #$01
	bne L98ef
	lda LTK_Command_Buffer
	cmp #$3d
	bne L990d
	lda #$00
	sta $ec
	ldx #$ae
	ldy #$9f
	jsr LTK_Print 
	lda #$00
	sta $e9
	ldx #$0e
	ldy #$ef
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L98da
	jsr LTK_KernalCall 
	cmp #$0d
	beq L98e7
	sta LTK_Command_Buffer,y
	iny
	bne L98da
L98e7
	sty $ea
	sty LTK_Save_XReg
	sty LTK_Save_YReg
L98ef
	tya
	pha
	cpy #$32
	bcc L98f7
	ldy #$31
L98f7
	lda #$00
	sta $9fae,y
L98fc
	dey
	bmi L9907
	lda LTK_Command_Buffer,y
	sta $9fae,y
	bne L98fc
L9907
	pla
	tay
	cpy #$02
	beq L990e
L990d
	rts
	
L990e
	lda #$5e
	cmp LTK_Command_Buffer
	bne L990d
	cmp $0201
	bne L990d
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
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L992f
	lda $91e3
	ldx $91e4
	ldy $91e5
	bit $d7
	bpl L9952
	lda $91e6
	ldx #$1a
	stx $d600
L9944
	bit $d600
	bpl L9944
	sta $d601
	ldy $91e7
	jmp L9958
	
L9952
	sta BORDER
	stx BACKGROUND
L9958
	lda $f1
	sty $f1
	and #$f0
	ora $f1
	sta $f1
	ldx $91e9
	stx LTK_HD_DevNum
	ldx $91eb
	stx LTK_Var_ActiveLU
	ldx $91ed
	stx LTK_Var_Active_User
	jsr S9847
L9977
	pla
	pla
	lda #$ff
	jsr LTK_SetLuActive 
	lda #$00
	sta LTK_Command_Buffer
	sta $ea
	jmp LTK_SysRet_OldRegs 
	
S9988
	ldy $ea
	cpy #$04
	bne L999a
	dey
L998f
	dey
	bmi L999b
	lda LTK_Command_Buffer,y
	cmp L99e7,y
	beq L998f
L999a
	rts
	
L999b
	lda $0203
	cmp #$45
	bne L99ad
	lda $9fac
	cmp #$ff
	beq L9977
	and #$7f
	bne L99b6
L99ad
	cmp #$44
	bne L999a
	lda $9fac
	ora #$80
L99b6
	sta $9fac
	cmp #$ff
	beq L9977
	and #$7f
	tay
	lda $9fad
	sec
	sbc #$05
	bcs L99c9
	dey
L99c9
	tax
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L99d3
	lda $9fac
	and #$80
	sta $91fc
	lda #$0a
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L99e4
	jmp L9977
	
L99e7
	.byte $41,$4c,$54 
S99ea
	dec L9a0a
	ldx #$2f
	cpx LTK_ReadChanFPTPtr
	bne L99f9
	cpx $9be3
	beq L9a07
L99f9
	lda #$0a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L9a04
	stx LTK_ReadChanFPTPtr
L9a07
	jmp LTK_FileReadBuffer 
	
L9a0a
	.byte $00
L9a0b
	.text "gocpm"
L9a10
	.byte $bb,$a2,$ae,$bc,$b0,$b6,$a2,$aa,$bb,$b9,$b2,$a7,$b0,$a3,$a2,$b9 
	.byte $aa,$a2,$aa,$bc 
L9a24
	.text "poke157,0:run"
	.byte $00
L9a32
	.text "not an executable file !!{return}"
	.byte $00
L9a4d
	.text "invalid logical unit !!{return}"
	.byte $00
L9a66
	.text "invalid user number !!{return}"
	.byte $00
L9a7e
	.text "{return}are you sure ? "
	.byte $00
L9a8f
	.byte $00
L9a90
	.byte $00
L9a91
	.byte $00
L9a92
	.byte $00
L9a93
	.byte $00
L9a94
	lda LTK_BeepOnErrorFlag
	beq L9ad3
	ldy #$18
	lda #$00
L9a9d
	sta SID_V1_FreqLo,y
	dey
	bpl L9a9d
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L9aaf
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9ad4
	iny
	tya
	cmp #$10
	bne L9aaf
	ldx #$50
	jsr S9ad4
	ldy #$10
	sta SID_V1_Control
L9ac7
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9ad4
	tya
	bne L9ac7
L9ad3
	rts
	
S9ad4
	dec L9add
	bne S9ad4
	dex
	bne S9ad4
	rts
	
L9add
	.byte $00
S9ade
	sta L9aef + 1
	stx L9aef + 2
	lda #$00
	sta L9b59
	sta L9b5a
	sta L9b5b
L9aef
	lda L9aef,y
	cmp #$30
	bcc L9b47
	cmp #$3a
	bcc L9b0c
	ldx L9b17 + 1
	cpx #$0a
	beq L9b47
	cmp #$41
	bcc L9b47
	cmp #$47
	bcs L9b47
	sec
	sbc #$07
L9b0c
	ldx L9b59
	beq L9b30
	pha
	tya
	pha
	lda #$00
	tax
L9b17
	ldy #$0a
L9b19
	clc
	adc L9b5b
	pha
	txa
	adc L9b5a
	tax
	pla
	dey
	bne L9b19
	sta L9b5b
	stx L9b5a
	pla
	tay
	pla
L9b30
	inc L9b59
	sec
	sbc #$30
	clc
	adc L9b5b
	sta L9b5b
	bcc L9b44
	inc L9b5a
	beq L9b51
L9b44
	iny
	bne L9aef
L9b47
	cmp #$20
	beq L9b44
	clc
	ldx L9b59
	bne L9b52
L9b51
	sec
L9b52
	lda L9b5a
	ldx L9b5b
	rts
	
L9b59
	.byte $00
L9b5a
	.byte $00
L9b5b
	.byte $00
