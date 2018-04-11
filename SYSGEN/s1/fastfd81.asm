;fastfd81.r.prg

	.include "../../include/kernal.asm"

	*=$1c20 ;$4000 for SYSGEN
	
L1c20	.text "fastcopy"
	.byte $a0, $a0 ; shift-space
	.text "00/ 00011234567890123456"
L1c42	.byte $84, $fe, $ff, $00, $00, $00, $48
	.byte $1c, $4a, $1c, $00, $3b, $58, $0c
	.byte $00, $00, $00, $00, $00, $00, $00
	.byte $00, $0d
L1c59	jmp L1cf2
	
L1c5c	jmp L1ea4
	
L1c5f	jmp L2eef
	
L1c62	jmp L1dba
	
L1c65	jmp L2e6a
	
L1c68	jmp L1d24
	
L1c6b	jmp S1cff
	
L1c6e	jmp L26cd
	
L1c71	jmp L2901
	
L1c74	jmp L299f
	
S1c77	jmp S1fae
	
S1c7a	jmp L1fdd
	
S1c7d	jmp L1fbd
	
L1c80	jmp L1f88
	
S1c83	jmp L1f45
	
S1c86	jmp L1c9e
	
S1c89	jmp L1cac
	
L1c8c	jmp L1cca
	
S1c8f	jmp L1cde
	
L1c92	jmp S25d0
	
L1c95	jmp S20a5
	
L1c98	jmp S2084
	
L1c9b	.byte 00, 00, 00
L1c9e	jsr S1c89
	bne L1cab
	lda #$03
	jsr S1c7a
	jsr S1d42
L1cab	rts
	
L1cac	sta $2f
	lda #$04
	sta $30
	lda #$04
	jsr S1c7a
	jsr S1c77
	lda L1c20 + 16
	jsr S1c7a
	lda L1c20 + 17
	jsr S1c7a
	jsr S1d42
	rts
	
L1cca	jsr S1d5b
	lda $1c46
	sta $03
	lda $1c47
	sta $04
	jsr S1c83
	jsr S1d42
	rts
	
L1cde	jsr S1d5b
	lda $1c46
	sta $03
	lda $1c47
	sta $04
	jsr L1c80
	jsr S1d42
	rts
	
L1cf2	jsr S3083
	jsr S1df8
	jsr S1d42
	jsr S3097
	rts
	
S1cff	jsr S3083
	lda #$01
	sta $1d41
L1d07	lda $1d41
	cmp #$51
	bne L1d13
	lda #$00
	clc
	beq L1d20
L1d13	jsr S1c86
	bne L1d20
	jsr S1ecb
	inc $1d41
	bne L1d07
L1d20	jsr S3097
	rts
	
L1d24	jsr S1cff
	bne L1d40
	jsr S3083
	php
	jsr L2eef
	jsr L2e6a
	lda #$00
	plp
	jsr S3097
	beq L1d3d
	lda #$ff
L1d3d	ora $25cf
L1d40	rts
	
	.byte $00
S1d42	jsr S1c7d
	tay
	lda L1d4e,y
	clc
	beq L1d4d
	sec
L1d4d	rts
	
L1d4e	.byte $00, $00
L1d50	.byte $14, $15, $16, $17, $00, $19, $1a, $1b, $00, $1d, $0c
S1d5b	pla
	tax
	pla
	tay
	pla
	sta L1d75 + 1
	pla
	sta L1d75 + 2
	inc L1d75 + 1
	bne L1d6f
	inc L1d75 + 2
L1d6f	tya
	pha
	txa
	pha
	ldy #$00
L1d75	lda L1d75,y
	cpy #$00
	beq L1d89
	cpy #$01
	beq L1d8d
	cpy #$02
	beq L1d92
	sta $1c47
	bne L1d98
L1d89	sta $2f
	bne L1d95
L1d8d	sta $30
	jmp L1d95
	
L1d92	sta $1c46
L1d95	iny
	bne L1d75
L1d98	lda #$03
	clc
	adc L1d75 + 1
	sta L1d75 + 1
	lda #$00
	adc L1d75 + 2
	sta L1d75 + 2
	pla
	tax
	pla
	tay
	lda L1d75 + 2
	pha
	lda L1d75 + 1
	pha
	tya
	pha
	txa
	pha
	rts
	
L1dba	jsr L2eef
	lda #$28
	jsr S1c89
	lda #$08
	jsr S1c7a
	ldx #$08
L1dc9	stx $1df7
	jsr S1c7d
	ldx $1df7
	sta L1dee,x
	dex
	bpl L1dc9
	lda L1dee
	beq L1ddf
	sec
	rts
	
L1ddf	lda $1def
	sta L1c20 + 16
	lda $1df0
	sta L1c20 + 17
	jmp L2da6
	
L1dee	.byte 00, 00, 00, 00, 00, 00, 00, 00, 00, 00
S1df8	sta $1e3d
	jsr S3083
	lda $9e43
	sta $1ec9
	lda $8008
	pha
	sta $1ea3
	jsr S1ec5
	pla
	beq L1e1a
	lda $ff00
	pha
	and #$cf
	sta $ff00
L1e1a	lda #$00
	sta $d030
	lda $d030
	and #$03
	beq L1e29
	jsr S3125
L1e29	lda $d7
	and #$80
	bne L1e2f
L1e2f	jsr CLRCHN
	jsr CLALL
	lda #$00
	jsr SETNAM
	lda #$02
	ldx #$08
	ldy #$0f
	jsr SETLFS
	jsr OPEN
	lda #$2e
	sta $33
	lda #$21
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
L1e65	jsr CHRIN
	cmp #$0d
	bne L1e65
	ldx #$02
	jsr CHKOUT
	jsr S20b1
	jsr CLRCHN
	lda #$00
	sta $98
	jsr S1ec2
	lda $8008
	beq L1e91
	pla
	sta $ff00
	lda #$03
	sta $1e96
	lda #$0a
	sta $1e97
L1e91	jsr S3097
	nop
	lda $02a6
	beq L1ea2
	inc $202f
	lda #$60
	sta $1e94
L1ea2	rts
	
	.byte 00
L1ea4	jsr S3083
	lda $9e43
	sta $1ec9
	jsr S1ec5
	jsr S20a5
	lda #$f1
	jsr S1c7a
	jsr S2084
	jsr S1ec2
	jsr S3097
	rts
	
S1ec2	lda #$34
	.byte $2c
S1ec5	lda #$3c
	sta $df03
	rts
	
S1ecb	jsr S1ef4
	lda S2084 + 1
	bne L1ef0
	lda $1f44
L1ed6	cmp $d012
	bne L1ed6
	ldx #$01
L1edd	dex
	bne L1edd
	inc $d020
	clc
	adc #$02
L1ee6	cmp $d012
	bne L1ee6
	ldx #$01
L1eed	dex
	bne L1eed
L1ef0	dec $d020
	rts
	
S1ef4	lda $2f
	sta $1f44
	clc
	ror a
	clc
	ror a
	adc $1f44
	clc
	adc $1f44
	sta $1f44
	lda #$b4
	sec
	sbc $1f44
	clc
	adc #$3d
	sta $1f44
	lda $8008
	beq L1f43
	ldx #$0a
	stx $d600
L1f1d	bit $d600
	bpl L1f1d
	lda #$00
	sta $d601
	ldx #$0e
	stx $d600
L1f2c	bit $d600
	bpl L1f2c
	sta $d601
	inx
	stx $d600
L1f38	bit $d600
	bpl L1f38
	ldx $2f
	dex
	stx $d601
L1f43	rts
	
	.byte $00
L1f45	lda #$01
	jsr L1fdd
	jsr S1fae
L1f4d	jsr L1fbd
	beq L1f79
	php
	and #$7f
	ldy #$00
	plp
	bpl L1f61
	tax
	dex
	txa
	ora #$80
	sta $30
L1f61	lda #$fe
	sta $2010
	jsr S2000
	lda $03
	clc
	adc #$fe
	sta $03
	lda #$00
	adc $04
	sta $04
	lda $30
	rts
	
L1f79	jsr L1fbd
	and #$7f
	sta $2f
	jsr S1ecb
	jmp L1f4d
	
	.byte $00, 00
L1f88	lda #$0d
	jsr L1fdd
	jsr S1fae
	jsr L1fbd
	lda #$00
	sta S203a + 1
	lda $04
	sta L2048 + 2
	lda $03
	sta L2048 + 1
	jsr S203a
	jsr S1ecb
	jsr L1fbd
	cmp #$00
	rts
	
S1fae	lda $2f
	ora #$80
	jsr L1fdd
	ldx $30
	inx
	txa
	jsr L1fdd
	rts
	
L1fbd	lda $03
	pha
	lda $04
	pha
	lda #$fd
	sta $2010
	lda #$31
	sta $04
	lda #$00
	sta $03
	jsr S2000
	pla
	sta $04
	pla
	sta $03
	lda L31f9 + 4
	rts
	
L1fdd	sta $31ff
	lda #$ff
	sta S203a + 1
	lda #$31
	sta L2048 + 2
	lda #$00
	sta L2048 + 1
	jsr S203a
	rts
	
L1ff3	.byte $27, $c6, $18, $10, $ca, $60, $48, $4a, $4a, $4a, $4a, $20, $04
S2000	lda #$17
	sta $dd00
L2005	bit $dd00
	bmi L2005
	lda #$07
	sta $dd00
	ldy #$fe
L2011	ldx #$04
L2013	bit $dd00
	bpl L2013
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
L2020	nop
	lda $dd00
	asl a
	rol $6b
	asl a
	rol $6b
	nop
	nop
	nop
	dex
	bne L2020
	lda $6b
	sta ($03),y
	iny
	cpy #$fe
	bne L2011
	rts
	
S203a	ldy #$00
	lda #$27
	sta $dd00
L2041	lda $dd00
	and #$40
	bne L2041
L2048	lda $31ff,y
	sta $6b
	tya
	pha
	ldx #$04
	lda #$07
	sta $dd00
L2056	lda #$00
	asl $6b
	rol a
	asl $6b
	rol a
	tay
	lda L2080,y
	sta $dd00
	dex
	bne L2056
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
	bne L2048
	lda #$07
	sta $dd00
	rts
	
L2080	.byte $07, $17, $27, $37
S2084	lda $1c9d
	sta $d030
	lda #$1b
	sta $d011
	lda $dd00
	ora #$03
	sta $dd00
	cli
	rts
	
S2099	sei
	lda #$0b
	sta $d011
	lda #$01
	sta $d030
	rts
	
S20a5	jsr S2099
	ldy #$20
L20aa	dex
	bne L20aa
	dey
	bne L20aa
	rts
	
S20b1	lda #$22
	sta $6b
	lda #$02
	sta L212b
	lda #$e2
	sta $212a
	ldy #$00
L20c1	lda #$1e
	clc
	adc $212a
	sta $212a
	lda #$00
	adc L212b
	sta L212b
	tya
	pha
	lda #$21
	sta $32
	lda #$27
	sta $31
	jsr S2103
	pla
	tay
	ldx #$1e
L20e3	lda ($33),y
	jsr CHROUT
	iny
	bne L20ed
	inc $34
L20ed	dex
	bne L20e3
	jsr S2117
	dec $6b
	bne L20c1
	lda #$21
	sta $32
	lda #$20
	sta $31
	jsr S2103
	rts
	
S2103	ldy #$00
L2105	lda ($31),y
	cmp #$a1
	beq L2116
	jsr CHROUT
	iny
	bne L2105
	inc $32
	jmp L2105
	
L2116	rts
	
S2117	jsr CLRCHN
	ldx #$02
	jsr CHKOUT
	rts
	
	.text "m-e"
L2123	.byte $00, $03, $0d, $a1
L2127	.byte $4d, $2d, $57, $00
	
L212b	.byte $03, $1e, $a1
L212e	jmp $048f
	
L2131	sei
	nop
	lda #$02
	nop
	sta $4001
L2139	nop
	lda $4001
	nop
	and #$04
	bne L2142
L2142	beq L2139
L2144	lda $0300
	nop
	nop
	sta $f4
	sta $f4
	nop
	ldx #$04
	nop
	lda #$00
	nop
	sta $4001
L2157	nop
	lda #$00
	php
	plp
	asl $f4
	rol a
	php
	plp
	asl $f4
	rol a
	nop
	tay
	nop
	nop
	lda $0370,y
	nop
	sta $4001
	nop
	dex
	beq L2173
L2173	bne L2157
	php
	plp
	php
	plp
	php
	plp
	php
	plp
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
	nop
	lda #$02
	nop
	sta $4001
	nop
	nop
	nop
	inc $0317
	beq L2194
L2194	bne L2144
	nop
	lda #$00
	nop
	sta $4001
	rts
	
L219e	.byte $0a, $02, $08, $00
L21a2	sei
	nop
	lda #$08
	nop
	sta $4001
L21aa	nop
	lda $4001
	nop
	and #$01
	bne L21b3
L21b3	beq L21aa
L21b5	nop
	lda #$00
	nop
	sta $4001
	nop
	nop
	nop
	ldx #$04
L21c1	nop
	lda $4001
	nop
	and #$01
	beq L21ca
L21ca	bne L21c1
	php
	plp
	php
	plp
	php
	plp
	php
	plp
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
L21dc	nop
	lda $4001
	nop
	and #$05
	nop
	tay
	nop
	nop
	lda $03e2,y
	php
	plp
	asl a
	rol $f4
	php
	plp
	asl a
	rol $f4
	nop
	dex
	beq L21f8
L21f8	bne L21dc
	lda $f4
	lda $f4
	nop
	nop
	sta $0300
	nop
	nop
	nop
	inc $03d3
	beq L220b
L220b	bne L21b5
	nop
	tay
	rts
	
L2210	.byte $00, $80, $00, $00, $40, $c0, $ff, $ff, $1c, $ff, $ff, $ff, $01, $01, $05, $15
	.byte $15, $15, $07, $15, $15, $15, $14, $15, $15, $14, $14, $14, $14, $00
L222e	sei
	lda #$02
	sta $4001
L2234	lda $4001
	and #$04
	beq L2234
L223b	lda $0300
	sta $f4
	ldx #$04
	lda #$00
	sta $4001
L2247	lda #$00
	asl $f4
	rol a
	asl $f4
	rol a
	tay
	lda $0443,y
	sta $4001
	dex
	bne L2247
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
	lda #$02
	sta $4001
	inc $040e
	bne L223b
	lda #$00
	sta $4001
	rts
	
L2271	.byte $0a, $02, $08, $00
L2275	sei
	lda #$08
	sta $4001
L227b	lda $4001
	and #$01
	beq L227b
L2282	lda #$00
	sta $4001
	nop
	ldx #$04
L228a	lda $4001
	and #$01
	bne L228a
	pha
	pla
	pha
	pla
	pha
	pla
	pha
	pla
L2299	lda $4001
	and #$05
	tay
	lda $0489,y
	asl a
	rol $f4
	asl a
	rol $f4
	dex
	bne L2299
	lda $f4
	sta $0300
	inc $0480
	bne L2282
	tay
	rts
	
L22b7	.byte $00, $80, $00, $00, $40, $c0
L22bd	lda #$c0
	ldx #$01
	ldy #$00
	stx $06f3
	sty $06f2
	jsr $04c4
	lda #$00
	sta $06f1
	lda #$60
	sta $8d
	lda #$94
	jsr $04c4
	ldx #$01
	ldy #$00
	sty $01fa
	jmp $0529
	
L22e4	lda #$96
	jsr $04c4
	lda #$86
	jsr $04c4
	cli
	jmp $ff06
	
L22f2	stx $15
	sty $16
	ldx #$05
	jmp $ff54
	
L22fb	sta $03ff
	dec $040e
	dec $0317
	jsr $0400
	rts
	
	.byte $ce, $80, $04
L230b	dec $03d3
L230e	jsr $0447
	tay
	rts
	
L2313	lda $06f5
	cmp #$05
	bne L2338
	lda #$06
	jsr $04cd
	lda #$02
	lda #$08
	sta $0481
	sta $03d4
	tya
	pha
	jsr $04e0
	pla
	tay
	lda #$03
	sta $0481
	sta $03d4
L2338	lda #$b6
	jsr $04c4
	beq L2344
	lda #$08
L2341	jmp $0525
	
L2344	lda #$90
	ldx $06f3
	ldy $06f2
	jsr $04c4
	bne L2341
	lda #$00
	sta $06f1
	rts
	
L2357	lda #$00
	sta $06f1
	lda $06f7
	sta $06f8
	lda $06f1
	jsr $04cd
	lda #$00
	sta $06f1
	sta $01fa
	jsr $04da
	cmp #$f1
	bne L237a
	jmp $ff06
	
L237a	cmp #$0d
	bne L2381
	jmp $069d
	
L2381	cmp #$04
	bne L239a
	jsr $06c6
	jsr $04da
	sta $1d
	jsr $04da
	sta $1e
	lda $06f3
	sta $06f7
	bne L2357
L239a	cmp #$03
	beq L23a1
	jmp $0605
	
L23a1	lda #$02
	sta $91
	lda #$01
	sta $94
	lda #$0a
	sta $92
	lda #$b6
	ldx $06f3
	ldy $06f2
	jsr $04c4
	beq L23c2
	lda #$08
	sta $06f1
	jmp $0534
	
L23c2	ldx $06f3
	dex
	bne L23cf
	lda #$c0
	jsr $04c4
	ldx #$00
L23cf	stx $6003
	lda $01db
	jsr $cbf4
	jsr $cbec
	ldx $06f3
	dex
	stx $6001
	jsr $cbd5
	ldx $06f3
	dex
	stx $88
	lda #$00
	sta $96
	lda #$00
	sta $9b
L23f3	lda $96
	sta $06f9
	lda $4000
	and #$fe
	ora $06f9
	sta $4000
	lda #$00
	sta $4a
	lda #$0c
	sta $4b
	jsr $c3d6
	bcs L2425
	php
	plp
	php
	plp
	jsr $cd3f
	bne L2427
	inc $96
	lda $96
	cmp #$02
	bne L23f3
	lda #$00
	beq L2427
L2425	lda #$06
L2427	sta $06f1
	ldx $06f3
	dex
	stx $88
	jmp $0534
	
L2433	cmp #$08
	bne L2457
	ldx #$01
	ldy #$01
	lda #$b0
	jsr $04c4
	sta $06f1
	ldx #$07
L2445	lda $1d,x
	sta $03ff
	txa
	pha
	jsr $04d0
	pla
	tax
	dex
	bpl L2445
	jmp $0534
	
L2457	jsr $06c6
	lda $06f7
	sta $06f6
	lda #$00
	jsr $04cd
	lda $06f7
	ora #$80
	jsr $04cd
	lda #$00
	sta $06f4
L2472	lda #$80
	ldx $06f3
	ldy $06f2
	jsr $04c4
	sta $06f1
	cmp #$02
	bcc L2486
	bne L2496
L2486	lda #$00
	sta $06f4
	beq L2496
L248d	ldx $06f2
	inx
	txa
	ora #$80
	bne L24a9
L2496	lda $06f4
	beq L24a4
	inc $06f4
	cmp #$10
	beq L248d
	bne L2472
L24a4	ldx $06f2
	inx
	txa
L24a9	jsr $04cd
	lda $06f2
	cmp #$14
	bcc L24b5
	sbc #$14
L24b5	clc
	adc #$0c
	sta $040f
	sta $0318
	jsr $04d6
	lda #$03
	sta $040f
	sta $0318
	bne L24f1
	jsr $06c6
	lda $06f7
	sta $06f6
	lda #$05
	sta $06f5
L24d9	jsr $04e5
	sta $06f1
	cmp #$02
	bcc L24ec
	dec $06f5
	bne L24d9
	lda #$05
	bne L24ee
L24ec	lda #$00
L24ee	jsr $04cd
L24f1	jmp $0534
	
L24f4	jsr $04da
	bmi L24fc
L24f9	jmp $0534
	
L24fc	and #$7f
	sta $06f3
	sta $06f7
	jsr $04da
	beq L24f9
	tax
	dex
	stx $06f2
	cpx #$28
	bcc L2517
L2512	lda #$02
	jmp $064f
	
L2517	lda $06f3
	cmp #$51
	bcs L2512
	rts
	
L251f	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00
S2528	lda #$3c
	sta $2550
L252d	ldy $25ca
	dey
	tya
	cmp #$28
	bcc L253f
	sbc #$28
	pha
	lda #$3d
	sta $2550
	pla
L253f	asl a
	sta $254f
	asl a
	clc
	adc $254f
	clc
	adc #$10
	sta $254f
	lda $3c10
	bne L2568
	lda #$00
	sta $25cb
L2558	inc $25ca
	lda $25ca
	cmp #$28
	beq L2558
	cmp #$51
	bne L252d
	sec
L2567	rts
	
L2568	lda $25ca
	sta $1c56
	lda $25cb
	sta $1c57
	jsr S259f
	bcs L259c
	jsr S25d0
	bne L2587
	lda $25ca
	sta $1c56
	lda $1c57
L2587	sta $25cb
	lda $25cb
	jsr S259f
	bcs L259c
	inc $25cb
	lda $25cb
	cmp #$28
	bne L2587
L259c	clc
	bcc L2567
S259f	pha
	ldy #$08
	lda $25cb
	ldx #$00
	jsr S260d
	sec
	adc $254f
	sta $25ba
	lda #$00
	adc $2550
	sta $25bb
	lda $3c10
L25bc	ror a
	dey
	bpl L25bc
	pla
	rts
	
L25c2	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
S25d0	lda $1c56
	beq L25e4
	inc $1c57
	lda $1c57
	cmp #$28
	beq L25e4
L25df	sta $1c57
	clc
	rts
	
L25e4	inc $1c56
	lda $1c56
	cmp #$51
	bcs L25f2
	lda #$00
	beq L25df
L25f2	dec $1c56
	lda $1c57
	rts
	
L25f9	lda L25c2
	sec
	sbc $25c4
	sta $25c6
	lda $25c3
	sbc $25c5
	sta $25c7
	rts
	
S260d	sta $2641
	stx $2640
	sty $263f
	lda #$00
	ldx #$10
L261a	clc
	rol $2641
	rol $2640
	rol a
	bcs L2629
	cmp $263f
	bcc L2634
L2629	sbc $263f
	inc $2641
	bne L2634
	inc $2640
L2634	dex
	bne L261a
	tay
	ldx $2640
	lda $2641
	rts
	
	.byte $00, $00, $00
S2642	php
	pha
	txa
	pha
	tya
	pha
	lda $31
	pha
	lda $32
	pha
	lda #$3c
	sta $2672
	ldy $25ca
	dey
	tya
	cmp #$28
	bcc L2665
	sbc #$28
	pha
	lda #$3d
	sta $2672
	pla
L2665	asl a
	sta $31
	asl a
	clc
	adc $31
	clc
	adc #$10
	sta $31
	lda #$3c
	sta $32
	ldy #$08
	lda $25cb
	ldx #$00
	jsr S260d
	sty $25c8
	ldx $25c8
	tay
	iny
	lda ($31),y
	clc
L268a	ror a
	dex
	bpl L268a
	ldx $25c8
	php
	clc
L2693	rol a
	dex
	bpl L2693
	sta ($31),y
	plp
	bcc L26a7
	ldy #$00
	lda ($31),y
	beq L26a7
	sec
	sbc #$01
	sta ($31),y
L26a7	sec
	lda $1c4e
	sbc #$01
	sta $1c4e
	lda $1c4f
	sbc #$00
	sta $1c4f
	inc $2bc1
	bne L26c0
	inc $2bc2
L26c0	pla
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
	
L26cd	jsr S3083
	jsr S2099
	jsr S2b5b
	bcc L26de
	jsr S3097
	lda #$ff
	rts
	
L26de	lda L1c42
	cmp #$84
	bne L26fd
	jsr S3041
	lda #$00
	sta L28fc
	sta $2b5a
	sta $28ff
	dec $28ff
	tay
L26f7	sta $3300,y
	iny
	bne L26f7
L26fd	jsr S2528
	lda $25ca
	sta $1c51
	lda $25cb
	sta $1c52
	lda #$00
	sta $2bc1
	sta $2bc2
L2714	jsr S2528
	jsr S2da0
	sta $1c50
	jsr S2642
	lda $25ca
	sta $25cc
	lda $25cb
	sta $25cd
	jsr S2528
	lda $1c46
	sec
	sbc #$02
	sta $1c46
	sta L2754 + 1
	sta $2783
	sta $2770
	lda $1c47
	sbc #$00
	sta $1c47
	sta L2754 + 2
	sta $2784
	sta $2771
	ldx #$01
L2754	lda L2754,x
	pha
	dex
	bpl L2754
	jsr S2c23
	ldx $25cc
	ldy $25cd
	jsr S3069
	bcc L277f
	sta $277e
	ldx #$00
L276e	pla
	sta $276f,x
	inx
	cpx #$02
	bne L276e
	sec
	lda $277e
	jmp L27ae
	
	.byte $00
L277f	ldx #$00
L2781	pla
	sta $2782,x
	inx
	cpx #$02
	bne L2781
	lda L1c42
	cmp #$84
	bne L2794
	jsr S2c63
L2794	lda $1c50
	beq L279c
	jmp L2714
	
L279c	lda L1c42
	cmp #$84
	bne L27a8
	jsr S27c9
	bcs L27ae
L27a8	jsr S2afc
	clc
	lda #$00
L27ae	php
	pha
	lda $1c46
	clc
	adc #$02
	sta $1c46
	lda $1c47
	adc #$00
	sta $1c47
	jsr S3097
	pla
	lda #$80
	plp
	rts
	
S27c9	lda $2bc7
	sta $2bc8
	lda #$00
	sta $2d9f
L27d4	jsr S2528
	jsr S2d73
	jsr S2642
	inc $2d9f
	dec $2bc7
	bne L27d4
	jsr S2cfc
	lda #$00
	sta $2d9f
	lda L3401 + 3
	sta $1c53
	ldy L28fc
	sta L3301 + 2,y
	iny
	lda L3401 + 4
	sta $1c54
	sta L3301 + 2,y
	iny
	sty L28fc
	lda $2bc8
	sta $1c55
L280d	lda $2d9f
	asl a
	tay
	lda L3401 + 3,y
	sta $25ca
	iny
	lda L3401 + 3,y
	sta $25cb
	jsr S2aad
	bcs L2888
	inc $2d9f
	dec $2bc8
	bne L280d
	lda $28ff
	bmi L288a
	lda $28ff
	sta $2f
	lda $2900
	sta $30
	lda #$35
	sta $04
	lda #$00
	sta $03
	jsr S1c83
	jsr S1d42
	bcs L2888
	lda $2b5a
	sec
	sbc $35fe
	sec
	sbc $35ff
	clc
	adc L3401 + 3
	clc
	adc L3401 + 4
	sta $2b5a
	ldy #$fe
L2863	lda $3500,y
	sta $3502,y
	dey
	cpy #$ff
	bne L2863
	lda L3401 + 3
	sta $3500
	lda L3401 + 4
	sta $3501
	lda #$00
	sta $03
	lda #$35
	sta $04
	jsr L1c80
	jsr S1d42
L2888	bcs L28fb
L288a	lda $25ca
	sta $28ff
	lda $25cb
	sta $2900
	clc
	lda $1c50
	bne L28fb
	jsr S2528
	jsr S2642
	ldx $25ca
	stx L3401 + 3
	lda #$fe
	sta L3301 + 1
	lda L3301 + 2
	sta $3300
	lda L3301 + 3
	sta L3301
	lda #$00
	sta $28d0
	sta $1c46
	lda #$33
	sta $28d1
	sta $1c47
	ldy #$00
	lda $2b5a
L28ce	clc
	adc $28cf,y
	iny
	bne L28ce
	sta $2b5a
	ldy $25cb
	jsr S3069
	lda L2b58
	sta $28f5
	lda $2b59
	sta $28f6
	ldy #$14
	ldx #$01
L28ee	lda $25ca,x
	sta $28fd,x
	sta $28f4,y
	dey
	dex
	bpl L28ee
L28fb	rts
	
L28fc	.byte $00, $00, $00, $00, $00
L2901	jsr S3083
	jsr S2099
	lda #$2a
	sta $2b59
	lda #$aa
	sta L2b58
	lda $1c51
	sta $2f
	sta $1c50
	lda $1c52
	sta $30
L291e	jsr S2da3
	lda $1c46
	sta $03
	sta $2971
	sta L2950 + 1
	sta $298d
	sta $297a
	sta $2966
	lda $1c47
	sta $04
	sta $2972
	sta L2950 + 2
	sta $298e
	sta $297b
	sta $297b
	sta $2967
	ldy #$fe
	ldx #$02
L2950	lda L2950,y
	pha
	iny
	dex
	bne L2950
	jsr S1c83
	jsr S1d42
	bcc L296e
	ldx #$02
	ldy #$ff
L2964	pla
	sta $298c,y
	dey
	dex
	bne L2964
	bcs L299b
L296e	ldy #$fe
	lda $2970,y
	sta $2f
	sta $1c50
	iny
	lda $2979,y
	sta $30
	sta $1c57
	sta $1c43
	dec $1c43
	ldx #$02
	ldy #$ff
L298b	pla
	sta $298c,y
	dey
	dex
	bne L298b
	lda $2f
	beq L299a
	jmp L291e
	
L299a	clc
L299b	jsr S3097
	rts
	
L299f	jsr S3083
	lda $2f
	pha
	lda $30
	pha
	jsr S2099
	lda $1c51
	sta $2f
	lda $1c52
	sta $30
L29b5	lda #$32
	sta $04
	lda #$00
	sta $03
	jsr S2da0
	sta L2aa9
	jsr S1c83
	jsr S1d42
	bcs L29fb
	lda $1c46
	sta L29db + 1
	lda $1c47
	sta L29db + 2
	ldy $1c43
	dey
L29db	lda L29db,y
	cmp $3200,y
	bne L29fb
	dey
	cpy #$ff
	bne L29db
	lda $3200,y
	sta $30
	dey
	lda $3200,y
	sta $2f
	lda L2aa9
	beq L2a17
	jmp L29b5
	
L29fb	sec
	lda L2b58
	sta $2a0b
	lda $2b59
	sta $2a0c
	lda #$00
	sta $2a0a
L2a0d	pla
	sta $30
	pla
	sta $2f
	jsr S3097
	rts
	
L2a17	lda L1c42
L2a1a	cmp #$84
	clc
	bne L2a0d
	lda $28fd
	sta $2f
	lda $28fe
	sta $30
	lda #$00
	sta $03
	lda #$33
	sta $04
	jsr S1c83
	jsr S1d42
	bcs L29fb
	lda #$00
	sta $2aab
	tay
	lda $2b5a
L2a42	sec
	sbc $3300,y
	iny
	bne L2a42
	sta $2b5a
L2a4c	ldy $2aab
	inc $2aab
	cpy #$0a
	beq L2a9e
	lda L3301,y
	beq L2a9e
	sta $2f
	inc $2aab
	lda L3301 + 1,y
	sta $30
	lda #$06
	sta $2aac
L2a6a	lda #$34
	sta $04
	lda #$00
	sta $03
	jsr S1c83
	jsr S1d42
	bcs L29fb
	lda $34fe
	sta $2f
	lda $34ff
	sta $30
	ldy #$00
	lda $2b5a
L2a89	sec
	sbc $3400,y
	iny
	bne L2a89
	sta $2b5a
	dec $2aac
	beq L2a4c
	lda $2f
	bne L2a6a
	beq L2a4c
L2a9e	lda $2b5a
	bne L2aa6
	jmp L2a1a
	
L2aa6	jmp L29fb
	
L2aa9	.byte $00, $00, $00, $00
S2aad	lda $31
	pha
	lda $32
	pha
	lda #$00
	sta $31
	lda #$34
	sta $32
	ldy #$03
	lda $1c44
	ldx #$04
L2ac2	sta ($31),y
	inc $32
	dex
	bne L2ac2
	pla
	sta $32
	pla
	sta $31
	lda #$34
	clc
	adc $2d9f
	sta $1c47
	sta $2aeb
	lda #$00
	sta $1c46
	sta $2aea
	ldy #$00
	lda $2b5a
L2ae8	clc
	adc $2ae9,y
	iny
	bne L2ae8
	sta $2b5a
	ldx $25ca
	ldy $25cb
	jsr S3069
	rts
	
S2afc	lda L2b58
	sta S2b52 + 1
	lda $2b59
	sta S2b52 + 2
	ldy #$00
	lda L1c42
	jsr S2b52
	lda $1c51
	jsr S2b52
	lda $1c52
	jsr S2b52
	ldx #$10
L2b1e	lda L1c20 + 15,y
	jsr S2b52
	bne L2b1e
	lda L1c42
	cmp #$84
	bne L2b35
	ldy #$15
	lda $1c44
	jsr S2b52
L2b35	ldy #$1c
	lda $2bc1
	jsr S2b52
	lda $2bc2
	jsr S2b52
	lda $91fd
	ldy #$16
	jsr S2b52
	lda $91f8
	jsr S2b52
	rts
	
S2b52	sta $3e00,y
	iny
	dex
	rts
	
L2b58	.byte $00, $00, $00
S2b5b	lda #$00
	sta L2b7f + 1
	lda #$3e
	sta L2b7f + 2
	lda $25ca
	sta $2bbf
	lda $25cb
	sta $2bc0
	lda #$28
	sta $25ca
	ldx #$03
	stx $25cb
L2b7b	ldy #$02
	ldx #$08
L2b7f	lda L2b7f,y
	beq L2b9b
	tya
	clc
	adc #$20
	tay
	dex
	bne L2b7f
	inc $25cb
	inc L2b7f + 2
	lda $25cb
	cmp #$28
	beq L2bae
	bne L2b7b
L2b9b	tya
	clc
	adc L2b7f + 1
	sta L2b58
	lda L2b7f + 2
	adc #$00
	sta $2b59
	clc
	bcc L2baf
L2bae	sec
L2baf	lda $2bbf
	sta $25ca
	lda $2bc0
	sta $25cb
	rts
	
L2bbc	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
S2bca	ldy #$00
	lda #$01
	sta $2bc9
	lda #$10
	sta L2be3 + 1
	lda #$3c
	sta L2be3 + 2
	lda #$00
	sta $1c4e
	sta $1c4f
L2be3	lda $3c10,y
	clc
	adc $1c4e
	sta $1c4e
	lda $1c4f
	adc #$00
	sta $1c4f
L2bf5	lda L2be3 + 1
	clc
	adc #$06
	sta L2be3 + 1
	lda L2be3 + 2
	adc #$00
	sta L2be3 + 2
	inc $2bc9
	lda $2bc9
	cmp #$28
	beq L2bf5
	cmp #$29
	bne L2c1e
	lda #$3d
	sta L2be3 + 2
	lda #$10
	sta L2be3 + 1
L2c1e	cmp #$51
	bne L2be3
	rts
	
S2c23	tya
	pha
	lda $1c46
	sta L2c4b + 1
	lda $1c47
	sta L2c4b + 2
	lda $1c50
	beq L2c40
	lda $25ca
	pha
	lda $25cb
	jmp L2c49
	
L2c40	lda #$00
	pha
	inc $1c43
	lda $1c43
L2c49	ldy #$01
L2c4b	sta L2c4b,y
	pla
	dey
	bpl L2c4b
	tay
	rts
	
S2c54	lda L2cfa
	ldx $2cfb
	ldy #$f0
	jsr S260d
	sta $2bc7
	rts
	
S2c63	jsr S2c54
	cmp #$06
	bcc L2cc8
	ldy #$00
	lda $1c46
	sta L2c78 + 1
	lda $1c47
	sta L2c78 + 2
L2c78	lda L2c78,y
	sta $3200,y
	iny
	bne L2c78
	lda $25cc
	pha
	lda $25cd
	pha
	jsr S27c9
	jsr S3041
	jsr S2528
	lda $25cb
	sta L3201
	lda $25ca
	sta $3200
	lda #$32
	sta $1c47
	lda #$00
	sta $1c46
	pla
	tay
	pla
	tax
	jsr S3069
	lda L2c78 + 1
	sta $1c46
	lda L2c78 + 2
	sta $1c47
	lda #$00
	sta $2bc7
	sta L2cfa
	sta $2cfb
	beq S2c63
L2cc8	inc $2bc7
	clc
	adc #$34
	sta $2cde
	lda #$10
	sta $2cdd
	ldx #$01
	iny
L2cd9	lda $25cc,x
	sta $3410,y
	dey
	dex
	bpl L2cd9
	lda $1c50
	beq L2cf9
	lda L2cfa
	clc
	adc #$02
	sta L2cfa
	lda $2cfb
	adc #$00
	sta $2cfb
L2cf9	rts
	
L2cfa	.byte $00, $00
S2cfc	lda #$34
	clc
	adc #$05
	sta $2d0e
	lda #$02
	sta $2d0d
	ldx #$05
L2d0b	txa
	sta L3401 + 1
	dec $2d0e
	dex
	bpl L2d0b
	jsr S2c54
	clc
	adc #$34
	sta L2d2c + 2
	lda #$00
	sta L2d2c + 1
	iny
	tya
	clc
	adc #$10
	ldy #$01
	ldx #$01
L2d2c	sta $3400,y
	dey
	lda #$00
	dex
	bpl L2d2c
	lda $2bc7
	beq L2d72
L2d3a	dec $2bc7
	lda $2bc7
	clc
	adc #$34
	sta $2d68
	lda #$00
	sta $2d67
	lda $2bc7
	clc
	adc #$01
	asl a
	clc
	adc #$04
	sta L2d63 + 1
	lda #$34
	adc #$00
	sta L2d63 + 2
	ldy #$00
	ldx #$01
L2d63	lda L3401 + 3,y
	sta $3400,y
	iny
	dex
	bpl L2d63
	lda $2bc7
	bne L2d3a
L2d72	rts
	
S2d73	lda #$34
	sta $2d8f
	lda #$04
	sta $2d8e
	lda #$06
	sta L2d9e
	lda $2d9f
	asl a
	tay
L2d87	iny
	ldx #$01
L2d8a	lda $25ca,x
	sta L3401 + 3,y
	dey
	dex
	bpl L2d8a
	inc $2d8f
	iny
	dec L2d9e
	bne L2d87
	rts
	
L2d9e	.byte $00, $00
S2da0	jmp ($1c48)
	
S2da3	jmp ($1c4a)
	
L2da6	jsr S3083
	lda #$3b
	sta L2db3 + 2
	ldy #$00
	ldx #$28
	tya
L2db3	sta $3b00,y
	iny
	bne L2db3
	inc L2db3 + 2
	dex
	bne L2db3
	lda #$28
	sta $2f
	sta $1f86
	lda #$00
	sta $1f87
	sta $25ce
	sta $30
	lda #$3e
	sta $2e0d
	lda #$3b
	sta $2ddf
L2dda	lda #$02
	sta $03
	lda #$3b
	sta $04
	jsr S1c83
	jsr S1d42
	ora $25ce
	sta $25ce
	inc $2ddf
	inc $30
	lda $30
	cmp #$03
	bne L2dda
	lda $25ce
	and #$fe
	bne L2e34
	lda #$28
	sta $2f
	lda #$03
	sta $30
L2e08	lda #$02
	sta $03
	lda #$3e
	jsr S1c83
	jsr S1d42
	ora $25ce
	sta $25ce
	inc $2e0d
	ldy #$00
	lda ($03),y
	sta $2f
	beq L2e34
	iny
	lda ($03),y
	sta $30
	inc $1f87
	lda $1f87
	cmp #$26
	bne L2e08
L2e34	jsr S2bca
	jsr S30c3
	lda #$00
	sta $1f86
	lda $25ce
	and #$fe
	sec
	bne L2e48
	clc
L2e48	jsr S3097
	lda #$28
	sta $3b00
	sta $3c00
	lda #$03
	sta $3b01
	lda #$02
	sta $3c01
	lda #$00
	sta $3d00
	lda #$ff
	sta $3d01
	jmp L300d
	
L2e6a	jsr S3083
	lda #$00
	sta $25cf
	sta $2eee
L2e75	lda #$28
	sta $2f
	ldy $2eee
	iny
	sty $2eee
	cpy #$29
	beq L2e9c
	dey
	tya
	sta $30
	clc
	adc #$3b
	sta $04
	lda #$00
	sta $03
	jsr L1c80
	jsr S1d42
	bcc L2e75
	jmp L2eea
	
L2e9c	lda #$00
	sta $25cf
	sta $2eee
L2ea4	lda #$28
	sta $2f
	ldy $2eee
	iny
	sty $2eee
	cpy #$29
	beq L2ee9
	dey
	tya
	sta $30
	clc
	adc #$3b
	sta L2ed4 + 2
	lda #$00
	sta $03
	lda #$32
	sta $04
	lda #$00
	sta L2ed4 + 1
	jsr S1c83
	jsr S1d42
	bcs L2eea
	ldy #$00
L2ed4	lda $3b00,y
	dey
	dey
	cmp $3200,y
	bne L2ee6
	iny
	iny
	iny
	bne L2ed4
	jmp L2ea4
	
L2ee6	sec
	bcs L2ee9
L2ee9	clc
L2eea	jsr S3097
	rts
	
	.byte $00
L2eef	jsr S3083
	lda #$3b
	sta L2efc + 2
	ldx #$28
	lda #$00
	tay
L2efc	sta $3b00,y
	iny
	bne L2efc
	inc L2efc + 2
	dex
	bne L2efc
	lda #$28
	sta L303b
	sta $3b00
	sta $3c00
	lda #$ff
	sta $3d01
	ldx #$01
	lda #$03
	sta $3b01
	lda #$02
	sta $3c01
	lda #$44
	sta $3b02
	sta $3c02
	sta $3d02
	eor #$ff
	sta $3c03
	sta $3d03
	lda #$00
	lda #$c0
	sta $3c06
	sta $3d06
	lda #$3c
	sta $2f5c
	lda #$3d
	sta $2f5f
	lda #$10
	sta $2f5b
	lda #$10
	sta $2f5e
L2f55	ldy #$00
L2f57	lda L303b,y
	sta $3c10,y
	sta $3d10,y
	iny
	cpy #$06
	bne L2f57
	lda $2f5b
	clc
	adc #$06
	sta $2f5b
	lda $2f5c
	adc #$00
	sta $2f5c
	lda $2f5e
	clc
	adc #$06
	sta $2f5e
	lda $2f5f
	adc #$00
	sta $2f5f
	inx
	cpx #$29
	bne L2f55
	ldx #$10
	ldy #$00
L2f90	lda L1c20,y
	sta $3b04,y
	iny
	dex
	bne L2f90
	ldx #$02
	lda #$a0
	ldy #$00
L2fa0	sta $3b14,y
	iny
	dex
	bne L2fa0
	lda L1c20 + 16
	sta $3b16
	sta $3c04
	sta $3d04
	lda L1c20 + 17
	sta $3b17
	sta $3c05
	sta $3d05
	lda #$a0
	sta $3b18
	lda #$33
	sta $3b19
	lda #$44
	sta $3b1a
	ldx #$02
	ldy #$00
	lda #$a0
L2fd4	sta $3b1b,y
	iny
	dex
	bne L2fd4
	ldx #$27
	ldy #$00
	lda #$3e
	sta L2fea + 2
	lda #$00
	sta L2fea + 1
	tya
L2fea	sta $3e00,y
	iny
	bne L2fea
	inc L2fea + 2
	dex
	bne L2fea
	lda #$00
	ldy #$05
L2ffa	sta $3cfa,y
	dey
	bpl L2ffa
	jsr S3097
	lda #$01
	sta $25ca
	lda #$00
	sta $25cb
L300d	php
	lda #$3e
	sta $301c
	sta $3020
	ldy #$04
L3018	lda #$28
	sta $3e00
	tya
	sta $3e01
	inc $301c
	inc $3020
	iny
	cpy #$28
	bne L3018
	lda #$00
	sta $6200
	lda #$ff
	sta $6201
	jsr S2bca
	plp
	rts
	
L303b	.byte $28, $ff, $ff, $ff, $ff, $ff
S3041	lda #$34
	sta L305c + 2
	lda #$00
	sta L305c + 1
	ldx #$06
	ldy #$00
	sty L2d9e
	sty $2d9f
	sty L2cfa
	sty $2cfb
	tya
L305c	sta $3400,y
	iny
	bne L305c
	inc L305c + 2
	dex
	bne L305c
	rts
	
S3069	lda $1c46
	sta $3080
	lda $1c47
	sta $3081
	stx $307e
	sty L307f
	jsr S1c8f
	brk
	
L307f	.byte $00, $00, $00, $60
S3083	php
	pha
	tya
	pha
	ldy #$03
L3089	lda $0031,y
	sta L30bf,y
	dey
	bpl L3089
	pla
	tay
	pla
	plp
	rts
	
S3097	php
	pha
	tya
	pha
	ldy #$03
L309d	lda L30bf,y
	sta $0031,y
	dey
	bpl L309d
	lda $1ea3
	beq L30ba
	ldy #$0a
	lda #$20
	sty $d600
L30b2	bit $d600
	bpl L30b2
	sta $d601
L30ba	pla
	tay
	pla
	plp
	rts
	
L30bf	.byte $00, $00, $00, $00
S30c3	lda #$00
	sta $3123
	lda $3cfb
	jsr S30fb
	lda #$08
	sta $3123
	lda $3cfc
	jsr S30fb
	lda #$10
	sta $3123
	lda $3cfd
	jsr S30fb
	lda #$18
	sta $3123
	lda $3cfe
	jsr S30fb
	lda #$20
	sta $3123
	lda $3cfe
	jsr S30fb
	rts
	
S30fb	sta L3124
	lda $3123
	clc
	adc #$3b
	sta $04
	lda #$00
	sta $03
L310a	lda L3124
	bne L3110
	rts
	
L3110	clc
	ror a
	sta L3124
	bcc L311f
	ldy #$00
	tya
L311a	sta ($03),y
	iny
	bne L311a
L311f	inc $04
	bne L310a
	brk
	
L3124	
	.byte $00
S3125	lda #$74
	sta L230e + 1
	lda #$03
	sta L230e + 2
	lda #$03
	sta $2305
	lda #$03
	sta $2306
	lda #$00
	sta $20a0
	lda #$0b
	sta $1edc
	sta $1eec
	rts
	
	.byte $8d,$b6
L3149
	.text "cmdch2"
	.byte $00,$ca
L3151	
	.text "cmdchn"
	.byte $00,$5c
L3159
	.text "cmdran"
	.byte $00,$76
L3161
	.text "cmdsiz"
	.byte $00,$03
L3169
	.text "cmdstr"
	.byte $01,$82
L3171
	.text "cmdtrk"
	.byte $00,$88
L3179
	.text "cmdtrm"
	.byte $21,$17
L3181
	.text "cmrnsz"
	.byte $00,$04
L3189
	.text "cnfcol"
	.byte $00,$33
L3191	
	.text "cnfigl"
	.byte $00,$3b
L3199
	.text "cntbav"
	.byte $2b,$ca
L31a1
	.text "cntblk"
	.byte $df,$00
L31a9
	.text "cntbv1"
	.byte $2b,$e3
L31b1
	.text "cntbv2"
	.byte $2b,$f5
L31b9
	.text "cntbv3"
	.byte $2c,$1e
L31c1
	.text "cnterr"
	.byte $00,$0d
L31c9
	.text "cntfil"
	.byte $00,$05
L31d1
	.text "cntr1 "
	.byte $80,$33
L31d9
	.text "colour"
	.byte $d8,$00
L31e1	
	.text "comchn"
	.byte $80,$8d
L31e9
	.text "comdbf"
	.byte $08,$00
L31f1
	.text "condns"
	.byte $00,$e4
L31f9
	.text "contfl"
	.byte $02,$9d
L3201
	.text "contin"
	.byte $fc,$e2
L3209
	.text "convio"
	.byte $00,$28
L3211
	.text "cpmbot"
	.byte $00,$d6
L3219
	.text "cpnssc"
	.byte $2c,$54
L3221
	.text "cpuspd"
	.byte $80,$38
L3229
	.text "crblok"
	.byte $00,$09
L3231
	.text "crc128"
	.byte $00,$f1
L3239
	.text "crc64 "
	.byte $02,$86
L3241
	.text "crdsov"
	.byte $80,$31
L3249
	.text "credit"
	.byte $00,$21
L3251
	.text "crmess"
	.byte $21,$25
L3259
	.text "crmins"
	.byte $80,$32
L3261
	.text "csmss1"
	.byte $2a,$e9
L3269
	.text "cssss "
	.byte $2a,$42
L3271
	.text "csumss"
	.byte $2a,$e8
L3279
	.text "ctmsid"
	.byte $25,$27
L3281	
	.text "curbyt"
	.byte $00,$0d
L3289
	.text "curixe"
	.byte $2b,$58
L3291
	.text "curnmb"
	.byte $2b,$c3
L3299
	.text "d71flg"
	.byte $1c,$9b
L32a1
	.text "dalcac"
	.byte $00,$19
L32a9
	.text "dalcar"
	.byte $00,$18
L32b1
	.text "dalexf"
	.byte $00,$1e
L32b9
	.text "datcel"
	.byte $22,$2d
L32c1
	.text "datntf"
	.byte $00,$04
L32c9
	.text "datove"
	.byte $00,$0a
L32d1
	.text "dbaval"
	.byte $1c,$4e
L32d9
	.text "dbchke"
	.byte $00,$05
L32e1
	.text "dbdstr"
	.byte $26,$0d
L32e9
	.text "dbmhdr"
	.byte $00,$ee
L32f1
	.text "dealcn"
	.byte $80,$84
L32f9
	.text "dealrn"
	.byte $80,$81
L3301
	.text "decbav"
	.byte $26,$a7
L3309
	.text "detwp "
	.byte $00,$b6
L3311
	.text "devcod"
	.byte $1e,$3c
L3319
	.text "dfltn "
	.byte $00,$99
L3321
	.text "dflto "
	.byte $00,$9a
L3329
	.text "difrnc"
	.byte $25,$c6
L3331
	.text "dirbuf"
	.byte $9f,$e0
L3339
	.text "dircnt"
	.byte $2b,$bd
L3341
	.text "dirctr"
	.byte $2b,$be
L3349
	.text "dircty"
	.byte $00,$60
L3351
	.text "direct"
	.byte $80,$90
L3359
	.text "dirsiz"
	.byte $00,$03
L3361
	.text "diskid"
	.byte $1c,$30
L3369
	.text "diskin"
	.byte $00,$92
L3371
	.text "disknm"
	.byte $1c,$20
L3379
	.text "divisr"
	.byte $26,$3f
L3381
	.text "dkfnlg"
	.byte $00,$0c
L3389
	.text "dmpdbl"
	.byte $1f,$93
L3391
	.text "dmpnxb"
	.byte $1f,$90
L3399
	.text "dnstat"
	.byte $00,$00
L33a1
	.text "dojob "
	.byte $22,$f2
L33a9
	.text "done  "
	.byte $22,$e4
L33b1
	.text "dorjob"
	.byte $24,$72
L33b9
	.text "dosadd"
	.byte $21,$2a
L33c1
	.text "dosadr"
	.byte $80,$00
L33c9
	.text "dosbsz"
	.byte $00,$1e
L33d1
	.text "dosdon"
	.byte $20,$f7
L33d9
	.text "dosext"
	.byte $80,$93
L33e1
	.text "dosimf"
	.byte $00,$08
L33e9
	.text "dosize"
	.byte $03,$fa
L33f1
	.text "doslen"
	.byte $00,$22
L33f9
	.text "dosm00"
	.byte $00,$00
L3401
	.text "dosm01"
	.byte $00,$01
L3409
	.text "dosm02"
	.byte $00,$02
L3411
	.text "dosm03"
	.byte $00,$03
L3419
	.text "dosm04"
	.byte $00
