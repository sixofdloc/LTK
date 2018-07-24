;fastfdos.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"
	.include "../../include/kernal.asm"

    *=$1c20

L1c20
	.text "fastcopy"
	.text "{$a0}{$a0}00/ 0"
L1c2f
	.byte $30  ;"0"
L1c30
	.byte $30 ;"0"
L1c31
	.text "11234567890123456"
L1c42
	.byte $84 
L1c43
	.byte $fe 
L1c44
	.byte $ff,$00 
L1c46
	.byte $00
L1c47
	.byte $00
L1c48
	.byte $48,$1c 
L1c4a
	.byte $4a,$1c,$00,$3c 
L1c4e
	.byte $98 
L1c4f
	.byte $02 
L1c50
	.byte $00
L1c51
	.byte $00
L1c52
	.byte $00
L1c53
	.byte $00
L1c54
	.byte $00
L1c55
	.byte $00
L1c56
	.byte $00
L1c57
	.byte $00
L1c58
	.byte $0d 
L1c59
	jmp L1cf2
	
L1c5c
	jmp L1ebe
	
L1c5f
	jmp S3189
	
L1c62
	jmp L1ddf
	
L1c65
	jmp S305a
	
L1c68
	jmp L1d48
	
L1c6b
	jmp L1cff
	
L1c6e
	jmp L2910
	
L1c71
	jmp L2a47
	
L1c74
	jmp L2ae5
	
S1c77
	jmp L1fc4
	
S1c7a
	jmp L1ff3
	
S1c7d
	jmp L1fd3
	
L1c80
	jmp L1f9e
	
L1c83
	jmp L1f5b
	
L1c86
	jmp L1c9e
	
S1c89
	jmp L1cac
	
L1c8c
	jmp L1cca
	
L1c8f
	jmp L1cde
	
L1c92
	jmp L27e8
	
L1c95
	jmp L21a5
	
L1c98
	jmp L2184
	
L1c9b
	.byte $00
L1c9c
	.byte $00
L1c9d
	.byte $00
L1c9e
	jsr S1c89
	bne L1cab
	lda #$03
	jsr S1c7a
	jsr S1d66
L1cab
	rts
	
L1cac
	sta $2f
	lda #$04
	sta $30
S1cb2
	lda #$04
	jsr S1c7a
	jsr S1c77
	lda L1c30
	jsr S1c7a
	lda L1c31
	jsr S1c7a
	jsr S1d66
	rts
	
L1cca
	jsr S1d80
	lda L1c46
	sta $03
	lda L1c47
	sta $04
	jsr L1c83
	jsr S1d66
	rts
	
L1cde
	jsr S1d80
	lda L1c46
	sta $03
	lda L1c47
	sta $04
	jsr L1c80
	jsr S1d66
	rts
	
L1cf2
	jsr S3319
	jsr S1e1d
	jsr S1d66
	jsr S332d
	rts
	
L1cff
	jsr S3319
	lda #$01
	sta L1d65
L1d07
	lda L1d65
	cmp #$24
	bne L1d13
	lda #$00
	clc
	beq L1d44
L1d13
	jsr L1c86
	bne L1d44
	jsr S1ee5
	lda L1c9b
	beq L1d3f
	lda L1c9c
	beq L1d3f
	lda L1d65
	clc
	adc #$23
	sta L1d65
	jsr L1c86
	bne L1d44
	jsr S1ee5
	lda L1d65
	sec
	sbc #$23
	sta L1d65
L1d3f
	inc L1d65
	bne L1d07
L1d44
	jsr S332d
	rts
	
L1d48
	jsr L1cff
	bne L1d64
	jsr S3319
	php
	jsr S3189
	jsr S305a
	lda #$00
	plp
	jsr S332d
	beq L1d61
	lda #$ff
L1d61
	ora L27e7
L1d64
	rts
	
L1d65
	.byte $00
S1d66
	jsr S1c7d
	tay
	lda L1d72,y
	clc
	beq L1d71
	sec
L1d71
	rts
	
L1d72
	.byte $00,$00,$14,$15,$16,$17,$00,$19,$1a,$1b,$00,$1d,$0c,$47 
S1d80
	pla
	tax
	pla
	tay
	pla
	sta L1d9a + 1
	pla
	sta L1d9a + 2
	inc L1d9a + 1
	bne L1d94
	inc L1d9a + 2
L1d94
	tya
	pha
	txa
	pha
	ldy #$00
L1d9a
	lda L1d9a,y
	cpy #$00
	beq L1dae
	cpy #$01
	beq L1db2
	cpy #$02
	beq L1db7
	sta L1c47
	bne L1dbd
L1dae
	sta $2f
	bne L1dba
L1db2
	sta $30
	jmp L1dba
	
L1db7
	sta L1c46
L1dba
	iny
	bne L1d9a
L1dbd
	lda #$03
	clc
	adc L1d9a + 1
	sta L1d9a + 1
	lda #$00
	adc L1d9a + 2
	sta L1d9a + 2
	pla
	tax
	pla
	tay
	lda L1d9a + 2
	pha
	lda L1d9a + 1
	pha
	tya
	pha
	txa
	pha
	rts
	
L1ddf
	jsr S3189
	lda #$12
	jsr S1c89
	lda #$08
	jsr S1c7a
	ldx #$08
L1dee
	stx L1e1c
	jsr S1c7d
	ldx L1e1c
	sta L1e13,x
	dex
	bpl L1dee
	lda L1e14
	beq L1e04
	sec
	rts
	
L1e04
	lda L1e15
	sta L1c30
	lda L1e16
	sta L1c31
	jmp L2ebf
	
L1e13
	.byte $00
L1e14
	.byte $00
L1e15
	.byte $00
L1e16
	.byte $00,$00,$00,$00,$00,$00 
L1e1c
	.byte $00
S1e1d
	sta L1e56 + 1
	jsr S3319
	lda LTK_HardwarePage
	sta L1ee1 + 2
	lda LTK_Var_CPUMode
	pha
	sta L1ebd
	jsr S1edf
	pla
	beq L1e3f
	lda $ff00
	pha
	and #$cf
	sta $ff00
L1e3f
	lda L1c9b
	bne L1e49
	lda #$2c
	sta $2511 ;Blocking out something in the DOS routine with BIT
L1e49
	jsr CLRCHN
	jsr CLALL 
	lda #$00
	jsr SETNAM
	lda #$02
L1e56
	ldx #$08
	ldy #$0f
	jsr SETLFS
	jsr OPEN  
	lda #$3f
	sta $33
	lda #$22
	sta $34
	ldx #$02
	jsr CHKOUT
	lda #$49
	jsr CHROUT
	lda #$30
	jsr CHROUT
	jsr CLRCHN
	ldx #$02
	jsr CHKIN 
L1e7f
	jsr CHRIN 
	cmp #$0d
	bne L1e7f
	ldx #$02
	jsr CHKOUT
	jsr S21c2
	jsr CLRCHN
	lda #$00
	sta $98
	jsr S1edc
	lda LTK_Var_CPUMode
	beq L1eab
	pla
	sta $ff00
	lda #$03
	sta L1eaf + 1
	lda #$0a
	sta L1eaf + 2
L1eab
	jsr S332d
L1eae
	nop
L1eaf
	lda $02a6
	beq L1ebc
	inc L212e + 1
	lda #$60
	sta L1eae
L1ebc
	rts
	
L1ebd
	.byte $00
L1ebe
	jsr S3319
	lda LTK_HardwarePage
	sta L1ee1 + 2
	jsr S1edf
	jsr L21a5
	lda #$f1
	jsr S1c7a
	jsr L2184
	jsr S1edc
	jsr S332d
	rts
	
S1edc
	lda #$34
	.byte $2c 
S1edf
	lda #$3c
L1ee1
	sta $df03
	rts
	
S1ee5
	jsr S1f09
	lda L1f5a
L1eeb
	cmp RASTER
	bne L1eeb
	ldx #$0b
L1ef2
	dex
	bne L1ef2
	dec BORDER
	clc
	adc #$04
L1efb
	cmp RASTER
	bne L1efb
	ldx #$0b
L1f02
	dex
	bne L1f02
	inc BORDER
	rts
	
S1f09
	lda $2f
	cmp #$24
	bcc L1f11
	sbc #$23
L1f11
	asl a
	sta L1f5a
	asl a
	clc
	adc L1f5a
	sta L1f5a
	lda #$fa
	clc
	sbc L1f5a
	clc
	adc #$06
	sta L1f5a
	lda LTK_Var_CPUMode
	beq L1f59
	ldx #$0a
	stx $d600
L1f33
	bit $d600
	bpl L1f33
	lda #$00
	sta $d601
	ldx #$0e
	stx $d600
L1f42
	bit $d600
	bpl L1f42
	sta $d601
	inx
	stx $d600
L1f4e
	bit $d600
	bpl L1f4e
	ldx $2f
	dex
	stx $d601
L1f59
	rts
	
L1f5a
	.byte $00
L1f5b
	lda #$01
	jsr L1ff3
	jsr L1fc4
L1f63
	jsr L1fd3
	beq L1f8f
	php
	and #$7f
	ldy #$00
	plp
	bpl L1f77
	tax
	dex
	txa
	ora #$80
	sta $30
L1f77
	lda #$fe
	sta L210f + 1
	jsr S2100
	lda $03
	clc
	adc #$fe
	sta $03
	lda #$00
	adc $04
	sta $04
	lda $30
	rts
	
L1f8f
	jsr L1fd3
	and #$7f
	sta $2f
	jsr S1ee5
	jmp L1f63
	
L1f9c
	.byte $00
L1f9d
	.byte $00
L1f9e
	lda #$0d
	jsr L1ff3
	jsr L1fc4
	jsr L1fd3
	lda #$00
	sta S213a + 1
	lda $04
	sta L2148 + 2
	lda $03
	sta L2148 + 1
	jsr S213a
	jsr S1ee5
	jsr L1fd3
	cmp #$00
	rts
	
L1fc4
	lda $2f
	ora #$80
	jsr L1ff3
	ldx $30
	inx
	txa
	jsr L1ff3
	rts
	
L1fd3
	lda $03
	pha
	lda $04
	pha
	lda #$fd
	sta L210f + 1
	lda #$33
	sta $04
	lda #$00
	sta $03
	jsr S2100
	pla
	sta $04
	pla
	sta $03
	lda L33fd
	rts
	
L1ff3
	sta L33ff
	lda #$ff
	sta S213a + 1
	lda #$33
	sta L2148 + 2
	lda #$00
	sta L2148 + 1
	jsr S213a
	rts
	
	.byte $30,$03,$18,$69,$07,$4c,$80,$27,$f3,$10,$f0,$10,$ed,$10,$ea,$10 
    .byte $e7,$10,$e4,$10,$e1,$10,$e1,$10,$de,$10,$db,$10,$d8,$10,$d5,$10
    .byte $d2,$10,$1c,$2a,$3a,$2b,$21,$12,$1e,$12,$f3,$11,$83,$11,$ad,$10
    .byte $35,$11,$20,$11,$11,$11,$4a,$0f,$4d,$0f,$47,$0f 
	.text "byt"
	.text "wor"
	.text "dby"
	.text "ski"
	.text "pag"
	.text "end"
	.text "opt"
	.text "fil"
	.text "lib"
	.text "ifn"
	.text "ife"
	.text "mnd"
	.text "mac"
	.text "gen"
	.text "nog"
	.text "sym"
	.text "nos"
	.text "noc"
	.text "cnt"
	.text "cou"
	.text "err"
	.text "noe"
	.text "mem"
	.text "nom"
	.text "lis"
	.text "nol"
	.text "adc"
	.text "and"
	.text "asl"
	.text "bcc"
	.text "bcs"
	.text "beq"
	.text "bit"
	.text "bmi"
	.text "bne"
	.text "bpl"
	.text "brk"
	.text "bvc"
	.text "bvs"
	.text "clc"
	.text "cld"
	.text "cli"
	.text "clv"
	.text "cmp"
	.text "cpx"
	.text "cpy"
	.text "dec"
	.text "dex"
	.text "dey"
	.text "eor"
	.text "inc"
	.text "inx"
	.text "iny"
	.text "jmp"
	.text "jsr"
	.text "lda"
	.text "ldx"
	.text "ldy"
	.text "lsr"
	.text "nop"
	.text "ora"
	.text "pha"
	.byte $50 
S2100
	lda #$17
	sta $dd00
L2105
	bit $dd00
	bmi L2105
	lda #$07
	sta $dd00
L210f
	ldy #$fe
L2111
	ldx #$04
L2113
	bit $dd00
	bpl L2113
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
L2120
	nop
	lda $dd00
	asl a
	rol $6b
	asl a
	rol $6b
	nop
	nop
	nop
	dex
L212e
	bne L2120
	lda $6b
	sta ($03),y
	iny
	cpy #$fe
	bne L2111
	rts
	
S213a
	ldy #$00
	lda #$27
	sta $dd00
L2141
	lda $dd00
	and #$40
	bne L2141
L2148
	lda L33ff,y
	sta $6b
	tya
	pha
	ldx #$04
	lda #$07
	sta $dd00
L2156
	lda #$00
	asl $6b
	rol a
	asl $6b
	rol a
	tay
	lda L2180,y
	sta $dd00
	dex
	bne L2156
	pha
	pla
	pha
	pla
	pha
	pla
	lda #$27
	sta $dd00
	pla
	tay
	iny
	php
	plp
	bne L2148
	lda #$07
	sta $dd00
	rts
	
L2180
	.byte $07,$17,$27,$37 
L2184
	lda L1c9d
	sta $d030
	lda #$1b
	sta $d011
	lda $dd00
	ora #$03
	sta $dd00
	cli
	rts
	
S2199
	sei
	lda #$00
	sta $d030
	lda #$0b
	sta $d011
	rts
	
L21a5
	jsr S2199
	ldy #$20
L21aa
	dex
	bne L21aa
	dey
	bne L21aa
	rts
	
L21b1
	lda #$0a
L21b3
	ldx #$00
L21b5
	ldy #$00
L21b7
	dey
	bne L21b7
	dex
	bne L21b5
	sbc #$01
	bne L21b3
	rts
	
S21c2
	lda #$2b
	sta $6b
	lda #$02
	sta MemWriteAddrHi
	lda #$e2
	sta MemWriteAddrLo
	ldy #$00
L21d2
	lda #$1e
	clc
	adc MemWriteAddrLo
	sta MemWriteAddrLo
	lda #$00
	adc MemWriteAddrHi
	sta MemWriteAddrHi
	tya
	pha
	; MemWriteCmd HI
	lda #$22
	sta $32
	; MemWriteCmd LO
	lda #$38
	sta $31
	jsr SendToDrive
	pla
	tay
	ldx #$1e
L21f4
	lda ($33),y
	jsr CHROUT
	iny
	bne L21fe
	inc $34
L21fe
	dex
	bne L21f4
	jsr S2228
	dec $6b
	bne L21d2
	lda #$22
	sta $32
	lda #$31
	sta $31
	jsr SendToDrive
	rts
	
SendToDrive
    ldy #$00
L2216
	lda ($31),y
	cmp #$a1
	beq L2227
	jsr CHROUT
	iny
	bne L2216
	inc $32
	jmp L2216
	
L2227
	rts
	
S2228
	jsr CLRCHN
	ldx #$02
	jsr CHKOUT
	rts
	
MemExecuteCommand   
    .text "m-e"
	.byte $00,$03,$0d,$a1 
MemWriteCommand     
    .text "m-w"
MemWriteAddrLo
    .byte $00 
MemWriteAddrHi
    .byte $03,$1e,$a1 
	; 223f
DriveSideFastDOS        
    .binary "output/driveside_fastfdos.prg",2
    *=$273f
    .offs 0
S273f
	ldy L27e2
	dey
	tya
	asl a
	asl a
	php
	clc
	adc #$04
	sta L275a + 1
	lda #$00
	adc #$3a
	sta L275a + 2
	plp
	bcc L275a
	inc L275a + 2
L275a
	lda $3a04
	bne L2778
	lda #$00
	sta L27e3
L2764
	inc L27e2
	lda L27e2
	cmp #$12
	beq L2764
	cmp #$35
	beq L2764
	cmp #$47
	bne S273f
	sec
L2777
	rts
	
L2778
	lda L27e2
	sta L1c56
	lda L27e3
	sta L1c57
	jsr S27b6
	bcs L27b3
	jsr L27e8
	bne L2797
	lda L27e2
	sta L1c56
	lda L1c57
L2797
	sta L27e3
	lda L27e3
	jsr S27b6
	bcs L27b3
	inc L27e3
	lda L27e3
	cmp L27d9
	bcc L2797
	sbc L27d9
	jmp L2797
	
L27b3
	clc
	bcc L2777
S27b6
	pha
	ldy #$08
	lda L27e3
	ldx #$00
	jsr S285b
	sec
	adc L275a + 1
	sta L27d0 + 1
	lda #$00
	adc L275a + 2
	sta L27d0 + 2
L27d0
	lda $3a04
L27d3
	ror a
	dey
	bpl L27d3
	pla
	rts
	
L27d9
	.byte $00
L27da
	.byte $00
L27db
	.byte $00
L27dc
	.byte $00
L27dd
	.byte $00
L27de
	.byte $00
L27df
	.byte $00
L27e0
	.byte $00
L27e1
	.byte $00
L27e2
	.byte $00
L27e3
	.byte $00
L27e4
	.byte $00
L27e5
	.byte $00
L27e6
	.byte $00
L27e7
	.byte $00
L27e8
	lda L1c56
	beq L2832
	ldx #$15
	cmp #$12
	bcc L2819
	ldx #$13
	cmp #$19
	bcc L2819
	ldx #$12
	cmp #$1f
	bcc L2819
	ldx #$11
	cmp #$24
	bcc L2819
	ldx #$15
	cmp #$35
	bcc L2819
	ldx #$13
	cmp #$3c
	bcc L2819
	ldx #$12
	cmp #$42
	bcc L2819
	ldx #$11
L2819
	stx L27d9
	lda L1c57
	clc
	adc L1c58
	cmp L27d9
	bcc L282d
	sbc L27d9
	beq L2832
L282d
	sta L1c57
	clc
	rts
	
L2832
	inc L1c56
	lda L1c56
	cmp #$47
	bcs L2840
	lda #$00
	beq L282d
L2840
	dec L1c56
	lda L1c57
	rts
	
L2847
	lda L27da
	sec
	sbc L27dc
	sta L27de
	lda L27db
	sbc L27dd
	sta L27df
	rts
	
S285b
	sta L288f
	stx L288e
	sty L288d
	lda #$00
	ldx #$10
L2868
	clc
	rol L288f
	rol L288e
	rol a
	bcs L2877
	cmp L288d
	bcc L2882
L2877
	sbc L288d
	inc L288f
	bne L2882
	inc L288e
L2882
	dex
	bne L2868
	tay
	ldx L288e
	lda L288f
	rts
	
L288d
	.byte $00
L288e
	.byte $00
L288f
	.byte $00
S2890
	php
	pha
	txa
	pha
	tya
	pha
	lda $31
	pha
	lda $32
	pha
	lda L27e2
	asl a
	asl a
	sta $31
	lda #$00
	bcc L28a9
	lda #$01
L28a9
	sta $32
	lda $31
	clc
	adc #$00
	sta $31
	lda $32
	adc #$3a
	sta $32
	ldy #$08
	lda L27e3
	ldx #$00
	jsr S285b
	sty L27e0
	ldx L27e0
	tay
	iny
	lda ($31),y
	clc
L28cd
	ror a
	dex
	bpl L28cd
	ldx L27e0
	php
	clc
L28d6
	rol a
	dex
	bpl L28d6
	sta ($31),y
	plp
	bcc L28ea
	ldy #$00
	lda ($31),y
	beq L28ea
	sec
	sbc #$01
	sta ($31),y
L28ea
	sec
	lda L1c4e
	sbc #$01
	sta L1c4e
	lda L1c4f
	sbc #$00
	sta L1c4f
	inc L2d46
	bne L2903
	inc L2d47
L2903
	pla
	sta $32
	pla
	sta $31
	pla
	tay
	pla
	tax
	pla
	plp
	rts
	
L2910
	jsr S3319
	jsr S2199
	jsr S2c50
	bcc L2921
	jsr S332d
	lda #$ff
	rts
	
L2921
	lda L1c42
	cmp #$84
	bne L292b
	jsr S32d7
L292b
	jsr S273f
	lda L27e2
	sta L1c51
	lda L27e3
	sta L1c52
	lda #$00
	sta L2d46
	sta L2d47
L2942
	jsr S273f
	jsr S2eb9
	sta L1c50
	jsr S2890
	lda L27e2
	sta L27e4
	lda L27e3
	sta L27e5
	jsr S273f
	lda L1c46
	sec
	sbc #$02
	sta L1c46
	sta L2982 + 1
	sta L29b0 + 1
	sta L299d + 1
	lda L1c47
	sbc #$00
	sta L1c47
	sta L2982 + 2
	sta L29b0 + 2
	sta L299d + 2
	ldx #$01
L2982
	lda L2982,x
	pha
	dex
	bpl L2982
	jsr S2d9e
	ldx L27e4
	ldy L27e5
	jsr S32ff
	bcc L29ad
	sta L29ac
	ldx #$00
L299c
	pla
L299d
	sta L299d,x
	inx
	cpx #$02
	bne L299c
	sec
	lda L29ac
	jmp L2a2c
	
L29ac
	.byte $00
L29ad
	ldx #$00
L29af
	pla
L29b0
	sta L29b0,x
	inx
	cpx #$02
	bne L29af
	lda L1c42
	cmp #$84
	bne L29c2
	jsr S2dde
L29c2
	lda L1c50
	beq L29ca
	jmp L2942
	
L29ca
	lda L1c42
	cmp #$84
	bne L2a26
	lda L2d4c
	sta L2d4d
	lda #$00
	sta L2eb8
L29dc
	jsr S273f
	jsr S2e8c
	jsr S2890
	inc L2eb8
	dec L2d4c
	bne L29dc
	jsr S2e15
	lda #$00
	sta L2eb8
	lda L3404
	sta L1c53
	lda L3405
	sta L1c54
	lda L2d4d
	sta L1c55
L2a07
	lda L2eb8
	asl a
	tay
	lda L3404,y
	sta L27e2
	iny
	lda L3404,y
	sta L27e3
	jsr S2bac
	bcs L2a2c
	inc L2eb8
	dec L2d4d
	bne L2a07
L2a26
	jsr S2be6
	clc
	lda #$00
L2a2c
	php
	pha
	lda L1c46
	clc
	adc #$02
	sta L1c46
	lda L1c47
	adc #$00
	sta L1c47
	jsr S332d
	pla
	lda #$80
	plp
	rts
	
L2a47
	jsr S3319
	jsr S2199
	lda #$2b
	sta L2c4f
	lda #$ab
	sta L2c4e
	lda L1c51
	sta $2f
	sta L1c50
	lda L1c52
	sta $30
L2a64
	jsr S2ebc
	lda L1c46
	sta $03
	sta L2ab6 + 1
	sta L2a96 + 1
	sta L2ad2 + 1
	sta L2abf + 1
	sta L2aab + 1
	lda L1c47
	sta $04
	sta L2ab6 + 2
	sta L2a96 + 2
	sta L2ad2 + 2
	sta L2abf + 2
	sta L2abf + 2
	sta L2aab + 2
	ldy #$fe
	ldx #$02
L2a96
	lda L2a96,y
	pha
	iny
	dex
	bne L2a96
	jsr L1c83
	jsr S1d66
	bcc L2ab4
	ldx #$02
	ldy #$ff
L2aaa
	pla
L2aab
	sta L2ad2,y
	dey
	dex
	bne L2aaa
	bcs L2ae1
L2ab4
	ldy #$fe
L2ab6
	lda L2ab6,y
	sta $2f
	sta L1c50
	iny
L2abf
	lda L2abf,y
	sta $30
	sta L1c57
	sta L1c43
	dec L1c43
	ldx #$02
	ldy #$ff
L2ad1
	pla
L2ad2
	sta L2ad2,y
	dey
	dex
	bne L2ad1
	lda $2f
	beq L2ae0
	jmp L2a64
	
L2ae0
	clc
L2ae1
	jsr S332d
	rts
	
L2ae5
	jsr S3319
	lda $2f
	pha
	lda $30
	pha
	jsr S2199
	lda L1c51
	sta $2f
	lda L1c52
	sta $30
L2afb
	lda #$50
	sta $04
	lda #$00
	sta $03
	jsr S2eb9
	sta L2baa
	jsr L1c83
	jsr S1d66
	bcs L2b41
	lda L1c46
	sta L2b21 + 1
	lda L1c47
	sta L2b21 + 2
	ldy L1c43
	dey
L2b21
	lda L2b21,y
	cmp $5000,y
	bne L2b41
	dey
	cpy #$ff
	bne L2b21
	lda $5000,y
	sta $30
	dey
	lda $5000,y
	sta $2f
	lda L2baa
	beq L2b5d
	jmp L2afb
	
L2b41
	sec
	lda L2c4e
	sta L2b50 + 1
	lda L2c4f
	sta L2b50 + 2
	lda #$00
L2b50
	sta L2b50
L2b53
	pla
	sta $30
	pla
	sta $2f
	jsr S332d
	rts
	
L2b5d
	lda L1c42
	cmp #$84
	clc
	bne L2b53
	lda L1c53
	sta $2f
	lda L1c54
	sta $30
	lda #$34
	sta L2b89 + 2
L2b74
	lda #$50
	sta $04
	lda #$00
	sta $03
	jsr L1c83
	jsr S1d66
	bcs L2b41
	ldy #$00
L2b86
	lda $5000,y
L2b89
	cmp L3402,y
	bne L2b41
	iny
	cpy #$fe
	bne L2b86
	inc L2b89 + 2
	dec L1c55
	clc
	beq L2b53
	lda $5000,y
	sta $2f
	iny
	lda $5000,y
	sta $30
	jmp L2b74
	
L2baa
	.byte $00
L2bab
	.byte $00
S2bac
	lda $31
	pha
	lda $32
	pha
	lda #$00
	sta $31
	lda #$34
	sta $32
	ldy #$03
	lda L1c44
	ldx #$04
L2bc1
	sta ($31),y
	inc $32
	dex
	bne L2bc1
	pla
	sta $32
	pla
	sta $31
	lda #$34
	clc
	adc L2eb8
	sta L1c47
	lda #$00
	sta L1c46
	ldx L27e2
	ldy L27e3
	jsr S32ff
	rts
	
S2be6
	lda L2c4e
	sta S2c48 + 1
	lda L2c4f
	sta S2c48 + 2
	ldy #$00
	lda L1c42
	jsr S2c48
	lda L1c51
	jsr S2c48
	lda L1c52
	jsr S2c48
	ldx #$10
L2c08
	lda L1c2f,y
	jsr S2c48
	bne L2c08
	lda L1c42
	cmp #$84
	bne L2c2b
	ldy #$13
	lda L3404
	jsr S2c48
	lda L3405
	jsr S2c48
	lda L1c44
	jsr S2c48
L2c2b
	ldy #$1c
	lda L2d46
	jsr S2c48
	lda L2d47
	jsr S2c48
	lda $91fd
	ldy #$16
	jsr S2c48
	lda $91f8
	jsr S2c48
	rts
	
S2c48
	sta $3d00,y
	iny
	dex
	rts
	
L2c4e
	.byte $00
L2c4f
	.byte $00
S2c50
	lda #$00
	sta L2c7f + 1
	lda #$3d
	sta L2c7f + 2
	lda L27e2
	sta L2d44
	lda L27e3
	sta L2d45
	lda #$12
	sta L27e2
	sec
	sbc $3a48
	sta L2d31
	ldx #$00
	stx L2d30
	inx
	stx L27e3
L2c7b
	ldy #$02
	ldx #$08
L2c7f
	lda L2c7f,y
	beq L2cab
	tya
	clc
	adc #$20
	tay
	dex
	bne L2c7f
	inc L2d30
	lda L2d30
	cmp L2d31
	beq L2cbe
	ldx L2d30
	lda L2d32,x
	sta L27e3
	tax
	dex
	txa
	clc
	adc #$3d
	sta L2c7f + 2
	bne L2c7b
L2cab
	tya
	clc
	adc L2c7f + 1
	sta L2c4e
	lda L2c7f + 2
	adc #$00
	sta L2c4f
	clc
	bcc L2cc6
L2cbe
	lda L2d31
	cmp #$12
	bne L2cd3
	sec
L2cc6
	lda L2d44
	sta L27e2
	lda L2d45
	sta L27e3
	rts
	
L2cd3
	inc L2d31
	lda L2c7f + 1
	sta L2cf8 + 1
	lda L2c7f + 2
	sta L2cf8 + 2
	ldx L2d30
	lda L2d32,x
	sta L27e3
	jsr S2890
	inc L1c4e
	bne L2cf6
	inc L1c4f
L2cf6
	ldx #$01
L2cf8
	sta L2cf8,x
	lda L27e2
	dex
	bpl L2cf8
	ldx L27e3
	dex
	txa
	clc
	adc #$3d
	sta L2c7f + 2
	sta L2d20 + 2
	sta L2d29 + 2
	lda #$00
	sta L2c7f + 1
	sta L2d20 + 1
	sta L2d29 + 1
	ldy #$00
	tya
L2d20
	sta L2d20,y
	iny
	bne L2d20
	iny
	lda #$ff
L2d29
	sta L2d29,y
	jmp L2c7b
	
	.byte $00
L2d30
	.byte $00
L2d31
	.byte $00
L2d32	 
    .byte $01,$04,$07,$0a,$0d,$10,$02,$05,$08,$0b,$0e,$11,$03,$06,$09,$0c
    .byte $0f,$12 
L2d44
	.byte $00
L2d45
	.byte $00
L2d46
	.byte $00
L2d47
	.byte $00,$00,$00,$00,$00 
L2d4c
	.byte $00
L2d4d
	.byte $00
L2d4e
	.byte $00
S2d4f
	ldy #$00
	lda #$01
	sta L2d4e
	lda #$04
	sta L2d68 + 1
	lda #$3a
	sta L2d68 + 2
	lda #$00
	sta L1c4e
	sta L1c4f
L2d68
	lda $3a04,y
	clc
	adc L1c4e
	sta L1c4e
	lda L1c4f
	adc #$00
	sta L1c4f
L2d7a
	lda L2d68 + 1
	clc
	adc #$04
	sta L2d68 + 1
	lda L2d68 + 2
	adc #$00
	sta L2d68 + 2
	inc L2d4e
	lda L2d4e
	cmp #$12
	beq L2d7a
	cmp #$35
	beq L2d7a
	cmp #$47
	bne L2d68
	rts
	
S2d9e
	tya
	pha
	lda L1c46
	sta L2dc6 + 1
	lda L1c47
	sta L2dc6 + 2
	lda L1c50
	beq L2dbb
	lda L27e2
	pha
	lda L27e3
	jmp L2dc4
	
L2dbb
	lda #$00
	pha
	inc L1c43
	lda L1c43
L2dc4
	ldy #$01
L2dc6
	sta L2dc6,y
	pla
	dey
	bpl L2dc6
	tay
	rts
	
S2dcf
	lda L2e13
	ldx L2e14
	ldy #$f0
	jsr S285b
	sta L2d4c
	rts
	
S2dde
	jsr S2dcf
	inc L2d4c
	clc
	adc #$34
	sta L2df5 + 2
	lda #$10
	sta L2df5 + 1
	ldx #$01
	iny
L2df2
	lda L27e4,x
L2df5
	sta L3410,y
	dey
	dex
	bpl L2df2
	lda L1c50
	beq L2e12
	lda L2e13
	clc
	adc #$02
	sta L2e13
	lda L2e14
	adc #$00
	sta L2e14
L2e12
	rts
	
L2e13
	.byte $00
L2e14
	.byte $00
S2e15
	lda #$34
	clc
	adc #$05
	sta L2e25 + 2
	lda #$02
	sta L2e25 + 1
	ldx #$05
L2e24
	txa
L2e25
	sta L3402
	dec L2e25 + 2
	dex
	bpl L2e24
	jsr S2dcf
	clc
	adc #$34
	sta L2e45 + 2
	lda #$00
	sta L2e45 + 1
	iny
	tya
	clc
	adc #$10
	ldy #$01
	ldx #$01
L2e45
	sta L3400,y
	dey
	lda #$00
	dex
	bpl L2e45
	lda L2d4c
	beq L2e8b
L2e53
	dec L2d4c
	lda L2d4c
	clc
	adc #$34
	sta L2e7f + 2
	lda #$00
	sta L2e7f + 1
	lda L2d4c
	clc
	adc #$01
	asl a
	clc
	adc #$04
	sta L2e7c + 1
	lda #$34
	adc #$00
	sta L2e7c + 2
	ldy #$00
	ldx #$01
L2e7c
	lda L3404,y
L2e7f
	sta L3400,y
	iny
	dex
	bpl L2e7c
	lda L2d4c
	bne L2e53
L2e8b
	rts
	
S2e8c
	lda #$34
	sta L2ea6 + 2
	lda #$04
	sta L2ea6 + 1
	lda #$06
	sta L2eb7
	lda L2eb8
	asl a
	tay
L2ea0
	iny
	ldx #$01
L2ea3
	lda L27e2,x
L2ea6
	sta L3404,y
	dey
	dex
	bpl L2ea3
	inc L2ea6 + 2
	iny
	dec L2eb7
	bne L2ea0
	rts
	
L2eb7
	.byte $00
L2eb8
	.byte $00
S2eb9
	jmp (L1c48)
	
S2ebc
	jmp (L1c4a)
	
L2ebf
	jsr S3319
	ldy #$00
	tya
L2ec5
	sta $3b00,y
	sta $3a00,y
	iny
	bne L2ec5
	lda #$3c
	sta $04
	sta L2f3f + 2
	sta L2f48 + 2
	sta L2f03 + 2
	sta L2f51 + 2
	lda #$02
	sta $03
	sta L2f3f + 1
	sta L2f03 + 1
	sta L2f51 + 1
	lda #$00
	sta L2f48 + 1
	lda #$12
	sta $2f
	sta L1f9c
	lda #$00
	sta L1f9d
	sta L27e6
	sta $30
L2f01
	ldy #$fe
L2f03
	lda $3c00,y
	pha
	iny
	bne L2f03
	lda #$08
	sta L3059
L2f0f
	jsr L1f5b
	jsr S1c7d
	sta L27e6
	and #$fe
	beq L2f3d
	ldy L3059
	dey
	lda $2f
	pha
	lda $30
	pha
	lda L3051,y
	sta $2f
	lda #$00
	sta $30
	jsr S1cb2
	pla
	sta $30
	pla
	sta $2f
	dec L3059
	bne L2f0f
L2f3d
	ldy #$fe
L2f3f
	lda $3c00,y
	pha
	iny
	bne L2f3f
	iny
L2f47
	pla
L2f48
	sta $3c00,y
	dey
	bpl L2f47
	ldy #$ff
L2f50
	pla
L2f51
	sta $3c00,y
	dey
	cpy #$fd
	bne L2f50
	lda #$02
	sta $03
	lda #$12
	sta $2f
	inc L1f9d
	ldy L1f9d
	lda L303e,y
	sta $30
	clc
	adc #$3c
	sta L2f48 + 2
	sta L2f3f + 2
	sta L2f51 + 2
	sta L2f03 + 2
	sta $04
	lda L27e6
	and #$fe
	beq L2f87
	jmp L3026
	
L2f87
	cpy #$13
	beq L2f8e
	jmp L2f01
	
L2f8e
	lda #$00
	sta L1c9c
	lda L1c9b
	beq L2fdf
	lda $3c03
	and #$80
	beq L2fdf
	lda #$3b
	sta L1c9c
	sta $04
	lda #$00
	sta $03
	lda #$35
	sta $2f
	sta L1f9c
	ldy #$08
	sty L3059
	lda #$00
	sta $30
L2fba
	jsr L1f5b
	jsr S1c7d
	ora L27e6
	sta L27e6
	and #$fe
	beq L2fcf
	dec L3059
	bne L2fba
L2fcf
	ldx #$69
	ldy #$fe
L2fd3
	lda $3b00,y
	sta $3b00,x
	inx
	iny
	cpy #$69
	bne L2fd3
L2fdf
	ldy #$00
L2fe1
	lda $3c00,y
	sta $3a00,y
	iny
	bne L2fe1
	ldy #$dd
	ldx #$00
L2fee
	lda $3c00,y
	sta $3a90,x
	inx
	inx
	inx
	inx
	iny
	bne L2fee
	ldx #$00
	ldy #$00
L2fff
	lda $3b69,y
	sta $3a91,x
	lda $3b6a,y
	sta $3a92,x
	lda $3b6b,y
	sta $3a93,x
	inx
	inx
	inx
	inx
	iny
	iny
	iny
	cpy #$69
	bne L2fff
	lda #$00
	ldx #$1c
L3020
	sta $3b00,x
	inx
	bne L3020
L3026
	jsr S2d4f
	jsr S3359
	lda #$00
	sta L1f9c
	lda L27e6
	and #$fe
	sec
	bne L303a
	clc
L303a
	jsr S332d
	rts
	
L303e		
	.byte $00,$0a,$01,$0b,$02,$0c,$03,$0d,$04,$0e,$05,$0f,$06,$10,$07,$11 
    .byte $08,$12,$09 
L3051
	.byte $5f,$62,$5d,$64,$5c,$63,$5e,$61 
L3059
	.byte $00
S305a
	jsr S3319
	ldy #$00
L305f
	lda $3a00,y
	sta $3c00,y
	iny
	cpy #$90
	bne L305f
	ldx #$00
	ldy #$00
L306e
	lda $3a91,x
	sta $3b69,y
	lda $3a92,x
	sta $3b6a,y
	lda $3a93,x
	sta $3b6b,y
	inx
	inx
	inx
	inx
	iny
	iny
	iny
	cpy #$69
	bne L306e
	ldx #$00
	ldy #$00
L308f
	lda $3a90,x
	sta $3cdd,y
	iny
	inx
	inx
	inx
	inx
	cpy #$23
	bne L308f
	ldy #$00
L30a0
	lda $3b69,y
	sta $3b00,y
	iny
	cpy #$69
	bne L30a0
	lda #$00
L30ad
	sta $3b00,y
	iny
	bne L30ad
	lda #$12
	sta $2f
	lda #$00
	sta L27e7
	sta L3188
L30bf
	ldy L3188
	iny
	sty L3188
	cpy #$14
	beq L30e4
	dey
	lda L303e,y
	sta $30
	clc
	adc #$3c
	sta $04
	lda #$00
	sta $03
	jsr L1c80
	jsr S1d66
	bcc L30bf
	jmp L3184
	
L30e4
	lda L1c9b
	beq L3132
	lda L1c9c
	beq L3132
	lda #$00
	sta $03
	lda #$3b
	sta $04
	lda #$35
	sta $2f
	lda #$00
	sta $30
	jsr L1c80
	jsr S1d66
	bcs L3184
	lda #$35
	sta $2f
	lda #$00
	sta L27e7
	sta $30
	lda #$00
	sta $03
	lda #$50
	sta $04
	jsr L1c83
	jsr S1d66
	bcs L3184
	ldy #$00
L3123
	lda $3b00,y
	dey
	dey
	cmp $5000,y
	bne L317e
	iny
	iny
	iny
	bne L3123
L3132
	lda #$12
	sta $2f
	lda #$00
	sta L27e7
	sta L3188
L313e
	ldy L3188
	iny
	sty L3188
	cpy #$14
	beq L3183
	dey
	lda L303e,y
	sta $30
	clc
	adc #$3c
	sta L316c + 2
	lda #$00
	sta $03
	lda #$50
	sta $04
	lda #$00
	sta L316c + 1
	jsr L1c83
	jsr S1d66
	bcs L3184
	ldy #$00
L316c
	lda $3c00,y
	dey
	dey
	cmp $5000,y
	bne L317e
	iny
	iny
	iny
	bne L316c
	jmp L313e
	
L317e
	sec
	jsr S332d
	rts
	
L3183
	clc
L3184
	jsr S332d
	rts
	
L3188
	.byte $00
S3189
	jsr S3319
	lda #$00
	tay
L318f
	sta $3c00,y
	sta $3a00,y
	sta $3b00,y
	iny
	bne L318f
	lda #$15
	sta L32d3
	lda #$1f
	sta L32d6
	ldx #$01
	lda #$12
	sta $3a00
	lda #$01
	sta $3a01
	lda #$41
	sta $3a02
	lda #$00
	sta $3a03
	lda #$3a
	sta L31e9 + 2
	sta L31ec + 2
	lda #$04
	sta L31e9 + 1
	sta L31ec + 1
	lda L1c9b
	beq L31e4
	lda L1c9c
	beq L31e4
	lda #$3a
	sta L31ec + 2
	lda #$90
	sta L31ec + 1
	lda #$80
	sta $3a03
L31e4
	ldy #$00
L31e6
	lda L32d3,y
L31e9
	sta $3a04,y
L31ec
	sta $3a90,y
	iny
	cpy #$04
	bne L31e6
	lda L31e9 + 1
	clc
	adc #$04
	sta L31e9 + 1
	lda L31e9 + 2
	adc #$00
	sta L31e9 + 2
	lda L31ec + 1
	clc
	adc #$04
	sta L31ec + 1
	lda L31ec + 2
	adc #$00
	sta L31ec + 2
	inx
	cpx #$12
	bne L3227
	lda #$13
	sta L32d3
	lda #$07
	sta L32d6
	bne L31e4
L3227
	cpx #$19
	bne L3237
	lda #$12
	sta L32d3
	lda #$03
	sta L32d6
	bne L31e4
L3237
	cpx #$1f
	bne L3247
	lda #$11
	sta L32d3
	lda #$01
	sta L32d6
	bne L31e4
L3247
	cpx #$24
	bne L31e4
	lda #$00
	ldy #$03
L324f
	sta $3ad4,y
	dey
	bpl L324f
	ldx #$10
	ldy #$00
L3259
	lda L1c20,y
	sta $3c90,y
	iny
	dex
	bne L3259
	ldx #$02
	lda #$a0
	ldy #$00
L3269
	sta $3ca0,y
	iny
	dex
	bne L3269
	lda L1c30
	sta $3ca2
	lda L1c31
	sta $3ca3
	lda #$a0
	sta $3ca4
	lda #$32
	sta $3ca5
	lda #$41
	sta $3ca6
	ldx #$04
	ldy #$00
	lda #$a0
L3291
	sta $3ca7,y
	iny
	dex
	bne L3291
	ldx #$12
	ldy #$00
	lda #$3d
	sta L32a7 + 2
	lda #$00
	sta L32a7 + 1
	tya
L32a7
	sta $3d00,y
	iny
	bne L32a7
	inc L32a7 + 2
	dex
	bne L32a7
	lda #$ff
	sta $3d01
	lda #$11
	sta $3a48
	lda #$fc
	sta $3a49
	jsr S2d4f
	jsr S332d
	lda #$01
	sta L27e2
	lda #$00
	sta L27e3
	rts
	
L32d3
	.byte $15 
L32d4
	.byte $ff 
L32d5
	.byte $ff 
L32d6
	.byte $1f 
S32d7
	lda #$34
	sta L32f2 + 2
	lda #$00
	sta L32f2 + 1
	ldx #$06
	ldy #$00
	sty L2eb7
	sty L2eb8
	sty L2e13
	sty L2e14
	tya
L32f2
	sta L3400,y
	iny
	bne L32f2
	inc L32f2 + 2
	dex
	bne L32f2
	rts
	
S32ff
	lda L1c46
	sta L3316
	lda L1c47
	sta L3317
	stx L3314
	sty L3315
	jsr L1c8f
L3314
	.byte $00
	
L3315
	.byte $00
L3316
	.byte $00
L3317
	.byte $00,$60 
S3319
	php
	pha
	tya
	pha
	ldy #$03
L331f
	lda $0031,y
	sta L3355,y
	dey
	bpl L331f
	pla
	tay
	pla
	plp
	rts
	
S332d
	php
	pha
	tya
	pha
	ldy #$03
L3333
	lda L3355,y
	sta $0031,y
	dey
	bpl L3333
	lda L1ebd
	beq L3350
	ldy #$0a
	lda #$20
	sty $d600
L3348
	bit $d600
	bpl L3348
	sta $d601
L3350
	pla
	tay
	pla
	plp
	rts
	
L3355
	.byte $00,$00,$00,$00 
S3359
	lda #$00
	sta L33a4
	lda $3a49
	jsr S337b
	lda #$08
	sta L33a3
	lda $3a4a
	jsr S337b
	lda #$10
	sta L33a3
	lda $3a4b
	jsr S337b
	rts
	
S337b
	sta L33a4
	lda L33a3
	clc
	adc #$3c
	sta $04
	lda #$00
	sta $03
L338a
	lda L33a4
	bne L3390
	rts
	
L3390
	clc
	ror a
	sta L33a4
	bcc L339f
	ldy #$00
	tya
L339a
	sta ($03),y
	iny
	bne L339a
L339f
	inc $04
	bne L338a
L33a3
	.byte $00
	
L33a4
	.byte $00
	.text "ar"
	.byte $00
	.text "{$18}dalexf"
    .byte $00 
	.text "{green}data2 {red}{$01}datcel'>datntf"
	.byte $00
	.text "{$04}datove"
    .byte $00 
	.text "{$0a}dbaval{red}ndbchke"
    .byte $00 
	.text "{$05}dbdstr([dbid  "
    .byte $00 
	.text "gdbmhdr"
	.byte $00,$ee,$44,$44,$52,$41 
L33fd
	.byte $32,$20 
L33ff			
    .byte $1c 
L3400
	.byte $03,$44 
L3402
	.byte $45,$41 
L3404
	.byte $4c 
L3405	          
    .byte $43,$4e,$80,$84,$44,$45,$41,$4c,$52,$4e,$80 
L3410
	.byte $81,$44,$45,$43,$42,$41,$56,$28,$ea,$44,$45,$4c,$41,$59,$20,$21

 
