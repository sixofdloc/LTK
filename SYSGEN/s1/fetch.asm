;fetch.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=$c000 ; $4000 for sysgen 
Lc000
	ldx $c8
	bit LTK_Var_CPUMode
	bpl Lc029
	ldx $ea
	pha
	lda #$c6
	sta Lc29b + 1
	lda #$4d
	sta Lc29b + 2
	lda #$3d
	sta Lc1f0
	lda #$3e
	sta Lc1f8
	lda #$d0
	sta Lc1f2
	lda #$ea
	sta Lc1f4
	pla
Lc029
	ldy LTK_HD_DevNum
	sty Lc156
	ldy LTK_Var_ActiveLU
	sty Lc10c
	ldy LTK_Var_Active_User
	sty Lc10d
	pha
	txa
	pha
	lda #$01
	jsr Sc3a0
	lda #$0f
	jsr Sc3a0
	jsr Sc396
	lda #$97
	sta Lc46b
	lda #$e0
	sta Lc46c
	pla
	tax
	pla
	sta Lc06d
	jsr Sc2f5
	beq Lc063
	jmp Lc10e
	
Lc063
	ldx #$6e
	ldy #$c0
	jsr Sc2d9
	jmp Lc20f
	
Lc06d
	.byte $00
Lc06e
	.text "{return}{$07}syntax is{return}{return}fetch [lu:user:]filename"
	.text "{return}{return}both lu and user are optional.{return}if user"
	.text " is supplied without an lu,{return}preceed user # with a "
	.text "colon, i.e.{return}fetch :7:filename{return}"
	.byte $00
Lc10c
	.byte $00
Lc10d
	.byte $00
Lc10e
	jsr Sc3af
	lda #$0f
	tay
	ldx Lc156
	jsr Sc3b9
	lda #$00
	jsr Sc3b4
	jsr Sc39b
	lda LTK_ErrorTrapFlag
	sta Lc221
	lda #$02
	sta LTK_ErrorTrapFlag
	jsr Sc2c1
	lda Lc221
	sta LTK_ErrorTrapFlag
	lda Lc2f4
	ldx Lc222
	ldy #$02
	jsr Sc3b4
	lda #$01
	ldx Lc156
	ldy #$02
	jsr Sc3b9
	jsr Sc39b
	jsr Sc2c1
	beq Lc157
	jmp Lc20f
	
Lc156
	.byte $08 
Lc157
	php
	pla
	sta Lc209
	sei
	tsx
	stx Lc207 + 1
	ldx #$00
Lc163
	lda $0100,x
	sta Lc4d2,x
	inx
	bne Lc163
	lda $0300
	sta Lc20c
	lda $0301
	sta Lc20d
	lda $0302
	sta Lc20a
	lda $0303
	sta Lc20b
	lda #$a1
	sta $0302
	sta $0300
	lda #$e0
	sta $0303
	sta $0301
	lda $0326
	sta $c2a1
	lda $0327
	sta $c2a2
	ldx #$d0
	txs
	ldx #$01
	jsr Sc3aa
	jsr Sc2ae
	jsr Sc3d7
	jsr $8e20
	lda Lc20a
	sta $0302
	lda Lc20b
	sta $0303
	lda Lc20c
	sta $0300
	lda Lc20d
	sta $0301
	ldx Lc207 + 1
	txs
	ldx #$00
Lc1cf
	lda Lc4d2,x
	sta $0100,x
	inx
	bne Lc1cf
	lda Lc209
	pha
	plp
	jsr Sc396
	lda #$01
	jsr Sc3a0
	lda #$0d
	jsr Sc38c
	lda #$00
	sta LTK_Command_Buffer
Lc1f0 = * + 1       
	sta $7a
Lc1f2 = * + 1       
	sta $c6
Lc1f4 = * + 1       
	sta $c8
	lda #$02
Lc1f8 = * + 1       
	sta $7b
Lc1f9
	jsr Sc3d2
	dec Lc207
	bne Lc1f9
	ldx #$00
	txa
	tay
	beq Lc20f
Lc207
	bcs Lc209
Lc209
	brk
	
Lc20a
	.byte $00
Lc20b
	.byte $00
Lc20c
	.byte $00
Lc20d
	.byte $00
Lc20e
	.byte $00
Lc20f
	lda Lc10c
	jsr LTK_SetLuActive 
	lda Lc10d
	sta LTK_Var_Active_User
	clc
	jmp LTK_MemSwapOut 
	
Lc21f
	.byte $00
Lc220
	.byte $00
Lc221
	.byte $00
Lc222
	.byte $00
Lc223
	.byte $00
Lc224
	.byte $00
Lc225
	.byte $00
Lc226
	bit LTK_Var_CPUMode
	bpl Lc230
Lc22b
	ldx #$00
	stx $ff00
Lc230
	ldx #$60
Lc232
	lda bRND,x
	sta $8ee0,x
	dex
	bpl Lc232
	ldx #$60
Lc23d
	lda $8e4e,x
	sta bRND,x
	dex
	bpl Lc23d
	lda $ffd3
	sta $8e1e
	lda #$60
	sta CLALL 
	sta $ffd3
	lda #$18
	sta CHROUT
	bit LTK_Var_CPUMode
	bpl Lc263
	lda #$30
	sta $ff00
Lc263
	rts
	
Lc264
	.byte $00
Lc265
	.byte $00
Lc266
	bit LTK_Var_CPUMode
	bpl Lc270
	ldx #$00
	stx $ff00
Lc270
	lda #$20
	sta CHROUT
	sta CLALL 
	lda $8e1e
	sta $ffd3
	ldx #$60
Lc280
	lda $8ee0,x
	sta bRND,x
	dex
	bpl Lc280
	bit LTK_Var_CPUMode
	bpl Lc293
	lda #$30
	sta $ff00
Lc293
	rts
	
Lc294
	tsx
	stx $01d2
Lc298
	ldx #$fc
	txs
Lc29b
	jsr $a483
	lda #$2e
	jsr CHROUT
	lda $90
	cmp #$40
	bcc Lc298
	ldx $01d2
	txs
	rts
	
Sc2ae
	ldx #$ff
	stx LTK_WriteChanFPTPtr
	inx
Lc2b4
	lda Lc226,x
	sta LTK_FileWriteBuffer ,x
	inx
	bne Lc2b4
	jsr LTK_FileWriteBuffer 
	rts
	
Sc2c1
	ldx #$0f
	jsr Sc3aa
Lc2c6
	jsr Sc391
	cmp #$0d
	beq Lc2c6
	pha
Lc2ce
	jsr Sc391
	cmp #$0d
	beq Lc2ce
	pla
	cmp #$30
	rts
	
Sc2d9
	stx Lc2df + 1
	sty Lc2df + 2
Lc2df
	lda Lc2df
	ora #$00
	beq Lc2f3
	jsr Sc38c
	inc Lc2df + 1
	bne Lc2df
	inc Lc2df + 2
	bne Lc2df
Lc2f3
	rts
	
Lc2f4
	.byte $24 
Sc2f5
	tay
	iny
	lda #$00
	sta LTK_Command_Buffer,x
	stx Lc2f4
	cpy Lc2f4
	bcc Lc307
	jmp Lc380
	
Lc307
	jsr Sc46d
	lda Lc4cd
	beq Lc327
	tya
	pha
	lda Lc4ce
	jsr LTK_SetLuActive 
	pla
	tay
	bcc Lc327
	pla
	pla
	ldx #$4a
	ldy #$c3
	jsr Sc2d9
	jmp Lc20f
	
Lc327
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc374
	iny
	jsr Sc46d
	lda Lc4cd
	beq Lc374
	lda Lc4ce
	cmp #$10
	bcc Lc370
	pla
	pla
	ldx #$5e
	ldy #$c3
	jsr Sc2d9
	jmp Lc20f
	
Lc34a
	.text "{return}{$07}not an active lu{return}{00}{return}{$07}invalid user #{return}"
	.byte $00
Lc370
	sta LTK_Var_Active_User
	iny
Lc374
	sty Lc222
	lda Lc2f4
	sec
	sbc Lc222
	bne Lc382
Lc380
	lda #$00
Lc382
	sta Lc2f4
	ldx Lc2f4
	rts
	
Lc389
	lda $90
	rts
	
Sc38c
	pha
	lda #$00
	beq Lc3dc
Sc391
	pha
	lda #$01
	bne Lc3dc
Sc396
	pha
	lda #$02
	bne Lc3dc
Sc39b
	pha
	lda #$03
	bne Lc3dc
Sc3a0
	pha
	lda #$04
	bne Lc3dc
	pha
	lda #$05
	bne Lc3dc
Sc3aa
	pha
	lda #$06
	bne Lc3dc
Sc3af
	pha
	lda #$07
	bne Lc3dc
Sc3b4
	pha
	lda #$08
	bne Lc3dc
Sc3b9
	pha
	lda #$09
	bne Lc3dc
	pha
	lda #$0a
	bne Lc3dc
	pha
	lda #$0b
	bne Lc3dc
	pha
	lda #$0c
	bne Lc3dc
	pha
	lda #$0d
	bne Lc3dc
Sc3d2
	pha
	lda #$0e
	bne Lc3dc
Sc3d7
	pha
	lda #$0f
	bne Lc3dc
Lc3dc
	sty Lc445
	stx Lc446
	ldy LTK_Save_PreconfigC
	sty Lc447
	ldy LTK_Save_PreconfigD
	sty Lc448
	ldy LTK_Save_P
	sty Lc449
	ldy LTK_Save_Accu
	sty Lc44a
	ldy LTK_Save_XReg
	sty Lc44b
	ldy LTK_Save_YReg
	sty Lc44c
	asl a
	tay
	lda Lc44d,y
	tax
	lda $c44e,y
	tay
	sec
	jsr LTK_KernalTrapSetup
	pla
	ldy Lc445
	ldx Lc446
	jsr LTK_KernalCall2 
	pha
	lda Lc447
	sta LTK_Save_PreconfigC
	lda Lc448
	sta LTK_Save_PreconfigD
	lda Lc449
	sta LTK_Save_P
	lda Lc44a
	sta LTK_Save_Accu
	lda Lc44b
	sta LTK_Save_XReg
	lda Lc44c
	sta LTK_Save_YReg
	pla
	rts
	
Lc445
	.byte $00
Lc446
	.byte $00
Lc447
	.byte $00
Lc448
	.byte $00
Lc449
	.byte $00
Lc44a
	.byte $00
Lc44b
	.byte $00
Lc44c
	.byte $00
Lc44d		              
	.byte $d2,$ff,$cf,$ff,$cc,$ff,$c0,$ff
	.byte $c3,$ff,$c9,$ff,$c6,$ff,$e7,$ff
	.byte $bd,$ff,$ba,$ff,$33,$a5,$d8,$a6
	.byte $9f,$ff,$79,$a5,$e4,$ff 
Lc46b
	.byte $6b 
Lc46c
	.byte $c4 
Sc46d
	lda #$00
	sta Lc4ce
	sta Lc4cf
	sta Lc4cd
Lc478
	lda LTK_Command_Buffer,y
	cmp #$3a
	bcc Lc480
Lc47f
	rts
	
Lc480
	cmp #$30
	bcc Lc47f
	jsr Sc492
	sty Lc4cd
	iny
	cpy Lc2f4
	beq Lc47f
	bne Lc478
Sc492
	clc
	sbc #$2f
	sta Lc4d1
	lda Lc4cf
	sta Lc4d0
	lda Lc4ce
	asl a
	rol Lc4d0
	asl a
	rol Lc4d0
	adc Lc4ce
	sta Lc4ce
	lda Lc4d0
	adc Lc4cf
	sta Lc4cf
	asl Lc4ce
	rol Lc4cf
	lda Lc4ce
	adc Lc4d1
	sta Lc4ce
	bcc Lc4cc
	inc Lc4cf
Lc4cc
	rts
	
Lc4cd
	.byte $00
Lc4ce
	.byte $00
Lc4cf
	.byte $00
Lc4d0
	.byte $00
Lc4d1
	.byte $00
Lc4d2	 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00 
