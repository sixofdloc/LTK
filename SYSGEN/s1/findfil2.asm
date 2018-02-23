;findfil2.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0 , $4000 for sysgen
L93e0               
	lda #$00
	sta $94ad
	tay
L93e6               
	lda LTK_FileHeaderBlock,y
	beq L93ee
	iny
	bne L93e6
L93ee
	sty $9518
	sec
	jsr S94af
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L9400
	ldx #$11
L9400
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;9be0
L9409               
	lda #$fe
	sta L94ac
L940e
	lda #$8f
	sta S9519 + 2
	lda #$e0
	sta S9519 + 1
	lda L94ac
	beq L942b
	ldy $94ad
L9420
	lda $9c02,y
	bne L942e
	iny
	dec L94ac
	bne L9420
L942b
	jmp L9497
                    
L942e
	iny
	sty $94ad
	dec L94ac
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L9440
	lda #$11
L9440
	ldy #$00
	clc
	adc $94ad
	tax
	bcc L944a
	iny
L944a
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
L9454
	lda $8ffc
	sta $94ae
L945a
	ldy #$1d
	jsr S9519
	bmi L946b
	jsr S94b8
	bcc L9471
	dec $94ae
	beq L940e
L946b
	jsr S949d
	jmp L945a
                    
L9471
	ldy #$1f
	jsr S9519
	tax
	dey
	jsr S9519
	tay
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0
L9486
	clc
	jsr S94af
	ldx $94ad
	dex
	txa
	ldx S9519 + 1
	ldy S9519 + 2
	clc
	rts
                    
L9497
	clc
	jsr S94af
	sec
	rts
                    
S949d 
	clc
	lda S9519 + 1
	adc #$20
	sta S9519 + 1
	bcc L94ab
	inc S9519 + 2
L94ab
	rts
                    
L94ac
	.byte $00,$00,$00
S94af
	lda #$01
	ldx #$e0
	ldy #$9b
	jmp LTK_MemSwapOut
                    
S94b8               
	ldy #$19
	jsr S9519
	lsr a
	lsr a
	lsr a
	lsr a
	cmp LTK_Var_Active_User
	bne L9513
	ldy #$16
	jsr S9519
	cmp #$01
	beq L9513
	cmp #$02
	beq L9513
	cmp #$03
	beq L9513
	ldx L9517
	beq L94e1
	cmp L9517
	bne L9513
L94e1
	ldx #$00
	ldy #$00
L94e5
	cpx $9518
	bcc L94f5
	cpy #$10
	bcs L9515
	jsr S9519
	beq L9515
	bne L9513
L94f5
	lda LTK_FileHeaderBlock,x
	cmp #$2a
	beq L9515
	cpy #$10
	bcs L9515
	jsr S9519
	beq L9513
	inx
	iny
	cmp LTK_FileHeaderBlock-$01,x
	beq L94e5
	lda LTK_FileHeaderBlock-$01,x
	cmp #$3f
	beq L94e5
L9513
	sec
	rts
                    
L9515
	clc
	rts
                    
L9517
	.byte $00,$00
S9519
	lda S9519,y
	rts