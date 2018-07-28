;subcl128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"


    *=LTK_MiniSubExeArea ;$93e0
 
L93e0
	lda $ff00
	sta LTK_Var_OrigCR
	ora #$0e
	sta $ff00
	lda $d503
	sta LTK_Save_PreconfigC
	lda $d504
	sta LTK_Save_PreconfigD
	lda #$00
	sta $d503
	lda #$40
	sta $d504
	stx $9ec5
	sty $9ec4
	tsx
	lda $0103,x
	cmp #$f5
	bne L9416
	lda $0104,x
	cmp #$4a
	beq L947f
L9416
	lda #$ff
	sta $9ec3
	lda $31
	pha
	lda $32
	pha
	sty $32
	ldx $9ec5
	stx $31
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
	jsr S95b4
	sta $9e65
	jsr S95b4
	sta $9e64
	jsr S958b
	ldy #$02
	jsr S95b4
	pha
	and #$7f
	sta $9e83
	ldx #$00
	pla
	bpl L9452
	inx
L9452
	stx L952a + 1
	jsr S95b4
	sta $9e84
	jsr S95b4
	sta $9ea3
	jsr S95b4
	sta $9e85
	jsr S95b4
	sta $9ea5
	jsr S95b4
	sta $9ea4
	pla
	sta $32
	pla
	sta $31
	jmp L94db
	
L947c
	jmp L9544
	
L947f
	ldx #$00
	stx $9ec3
	inx
	stx L952a + 1
	jsr S9552
	sta $9e65
	jsr S9552
	sta $9e64
	jsr S958b
	jsr S9552
	sta $9e83
	jsr S957f
	jsr S9579
	lda $0f
	beq L947c
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
	jsr S956b
	sta $9e84
	iny
	jsr S956b
	sta $9ea3
	iny
	jsr S956b
	sta $9e85
	lda $3d
	sta $9ec5
	lda $3e
	sta $9ec4
	jsr S9552
	sta $9ea5
	jsr S9552
	sta $9ea4
L94db
	lda $9e65
	cmp #$08
	bcs L9544
	asl a
	tay
	lda L95be,y
	tax
	lda L95bd,y
	jsr LTK_CallExtDosOvl 
	lda $9e65
	cmp #$01
	bne L953e
	lda $2f
	pha
	lda $30
	pha
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda #$ff
	sta LTK_BLKAddr_MiniSub
	ldx #$1d
	lda #$00
L9510
	sta $95e3,x
	dex
	bpl L9510
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L952a
	ldx #$01
	lda #$31
	jsr LTK_KernalCall 
	sta $95e3,y
	iny
	cpy #$1e
	beq L953e
	cpy $9e84
	bne L952a
L953e
	lda L952a + 1
	jmp LTK_DOSOverlay 
	
L9544
	bit $9ec3
	bmi L954c
	jmp LTK_SysRet_OldRegs 
	
L954c
	sec
	lda #$ff
	jmp LTK_SysRet_AsIs  
	
S9552
	jsr S957f
	jsr S9579
	lda $0f
	bne L9563
	jsr S9573
	lda $66
	beq L9568
L9563
	pla
	pla
	jmp LTK_SysRet_OldRegs 
	
L9568
	lda $67
	rts
	
S956b
	lda #$66
	ldx #$01
	jsr LTK_KernalCall 
	rts
	
S9573
	ldx #$b4
	ldy #$84
	bne L9583
S9579
	ldx #$ef
	ldy #$77
	bne L9583
S957f
	ldx #$80
	ldy #$03
L9583
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S958b
	ldx #$00
	ldy #$07
L958f
	lda LTK_FileParamTable,x
	cmp $9e64
	bne L959e
	lda $9df9,x
	cmp #$04
	beq L95a8
L959e
	txa
	clc
	adc #$20
	tax
	dey
	bne L958f
	ldx #$ff
L95a8
	stx $9e64
	lda $9de6,x
	and #$0f
	sta $9e63
	rts
	
S95b4
	lda #$31
	ldx #$00
	jsr LTK_KernalCall 
	iny
	rts
	
L95bd
	.byte $d2 
L95be
	.byte $03,$a6,$03,$aa,$03,$ae,$02,$b2,$02,$b6,$02,$ba,$02,$be,$03 
