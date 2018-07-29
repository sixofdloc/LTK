;sysbt128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"

    *=$0b00
 
L0b00
	lda LTK_HardwarePage
	sta L0bc2 + 2
	cmp #$df
	beq L0b1d
	lda #$00
	sta $31
	lda #$0b
	sta $32
	lda #$00
	sta $33
	lda #$0f
	sta $34
	jsr LTK_MiniSubExeArea 
L0b1d
	ldx #$03
	lda #$00
	tay
L0b22
	sta $1900,y
	iny
	bne L0b22
	inc L0b22 + 2
	dex
	bne L0b22
	ldx #$1f
	ldy #$00
L0b32
	lda #$3c
	sta $df03
	lda $e000,y
	pha
	lda #$34
	sta $df03
	pla
	sta $e000,y
	iny
	bne L0b32
	inc $0b39
	inc $0b43
	dex
	bne L0b32
	ldy #$05
L0b52
	lda #$3c
	sta $df03
	lda $ff00,y
	ldx #$34
	stx $df03
	sta $ff00,y
	iny
	bne L0b52
	lda #$00
	sta $31
	lda #$80
	sta $32
	lda #$07
	sta $0ee4
	lda #$08
	sta $0ee3
	jsr S0e3b
	lda LTK_HardwarePage
	cmp #$df
	beq L0b94
	lda $8046
	sta $31
	sta $33
	ldx $8047
	stx $32
	inx
	inx
	stx $34
	jsr LTK_MiniSubExeArea 
L0b94
	lda $91f2
	and #$3f
	sta $0ee6
	lda $91f3
	sta $0ee7
	ldx $91f9
	dex
	stx L0ee9
	lda $91f6
	sta $0eea
	ldx $91f7
	dex
	stx L0eeb
	lda $91f5
	sta $0eec
	lda $91fa
	sta $0eed
L0bc2
	lda $df04
	and #$0f
	pha
	bne L0bdd
	bit $91f2
	bmi L0bdd
	sta $0ee3
	sta $0ee4
	jsr S0e25
	beq L0bdd
	jmp L0ca9
	
L0bdd
	pla
	clc
	adc #$9e
	sta $0ee3
	lda #$02
	adc #$00
	sta $0ee2
	lda #$e0
	sta $31
	lda #$9b
	sta $32
	lda #$01
	sta $0ee4
	jsr S0e3b
	lda $9bfa
	sta $d030
	sta LTK_Default_CPU_Speed
	lda $9bf8
	sta LTK_AutobootFlag
	lda $9bef
	sta LTK_BeepOnErrorFlag
	lda $9be9
	sta LTK_HD_DevNum
	ldx LTK_HardwarePage
	ldy #$ff
L0c1b
	tya
	cmp #$63
	beq L0c25
	cmp LTK_FileParamTable,y
	bne L0c28
L0c25
	dey
	bne L0c1b
L0c28
	cpy #$03
	bcs L0c2f
	sty LTK_AutobootFlag
L0c2f
	lda #$00
	tay
L0c32
	sta LTK_FileParamTable,y
	iny
	bne L0c32
	stx LTK_HardwarePage
	ldx #$4c
	ldy #$00
L0c3f
	lda $0cd3,y
	sta $fc3d,y
	iny
	dex
	bne L0c3f
	ldy #$00
L0c4b
	lda L0d1f,y
	sta $e8d0,y
	iny
	bne L0c4b
	ldx #$06
L0c56
	lda L0e1f,y
	sta $e9d0,y
	iny
	dex
	bne L0c56
	ldx #$09
	ldy #$00
	jsr L0cb7
	ldx #$02
	ldy #$24
	jsr L0cb7
	lda #$7a
	sta $ff4e
	lda #$fc
	sta $ff4f
	lda $9bfd
	beq L0c8f
	lda #$83
	sta $fffe
	lda #$fc
	sta $ffff
	lda #$ea
	sta $fc44
	sta LTK_Krn_BankOut
L0c8f
	lda $9bff
	beq L0c9e
	lda #$86
	sta $fffa
	lda #$fc
	sta $fffb
L0c9e
	lda #$00
	sta $df02
L0ca3
	sta $8004
	jmp L0ef0
	
L0ca9
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$00
	beq L0ca3
L0cb7
	lda L0cd0
	sta OPEN  ,y
	iny
	lda L0cd0 + 1
	sta OPEN  ,y
	iny
	lda L0cd0 + 2
	sta OPEN  ,y
	iny
	dex
	bne L0cb7
	rts
	
L0cd0
	jsr $fc59
	lda #$00
	sta $df02
	pla
	plp
	cli
S0cdb
	jsr S0cdb
	jsr LTK_Krn_BankOut
	jmp (LTK_Var_Ext_RetVec)
	
L0ce4
	sei
	php
	pha
	lda #$40
	sta $df02
	pla
	plp
	rts
	
L0cef
	jsr LTK_Krn_BankOut
	jmp (LTK_Var_Kernel_Basin_Vec)
	
L0cf5
	rti
	
L0cf6
	nop
	nop
L0cf8
	jmp $e8d0
	
L0cfb
	jmp $e8f7
	
L0cfe
	jmp $e92b
	
L0d01
	jmp $e934
	
L0d04
	jmp $e93c
	
L0d07
	jmp $e969
	
L0d0a
	jsr LTK_Krn_BankOut
	jmp (LTK_Var_BASIC_ExtVec)
	
L0d10
	jsr LTK_Krn_BankOut
	jmp (LTK_Var_Go64_Vec)
	
L0d16
	jmp $e944
	
L0d19
	jmp $e973
	
L0d1c
	jmp $e976
	
L0d1f
	jsr $e920
	ldx $ff00
L0d25
	lda $df02
	bmi L0d25
	and #$04
	beq L0d62
	lda $df00
	pha
	txa
	ora #$01
	sta $ff00
	pla
	sta ($31),y
	stx $ff00
	iny
	bne L0d25
	inc $32
	jmp $e8d6
	
L0d46
	jsr $e920
L0d49
	lda $df02
	bmi L0d49
	and #$04
	beq L0d62
	lda ($31),y
	sta $df00
	lda $df00
	iny
	bne L0d49
	inc $32
	jmp $e8fa
	
L0d62
	php
	pha
	lda #$40
	sta $df02
	sta LTK_Krn_BankControl
	pla
	plp
	rts
	
L0d6f
	php
	pha
	lda LTK_Krn_BankControl
	sta $df02
	pla
	plp
	rts
	
L0d7a
	jsr $e969
	jsr $03b7
	jmp $e913
	
L0d83
	jsr $e969
	sta ($31),y
	jmp $e913
	
L0d8b
	jsr $e969
	lda ($31),y
	jmp $e913
	
L0d93
	sta $e95e
	pla
	sta $e967
	pla
	sta $e968
	inc $e967
	bne L0da6
	inc $e968
L0da6
	lda #$00
	sta $df02
	tay
	lda #$00
	sta ($ae),y
	lda #$40
	sta $df02
L0db5
	jmp L0db5
	
L0db8
	php
	pha
	lda #$00
	sta $df02
	pla
	plp
	rts
	
L0dc2
	clc
	bcc L0dc6
	sec
L0dc6
	pha
	lda $ff00
	pha
	and #$fe
	sta $ff00
	bit $df02
	bvc L0dff
	lda LTK_Var_CurRoutine
	pha
	lda LTK_Save_Accu
	pha
	lda LTK_Save_XReg
	pha
	lda LTK_Save_YReg
	pha
	lda LTK_Save_P
	pha
	lda #$00
	sta $df02
	lda #$e9
	pha
	lda #$b7
	pha
	lda #$04
	pha
L0df7
	bcc L0dfc
	jmp $ff05
	
L0dfc
	jmp $ff17
	
L0dff
	pla
	sta $ff00
	pla
	bvc L0df7
	lda #$40
	sta $df02
	pla
	sta LTK_Save_P
	pla
	sta LTK_Save_YReg
	pla
	sta LTK_Save_XReg
	pla
	sta LTK_Save_Accu
	pla
	sta LTK_Var_CurRoutine
L0e1f
	pla
	sta $ff00
	pla
	rti
	
S0e25
	lda #$c2
	sta L0ee0
	jsr S0e70
	bne L0e6f
	ldx #$10
	ldy #$00
	jsr S0e8c
	jsr S0ec9
	txa
	rts
	
S0e3b
	lda #$08
	sta L0ee0
	jsr S0e70
	bne L0e6f
	ldx #$06
	ldy #$00
	jsr S0e8c
	ldy #$00
	jsr S0ea2
	lda #$2c
	sta $df01
L0e56
	lda $df02
	bmi L0e56
	and #$04
	beq L0e6b
	lda $df00
	sta ($31),y
	iny
	bne L0e56
	inc $32
	bne L0e56
L0e6b
	jsr S0ec9
	txa
L0e6f
	rts
	
S0e70
	jsr S0ea5
	lda #$fe
	sta $df00
	lda #$50
	sta $df02
L0e7d
	lda $df02
	and #$08
	bne L0e7d
	ora #$40
	sta $df02
	lda #$00
	rts
	
S0e8c
	jsr S0eb5
	lda L0ee0,y
	eor #$ff
	sta $df00
	jsr S0ebb
	iny
	dex
	bne S0e8c
	jsr S0eb5
	rts
	
S0ea2
	ldx #$00
	.byte $2c 
S0ea5
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
	
S0eb5
	lda $df02
	bmi S0eb5
	rts
	
S0ebb
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
	
S0ec9
	jsr S0ea2
	jsr S0ed2
	and #$9f
	tax
S0ed2
	jsr S0eb5
	lda $df00
	eor #$ff
	tay
	jsr S0ebb
	tya
	rts
	
L0ee0
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00 
L0ee9
	.byte $00,$00 
L0eeb
	.byte $00,$00,$00,$00,$00 
L0ef0
	lda #$60
	ldy #$00
L0ef4
	sta L0b00,y
	iny
	bne L0ef4
	inc L0ef4 + 2
	bne L0ef4

