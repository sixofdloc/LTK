;ltkrn128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
 
    *=LTK_Var_ActiveLU

L8000
	.byte $0a,$00 
L8002
	.byte $00
L8003
	.byte $00
L8004
	.byte $00
L8005
	.byte $00,$00 
L8007
	.byte $00,$ff,$8c,$81,$1d,$81,$89,$82 
L800f
	sta L802c
	stx L802d
	sty L802e
	php
	php
	pla
	sta L802f
	lda L802c
	plp
	rts
	
	.byte $17,$82,$ff,$ff,$ff 
L8028
	.byte $00,$01 
L802a
	.byte $08,$00 
L802c
	.byte $00
L802d
	.byte $00
L802e
	.byte $00
L802f
	.byte $00
L8030
	.byte $01 
L8031
	.byte $00
L8032
	.byte $00
L8033
	.byte $00
L8034
	.byte $00
L8035
	.byte $00
L8036
	.byte $ff 
L8037
	.byte $ff,$00 
L8039
	jmp L80da
	
L803c
	jmp L80df
	
L803f
	jmp L816c
	
L8042
	jmp L8301
	
L8045
	jmp S83c5
	
L8048
	jmp L85d7
	
L804b
	jmp L818f
	
L804e
	jmp L8192
	
L8051
	jmp L8195
	
L8054
	jmp L8320
	
L8057
	jmp L8127
	
L805a
	jmp L8135
	
L805d
	jmp L8139
	
L8060
	jmp L8147
	
L8063
	jmp L814b
	
L8066
	jmp L800f
	
L8069
	jmp S8177
	
L806c
	jmp L8333
	
L806f
	jmp L8307
	
L8072
	jmp S85b5
	
L8075
	jmp L8114
	
L8078
	jmp L819b
	
L807b
	jmp L819e
	
L807e
	jmp L81a1
	
L8081
	jmp L81a4
	
L8084
	jmp L81a7
	
L8087
	jmp L8317
	
L808a
	jmp L8198
	
L808d
	jmp S81f5
	
L8090
	jmp L81f8
	
L8093
	jmp L81ff
	
L8096
	jmp L8246
	
L8099
	jmp L8186
	
L809c
	jmp L81a9
	
L809f
	jmp L8737
	
L80a2
	jmp L8c88
	
S80a5
	jmp S80a5
	
L80a8
	.byte $ff 
L80a9
	.byte $ff 
L80aa
	.byte $ff,$ff 
L80ac		           
    .byte $ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
L80da
	bcs L80f8
	ldy L8028
L80df
	cpy #$14
	bcs L80eb
	ldx $031a,y
	lda $031b,y
	bcc L80f7
L80eb
	bne L80f3
	ldx #$65
	lda #$f2
	bne L80f7
L80f3
	ldx #$3e
	lda #$f5
L80f7
	tay
L80f8
	lda $ff00
	sta L811f + 1
	pha
	and #$cf
	sta $ff00
	lda #$20
	sta $fc45
	stx $fc46
	sty $fc47
	pla
	sta $ff00
	rts
	
L8114
	jsr L816c
	php
	pha
	lda #$3e
	bne L8121
	php
	pha
L811f
	lda #$0e
L8121
	sta $ff00
	pla
	plp
	rts
	
L8127
	sta L802c
	stx L802d
	sty L802e
	php
	pla
	sta L802f
L8135
	lda #$60
	bne L814d
L8139
	sta L802c
	stx L802d
	sty L802e
	php
	pla
	sta L802f
L8147
	clc
	jsr L80da
L814b
	lda #$4c
L814d
	ldx L8034
	stx $d503
	ldx L8035
	stx $d504
	sta $fc45
	lda L802f
	pha
	lda L802c
	ldx L802d
	ldy L802e
	jmp L816d
	
L816c
	php
L816d
	pha
	lda L8005
	sta $ff00
	jmp $fc3d
	
S8177
	lda L802f
	pha
	lda L802c
	ldx L802d
	ldy L802e
	plp
	rts
	
L8186
	tax
	bpl L81ca
	lda #$1a
	.byte $2c 
L818c
	lda #$25
	.byte $2c 
L818f
	lda #$11
	.byte $2c 
L8192
	lda #$12
	.byte $2c 
L8195
	lda #$13
	.byte $2c 
L8198
	lda #$14
	.byte $2c 
L819b
	lda #$15
	.byte $2c 
L819e
	lda #$16
	.byte $2c 
L81a1
	lda #$17
	.byte $2c 
L81a4
	lda #$18
	.byte $2c 
L81a7
	lda #$19
L81a9
	cmp L8032
	beq L81c7
	sta L8032
	txa
	pha
	tya
	pha
	lda #$0a
	ldx L8032
	ldy #$00
	clc
	jsr S83c5
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L81c3
	pla
	tay
	pla
	tax
L81c7
	jmp LTK_MiniSubExeArea 
	
L81ca
	cmp #$0a
	beq L81da
	bcc L81d2
L81d0
	sec
	rts
	
L81d2
	jsr S81df
	lda L80a8,y
	bmi L81d0
L81da
	stx L8000
	clc
	rts
	
S81df
	sta L81e5 + 1
	asl a
	asl a
	clc
L81e5
	adc #$00
	tay
	rts
	
S81e9
	lda #$9a
	.byte $2c 
L81ec
	lda #$9e
	.byte $2c 
L81ef
	lda #$a2
	.byte $2c 
L81f2
	lda #$58
	.byte $2c 
S81f5
	lda #$5c
	.byte $2c 
L81f8
	lda #$60
	.byte $2c 
L81fb
	lda #$6a
	ldx #$03
L81ff
	cmp L8031
	beq L8216
	sta L8031
	stx L8215
	tax
	ldy #$00
	lda #$0a
	clc
	jsr S83c5
L8213
	.byte <LTK_DOSOverlay,>LTK_DOSOverlay ;$95e0
L8215
	.byte $00
	
L8216
	rts
	
L8217
	ldy #$00
	sty LTK_Krn_BankControl
	lda #$0a
	ldx #$2d
	clc
	jsr L8045
	.byte $00,$80,$02 
L8227
	sty $02
L8229
	lda #$80
	sta $03
	lda #$0a
	sta $04
	ldx #$71
	ldy #$ff
	sec
	jsr L80da
	lda #$78
	sta $fc44
	lda LTK_HardwarePage
	sta $06
	jmp L816c
	
L8246
	bcc L825b
	sta L8274
	stx L8272
	sty L8273
	lda #$3e
	sta $ff00
	lda #$ff
	sta L8007
L825b
	php
	php
	jsr LTK_GetPortNumber
	asl a
	asl a
	asl a
	ldy #$02
	clc
	adc #$ae
	bcc L826b
	iny
L826b
	tax
	lda #$0a
	plp
	jsr S83c5
L8272
	.byte $00
	
L8273
	.byte $00
L8274
	.byte $00
L8275
	ldx L8272
	ldy L8273
	plp
	bcs L8288
	lda #$0e
	sta $ff00
	lda #$00
	sta L8007
L8288
	rts
	
L8289
	sta L802c
	stx L802d
	sty L802e
	php
	pla
	sta L802f
	lda $ff00
	sta L8005
	ora #$0e
	sta $ff00
	lda $d503
	sta L8034
	lda $d504
	sta L8035
	lda #$00
	sta $d503
	lda #$40
	sta $d504
	pla
	sec
	sbc #$c2
	tay
	pla
	lda L8352,y
	sta L8028
	lda L8351,y
	pha
	lda L8350,y
	pha
	rts
	
L82cd
	tay
	bne L8330
	clc
	jsr L80da
	lda L802f
	pha
	lda L802c
	ldx L802d
	ldy L802e
	plp
	jsr L803f
	sta L802c
	stx L802d
	sty L802e
	php
	pla
	sta L802f
	lda L802c
	cmp #$0d
	beq L82fd
L82fa
	jmp L8135
	
L82fd
	lda $7f
	bmi L82fa
L8301
	jsr S81e9
	jmp LTK_DOSOverlay 
	
L8307
	jsr S8343
	lda L8033
	jsr LTK_DOSOverlay 
	lda #$00
	sta $ea
	sta LTK_Command_Buffer
L8317
	jsr S8177
	clc
	lda #$0d
	jmp L8127
	
L8320
	php
	pha
	lda $ba
	cmp L802a
	bne L832c
	pla
	plp
	rts
	
L832c
	pla
	pla
	pla
	pla
L8330
	jmp L8147
	
L8333
	lda #$00
	tay
L8336
	sta LTK_FileHeaderBlock ,y
	iny
	bne L8336
L833c
	sta $92e0,y
	iny
	bne L833c
	rts
	
S8343
	lda $91f8
	cmp #$0a
	bcs L834d
	jmp L808a
	
L834d
	jmp L804e
	
L8350
	.byte $85 
L8351
	.byte $83 
L8352	 
    .byte $00,$92,$83,$02,$f4,$85,$04,$11,$86,$06,$39,$89,$08,$81 
	.byte $86,$0a,$be,$86,$0c,$ae,$83,$14,$b6,$83,$16,$00 
L836c
	.byte $00,$00 
L836e
	.byte $00,$00 
L8370
	.byte $00
L8371
	.byte $00
L8372
	.byte $00
L8373
	.byte $00,$81,$86,$10,$bb,$83,$12 
L837a
	.byte $00,$00 
L837c
	.byte $00
L837d
	.byte $00
L837e
	.byte $00
L837f
	.byte $00
L8380
	.byte $01,$00 
L8382
	.byte $00
L8383
	.byte $00
L8384
	.byte $00
L8385
	.byte $00
L8386
	lda L8030
	bpl L838e
	jsr L8320
L838e
	jsr L81ec
	beq L83c2
L8393
	jsr S8177
	tax
	jsr S865a
	bcs L8330
	and #$0f
	tay
	txa
	pha
	cpy #$0f
	bne L83a8
	jsr S873a
L83a8
	jsr L81ef
	pla
	jmp $95e3
	
L83af
	jsr L8320
	jsr L81fb
	beq L83c2
	jsr L81f2
	beq L83c2
L83bc
	jsr S873a
L83bf
	jsr L81ef
L83c2
	jmp LTK_DOSOverlay 
	
S83c5
	and #$3f
	stx L8004
	stx L837f
	sty L8003
	sty L837e
	ldx #$08
	bcc L83d9
	ldx #$0a
L83d9
	stx L837c
	ldx #$00
	stx L837d
	stx L836c
	ldx #$fe
	stx S8545 + 1
L83e9
	ldx #$0a
	sta L8002
	sta L83e9 + 1
	cmp #$0a
	bne L8419
	tya
	bne L846e
	ldy L8004
	cpy #$11
	bcc L846e
	cpy #$ee
	bcs L846e
	dec L836c
	cpx #$0a
	beq L846e
	txa
	jsr S81df
	lda L80aa,y
	and #$08
	beq L846e
	txa
	inc L837e
L8419
	sta L83e9 + 1
	jsr S81df
	lda L80a8,y
	pha
	pha
	and #$1c
	lsr a
	lsr a
	tax
	beq L8432
L842b
	sec
	rol S8545 + 1
	dex
	bne L842b
L8432
	pla
	and #$60
	sta L837d
	pla
	and #$03
	tax
	lda L80ac,y
	sta L8452 + 1
	lda L80a9,y
	pha
	lda L80aa,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	pla
	jsr S85b5
L8452
	ldy #$00
	jsr S85b5
	clc
	adc L837f
	sta L837f
	txa
	adc L837e
	sta L837e
	lda L836e
	adc L837d
	sta L837d
L846e
	pla
	sta S85b0 + 1
	pla
	sta S85b0 + 2
	lda $31
	pha
	lda $32
	pha
	ldy #$01
	jsr S85b0
	sta $31
	jsr S85b0
	sta $32
	jsr S85b0
	sta L8380
	tya
	tax
	jsr S85b0
	cmp #$b2
	bne L84a5
	jsr S85b0
	cmp #$c2
	bne L84a5
	jsr S85b0
	cmp #$d2
	beq L84b3
L84a5
	txa
	tay
	lda L837c
	cmp #$08
	beq L84b3
	lda L836c
	bne L8501
L84b3
	tya
	clc
	adc S85b0 + 1
	sta S85b0 + 1
	bcc L84c0
	inc S85b0 + 2
L84c0
	jsr S8575
	jsr S8545
	bne L8501
	ldx #$06
	ldy #$00
	jsr S855e
	ldy #$00
	lda L837c
	cmp #$08
	beq L8504
	lda #$2c
	sta $df01
	lda L8007
	bne L84e8
	jsr $fc65
	jmp L852d
	
L84e8
	lda $df02
	bmi L84e8
	and #$04
	beq L852d
L84f1
	lda ($31),y
	sta $df00
	lda $df00
	iny
	bne L84f1
	inc $32
	jmp L84e8
	
L8501
	jsr S80a5
L8504
	jsr S8572
	lda #$2c
	sta $df01
	lda L8007
	bne L8517
	jsr $fc62
	jmp L852d
	
L8517
	lda $df02
	bmi L8517
	and #$04
	beq L852d
L8520
	lda $df00
	sta ($31),y
	iny
	bne L8520
	inc $32
	jmp L8517
	
L852d
	jsr S8599
	txa
	bne L8501
	pla
	sta $32
	pla
	sta $31
	lda L8002
	ldx L8004
	ldy L8003
	jmp (S85b0 + 1)
	
S8545
	lda #$fe
	sta $df00
L854a
	lda #$50
	sta $df02
	lda $df02
	and #$08
	bne L854a
	lda #$40
	sta $df02
	lda #$00
	rts
	
S855e
	jsr S8585
	lda L837c,y
	eor #$ff
	sta $df00
	jsr S858b
	iny
	dex
	bne S855e
	beq S8585
S8572
	ldx #$00
	.byte $2c 
S8575
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
	
S8585
	lda $df02
	bmi S8585
	rts
	
S858b
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
	
S8599
	jsr S8572
	jsr S85a2
	and #$9f
	tax
S85a2
	jsr S8585
	lda $df00
	eor #$ff
	tay
	jsr S858b
	tya
	rts
	
S85b0
	lda S85b0,y
	iny
	rts
	
S85b5
	sta L85c6 + 1
	stx L85ca + 1
	lda #$00
	sta L836e
	tax
	cpy #$00
	beq L85d6
L85c5
	clc
L85c6
	adc #$00
	pha
	txa
L85ca
	adc #$00
	tax
	bcc L85d2
	inc L836e
L85d2
	pla
	dey
	bne L85c5
L85d6
	rts
	
L85d7
	stx L85e2 + 1
	sty L85e2 + 2
	ldy #$0c
	jsr L80df
L85e2
	lda L85e2
	beq L85f4
	jsr L803f
	inc L85e2 + 1
	bne L85e2
	inc L85e2 + 2
	bne L85e2
L85f4
	rts
	
L85f5
	jsr S8641
	stx L8382
	lda $ba
	sta $99
	bcs L8637
	cpx #$e0
	bne L8637
	lda $9dfc,x
	beq L8637
	ldy #$00
	jsr L8051
	clc
	bcc L8637
	jsr S8641
	lda $ba
	sta $9a
	lda L8383
	sta L8384
	stx L8383
	cpx #$e0
	beq L8628
	bcs L8637
L8628
	lda L8384
	cmp L8383
	beq L8637
	cmp #$e0
	bne L8637
	jsr S873a
L8637
	clc
	lda $ba
	tax
	ldy L802e
	jmp L8127
	
S8641
	jsr S8177
	jsr S865a
	ldy #$00
	sty $90
	bcc L8652
	pla
	pla
	jmp L8147
	
L8652
	jsr S8b5e
	bcc L8659
	ldx #$fe
L8659
	rts
	
S865a
	sec
	txa
	pha
	ldx #$07
	ldy #$f2
	jsr L80da
	pla
	jsr L803f
	beq L866c
L866a
	sec
	rts
	
L866c
	lda $0362,x
	sta $b8
	ldy $036c,x
	sty $ba
	lda $0376,x
	sta $b9
	cpy L802a
	bne L866a
	clc
	rts
	
L8682
	lda $99
	cmp L802a
	bne L86bc
	ldx L8382
	lda $9df9,x
	cmp #$0f
	bne L869b
	lda $9dfa,x
	bmi L869b
	jsr S88a5
L869b
	ldy #$00
	jsr S89b7
	sta L802c
	php
	cpx #$e0
	bne L86b3
	cmp #$0d
	bne L86b3
	lda #$40
	sta $90
	sta $9dfc,x
L86b3
	pla
L86b4
	and #$fe
	sta L802f
	jmp L8135
	
L86bc
	jmp L82cd
	
L86bf
	ldx $9a
	cpx L802a
	beq L86f4
	cpx #$03
	bne L86f1
	lda L802c
	cmp #$52
	bne L86e8
	tsx
	lda $0106,x
	cmp #$2e
	bne L86f1
	lda $0107,x
	cmp #$4d
	bne L86f1
	lda #$ff
	jsr L8186
	jmp L8147
	
L86e8
	cmp #$07
	bne L86f1
	ldy #$ff
	jsr L8051
L86f1
	jmp L8147
	
L86f4
	ldx L8383
	stx $9de4
	lda $9df9,x
	cmp #$0f
	bne L8711
	lda $9dfa,x
	asl a
	bpl L8711
	lda #$44
	ldx #$03
	jsr L8093
	jsr LTK_DOSOverlay 
L8711
	lda $b9
	and #$0f
	cmp #$0f
	bne L872b
	lda L802c
	ldx L88a3
	sta LTK_CMDChannelBuffer,x
	cpx #$29
	bcs L8731
	inc L88a3
	bne L8731
L872b
	lda L802c
	jsr S8b8a
L8731
	lda L802f
	jmp L86b4
	
L8737
	stx L88a3
S873a
	ldx L88a3
	bne L8740
	rts
	
L8740
	ldx #$00
	jsr S8899
	cmp #$50
	beq L8755
	jsr S81f5
	lda L88a3
	jsr LTK_DOSOverlay 
	jmp L87d5
	
L8755
	jsr S8899
	bcs L87bb
	and #$0f
	sta L88a4
	jsr S8899
	bcs L87bb
	tay
	jsr S8899
	bcs L87bb
	cmp #$00
	bne L8773
	cpy #$00
	bne L8773
	iny
L8773
	sta $9e03
	sty $9e04
	jsr S8899
	bcs L87bb
	tay
	jsr S8899
	bcs L8788
	cmp #$0d
	bcc L878a
L8788
	lda #$00
L878a
	cpy #$00
	bne L8792
	cmp #$00
	beq L879a
L8792
	dey
	cpy #$ff
	bne L879a
	sec
	sbc #$01
L879a
	sta $9e05
	sty $9de5
	ldx #$00
	ldy #$07
L87a4
	lda $9dff,x
	and #$0f
	cmp L88a4
	beq L87c6
	pha
	txa
	clc
	adc #$20
	tax
	pla
	dey
	bne L87a4
L87b8
	ldy #$46
	.byte $2c 
L87bb
	ldy #$1e
	.byte $2c 
L87be
	ldy #$40
	jsr L8051
	jmp L87d5
	
L87c6
	lda LTK_FileParamTable,x
	beq L87b8
	lda $9df9,x
	cmp #$0f
	bne L87be
	jsr S87db
L87d5
	lda #$00
	sta L88a3
	rts
	
S87db
	stx $9de4
	lda $9e03
	ldy $9e04
	jsr S8850
	pha
	pha
	txa
	pha
	tya
	ldx $9de4
	sta $9df4,x
	sta $9ded,x
	pla
	tay
	pla
	clc
	adc $9df8,x
	sta $9df6,x
	tya
	adc $9df7,x
	sta $9df5,x
	bcc L880b
	inc $9df4,x
L880b
	pla
	clc
	adc $9de5
	sta $9def,x
	tya
	adc $9e05
	sta $9dee,x
	bcc L881f
	inc $9ded,x
L881f
	lda #$00
	tay
	sta $9dfc,x
	sta $9dfa,x
	lda $9e03
	cmp $9df2,x
	bcc L884d
	bne L883a
	lda $9e04
	cmp $9df3,x
	bcc L884d
L883a
	lda $9df4,x
	bne L8846
	lda $9df5,x
	cmp #$02
	bcc L8848
L8846
	ldy #$32
L8848
	lda #$40
	sta $9dfa,x
L884d
	jmp L8051
	
S8850
	sta L8882 + 1
	sta $9de1,x
	sty L887e + 1
	tya
	sta $9de2,x
	lda $9df7,x
	sta $9e23
	lda $9df8,x
	sta $9e24
	lda #$0c
	sta $9e25
	lda #$00
	sta L8886 + 1
	tax
	tay
L8875
	lsr $9e23
	ror $9e24
	bcc L888a
	clc
L887e
	adc #$00
	pha
	txa
L8882
	adc #$00
	tax
	tya
L8886
	adc #$00
	tay
	pla
L888a
	asl L887e + 1
	rol L8882 + 1
	rol L8886 + 1
	dec $9e25
	bne L8875
	rts
	
S8899
	cpx L88a3
	bcs L88a2
	lda LTK_CMDChannelBuffer,x
	inx
L88a2
	rts
	
L88a3
	.byte $00
L88a4
	.byte $00
S88a5
	lda $9ded,x
	pha
	sta $9e23
	lda $9dee,x
	pha
	sta $9e24
	lda $9def,x
	pha
	sta $9e25
	lda #$00
	sta $9dfc,x
	lda $9df4,x
	sta $9ded,x
	lda $9df5,x
	sta $9dee,x
	lda $9df6,x
	sta $9def,x
L88d1
	sec
	lda $9def,x
	sbc #$01
	sta $9def,x
	lda $9dee,x
	sbc #$00
	sta $9dee,x
	lda $9ded,x
	sbc #$00
	sta $9ded,x
	ldy #$ff
	jsr S89b7
	bne L890e
	lda $9e23
	cmp $9ded,x
	bne L88d1
	lda $9e24
	cmp $9dee,x
	bne L88d1
	lda $9e25
	cmp $9def,x
	bne L88d1
	dec $9dfc,x
	bne L8916
L890e
	jsr S8b2f
	lda #$00
	sta $9dfc,x
L8916
	lda $9ded,x
	sta $9df4,x
	lda $9dee,x
	sta $9df5,x
	lda $9def,x
	sta $9df6,x
	pla
	sta $9def,x
	pla
	sta $9dee,x
	pla
	sta $9ded,x
	lda #$80
	sta $9dfa,x
L8939
	rts
	
L893a
	lda $9a
	cmp L802a
	bne L895a
	ldx L8383
	lda #$00
	sta $9a
	jsr S8974
	lda L8383
	cmp #$e0
	bne L8955
	jsr S873a
L8955
	lda #$ff
	sta L8383
L895a
	lda $99
	cmp L802a
	bne L8971
	ldx L8382
	lda #$ff
	jsr S8974
	ldx #$00
	stx $99
	dex
	stx L8382
L8971
	jmp L8147
	
S8974
	sta L89a6 + 1
	tay
	cpx #$ff
	beq L8939
	lda $9df9,x
	cmp #$0f
	bne L8939
	tya
	beq L898b
	lda $9dfc,x
	beq L8939
L898b
	lda $9de1,x
	tay
	lda $9de2,x
	clc
	adc #$01
	bcc L8998
	iny
L8998
	sty $9e03
	sta $9e04
	lda #$00
	sta $9e05
	sta $9de5
L89a6
	ldy #$00
	bne L89af
L89aa
	jsr S8b8a
	bcc L89aa
L89af
	jsr S87db
	ldy #$00
	jmp L8051
	
S89b7
	ldx L8382
	stx L8370
	sty L837a
	lda #$0d
	cpx #$fe
	bcc L89d0
	bne L89cd
	inc L8382
	lda #$c7
L89cd
	jmp L8b84
	
L89d0
	lda $9dfe,x
	tay
	cmp #$24
	bne L89e1
	jsr L81f8
	ldx L8370
	jmp LTK_DOSOverlay 
	
L89e1
	lda $9dfc,x
	beq L89eb
	sta $90
	lda #$0d
	rts
	
L89eb
	tya
	bmi L8a02
	bne L89f6
	lda $9de2,x
	jmp L89fd
	
L89f6
	cmp #$01
	bne L8a02
	lda $9de1,x
L89fd
	inc $9dfe,x
	tay
	rts
	
L8a02
	lda #$e0
	ldy #$9e
	cpx #$e0
	beq L8a2b
	lda $9df9,x
	cmp #$0f
	bne L8a1f
	cpx L8037
	beq L8a19
	jsr L8c88
L8a19
	lda #$e0
	ldy #$8d
	bne L8a2b
L8a1f
	cpx L8036
	beq L8a27
	jsr S8c7f
L8a27
	lda #$e0
	ldy #$9b
L8a2b
	jsr S8a4e
	beq L8a3d
	lda $9df9,x
	cmp #$0f
	bne L8a3a
	jsr S8d1d
L8a3a
	jsr S8a9e
L8a3d
	bit L837a
	bmi L8a4a
	jsr S8b2f
	lda $9dfc,x
	sta $90
L8a4a
	lda L8a4a
	rts
	
S8a4e
	sta L8a4a + 1
	sty L8a4a + 2
	sta L8b0b
	sty L8b0c
	lda $9def,x
	sta L8373
	clc
	adc L8a4a + 1
	sta L8a4a + 1
	sta L8c2c + 1
	lda $9dee,x
	sta L8372
	and #$01
L8a72
	adc L8a4a + 2
	sta L8a4a + 2
	sta L8c2c + 2
	lda $9ded,x
	sta L8371
	ldy #$09
L8a83
	lsr L8371
	ror L8372
	ror L8373
	dey
	bne L8a83
	lda $9dea,x
	ldy $9de9,x
	cpy L8372
	bne L8a9d
	cmp L8373
L8a9d
	rts
	
S8a9e
	clc
	jsr S8cc6
	lda L8373
	sta L8b2e
	sta $9dea,x
	lda L8372
	sta L8b2d
	sta $9de9,x
	lda #$02
	ldy #$92
	jsr S8b15
	lda $9df0,x
	bne L8ac7
	lda $9df1,x
	cmp #$f1
	bcc L8af7
L8ac7
	ldy #$08
L8ac9
	lsr L8b2d
	ror L8b2e
	dey
	bne L8ac9
	lda $9de6,x
	and #$0f
	pha
	lda L8b2e
	jsr S8b1c
	pha
	tya
	tax
	pla
	tay
	beq L8b12
	pla
	clc
	jsr S83c5
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L8aed
	ldx L8370
	lda #$e0
	ldy #$91
	jsr S8b15
L8af7
	lda L8373
	jsr S8b1c
	sta $9deb,x
	tya
	sta $9dec,x
	jsr S8cb4
	clc
	jsr S83c5
L8b0b
	.byte $00
	
L8b0c
	.byte $00
L8b0d
	.byte $01 
L8b0e
	ldx L8370
	rts
	
L8b12
	jsr S80a5
S8b15
	sta S8b7f + 1
	sty S8b7f + 2
	rts
	
S8b1c
	asl a
	tay
	bcc L8b23
	inc S8b7f + 2
L8b23
	jsr S8b7f
	pha
	jsr S8b7f
	tay
	pla
	rts
	
L8b2d
	.byte $00
L8b2e
	.byte $00
S8b2f
	inc $9def,x
	bne L8b3c
	inc $9dee,x
	bne L8b3c
	inc $9ded,x
L8b3c
	lda $9ded,x
	cmp $9df4,x
	bcc L8b5d
	bne L8b58
	lda $9dee,x
	cmp $9df5,x
	bcc L8b5d
	bne L8b58
	lda $9def,x
	cmp $9df6,x
	bcc L8b5d
L8b58
	lda #$40
	sta $9dfc,x
L8b5d
	rts
	
S8b5e
	ldx #$e0
	lda $b9
	and #$0f
	cmp #$0f
	beq L8b7d
	ldx #$00
	ldy #$07
L8b6c
	lda LTK_FileParamTable,x
	cmp $b8
	beq L8b7d
	txa
	clc
	adc #$20
	tax
	dey
	bne L8b6c
	sec
	rts
	
L8b7d
	clc
	rts
	
S8b7f
	lda S8b7f,y
	iny
	rts
	
L8b84
	ldy #$42
	sty $90
L8b88
	sec
	rts
	
S8b8a
	sta L8385
	tay
	ldx L8383
	stx L8370
	cpx #$fe
	bcc L8b9f
	bne L8b84
	inc L8383
	bne L8b88
L8b9f
	lda $9df9,x
	bmi L8ba8
	cmp #$0f
	bne L8b84
L8ba8
	lda $9dfe,x
	bmi L8bc3
	bne L8bb6
	tya
	sta $9de2,x
	jmp L8bbe
	
L8bb6
	cmp #$01
	bne L8bc3
	tya
	sta $9de1,x
L8bbe
	inc $9dfe,x
	clc
	rts
	
L8bc3
	cpx L8037
	beq L8bcb
	jsr L8c88
L8bcb
	lda $9df9,x
	cmp #$0f
	bne L8bda
	lda $9dfc,x
	beq L8c0d
	sec
	bcs L8c3b
L8bda
	lda $9de9,x
	cmp #$ff
	bne L8c0d
	lda $9dea,x
	cmp #$fe
	bcc L8c0d
	bne L8c0a
	lda #$e0
	ldy #$8d
	jsr S8a4e
	jsr S8a9e
	lda $9deb,x
	bne L8c29
	lda $9dea,x
	sec
	sbc #$01
	sta $9dea,x
	lda $9de9,x
	sbc #$00
	sta $9de9,x
L8c0a
	jsr S8c3f
L8c0d
	lda #$e0
	ldy #$8d
	jsr S8a4e
	beq L8c29
	jsr S8d1d
	lda $9df9,x
	cmp #$0f
	bne L8c26
	jsr S8a9e
	jmp L8c29
	
L8c26
	jsr S8c3f
L8c29
	lda L8385
L8c2c
	sta L8c2c
	jsr S8b2f
L8c32
	lda #$40
	ora $9dfe,x
	sta $9dfe,x
	clc
L8c3b
	lda L8385
	rts
	
S8c3f
	lda L8000
	pha
	lda $9de6,x
	and #$0f
	sta L8000
	clc
	jsr S8cc6
	jsr L807e
	bcs L8cc3
	txa
	ldx L8370
	sta $9deb,x
	tya
	sta $9dec,x
	inc $9dea,x
	bne L8c67
	inc $9de9,x
L8c67
	sec
	jsr S8cc6
	pla
	sta L8000
	lda #$00
	tay
L8c72
	sta LTK_FileWriteBuffer ,y
	iny
	bne L8c72
L8c78
	sta $8ee0,y
	iny
	bne L8c78
	rts
	
S8c7f
	stx L8036
	lda #$e0
	ldy #$9b
	bne L8ca0
L8c88
	lda L8037
	stx L8037
	stx L8370
	tax
	cpx #$ff
	beq L8c99
	jsr S8d1d
L8c99
	ldx L8370
	lda #$e0
L8c9e
	ldy #$8d
L8ca0
	sta L8cad
	sty L8cae
	jsr S8cb4
	clc
	jsr S83c5
L8cad
	.byte $00
	
L8cae
	.byte $00
L8caf
	.byte $01 
L8cb0
	ldx L8370
	rts
	
S8cb4
	lda $9de6,x
	and #$0f
	pha
	ldy $9deb,x
	lda $9dec,x
	tax
	pla
	rts
	
L8cc3
	jsr S80a5
S8cc6
	bcs L8d03
	lda $91fd
	cmp $9de6,x
	bne L8d02
	lda $9200
	cmp $9de7,x
	bne L8d02
	lda $9201
	cmp $9de8,x
	bne L8d02
	lda $91f0
	cmp $9df0,x
	bne L8d02
	lda $91f1
	cmp $9df1,x
	bne L8d02
	lda $9df9,x
	and #$7f
	cmp $91f8
	bne L8d02
	lda $91fc
	cmp $9dfb,x
	beq L8d19
L8d02
	clc
L8d03
	lda $9de6,x
	and #$0f
	pha
	ldy $9de7,x
	beq L8cc3
	lda $9de8,x
	tax
	pla
	jsr S83c5
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L8d19
	ldx L8370
	rts
	
S8d1d
	jsr S8cb4
	cpy #$00
	beq L8d2b
	sec
	jsr S83c5
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L8d2b
	ldx L8370
	rts


