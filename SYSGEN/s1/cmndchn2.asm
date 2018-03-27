;cmndchn2.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen

L95e0
	pla
	sta L9be1
	pla
	sta S9709
	pla
	sta L9bdf
	lda LTK_Var_Active_User
	sta L96b8
	sta L9bdb
	sta L9bdc
	pla
	cmp #$43
	beq L9600
L95fd
	jmp L96bf
	
L9600
	lda LTK_Var_ActiveLU
	sta L96b5
	sta L96b7
	ldy #$00
L960b
	jsr S9709
	sta L9c84,y
	iny
	cpy L9bdf
	bcc L960b
	ldy L9be1
L961a
	iny
	cpy L9bdf
	bcs L95fd
	lda L9c84,y
	cmp #$30
	bcc L961a
	cmp #$3b
	bcs L961a
	sty L9be1
	jsr S9abf
	bcc L9639
	cmp #$3a
	beq L9645
	bne L95fd
L9639
	txa
	jsr LTK_SetLuActive 
	bcs L95fd
	lda LTK_Var_ActiveLU
	sta L96b7
L9645
	jsr S9abf
	bcs L9651
	cpx #$10
	bcs L95fd
	stx L9bdc
L9651
	jmp L9732
	
L9654
	ldx #$00
	lda $91f0
	bne L9662
	lda $91f1
	cmp #$ee
	bcc L966e
L9662
	lda #$01
	ldx #$e0
	ldy #$9b
	sec
	jsr LTK_MemSwapOut 
	ldx #$ff
L966e
	lda #$00
	sta LTK_BLKAddr_MiniSub
	stx L96b6
	jsr LTK_AppendBlocks 
	bcc L968e
	sta L9686 + 1
	pla
	pla
	pla
	pla
	cpx #$80
	bne L968b
L9686
	ldx #$00
	jmp L96b9
	
L968b
	jmp L96cb
	
L968e
	stx L96b1
	sty L96b2
	jsr S9a9d
	lda L96b5
	ldx L96b4
	ldy L96b3
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L96a7
	bit L96b6
	bpl L96b0
	clc
	jsr LTK_MemSwapOut 
L96b0
	rts
	
L96b1
	.byte $00
L96b2
	.byte $00
L96b3
	.byte $00
L96b4
	.byte $00
L96b5
	.byte $00
L96b6
	.byte $00
L96b7
	.byte $00
L96b8
	.byte $00
L96b9
	ldy #$04
	.byte $2c 
L96bc
	ldy #$05
	.byte $2c 
L96bf
	ldy #$1f
	.byte $2c 
L96c2
	ldy #$1e
	.byte $2c 
L96c5
	ldy #$3e
	.byte $2c 
L96c8
	ldy #$3f
	.byte $2c 
L96cb
	ldy #$48
	.byte $2c 
L96ce
	ldy #$00
	jsr LTK_ErrorHandler 
	lda L96b5
	jsr S96ff
	lda L96b7
	jsr S96ff
	lda $9de3
	sta LTK_Var_ActiveLU
	lda L96b8
	sta LTK_Var_Active_User
	pla
	sta $32
	pla
	sta $31
	lda LTK_Var_CurRoutine
	cmp #$00
	beq L96f9
	rts
	
L96f9
	lda #$00
	clc
	jmp LTK_SysRet_AsIs  
	
S96ff
	sta LTK_Var_ActiveLU
	lda #$02
	clc
	jsr $9f00
	rts
	
S9709
	nop
	bcc L972e
	lda LTK_Var_CPUMode
	beq L972a
	stx L9727 + 1
	tya
	pha
	sec
	ldx #$74
	ldy #$ff
	jsr LTK_KernalTrapSetup
	pla
	tay
	lda #$bb
	ldx $c7
	jsr LTK_KernalCall 
L9727
	ldx #$00
	rts
	
L972a
	jsr $fc6e
	rts
	
L972e
	lda LTK_CMDChannelBuffer,y
	rts
	
L9732
	jsr LTK_ClearHeaderBlock 
	ldy L9be1
	tax
L9739
	lda L9c84,y
	cmp #$3d
	beq L9751
	cpx #$10
	beq L9748
	sta L9bf5,x
	inx
L9748
	iny
	cpy L9bdf
	bcc L9739
	jmp L96c2
	
L9751
	txa
	bne L9755
	dex
L9755
	stx L9bdd
	iny
	cpy L9bdf
	bcc L9761
	jmp L96c5
	
L9761
	sty L9be1
	jsr S9ae5
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
L976c
	lda L9bf5,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl L976c
	lda L96b7
	sta LTK_Var_ActiveLU
	lda L9bdc
	sta LTK_Var_Active_User
	lda #$02
	sec
	jsr $9f00
	bcc L978c
	jmp L96bc
	
L978c
	jsr LTK_FindFile 
	bcs L9794
	jmp L96c8
	
L9794
	sta L9be0
	stx L9bed
	sty L9bec
	jsr S9a9d
	ldy #$10
L97a2
	lda LTK_MiscWorkspace,y
	sta LTK_FileHeaderBlock ,y
	iny
	lda L9bee
	beq L97b4
	cpy #$00
	beq L97b8
	bne L97a2
L97b4
	cpy #$20
	bne L97a2
L97b8
	lda L9bee
	bne L97d1
	bit L9be7
	bpl L97d1
	ldx $91f0
	lda $91f1
	jsr S9b99
	sta $91f1
	stx $91f0
L97d1
	lda L9bee
	beq L97dd
	jsr LTK_AllocContigBlks 
	bcc L97ed
	bcs L97e2
L97dd
	jsr LTK_AllocateRandomBlks 
	bcc L97ed
L97e2
	cpx #$80
	bne L97ea
	tax
	jmp L96b9
	
L97ea
	jmp L96cb
	
L97ed
	ldx #$00
	stx LTK_BLKAddr_MiniSub
	stx L9be2
	stx L9be3
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta LTK_WriteChanFPTPtr
	jsr S9a9d
	lda $9200
	sta L9bf3
	lda $9201
	sta L9bf4
	jmp L982c
	
L9812
	jsr S99e6
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L981c
	jsr S9a0d
	sec
	stx L96b2
	sty L96b1
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L982c
	inc L9be3
	bne L9834
	inc L9be2
L9834
	lda $91f1
	ldx $91f0
	ldy L9bee
	bne L9846
	sec
	sbc L9be8
	bcs L9846
	dex
L9846
	cpx L9be2
	bne L9812
	cmp L9be3
	bne L9812
	lda $91f8
	cmp #$04
	bne L985c
	lda #$1f
	jsr LTK_ExeExtMiniSub 
L985c
	jsr S99c6
	lda L9bdf
	cmp L9be1
	bcc L986e
	sbc L9be1
	cmp #$02
	bcs L9871
L986e
	jmp L96ce
	
L9871
	lda L96b5
	jsr S96ff
	ldy L9be1
L987a
	lda L9c84,y
	cmp #$2c
	beq L9889
	iny
	cpy L9bdf
	bcc L987a
	bcs L986e
L9889
	iny
	sty L9be1
	jsr S9ae5
	ldx $91f0
	lda $91f1
	bit L9be7
	bpl L989e
	jsr S9b99
L989e
	cpx #$00
	bne L98a6
	cmp #$01
	beq L986e
L98a6
	sec
	sbc #$01
	bcs L98ac
	dex
L98ac
	sta L9bf0
	stx L9bef
	ldx #$00
	stx L9be2
	inx
	stx L9be3
	jsr S9aae
	lda $91fc
	clc
	adc #$e0
	sta $31
	lda $91f9
	and #$01
	adc #$8d
	sta $32
	jsr S9a9d
L98d2
	jsr S9904
	bcs L98dd
	jsr S9985
	jmp L98d2
	
L98dd
	lda $31
	sec
	sbc #$e0
	sta $91fc
	lda $32
	and #$01
	sta $91f9
	ldx L96b2
	ldy L96b1
	bne L98f7
	txa
	beq L9901
L98f7
	lda L96b7
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L9901
	jmp L985c
	
S9904
	lda L9bf2
	bne L9966
	lda L9bf1
	bne L9966
	lda L9bf0
	bne L9919
	lda L9bef
	sec
	beq L9984
L9919
	jsr S99e6
	clc
	stx L96b4
	sty L96b3
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L9929
	inc L9be3
	bne L9931
	inc L9be2
L9931
	lda #$e0
	sta L9966 + 1
	lda #$93
	sta L9966 + 2
	ldx L9bf0
	ldy L9bef
	dex
	cpx #$ff
	bne L9947
	dey
L9947
	stx L9bf0
	sty L9bef
	lda #$02
	sta L9bf1
	tya
	bne L9966
	txa
	bne L9966
	lda $8ff9
	and #$01
	sta L9bf1
	lda $8ffc
	sta L9bf2
L9966
	lda L9966
	inc L9966 + 1
	bne L9971
	inc L9966 + 2
L9971
	ldx L9bf2
	ldy L9bf1
	dex
	cpx #$ff
	bne L997d
	dey
L997d
	stx L9bf2
	sty L9bf1
	clc
L9984
	rts
	
S9985
	pha
	lda $31
	cmp #$e0
	bne L99a8
	lda $32
	cmp #$8d
	bne L99a8
	lda L96b7
	sta LTK_Var_ActiveLU
	ldx L96b2
	ldy L96b1
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L99a5
	jsr L9654
L99a8
	pla
	ldy #$00
	sta ($31),y
	ldx $31
	ldy $32
	inx
	bne L99b5
	iny
L99b5
	cpx #$e0
	bne L99c1
	cpy #$8f
	bne L99c1
	ldx #$e0
	ldy #$8d
L99c1
	stx $31
	sty $32
	rts
	
S99c6
	lda L9be0
	pha
	ldx L9bed
	ldy L9bec
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda L96b7
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L99e5
	rts
	
S99e6
	lda L9bee
	beq L99fe
	lda $9001
	clc
	adc L9be3
	tax
	lda $9000
	adc L9be2
	tay
	lda L96b5
	rts
	
L99fe
	lda #$02
	sta L9a4a + 1
	lda L96b5
	sta $9a68
	lda #$90
	bne L9a32
S9a0d
	lda L9bee
	beq L9a25
	lda $9201
	clc
	adc L9be3
	tax
	lda $9200
	adc L9be2
	tay
	lda L96b7
	rts
	
L9a25
	lda #$02
	sta L9a4a + 1
	lda L96b7
	sta $9a68
	lda #$92
L9a32
	sta L9a4c + 1
	ldx L9be2
	lda L9be3
	sec
	sbc #$01
	bcs L9a41
	dex
L9a41
	stx L9be9
	sta L9bea
	sta L9beb
L9a4a
	lda #$00
L9a4c
	ldx #$00
	jsr S9a81
	lda L9be7
	beq L9a77
	ldy #$08
L9a58
	lsr L9be9
	ror L9bea
	dey
	bne L9a58
	lda L9bea
	jsr S9a88
	lda #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L9a70
	lda #$e0
	ldx #$93
	jsr S9a81
L9a77
	lda L9beb
	jsr S9a88
	lda $9a68
	rts
	
S9a81
	sta S9a98 + 1
	stx S9a98 + 2
	rts
	
S9a88
	asl a
	tax
	bcc L9a8f
	inc S9a98 + 2
L9a8f
	jsr S9a98
	tay
	jsr S9a98
	tax
	rts
	
S9a98
	lda S9a98,x
	inx
	rts
	
S9a9d
	ldy L9be4
	ldx L9be5
	lda L96b5
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9aad
	rts
	
S9aae
	lda L96b7
	ldx L9bf4
	ldy L9bf3
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9abe
	rts
	
S9abf
	ldy L9be1
	lda #$84
	ldx #$9c
	cpy L9bdf
	bcs L9ae3
	jsr S9c06
	php
	bcs L9ad5
	pha
	pla
	bne L9ae2
L9ad5
	lda L9c84,y
	cmp #$3a
	bne L9ae2
	iny
	sty L9be1
	plp
	rts
	
L9ae2
	plp
L9ae3
	sec
	rts
	
S9ae5
	jsr S9abf
	bcc L9af0
	cmp #$3a
	beq L9afb
	bne L9b07
L9af0
	txa
	jsr LTK_SetLuActive 
	bcc L9afb
L9af6
	pla
	pla
	jmp L96bf
	
L9afb
	jsr S9abf
	bcs L9b07
	cpx #$10
	bcs L9af6
	stx L9bdb
L9b07
	lda LTK_Var_ActiveLU
	sta L96b5
	ldx #$00
	stx L9bee
	stx L9be7
	ldy L9be1
L9b18
	lda L9c84,y
	cpx #$10
	beq L9b3b
	cmp #$0d
	beq L9b3b
	cmp #$2c
	beq L9b3b
	sta LTK_FileHeaderBlock ,x
	bit L9bdd
	bpl L9b32
	sta L9bf5,x
L9b32
	iny
	cpy L9bdf
	bcs L9b3b
	inx
	bne L9b18
L9b3b
	lda L96b5
	sta LTK_Var_ActiveLU
	lda L9bdb
	sta LTK_Var_Active_User
	sty L9be1
	lda #$02
	sec
	jsr $9f00
	bcc L9b5c
	pla
	pla
	jmp L96bc
	
L9b57
	pla
	pla
	jmp L96c5
	
L9b5c
	jsr LTK_FindFile 
	sta L9be6
	sta L9bde
	bcs L9b57
	lda $91f8
	cmp #$01
	beq L9b57
	cmp #$03
	beq L9b57
	cmp #$02
	beq L9b57
	cmp #$0a
	bcs L9b7d
	dec L9bee
L9b7d
	lda $9200
	sta L9be4
	lda $9201
	sta L9be5
	lda $91f0
	bne L9b95
	lda $91f1
	cmp #$f1
	bcc L9b98
L9b95
	dec L9be7
L9b98
	rts
	
S9b99
	sta L9be3
	stx L9be2
	sec
	sbc #$01
	bcs L9ba5
	dex
L9ba5
	tay
	lda #$00
L9ba8
	cpx #$01
	bcc L9bbf
	bne L9bb2
	cpy #$01
	bcc L9bbf
L9bb2
	adc #$00
	dey
	cpy #$ff
	bne L9bbc
	dex
	beq L9bbf
L9bbc
	dex
	bne L9ba8
L9bbf
	cpx #$00
	bne L9bc7
	cpy #$00
	beq L9bca
L9bc7
	clc
	adc #$01
L9bca
	sta L9be8
	ldx L9be2
	lda L9be3
	sec
	sbc L9be8
	bcs L9bda
	dex
L9bda
	rts
	
L9bdb
	.byte $00
L9bdc
	.byte $00
L9bdd
	.byte $00
L9bde
	.byte $00
L9bdf
	.byte $00
L9be0
	.byte $00
L9be1
	.byte $00
L9be2
	.byte $00
L9be3
	.byte $00
L9be4
	.byte $00
L9be5
	.byte $00
L9be6
	.byte $00
L9be7
	.byte $00
L9be8
	.byte $00
L9be9
	.byte $00
L9bea
	.byte $00
L9beb
	.byte $00
L9bec
	.byte $00
L9bed
	.byte $00
L9bee
	.byte $00
L9bef
	.byte $00
L9bf0
	.byte $00
L9bf1
	.byte $00
L9bf2
	.byte $00
L9bf3
	.byte $00
L9bf4
	.byte $00
L9bf5	          
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00 
S9c06
	sta L9c17 + 1
	stx L9c17 + 2
	lda #$00
	sta L9c81
	sta L9c82
	sta L9c83
L9c17
	lda L9c17,y
	cmp #$30
	bcc L9c6f
	cmp #$3a
	bcc L9c34
	ldx L9c3f + 1
	cpx #$0a
	beq L9c6f
	cmp #$41
	bcc L9c6f
	cmp #$47
	bcs L9c6f
	sec
	sbc #$07
L9c34
	ldx L9c81
	beq L9c58
	pha
	tya
	pha
	lda #$00
	tax
L9c3f
	ldy #$0a
L9c41
	clc
	adc L9c83
	pha
	txa
	adc L9c82
	tax
	pla
	dey
	bne L9c41
	sta L9c83
	stx L9c82
	pla
	tay
	pla
L9c58
	inc L9c81
	sec
	sbc #$30
	clc
	adc L9c83
	sta L9c83
	bcc L9c6c
	inc L9c82
	beq L9c79
L9c6c
	iny
	bne L9c17
L9c6f
	cmp #$20
	beq L9c6c
	clc
	ldx L9c81
	bne L9c7a
L9c79
	sec
L9c7a
	lda L9c82
	ldx L9c83
	rts
	
L9c81
	.byte $00
L9c82
	.byte $00
L9c83
	.byte $00
L9c84	       
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00 
