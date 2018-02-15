;sysbootr.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	*=$0400 ;$4000 for sysgen
	
START
	lda $9e43
	sta $04c3
	cmp #$df
	beq clear_roms_boot_stub

	lda #$00
	sta $31
	lda #$04
	sta $32
	lda #$00
	sta $33
	lda #$08
	sta $34
	jsr $93e0

clear_roms_boot_stub
	ldx #$03
	lda #$00
	tay
clearbootstubloop
	sta $cd00,y
	iny
	bne clearbootstubloop
	inc clearbootstubloop + 2
	dex
	bne clearbootstubloop

	;copy kernal into shadow ram
	ldx #$20
	ldy #$00
L0432
	lda #$3c
	sta $df03	;set normal c64 mem at $e000
	lda $e000,y
	pha
	lda #$34
	sta $df03	;set shadow ram at $e000
	pla
	sta $e000,y
	iny
	bne L0432
	inc $0439
	inc $0443
	dex
	bne L0432

	lda #$00
	sta $31
	lda #$80
	sta $32
	lda #$07
	sta $07ab
	lda #$01
	sta $07aa
	jsr S0702
	lda $9e43
	cmp #$df
	beq L047f
	lda $8046
	sta $31
	sta $33
	ldx $8047
	stx $32
	inx
	inx
	stx $34
	jsr $93e0
L047f
	lda $91f2
	and #$3f
	sta $07ad
	lda $91f3
	sta $07ae
	ldx $91f9
	dex
	stx $07b0
	lda $91f6
	sta $07b1
	ldx $91f7
	dex
	stx $07b2
	lda $91f5
	sta $07b3
	lda $91fa
	sta $07b4
	ldx $9e43
	lda #$00
	tay
L04b3
	sta $9de0,y
	iny
	bne L04b3
	stx $9e43
	lda #$ff
	sta $9de0
	lda $df04
	and #$0f
	pha
	bne L04e4
	bit $91f2
	bmi L04e4
	sta $07aa
	sta $07ab
	jsr S06ec
	lda #$20
	sta $07a8
	jsr S06ec
	lda #$00
	sta $07a8
L04e4
	pla
	clc
	adc #$9e
	sta $07aa
	lda #$02
	adc #$00
	sta $07a9
	lda #$e0
	sta $31
	lda #$9b
	sta $32
	lda #$01
	sta $07ab
	jsr S0702
	lda $9bf9
	sta $d030
	sta $8038
	lda $9bee
	sta $8029
	lda $9be8
	sta $802a
	ldx #$4c
	ldy #$00
L051b
	lda $05ab,y
	sta $fc3d,y
	iny
	dex
	bne L051b
	ldx #$f5
	ldy #$00
L0529
	lda L05f7,y
	sta $f92c,y
	iny
	dex
	bne L0529
	ldx $93e3
	ldy #$00
L0538
	lda $93e4,y
	sta $fa2c,y
	iny
	dex
	bne L0538
	ldx #$09
	ldy #$00
	jsr S058f
	ldx #$02
	ldy #$24
	jsr S058f
	lda $9bfc
	beq L0567
	lda #$83
	sta $fffe
	lda #$fc
	sta $ffff
	lda #$ea
	sta $fc44
	sta $fc4e
L0567
	lda $9bfe
 	beq L0576
 	lda #$86
 	sta $fffa
 	lda #$fc
 	sta $fffb
L0576
	lda #$00
	sta $df02
L057b
	sta $8004
	jmp L07b7
                    
L0581
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$00
	beq L057b
S058f
	lda L05a8
	sta OPEN,y
	iny
	lda L05a8 + 1
	sta OPEN,y
	iny
	lda L05a8 + 2
	sta OPEN,y
	iny
	dex
	bne S058f
	rts
                    
L05a8
	jsr $fc59
	lda #$00
	sta $df02
	pla
	plp
	cli
S05b3
	jsr S05b3
	jsr $fc4e
	jmp ($800b)
                    
L05bc
	sei
	php
	pha
	lda #$40
	sta $df02
	pla
	plp
	rts
                    
L05c7	
	jsr $fc4e
	jmp ($800d)
                    
L05cd
	.byte $40,$ff,$ea
L05d0
	jmp $f92c
                    
L05d3
	jmp $f949
                    
L05d6
	jmp $f981
                    
L05d9
	jmp $f989
                    
L05dc
	jmp $f991
                    
L05df
	jmp $f9be
                    
L05e2
	jsr $fc4e
	jmp ($8009)
                    
L05e8
	jmp L05e8
                    
L05eb
	jmp L05eb
                    
L05ee
	jmp $f999
                    
L05f1
	jmp $f9c8
                    
L05f4
	jmp $f9cb
                    
L05f7
	jsr $f976
L05fa
	lda $df02
	bmi L05fa
	and #$04
	beq L0634
	ldx #$02
L0605
	lda $df00
	sta ($31),y
	iny
	bne L0605
	inc $32
	dex
	bne L0605
	beq L05fa
	jsr $f976
L0617
	lda $df02
	bmi L0617
	and #$04
	beq L0634
	ldx #$02
L0622
	lda ($31),y
	sta $df00
	lda $df00
	iny
	bne L0622
	inc $32
	dex
	bne L0622
	beq L0617
L0634
	php
	pha
	lda #$40
	sta $df02
	sta $fc5f
	pla
	plp
	rts
                    
L0641
	php
	pha
	lda $fc5f
	sta $df02
	pla
	plp
	rts
                    
L064c
	jsr $f9be
	lda ($22),y
	jmp $f969
                    
L0654
	jsr $f9be
	sta ($31),y
	jmp $f969
                    
L065c
	jsr $f9be
	lda ($31),y
	jmp $f969
                    
L0664
	sta $f9b3
	pla
	sta $f9bc
	pla
	sta $f9bd
	inc $f9bc
	bne L0677
	inc $f9bd
L0677
	lda #$00
	sta $df02
	tay
	lda #$00
	sta ($ae),y
	lda #$40
	sta $df02
L0686	
	jmp L0686
                    
L0689
	php
	pha
	lda #$00
	sta $df02
	pla
	plp
	rts
                    
L0693
	clc
	bcc L0697
	sec
L0697
	bit $df02
	bvc L06bf
	pha
	lda $8028
	pha
	lda $802c
	pha
	lda $802d
	pha
	lda $802e
	pha
	lda $802f
	pha
	lda #$00
	sta $df02
	lda #$fa
	pha
	lda #$06
	pha
	lda #$04
	pha
L06bf
	bcc L06c4
	jmp $fe43
                    
L06c4
	bvs L06cb
	bit $fc60
	bvs L06ce
L06cb
	jmp $ff48
                    
L06ce
	jmp $fa2c
                    
L06d1
	lda #$40
	sta $df02
	pla
	sta $802f
	pla
	sta $802e
	pla
	sta $802d
	pla
	sta $802c
	pla
	sta $8028
	pla
	rti
                    
S06ec
	lda #$c2
	sta L07a7
	jsr S0737
	bne L0736
	ldx #$10
	ldy #$00
	jsr S0753
	jsr S0790
	txa
	rts
                    
S0702
	lda #$08
	sta L07a7
	jsr S0737
	bne L0736
	ldx #$06
	ldy #$00
	jsr S0753
	ldy #$00
	jsr S0769
	lda #$2c
	sta $df01
L071d
	lda $df02
	bmi L071d
	and #$04
	beq L0732
	lda $df00
	sta ($31),y
	iny
	bne L071d
	inc $32
	bne L071d
L0732
	jsr S0790
	txa
L0736
	rts
                    
S0737
	jsr S076c
	lda #$fe
	sta $df00
	lda #$50
	sta $df02
L0744
	lda $df02
	and #$08
	bne L0744
	ora #$40
	sta $df02
	lda #$00
	rts
                    
S0753
	jsr S077c
	lda L07a7,y
	eor #$ff
	sta $df00
	jsr S0782
	iny
	dex
	bne S0753
	jsr S077c
	rts
                    
S0769               
	ldx #$00
	.byte $2c 
S076c
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
                    
S077c
	lda $df02
	bmi S077c
	rts
                    
S0782
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
S0790
	jsr S0769
	jsr S0799
	and #$9f
	tax
S0799
	jsr S077c
	lda $df00
	eor #$ff
	tay
	jsr S0782
	tya
	rts
                    
L07a7                                    
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	
L07b7   
	lda #$fc
	pha
	lda #$e2
	pha
	lda #$04
	pha
	lda #$40
	ldy #$00
L07c4
	sta START,y
	iny
	bne L07c4
	inc L07c4 + 2
	bne L07c4