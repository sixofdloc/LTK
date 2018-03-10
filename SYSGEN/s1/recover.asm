;recover.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"
	.include "../../include/sid_regs.asm"

	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen
 
L95e0
	ldx #$00
	stx LTK_BLKAddr_MiniSub
	dex
	stx LTK_ReadChanFPTPtr
	lda LTK_Var_ActiveLU
	sta $9de4
	lda LTK_Var_Active_User
	sta $9de5
L95f5
	jsr LTK_GetPortNumber
	beq L9607
	ldx #$7a
	ldy #$99
	jsr LTK_Print 
	jsr S9d22
	jmp L97af
	
L9607
	ldx #$a7
	ldy #$99
	jsr S9958
	ldx #$5c
	ldy #$9c
	jsr S9958
	bcs L95f5
	cpy #$01
	bne L961e
	jmp L97af
	
L961e
	sec
	sta $9c8e
	sbc #$30
	cmp #$0a
	bcs L95f5
	jsr LTK_SetLuActive 
	bcs L95f5
	lda LTK_Var_ActiveLU
	sta L991e
	asl a
	asl a
	clc
	adc LTK_Var_ActiveLU
	sta L991f
	tay
	lda #$f7
	and $80aa,y
	sta $80aa,y
	lda #$0a
	ldx #$1a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L9652
	ldy L991f
	lda $93e6,y
	and #$07
	sta L9920
	lda $93e7,y
	sta L9921
L9663
	ldx #$7d
	ldy #$9c
	jsr S9958
	bcs L9688
	cpy #$01
	bne L9673
	jmp L95f5
	
L9673
	cmp #$59
	bne L9688
	ldx #$a7
	ldy #$9c
	jsr S9958
	bcs L9663
	cpy #$01
	beq L9663
	cmp #$59
	beq L968b
L9688
	jmp L97af
	
L968b
	ldx #$cf
	ldy #$9c
	jsr LTK_Print 
	ldy L991f
	lda $93e8,y
	pha
	lda $93e6,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	ldx #$00
	pla
	jsr LTK_TPMultiply 
	tay
	lda L9921
	ldx L9920
	jsr LTK_TPMultiply 
	sta L991b
	stx L991a
	jsr S97f0
	ldx #$ea
	ldy #$9c
	jsr LTK_Print 
	lda L9919
	sta L9917
	lda L9918
	sta L9916
L96cd
	clc
	jsr S97e0
	lda $91fe
	cmp #$00
	beq L96db
	jmp L97cc
	
L96db
	lda LTK_FileHeaderBlock 
	beq L974b
	lda $9201
	ldx $9200
	cpx L9918
	bcc L974b
	bne L96f2
	cmp L9919
	bcc L974b
L96f2
	cpx L991a
	bcc L96fe
	bne L974b
	cmp L991b
	bcs L974b
L96fe
	lda $91f1
	ldx $91f0
	cpx L991a
	bcc L9710
	bne L974b
	cmp L991b
	bcs L974b
L9710
	lda $91f8
	beq L974b
	cmp #$04
	beq L9735
	cmp #$05
	beq L9735
	cmp #$0b
	beq L9735
	cmp #$0c
	beq L9735
	cmp #$0d
	beq L9735
	cmp #$0e
	beq L9735
	cmp #$0f
	beq L9735
	cmp #$10
	bne L974b
L9735
	lda $91fd
	tax
	and #$0f
	cmp LTK_Var_ActiveLU
	bne L974b
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	jsr S98f7
L974b
	inc L9917
	bne L9753
	inc L9916
L9753
	lda L9916
	cmp L991a
	bne L97bc
	lda L9917
	cmp L991b
	bne L97bc
	ldx #$03
	ldy #$9d
	jsr LTK_Print 
	jsr LTK_ClearHeaderBlock 
	ldy #$07
L976f
	lda L994e,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl L976f
	iny
	sty LTK_Var_Active_User
	lda #$0a
	sta LTK_Var_ActiveLU
	jsr LTK_FindFile 
	bcs L97ac
	lda #$08
	ldx #$00
	ldy #$c0
	sec
	jsr LTK_MemSwapOut 
	lda #$0a
	ldx $9201
	ldy $9200
	inx
	bne L979c
	iny
L979c
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$c0,$08 
L97a3
	lda L991e
	sta LTK_Var_ActiveLU
	jmp $c003
	
L97ac
	jsr LTK_FatalError 
L97af
	lda $9de4
	sta LTK_Var_ActiveLU
	lda $9de5
	sta LTK_Var_Active_User
	rts
	
L97bc
	dec L9922
	bne L97c9
	inc BORDER
	lda #$20
	sta L9922
L97c9
	jmp L96cd
	
L97cc
	cmp #$ac
	beq L97d4
	cmp #$af
	bne L97dd
L97d4
	lda #$00
L97d6
	sta $91fe
	sec
	jsr S97e0
L97dd
	jmp L974b
	
S97e0
	lda LTK_Var_ActiveLU
	ldx L9917
	ldy L9916
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L97ef
	rts
	
S97f0
	ldx #$12
	stx L9917
	dex
	ldy #$00
	sty L9916
	sty LTK_Var_Active_User
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9808
	lda $91fe
	pha
	jsr LTK_ClearHeaderBlock 
	ldx #$0a
L9811
	lda L9933,x
	sta LTK_FileHeaderBlock ,x
	dex
	bpl L9811
	ldx #$ff
	stx $91f1
	dex
	stx L991c
	ldx #$01
	stx $91f8
	ldx #$11
	stx $9201
	dec $9237
	pla
	sta $91fe
	sta $96d5
	lda LTK_Var_ActiveLU
	sta $91fd
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9846
	lda #$10
	sta L991d
	jsr LTK_ClearHeaderBlock 
L984e
	ldx #$03
	lda #$ff
L9852
	sta $91fd
	inc L9852 + 1
	bne L985d
	inc L9852 + 2
L985d
	dex
	bne L9852
	clc
L9862 = * + 1       
	lda L9852 + 1
	adc #$1d
	sta L9852 + 1
	bcc L986e
	inc L9852 + 2
L986e
	dec L991d
	bne L984e
L9873
	lda LTK_Var_ActiveLU
	ldx L9917
	ldy L9916
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9883
	inc L9917
	bne L988b
	inc L9916
L988b
	ldx #$56
	ldy #$99
	jsr LTK_Print 
	dec L991c
	bne L9873
	lda LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98a5
	ldy #$0f
L98a7
	lda L9922 + 1,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl L98a7
	jsr S98f7
	lda LTK_Var_ActiveLU
	ldx #$11
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98c1
	jsr S98f7
	lda LTK_Var_ActiveLU
	ldx #$10
	ldy #$01
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98d2
	lda #$10
	sta L9919
	lda #$01
	sta L9918
	ldy #$0f
L98de
	lda LTK_FileHeaderBlock ,y
	cmp L993e,y
	bne L98f6
	dey
	bpl L98de
	jsr S98f7
	lda #$ee
	sta L9919
	lda #$01
	sta L9918
L98f6
	rts
	
S98f7
	jsr LTK_FindFile 
	bcc L9915
	pha
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda #$00
	sta $91f0
	ldx #$17
	ldy #$9d
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
L9915
	rts
	
L9916
	.byte $00
L9917
	.byte $00
L9918
	.byte $00
L9919
	.byte $00
L991a
	.byte $00
L991b
	.byte $00
L991c
	.byte $00
L991d
	.byte $00
L991e
	.byte $00
L991f
	.byte $00
L9920
	.byte $00
L9921
	.byte $00
L9922
	.text " discbitmap"
L992d
	.byte $00
L992e
	.byte $00
L992f
	.byte $00
L9930
	.byte $00
L9931
	.byte $00
L9932
	.byte $00
L9933
	.text "systemindex"
L993e
	.text "ltkernaldosimage"
L994e
	.text "validate"
L9956
	.byte $2e 
L9957
	.byte $00
S9958
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L9962
	jsr LTK_KernalCall 
	sta L9976,y
	iny
	cpy #$03
	bcs L9975
	cmp #$0d
	bne L9962
	lda L9976
	clc
L9975
	rts
	
L9976
	.byte $00
L9977
	.byte $00
L9978
	.byte $00
L9979
	.byte $00
L997a
	.text "{clr}{return}{return}sorry, only port{rvs on} 0 {rvs off}can recover an lu !{return}"
	.byte $00
L99a7
	.text "{clr}{rvs on}important{rvs off}-the purpose of this routine{return}          "
	.text "is to attempt to recover{return}          all files on a given lu{return}          "
	.text "where {$22}systemindex{$22} damage{return}          "
	.text "is suspected. this is done{return}          "
	.text "in the following way:{return}{return}          "
	.text "1) the {$22}systemindex{$22} file{return}             "
	.text "is completely rebuilt{return}             and cleared.{return}          "
	.text "2) the entire lu is scanned{return}             "
	.text "for valid file headers.{return}          "
	.text "3) when found, its filename{return}             "
	.text "is inserted back in the{return}             "
	.text "new {$22}systemindex{$22}.{return}          "
	.text "4) after the lu scan has{return}             "
	.text "completed, a validate{return}             "
	.text "is envoked to ensure the{return}             integrity of the bitmap.{return}{return}"
	.text "please {rvs on}do not{rvs off} interrupt it !!!{return}"
	.text "{return}{rvs on}press return{rvs off} "
	.byte $00
L9c5c
	.text "{clr}{return}enter lu number (0-9) or <cr> "
	.byte $00
L9c7d
	.text "{return}{return}are you sure {rvs on} "
	.byte $00
L9c8f
	.text " {rvs off} is the correct lu ? "
	.byte $00
L9ca7
	.text "{return}{return}{return}last change - ok to proceed (y/n) ? "
	.byte $00
L9ccf
	.text "{clr}{return}{rvs on}building {$22}systemindex{$22}{return}"
	.byte $00
L9cea
	.text "{return}{return}{rvs on}scanning for headers{return}"
	.byte $00
L9d03
	.text "{return}{clr}{return}{rvs on}validating lu{return}{return}"
	.byte $00
L9d17
	.text "{return}found  {$22}{del}"
	.byte $00
S9d22
	lda LTK_BeepOnErrorFlag
	beq L9d61
	ldy #$18
	lda #$00
L9d2b
	sta SID_V1_FreqLo,y
	dey
	bpl L9d2b
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L9d3d
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9d62
	iny
	tya
	cmp #$10
	bne L9d3d
	ldx #$50
	jsr S9d62
	ldy #$10
	sta SID_V1_Control
L9d55
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9d62
	tya
	bne L9d55
L9d61
	rts
	
S9d62
	dec L9d6b
	bne S9d62
	dex
	bne S9d62
	rts
	
L9d6b
	.byte $00
