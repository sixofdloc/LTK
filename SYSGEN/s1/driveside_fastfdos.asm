  *=$0300
;=============================================================================
; START OF DRIVE-SIDE FASTLOADER CODE
;=============================================================================
L0300
	lda #$07
	sta $47
	; Clear error flags
	jsr $c123
	; Turn LED on for current drive
	jsr $c100
	sei
	; Turn drive motor on
	jsr $f97e
	ldx #$00
L0310
	dex
	bne L0310
	lda $ff2f
	; Should b $AA in a 1541
	cmp #$a9
	bne L031c
	ldx #$0d
L031c
	stx L07a5
	lda #$12
	sta $22
	lda #$01
	sta $06
	sta $18
	jsr S05c2
	ldx #$00
	; Turns stepper motor off?
	jsr $fa69
	jmp L0454
	
S0334
	sta L07ff
S0337
	dec L0352 + 1
	jmp S0345
	
S033d
	dec L03b9 + 1
	jsr S0387
	tay
	rts
	
S0345
	sei
	lda #$02
	sta $1800
L034b
	lda $1800
	and #$04
	beq L034b
L0352
	lda $0700
	sta $08
	ldx #$04
	lda #$00
	sta $1800
L035e
	lda #$00
	asl $08
	rol a
	asl $08
	rol a
	tay
	lda L0383,y
	sta $1800
	dex
	bne L035e
	; read byte x in BAM
	jsr $efe3
	lda #$02
	sta $1800
	inc L0352 + 1
	bne L0352
	lda #$00
	sta $1800
	rts
	
L0383
	.byte $0a,$02,$08,$00 
S0387
	lda #$08
	sta $1800
L038c
	lda $1800
	and #$01
	beq L038c
	lda #$00
	sta $1800
	nop
L0399
	ldx #$04
L039b
	lda $1800
	and #$01
	bne L039b
	; read byte x in BAM
	jsr $efe3
L03a5
	lda $1800
	and #$05
	tay
	lda L03c3,y
	asl a
	rol $08
	asl a
	rol $08
	dex
	bne L03a5
	lda $08
L03b9
	sta $0700
	inc L03b9 + 1
	bne L0399
	tay
	rts
	
L03c3
	.byte $00,$80,$00,$00,$40,$c0 
S03c9
	jsr S0796
	lda $0e
	cmp #$05
	bne L03f1
	lda #$00
	sta $33
	sta $30
	lda #$06
	sta $32
	jsr S0334
	nop
	lda #$02
	sta $31
	lda #$02
	sta L03b9 + 2
	jsr S0387
	lda #$07
	sta L03b9 + 2
L03f1
	lda $1c00
	and #$10
	bne L03fd
	lda #$08
L03fa
	jmp L0780
	
L03fd
	lda #$00
	sta $3d
	; Calculate parity for data buffer
	jsr $f5e9
	sta $3a
	; convert 260 bytes to 325 bytes group code
	jsr $f78f
	jsr S07a6
	bne L03fa
	ldx #$08
L0410
	bvc L0410
	clv
	dex
	bne L0410
	dex
	stx $1c03
	lda $1c0c
	and #$1f
	ora #$c0
	sta $1c0c
	stx $1c01
	ldx #$05
	clv
L042a
	bvc L042a
	clv
	dex
	bne L042a
	ldy #$bb
L0432
	lda $0100,y
L0435
	bvc L0435
	clv
	sta $1c01
	iny
	bne L0432
L043e
	lda ($30),y
L0440
	bvc L0440
	clv
	sta $1c01
	iny
	bne L043e
L0449
	bvc L0449
	; Switch to reading
	jsr $fe00
	jsr S07a0
	jmp L077e
	
L0454
	jsr S05be
L0457
	lda L07a5
	jsr S0334
	lda #$00
	sta L07a5
	jsr S033d
	cmp #$f1
	beq L04a2
	cmp #$0d
	beq L049f
	cmp #$04
	bne L0492
	jsr S062b
	jsr S033d
	sta $16
	jsr S033d
	sta $17
	lda $18
	sec
	sbc #$4c
	bcc L0454
	sbc #$14
	dec L05ff + 1
	jsr S05fd
	inc L05ff + 1
L0490
	bne L0457
L0492
	cmp #$03
	bne L04a5
	jsr S0641
	sta L07a5
	jmp L0457
	
L049f
	jmp L054e
	
	; Power-up RESET routine
L04a2
	jmp $eaa0
	
L04a5
	cmp #$08
	bne L04f4
	ldx #$5a
	sta $4b
	ldx #$00
	lda #$52
	sta $24
	jsr S0796
L04b6
	jsr S07d8
	bne L04f0
L04bb
	bvc L04bb
	clv
	lda $1c01
	cmp $24
	bne L04ec
L04c5
	bvc L04c5
	clv
	lda $1c01
	sta $25,x
	inx
	cpx #$07
	bne L04c5
	; Save 30/31 and read 10 GCR bytes
	jsr $f497
	lda #$00
L04d7
	sta $15
	ldx #$07
L04db
	lda $15,x
	sta L07ff
	txa
	pha
	jsr S0337
	pla
	tax
	dex
	bpl L04db
	bmi L0490
L04ec
	dec $4b
	bne L04b6
L04f0
	lda #$09
	bne L04d7
L04f4
	jsr S062b
	lda $18
	jsr S05be
	lda $06
	sta $0d
	lda #$00
	jsr S0334
	lda $06
	ora #$80
	jsr S0334
	lda #$00
	sta $09
L0510
	jsr S0576
	lda $00
	sta L07a5
	cmp #$02
	bcc L051e
	bne L052c
L051e
	lda #$00
	sta $09
	beq L052c
L0524
	ldx $19
	inx
	txa
	ora #$80
	bne L053c
L052c
	lda $09
	beq L0538
	inc $09
	cmp #$10
	beq L0524
	bne L0510
L0538
	ldx $19
	inx
	txa
L053c
	jsr S0334
	lda #$02
	sta L0352 + 2
	jsr S0345
	lda #$07
	sta L0352 + 2
	bne L0573
L054e
	jsr S062b
	lda $06
	sta $0d
	lda #$05
	sta $0e
L0559
	jsr S05be
	jsr S03c9
	sta L07a5
	cmp #$02
	bcc L056e
	dec $0e
	bne L0559
	lda #$05
	bne L0570
L056e
	lda #$00
L0570
	jsr S0334
L0573
	jmp L0457
	
S0576
	lda #$00
	sta $30
	lda #$02
	sta $31
	jsr S0796
	jsr S07d3
	bne L05bb
L0586
	bvc L0586
	clv
	lda $1c01
	sta ($30),y
	iny
	bne L0586
	ldy #$ba
L0593
	bvc L0593
	clv
	lda $1c01
	sta $0100,y
	iny
	bne L0593
	; Decode 69 GCR bytes
	jsr $f8e0
	lda $38
	cmp $47
	beq L05ad
L05a8
	lda #$04
	pha
	bne L05b7
	; Calculate parity for data buffer
L05ad
	jsr $f5e9
	cmp $3a
	bne L05a8
	lda #$01
	pha
L05b7
	jsr S07a0
	pla
L05bb
	jmp L0780
	
S05be
	lda $18
	sta $06
S05c2
	lda $22
	cmp #$24
	bcc L05cc
	sbc #$23
	sta $22
	; Jumps to C1 in 20 E5 C1 
L05cc
	jsr $c906
	bit $08
	pha
L2511   ;The main source comments this jsr out with a bit in some cases
   	jsr $93f3
	pla
	plp
	bcc L05db
	sbc #$23
L05db
	pha
	ldx #$04
	; 4 track ranges
L05de
	cmp $fed6,x
	dex
	bcs L05de
	txa
	asl a
	asl a
	asl a
	asl a
	asl a
	sta $44
	lda $1c00
	and #$9f
	ora $44
	sta $1c00
	pla
	sec
	sbc $22
	asl a
	beq L0626
S05fd
	sta $4a
L05ff
	ldy #$02
L0601
	lda $4a
	bmi L060b
	; step counter for head transport
	jsr $fa63
	jmp L0614
	
L060b
	inc $4a
	ldx $1c00
	dex
	; stepper motor off
	jsr $fa69
L0614
	ldx #$0a
	stx $44
L0618
	dex
	bne L0618
	dec $44
	bne L0618
	dey
	bne L0601
	lda $4a
	bne L05ff
L0626
	lda $06
	sta $22
	rts
	
S062b
	jsr S033d
	bmi L0633
L0630
	jmp L0457
	
L0633
	and #$7f
	sta $18
	jsr S033d
	beq L0630
	tax
	dex
	stx $19
	rts
	
S0641
	jsr S0796
	ldx #$04
	lda $22
	cmp #$24
	bcc L064e
	sbc #$23
	; 4 track ranges
L064e
	cmp $fed6,x
	dex
	bcs L064e
	lda $078d,x
	sta $0c
	; number of sectors per track
	lda $fed1,x
	sta $43
	ldy #$00
	sty $0a
	sty $30
	ldx #$00
L0666
	lda $39
	jsr S0791
	iny
	lda $0a
	jsr S0791
	lda $06
	jsr S0791
	lda $17
	jsr S0791
	lda $16
	jsr S0791
	lda #$0f
	jsr S0791
	jsr S0791
	lda $01fa,y
	eor $01fb,y
	eor $01fc,y
	eor $01fd,y
	sta $01f9,y
	inc $0a
	lda $0a
	cmp $43
	bcc L0666
	tya
	pha
	lda #$02
	sta $31
	; convert header in buffer 0 to GCR
	jsr $fe30
	pla
	tay
	dey
L06ab
	lda $0200,y
	sta $0245,y
	dey
	bne L06ab
	lda $0200
	sta $0245
	; copy data from overflow buffer
	jsr $fdf5
	lda #$00
	sta $32
	lda $1c00
	and #$10
	bne L06cd
	lda #$08
	jmp L0780
	
L06cd
	lda $1c0c
	and #$1f
	ora #$c0
	sta $1c0c
	lda #$ff
	sta $1c03
	lda #$55
	sta $1c01
	ldx #$02
	; write 10240 times
	jsr $fe24
L06e6
	lda #$ff
	sta $1c01
	ldx #$05
L06ed
	bvc L06ed
	clv
	dex
	bne L06ed
	ldx #$0a
	ldy $32
L06f7
	bvc L06f7
	clv
	lda $0200,y
	sta $1c01
	iny
	dex
	bne L06f7
	ldx #$09
L0706
	bvc L0706
	clv
	lda #$55
	sta $1c01
	dex
	bne L0706
	lda #$ff
	ldx #$05
L0715
	bvc L0715
	clv
	sta $1c01
	dex
	bne L0715
	lda #$55
	sta L0787
	ldy #$04
L0725
	lda L0783,y
L0728
	bvc L0728
	clv
	sta $1c01
	dey
	bpl L0725
	lda #$52
	sta L0787
	ldx #$3f
L0738
	ldy #$04
L073a
	lda L0783,y
L073d
	bvc L073d
	clv
	sta $1c01
	dey
	bpl L073a
	dex
	bne L0738
	ldy #$04
L074b
	lda L0788,y
L074e
	bvc L074e
	clv
	sta $1c01
	dey
	bpl L074b
	ldx $0c
	lda #$55
L075b
	bvc L075b
	clv
	sta $1c01
	dex
	bne L075b
	lda $32
	clc
	adc #$0a
	sta $32
	dec $0a
	beq L0772
	jmp L06e6
	
L0772
	bvc L0772
	clv
L0775
	bvc L0775
	clv
	; switch to reading
	jsr $fe00
	jsr S07a0
L077e
	lda #$00
L0780
	sta $00
	rts
	
L0783
	.byte $4b,$2d,$b5,$d4 
L0787
	.byte $55 
L0788
	.byte $4a,$29,$a5,$d4,$52,$06,$09,$0a,$07 
S0791
	sta $0200,y
	iny
	rts
	
S0796
	lda $1c0c
	ora #$0e
L079b
	sta $1c0c
	clv
	rts
	
S07a0
	lda $1c0c
	bne L079b
L07a5
	.byte $00 
	
S07a6
	lda #$00
	eor $16
	eor $17
	eor $18
	eor $19
	sta $1a
	; convert block header to GCR
	jsr $f934
	ldx #$5a
L07b7
	jsr S07d8
	bne L07cc
L07bc
	bvc L07bc
	clv
	lda $1c01
	cmp $0024,y
	bne L07cd
	iny
	cpy #$08
	bne L07bc
L07cc
	rts
	
L07cd
	dex
	bne L07b7
	lda #$02
	rts
	
S07d3
	jsr S07a6
	bne L07cc
S07d8
	lda #$d0
	sta $1805
L07dd
	bit $1805
	bmi L07e5
	lda #$03
	rts
	
L07e5
	bit $1c00
	bmi L07dd
	lda $1c01
	clv
	ldy #$00
	rts
	
L07f1
	php
	jmp $2663
	
L07f5
	lda $0987
	sta $10
	lda $0988
	sta $11
L07ff
	brk
DriveSideFastDOSEnd
;=============================================================================
; END OF DRIVE-SIDE FASTLOADER CODE
;=============================================================================

