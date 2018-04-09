;subcallr.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	stx $9ec5
	sty $9ec4
	tsx
	lda $0101,x
	cmp #$46
	bne L93f5
	lda $0102,x
	cmp #$e1
	beq L9450
L93f5
	lda #$ff
	sta $9ec3
	lda $31
	pha
	lda $32
	pha
	sty $32
	ldx $9ec5
	stx $31
	ldy #$00
	jsr $fc6e
	sta $9e65
	iny
	jsr $fc6e
	sta $9e64
	jsr S954d
	ldy #$02
	jsr $fc6e
	sta $9e83
	iny
	jsr $fc6e
	sta $9e84
	iny
	jsr $fc6e
	sta $9ea3
	iny
	jsr $fc6e
	sta $9e85
	iny
	jsr $fc6e
	sta $9ea5
	iny
	jsr $fc6e
	sta $9ea4
	pla
	sta $32
	pla
	sta $31
	jmp L94b4
	
L944d
	jmp L950e
	
L9450
	lda #$00
	sta $9ec3
	jsr S951c
	sta $9e65
	jsr S951c
	sta $9e64
	jsr S954d
	jsr S951c
	sta $9e83
	jsr S9541
	jsr S953b
	lda $0d
	beq L944d
	lda $31
	pha
	lda $32
	pha
	lda $64
	sta $31
	lda $65
	sta $32
	ldy #$00
	jsr $fc6e
	sta $9e84
	iny
	jsr $fc6e
	sta $9ea3
	iny
	jsr $fc6e
	sta $9e85
	pla
	sta $32
	pla
	sta $31
	lda $7a
	sta $9ec5
	lda $7b
	sta $9ec4
	jsr S951c
	sta $9ea5
	jsr S951c
	sta $9ea4
L94b4
	lda $9e65
	cmp #$08
	bcs L950e
	asl a
	tay
	lda $9577,y
	tax
	lda L9576,y
	jsr LTK_CallExtDosOvl 
	lda $9e65
	cmp #$01
	bne L950b
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
L94e9
	sta $95e3,x
	dex
	bpl L94e9
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy #$00
L94fb
	jsr $fc6e
	sta $95e3,y
	iny
	cpy #$1e
	beq L950b
	cpy $9e84
	bne L94fb
L950b
	jmp LTK_DOSOverlay 
	
L950e
	bit $9ec3
	bmi L9516
	jmp LTK_SysRet_OldRegs 
	
L9516
	sec
	lda #$ff
	jmp LTK_SysRet_AsIs  
	
S951c
	jsr S9541
	jsr S953b
	lda $0d
	bne L952d
	jsr S9535
	lda $64
	beq L9532
L952d
	pla
	pla
	jmp LTK_SysRet_OldRegs 
	
L9532
	lda $65
	rts
	
S9535
	ldx #$bf
	ldy #$b1
	bne L9545
S953b
	ldx #$9e
	ldy #$ad
	bne L9545
S9541
	ldx #$73
	ldy #$00
L9545
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S954d
	ldx #$00
	ldy #$07
L9551
	lda LTK_FileParamTable,x
	cmp $9e64
	bne L9560
	lda $9df9,x
	cmp #$04
	beq L956a
L9560
	txa
	clc
	adc #$20
	tax
	dey
	bne L9551
	ldx #$ff
L956a
	stx $9e64
	lda $9de6,x
	and #$0f
	sta $9e63
	rts
	
L9576
	.byte $ce,$03,$7e,$03,$82,$03,$86,$02
	.byte $8a,$02,$8e,$02,$92,$02,$96,$03 
