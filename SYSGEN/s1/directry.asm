;directry.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

  
 	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
 	
L95e0
	stx L97fa
	lda LTK_Var_ActiveLU
	sta L97fb
	lda LTK_Var_Active_User
	sta L97fc
	lda $9de6,x
	pha
	and #$0f
	sta LTK_Var_ActiveLU
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	ldx L97fa
	lda $9dfd,x
	bne L967e
	dec $9df1,x
	ldx #$00
	stx $9fff
	ldy LTK_DirPtnMatchBuffer
L9613
	dey
	lda $9fe1,y
	cmp #$3d
	bne L9631
	lda $9fe2,y
	ldx #$05
L9620
	cmp L97fe,x
	beq L962a
	dex
	bpl L9620
	ldx #$f6
L962a
	txa
	clc
	adc #$0a
	sta $9fff
L9631
	cmp #$3a
	beq L9641
	tya
	bne L9613
	ldx #$01
	lda #$2a
	sta $9fe1
	bne L9652
L9641
	ldx #$00
L9643
	iny
	cpy LTK_DirPtnMatchBuffer
	bcs L9652
	lda $9fe1,y
	sta $9fe1,x
	inx
	bne L9643
L9652
	stx LTK_DirPtnMatchBuffer
	ldx #$ee
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L9660
	ldx #$00
L9660
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9669
	lda $9271
	cmp #$80
	bcs L967e
	lda $9272
	asl a
	sta L9835
	lda $9271
	rol a
	sta L9836
L967e
	jmp L9863
	
L9681
	lda $9df8,x
	beq L9691
	cpx LTK_ReadChanFPTPtr
	beq L96b9
	jsr S9777
	jmp L96b9
	
L9691
	jsr S973e
	bcc L9699
	jmp L9b8f
	
L9699
	ldx L97fa
	jsr S9777
	lda $9bfc
	sta $9df8,x
	lda #$9b
	sta $9dee,x
	lda #$e0
	sta $9def,x
	lda #$00
	sta $9ded,x
	lda #$10
	sta $9df7,x
L96b9
	lda $9dee,x
	sta S9793 + 2
	lda $9def,x
	sta S9793 + 1
	lda $9df6,x
	bne L96f8
	ldy #$1d
	jsr S9793
	bpl L96e4
	jsr S970c
	jmp L96df
	
L96d7
	jsr S970c
	dec $9df8,x
	beq L9691
L96df
	dec $9df7,x
	bne L96b9
L96e4
	lda LTK_DirPtnMatchBuffer
	beq L96d7
	jsr S9799
	bcs L96d7
	lda #$20
	sta $9df6,x
	lda #$00
	sta $9ded,x
L96f8
	dec $9df6,x
	bne L9706
	dec $9df8,x
	dec $9df7,x
	jmp L9b7c
	
L9706
	jmp L992e
	
L9709
	clc
	bcc L971b
S970c
	clc
	lda $9def,x
	adc #$20
	sta $9def,x
	bcc L971a
	inc $9dee,x
L971a
	rts
	
L971b
	php
	pha
	lda L97fb
	sta LTK_Var_ActiveLU
	lda L97fc
	sta LTK_Var_Active_User
	pla
	plp
	rts
	
S972c
	ldy $9de7,x
	lda $9de8,x
	tax
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L973d
	rts
	
S973e
	lda $9df1,x
	bne L9745
	sec
	rts
	
L9745
	jsr S972c
	ldx L97fa
	lda $9de7,x
	sta $9deb,x
	ldy $9dfd,x
L9754
	lda $9202,y
	bne L9761
	iny
	dec $9df1,x
	bne L9754
	sec
	rts
	
L9761
	iny
	tya
	sta $9dfd,x
	dec $9df1,x
	clc
	adc $9de8,x
	sta $9dec,x
	bcc L9775
	inc $9deb,x
L9775
	clc
	rts
	
S9777
	stx LTK_ReadChanFPTPtr
	lda $9de6,x
	and #$0f
	pha
	ldy $9deb,x
	lda $9dec,x
	tax
	pla
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L978f
	ldx L97fa
	rts
	
S9793
	lda S9793,y
	rts
	
L9797
	sec
	rts
	
S9799
	ldy #$19
	jsr S9793
	lsr a
	lsr a
	lsr a
	lsr a
	cmp LTK_Var_Active_User
	bne L9797
	ldy #$16
	jsr S9793
	cmp #$06
	bcc L9797
	ldy $9fff
	beq L97c8
	cpy #$0a
	bne L97c3
	cmp #$0b
	beq L97c8
	cmp #$0c
	beq L97c8
	bne L9797
L97c3
	cmp $9fff
	bne L9797
L97c8
	ldy #$00
L97ca
	cpy LTK_DirPtnMatchBuffer
	bcs L97f3
	lda $9fe1,y
	cmp #$2a
	beq L97f8
	cmp #$3f
	bne L97e6
	jsr S9793
	beq L9797
L97df
	iny
	cpy #$10
	bne L97ca
	beq L97f8
L97e6
	sta L97fd
	jsr S9793
	cmp L97fd
	beq L97df
	bne L9797
L97f3
	jsr S9793
	bne L9797
L97f8
	clc
	rts
	
L97fa
	.byte $00
L97fb
	.byte $00
L97fc
	.byte $00
L97fd
	.byte $00
L97fe
	.text "pbmsur"
L9804
	.byte $82,$82,$81,$83,$84 
L9809
	.text "grpgrpqesrsuler"
L9818
	.text "lt kernal 7.2   {$a0}{$a0}"
L982a
	.text "lk{$a0}2a"
L982f
	.byte $00
L9830
	.byte $00
L9831
	.byte $00
L9832
	.byte $00
L9833
	.byte $01,$01 
L9835
	.byte $ff 
L9836
	.byte $ff 
L9837
	.text "blocks free.             "
	.byte $00,$00,$00 
L9853
	.byte $00,$00,$0a,$00,$5a,$00,$84,$03,$28,$23 
L985d
	ldx L97fa
	jmp L9681
	
L9863
	ldx L97fa
	lda $9df3,x
	bne L985d
	lda #$01
	sta $9dfd,x
	jsr S9bc7
	beq L98d0
	lda $9df2,x
	beq L98b2
	cmp #$01
	beq L98b6
	cmp #$a9
	bcs L98b6
	cmp #$8e
	bcc L98ba
	cmp #$a0
	bcc L98c7
	cmp #$a5
	bcc L98be
	lda #$a0
L9890
	inc $9df2,x
	pha
	lda $9df2,x
	cmp #$ff
	bcs L98a0
	pla
	clc
	jmp L971b
	
L98a0
	lda #$00
	sta $9df2,x
	sta $9df3,x
	sta $9dfd,x
	inc $9df3,x
	pla
	jmp L9681
	
L98b2
	lda #$41
	bne L9890
L98b6
	lda #$00
	beq L9890
L98ba
	lda #$ff
	bne L9890
L98be
	sec
	sbc #$a0
	tay
	lda L982a,y
	bne L9890
L98c7
	sec
	sbc #$8e
	tay
	lda L9818,y
	bne L9890
L98d0
	lda $9df2,x
	cmp #$02
	bcc L98fb
	cmp #$04
	bcc L9907
	cmp #$06
	bcc L98b6
	beq L990b
	cmp #$07
	beq L990f
	cmp #$18
	bcc L9913
	beq L990f
	cmp #$19
	beq L992a
	cmp #$1f
	bcc L991f
	beq L98b6
	lda #$00
	pha
	jmp L98a0
	
L98fb
	cmp #$01
	beq L9903
	lda #$01
	bne L9890
L9903
	lda #$04
	bne L9890
L9907
	lda #$01
	bne L991c
L990b
	lda #$12
	bne L991c
L990f
	lda #$22
	bne L991c
L9913
	sec
	sbc #$08
	tay
	lda L9818,y
	and #$7f
L991c
	jmp L9890
	
L991f
	sec
	sbc #$1a
	tay
	lda L982a,y
	and #$7f
	bpl L991c
L992a
	lda #$20
	bne L991c
L992e
	ldx L97fa
	jsr S9bc7
	bne L9939
	jmp L99da
	
L9939
	lda $9df2,x
	and #$1f
	beq L9961
	cmp #$03
	bcc L996f
	cmp #$13
	bcc L997f
	cmp #$15
	bcc L99bb
	beq L998c
	cmp #$1c
	bcc L9956
	cmp #$1e
	bcc L9991
L9956
	lda $9df2,x
	cmp #$fe
	bcs L99c3
	lda #$00
	beq L99bb
L9961
	ldy #$16
	jsr S9793
	sec
	sbc #$0b
	tay
	lda L9804,y
	bne L99bb
L996f
	cmp #$01
	beq L9977
	ldy #$1e
	bne L9979
L9977
	ldy #$1f
L9979
	jsr S9793
	jmp L99bb
	
L997f
	sec
	sbc #$03
	tay
	jsr S9793
	bne L99bb
	lda #$a0
	bne L99bb
L998c
	ldy #$13
	jmp L9979
	
L9991
	sec
	sbc #$1c
	pha
	ldy #$10
	jsr S9793
	sta L9830
	iny
	jsr S9793
	sec
	sbc #$01
	sta L982f
	lda L9830
	sbc #$00
	sta L9830
	clc
	rol L982f
	rol L9830
	pla
	tay
	lda L982f,y
L99bb
	pha
	inc $9df2,x
	pla
	jmp L9709
	
L99c3
	lda #$00
	sta $9df2,x
	sta $9df6,x
	dec $9ded,x
	jsr S970c
	dec $9df8,x
	dec $9df7,x
	jmp L967e
	
L99da
	lda $9df2,x
	cmp #$02
	bcc L9a35
	cmp #$04
	bcc L9a39
	cmp #$1f
	beq L9a15
	jsr S9bd3
	bne L99f6
	jsr S9bcd
	ora #$20
	sta $9dfb,x
L99f6
	jsr S9bd3
	cmp #$20
	beq L9a20
	cmp #$40
	beq L9a23
	cmp #$60
	beq L9a26
	cmp #$80
	beq L9a29
	cmp #$a0
	beq L9a2c
	cmp #$c0
	beq L9a2f
	cmp #$e0
	beq L9a32
L9a15
	lda #$00
	sta $9df2,x
	sta $9dfb,x
L9a1d
	jmp L9709
	
L9a20
	jmp L9ab3
	
L9a23
	jmp L9ad5
	
L9a26
	jmp L9ae5
	
L9a29
	jmp L9adc
	
L9a2c
	jmp L9b27
	
L9a2f
	jmp L9b48
	
L9a32
	jmp L9b79
	
L9a35
	lda #$01
	bne L9ab0
L9a39
	ldy #$10
	jsr S9793
	sta L9830
	iny
	jsr S9793
	sec
	sbc #$01
	sta L982f
	lda L9830
	sbc #$00
	sta L9830
	clc
	rol L982f
	rol L9830
L9a5a
	lda L9830
	sta L9832
	lda L982f
	sta L9831
	ldy #$02
L9a68
	sec
	lda L9831
	sbc L9853,y
	iny
	sta L9831
	lda L9832
	sbc L9853,y
	sta L9832
	bcc L9a8f
	iny
	cpy #$0a
	bne L9a68
	lda #$0f
	sta L982f
	lda #$27
	sta L9830
	bne L9a5a
L9a8f
	tya
	lsr a
	sta L9831
	lda #$04
	sec
	sbc L9831
	sta L9831
	jsr S9bd3
	ora L9831
	sta $9dfb,x
	lda $9df2,x
	sec
	sbc #$02
	tay
	lda L982f,y
L9ab0
	jmp L99bb
	
L9ab3
	jsr S9bcd
	beq L9ad5
	tay
	dey
	jsr S9bd3
	sta $9dfb,x
	tya
	ora $9dfb,x
	sta $9dfb,x
	and #$1f
	bne L9ad0
	lda #$40
	sta $9dfb,x
L9ad0
	lda #$20
L9ad2
	jmp L99bb
	
L9ad5
	lda #$60
	sta $9dfb,x
	bne L9ae1
L9adc
	lda #$a0
	sta $9dfb,x
L9ae1
	lda #$22
	bne L9ad2
L9ae5
	jsr S9bcd
	bne L9b09
	ldy #$10
L9aec
	dey
	jsr S9793
	beq L9aec
	jsr S9bd3
	iny
	sta $9dfb,x
	tya
	clc
	adc #$10
	sta $9df9,x
	tya
	ora $9dfb,x
	sta $9dfb,x
	and #$1f
L9b09
	sta L982f
	lda $9df9,x
	sec
	sbc #$10
	sec
	sbc L982f
	tay
	dec $9dfb,x
	jsr S9bcd
	bne L9b24
	lda #$80
	sta $9dfb,x
L9b24
	jmp L9979
	
L9b27
	jsr S9bcd
	bne L9b37
	sec
	lda #$21
	sbc $9df9,x
	ora #$a0
	sta $9dfb,x
L9b37
	dec $9dfb,x
	jsr S9bcd
	bne L9b44
	lda #$c3
	sta $9dfb,x
L9b44
	lda #$20
	bne L9ad2
L9b48
	dec $9dfb,x
	jsr S9bcd
	bne L9b55
	lda #$e0
	sta $9dfb,x
L9b55
	jsr S9bcd
	sta L982f
	ldy #$16
	jsr S9793
	sec
	sbc #$0b
	sta L9830
	clc
	rol L9830
	clc
	adc L9830
	clc
	adc L982f
	tay
	lda L9809,y
	jmp L99bb
	
L9b79
	jmp L9ad0
	
L9b7c
	jsr S970c
	jsr S9bc7
	beq L9b87
	jmp L9706
	
L9b87
	lda #$00
	sta $9dfb,x
	jmp L9a15
	
L9b8f
	lda $9dfb,x
	bne L9b99
	lda #$20
	sta $9dfb,x
L9b99
	dec $9dfb,x
	bne L9ba1
	jsr S9bb8
L9ba1
	jsr S9bc7
	bne L9bb3
	lda #$1f
	sec
	sbc $9dfb,x
	tay
	lda L9833,y
	jmp L9a1d
	
L9bb3
	lda #$00
	jmp L9a1d
	
S9bb8
	txa
	pha
	lda #$40
	sta $90
	sta $9dfc,x
	jsr L971b
	pla
	tax
	rts
	
S9bc7
	lda $9dff,x
	and #$0f
	rts
	
S9bcd
	lda $9dfb,x
	and #$1f
	rts
	
S9bd3
	lda $9dfb,x
	and #$e0
	rts
