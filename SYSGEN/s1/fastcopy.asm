;fastcopy.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen 
 
L95e0
	jmp L9606
	
L95e3
	jmp L95fa
	
L95e6
	.byte $00
L95e7
	.byte $00
L95e8
	.byte $00
L95e9
	.byte $00
L95ea
	.byte $00
L95eb
	.byte $00
L95ec
	.byte $00
L95ed
	.byte $00
L95ee
	.byte $00
L95ef
	.byte $00
L95f0
	.byte $00
L95f1
	.byte $00
L95f2
	.byte $00
L95f3
	.byte $00
L95f4
	.byte $00
L95f5
	.byte $00
L95f6
	.byte $00
L95f7
	.byte $00
L95f8
	.byte $00
L95f9
	.byte $00
L95fa
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$c0,$08 
L9603
	jmp $c000
	
L9606
	lda LTK_Var_ActiveLU
	sta L9854
	lda LTK_Var_Active_User
	sta L9855
	lda #$0a
	ldx #$92
	ldy #$02
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$6c,$0a 
L961f
	lda $d030
	and #$03
	sta L9856
L9627
	lda #$00
	sta $1c9d
	sta $d030
	ldx #$14
	jsr S9824
	bcs L9627
	cpy #$02
	bne L9641
	cmp #$51
	bne L9641
	jmp L9794
	
L9641
	lda #$e0
	ldx #$8f
	ldy #$00
	jsr S9881
	bcs L9627
	tay
	bne L9627
	cpx #$05
	bcc L9627
	stx L9857
	lda #$16
	ldx #$e0
	ldy #$8f
	jsr $6c03
	lda #$0a
	ldx #$9c
	ldy #$02
	clc
	jsr LTK_HDDiscDriver 
	jsr $011c
	lda L9857
	jsr $1c20
	bcc L9677
	jmp L97fd
	
L9677
	stx L9858
	ldx #$fc
	ldy #$01
	cmp #$38
	beq L9686
	ldx #$f0
	ldy #$01
L9686
	sta L95e6
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	jsr $0c1c
	lda L9858
	sta $1c9b
	lda #$ff
	sta LTK_Var_SAndRData
	sta $8026
	sta $8027
	lda #$15
	ldx #$e6
	ldy #$95
	jsr $6c03
	ldx #$17
	jsr $6c00
	lda L9857
	jsr $1c59
	lda #$ff
	sta L9859
	lda $01
	sta L97b2 + 1
	ldx LTK_Var_CPUMode
	bne L96ca
	and #$fe
	sta $01
L96ca
	txa
	beq L96d0
	jsr S9805
L96d0
	lda #$31
	sta L985a + 5
	lda LTK_Var_CPUMode
	beq L96e6
	lda $d7
	beq L96e6
	lda #$01
	sta $d030
	sta $1c9d
L96e6
	ldx #$18
	jsr $6c00
	ldx #$19
	jsr $6c00
	ldx #$1a
	jsr $6c00
	ldx #$65
	ldy #$98
	jsr LTK_Print 
	jsr S9819
	ldx #$1b
	jsr $6c00
	jsr S9819
	ldx #$1c
	jsr $6c00
	jsr S9819
	ldx #$42
	jsr $6c00
	jsr S9819
	ldx #$30
	jsr $6c00
	jsr S9819
	ldx #$69
	ldy #$98
	jsr LTK_Print 
	jsr S9819
	ldx #$69
	ldy #$98
	jsr LTK_Print 
	jsr S9819
	ldx #$69
	ldy #$98
	jsr LTK_Print 
	jsr S9819
	ldx #$1e
	jsr $6c00
	ldx #$15
	jsr $6c00
	ldx #$6c
	ldy #$98
	jsr LTK_Print 
L974e
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	tax
	beq L974e
	cmp #$85
	bne L9760
	jmp L97c9
	
L9760
	cmp #$89
	bne L9767
	jmp L97cf
	
L9767
	cmp #$86
	bne L976e
	jmp L97d5
	
L976e
	cmp #$8a
	bne L9778
	jsr L97aa
	jmp L9627
	
L9778
	cmp #$87
	bne L977f
	jmp L96d0
	
L977f
	cmp #$8b
	bne L9786
	jmp L96d0
	
L9786
	cmp #$88
	bne L978d
	jmp L96d0
	
L978d
	cmp #$8c
	bne L974e
	jsr L97aa
L9794
	lda L9854
	sta LTK_Var_ActiveLU
	lda L9855
	sta LTK_Var_Active_User
	lda $d030
	ora L9856
	sta $d030
	rts
	
L97aa
	lda LTK_Var_CPUMode
	beq L97b2
	jsr S9805
L97b2
	lda #$00
	sta $01
	lda #$00
	sta $d030
	bit L9859
	bpl L97c3
	jsr $1c5c
L97c3
	lda #$00
	sta L9859
	rts
	
L97c9
	lda #$08
	ldx #$02
	bne L97d9
L97cf
	lda #$18
	ldx #$02
	bne L97d9
L97d5
	lda #$28
	ldx #$02
L97d9
	pha
	txa
	pha
	lda #$08
	ldx #$00
	ldy #$c0
	sec
	jsr LTK_MemSwapOut 
	pla
	tay
	pla
	tax
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$c0,$08 
L97f3
	jsr $c000
	clc
	jsr LTK_MemSwapOut 
	jmp L96d0
	
L97fd
	ldx #$1d
	jsr $6c00
	jmp L9794
	
S9805
	ldy #$11
L9807
	lda L986f,y
	tax
	lda $1000,y
	sta L986f,y
	txa
	sta $1000,y
	dey
	bpl L9807
	rts
	
S9819
	ldx #$5a
	ldy #$98
	jsr LTK_Print 
	inc L985a + 5
	rts
	
S9824
	stx $9845
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L9831
	jsr LTK_KernalCall 
	sta LTK_MiscWorkspace,y
	iny
	cpy #$10
	bcs L9841
	cmp #$0d
	bne L9831
	clc
L9841
	php
	tya
	pha
	lda #$00
	ldx #$e0
	ldy #$8f
L984a
	jsr $6c03
	pla
	tay
	plp
	lda LTK_MiscWorkspace
	rts
	
L9854
	.byte $00
L9855
	.byte $00
L9856
	.byte $00
L9857
	.byte $00
L9858
	.byte $00
L9859
	.byte $00
L985a
	.text "  {rvs on} f1 {rvs off}  "
	.byte $00
L9865
	.text "{Return}{Return}{Return}"
	.byte $00
L9869
	.text "{Return}{Return}"
	.byte $00
L986c
	.text "1{Rvs Off}"
L986e
	.byte $00
L986f
	.byte $01 
L9870
	.byte $01 
L9871
	.byte $01 
L9872
	.byte $01 
L9873
	.byte $01 
L9874
	.byte $01 
L9875
	.byte $01 
L9876
	.byte $01 
L9877
	.byte $00
L9878
	.byte $00
L9879
	.byte $85 
L987a
	.byte $89 
L987b
	.byte $86 
L987c
	.byte $8a 
L987d
	.byte $87 
L987e
	.byte $8b 
L987f
	.byte $88 
L9880
	.byte $8c 
S9881
	sta L9892 + 1
	stx L9892 + 2
	lda #$00
	sta L98fc
	sta L98fd
	sta L98fe
L9892
	lda L9892,y
	cmp #$30
	bcc L98ea
	cmp #$3a
	bcc L98af
	ldx L98ba + 1
	cpx #$0a
	beq L98ea
	cmp #$41
	bcc L98ea
	cmp #$47
	bcs L98ea
	sec
	sbc #$07
L98af
	ldx L98fc
	beq L98d3
	pha
	tya
	pha
	lda #$00
	tax
L98ba
	ldy #$0a
L98bc
	clc
	adc L98fe
	pha
	txa
	adc L98fd
	tax
	pla
	dey
	bne L98bc
	sta L98fe
	stx L98fd
	pla
	tay
	pla
L98d3
	inc L98fc
	sec
	sbc #$30
	clc
	adc L98fe
	sta L98fe
	bcc L98e7
	inc L98fd
	beq L98f4
L98e7
	iny
	bne L9892
L98ea
	cmp #$20
	beq L98e7
	clc
	ldx L98fc
	bne L98f5
L98f4
	sec
L98f5
	lda L98fd
	ldx L98fe
	rts
	
L98fc
	.byte $00
L98fd
	.byte $00
L98fe
	.byte $00
