
	.include "../../include/kernal.asm"
	*=$8000
;setup.prg
 
SETUP_Start               
	jmp START
                    
L8003               
	.byte $a9,$9b,$00,$00,$00,$00,$00,$00 
START
	jsr S8198
	bit $9bb7
	bvc L802d
	jsr S9719
	lda #$7f
	sta $df00
	lda #$60
	sta $df02
	ldx #$00
L8022
	inx
	bne L8022
L8025
	inx
	bne L8025
	lda #$40
	sta $df02
L802d
	bit $9bb7
	bmi L8035
	jsr S9656
L8035
	ldx #$00
	stx $9799
	stx $979a
	inx
	stx $979d
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	jsr S8c96
	lda $9c1e
	beq L805e
	cmp #$ac
	beq L805e
	cmp #$af
	beq L805e
	dec $822a
L805e
	lda #$ff
	sta $9c1e
	jsr S8c9e
	ldy #$07
	ldx #$00
L806a
	lda $9ba9,y
	cmp $9df4,y
	bne L8077
	dey
	bpl L806a
	bmi L80a3
                    
	;print warning about serial # on drive not matching sysgen disk
L8077
	ldx #<str_SNMismatchWarning
	ldy #>str_SNMismatchWarning
	jsr printZTString
	cli
L807f
	jsr GETIN
	tax
	beq L807f
	sei
	cmp #$59
	beq L809a
L808a
	ldy #$00
L808c
	lda L818f,y
	sta $033c,y
	beq L8097
	iny
	bne L808c
L8097
	jmp $033c
                    
L809a
	dec $8229
	dec $822a
	jmp L810a
                    
L80a3
	lda #$00
	sta $979c
	lda #$9e
	sta $979b
	lda #$1a
	sta $979a
	jsr S8c96
	ldx #$00
	lda $9cad
	cmp #$37
	bne L80c6
	lda $9cae
	cmp #$2e
	bne L80c6
	dex
L80c6
	stx $8228
	txa
	beq L80eb
	ldy #$31
L80ce
	lda $9e04,y
	sta $841a,y
	dey
	bpl L80ce
	ldx #$0a
	ldy #$00
L80db
	lda $841c,y
	and #$f7
	sta $841c,y
	iny
	iny
	iny
	iny
	iny
	dex
	bne L80db
L80eb
	lda #$9d
	sta $979a
	lda #$02
	sta $9799
	jsr S8c96
	ldy #$0f
L80fa
	lda $9e00,y
	cmp L90f4,y
	bne L8107
	dey
	bpl L80fa
	bmi L810a
L8107
	dec $822a
	;print message "Please Wait, SYSGEN in progress"
L810a               
	ldx #<str_SYSGENInProgress
	ldy #>str_SYSGENInProgress
	jsr printZTString
	jsr S8452
	ldx #$00
	stx $9799
	stx $979a
	inx
	stx $979d
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	jsr S8c96
	ldy #$37
L812f
	lda $9bbf,y
	sta $9d00,y
	dey
	bpl L812f
	lda $8cf5
	sta $9c94
	lda $8cf6
	sta $9c95
	;print "checksumming" message
	ldx #<str_Checksumming
	ldy #>str_Checksumming
	jsr printZTString
	jsr S822b
	php
	ldy #$05
L8151               
	lda $9bb1,y
	sta $9c96,y
	dey
	bpl L8151
	iny
L815b
	lda txt_LTKRev,y
	beq L8166
	sta $9c9d,y
	iny
	bne L815b
L8166
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	lda #$00
	sta $9c1e
	sta $9799
	sta $979a
	jsr S8c9e
	;print message that Initialization is complete...
	ldx #<str_InitComplete
	ldy #>str_InitComplete
	plp
	; or...
	beq L8189
	;print message that checksums did not match
	ldx #<str_CSMismatch
	ldy #>str_CSMismatch
L8189
	jsr printZTString
LOCKUP
	jmp LOCKUP
                    
L818f
	lda #$3c
	sta $df03
	jmp $fce2

	.byte $00                    

S8198
	ldx #$08
	lda #$01
	sta $df00
L819f               
	cmp $df00
	bne L81b3
	clc
	rol $df00
	rol a
	dex
	bne L819f
	lda #$df
	bne L8223
L81b0
	jmp L808a
                    
L81b3
	ldx #$08
	lda #$01
	sta $de00
L81ba
	cmp $de00
	bne L81b0
	clc
	rol $de00
	rol a
	dex
	bne L81ba
	lda #$00
	sta $fb
	lda #$80
	sta $fc
L81cf
	ldy #$00
	jsr S8224
	cmp #$8d
	beq L81f0
	cmp #$8e
	beq L81f0
	cmp #$8c
	beq L81f0
	cmp #$ad
	beq L81f0
	cmp #$ae
	beq L81f0
	cmp #$ac
	beq L81f0
	cmp #$2c
	bne L8211
L81f0
	jsr S8224
 	cmp #$04
 	bcs L8211
 	jsr S8224
 	cmp #$df
 	bne L8211
 	lda #$de
 	dey
 	sta ($fb),y
 	lda $fb
 	clc
 	adc #$03
 	sta $fb
 	bcc L820e
 	inc $fc
L820e
	clc
 	bcc L81cf
L8211
	inc $fb
 	bne L8217
 	inc $fc
L8217
	lda $fc
 	cmp #$a0
 	bne L81cf
 	lda $fb
 	cmp #$00
 	bcc L81cf
L8223
	rts
                    
S8224
	lda ($fb),y
 	iny
 	rts
                    
 	.byte $00,$00,$00
S822b
	lda #$00
	sta $979c
	lda #$9e
	sta $979b
	ldx #$01
	stx $979d
	ldy #$00
L823c
	stx $979a
	sty $9799
	jsr S8c96
	lda #$00
	sta $fb
	lda #$9e
	sta $fc
	ldy #$00
	ldx #$02
L8251
	lda ($fb),y
	pha
	clc
	adc $8005
	sta $8005
	lda #$00
	adc $8006
	sta $8006
	pla
	clc
	adc $8009
	asl a
	sta $8009
	lda $800a
	rol a
	bcc L827a
	inc $8007
	bne L827a
	inc $8008
L827a
	sta $800a
	iny
	bne L8251
	inc $fc
	dex
	bne L8251
	ldx $979a
	ldy $9799
	inx
	bne L828f
	iny
L828f
	tya
	bne L82a1
	cpx #$1a
	bne L8297
	inx
L8297
	cpx #$ee
	bne L82ad
	ldx #$ef
	ldy #$01
	bne L82ad
L82a1
	cpy #$02
	bne L82ad
	cpx #$9e
	bne L82ad
	ldx #$2e
	ldy #$03
L82ad
	cpy $9c94
	beq L82b5
L82b2
	jmp L823c
                    
L82b5
	cpx $9c95
	bne L82b2
	ldy #$05
L82bc
	lda $9bb1,y
	cmp $8005,y
	bne L82c8
	dey
	bpl L82bc
	iny
L82c8
	rts
                    
str_SYSGENInProgress ;$82c9               
	.text "{clr}{return}{rvs on}please wait...sysgen in process{return}{return}"
	.byte $00
str_SNMismatchWarning ;$82ee
	.text "{clr}{return}warning - your drive serial number does not match this sysgen disk !!!{return}{return}if your drive fails to boot upon{return}completion, please call for assistance .{return}{return}do you wish to proceed ? "
	.byte $00
str_Checksumming ;$839d
	.text "{clr}{return}{rvs on}please wait...checksumming the dos.{return}{return}"
	.byte $00
str_CSMismatch ;$83c6
	.text "{clr}{return}sorry, the dos checksums did {rvs on}not{rvs off} verify.{return}{return}you must do the entire sysgen again.{return}"
	.byte $00
tab_841a                   
        .byte $00,$00,$d0,$d0,$00,$c0,$50,$60 
	.byte $50,$06,$06,$00,$00,$30,$00,$f0 
	.byte $00,$00,$00,$00,$06,$66,$06,$00 
	.byte $60,$00,$06,$00,$00,$60,$00,$06 
	.byte $66,$c6,$06,$06,$00,$00,$00,$00 
	.byte $00,$06,$06,$60,$00,$f0,$60,$00 
	.byte $00,$06,$06,$00,$06,$00,$60,$00 
S8452
	lda #$ff
	sta $8cef
	sta $8cf0
	sta $8cf1
	ldy $9bba
	ldx #$00
	stx $95fd
	lda $9bb9
	jsr S95ad
	sta $8ce4
	ldy #$00
	sty $963e
	ldy #$08
	jsr S9603
	cpy #$00
	clc
	beq L847e
	sec
L847e
	adc #$03
	sta $8ce5
	lda #$00
	sta $963e
	lda #$f8
	ldx #$07
	ldy $8ce4
	jsr S9603
	sta $8cf4
	ldy $8ce5
	ldx #$02
	lda #$00
	sta $963e
	jsr S9603
	sta $8ce6
	jsr S8cf7
	ldx #$09
L84aa
	lda L90d4,x
	sta $9c00,x
	dex
	bpl L84aa
	lda $8ce6
	sta $9c13
	lda $8ce5
	sta $9c15
	lda #$02
	sta $9c11
	lda $8cf4
	sta $9c17
	lda #$01
	sta $979d
	lda #$01
	sta $9c18
	lda $8ce4
	sta $9c19
	ldy $8cf4
L84dd
	lda $8ce4
	clc
	adc $9c92
	sta $9c92
	bcc L84ec
	inc $9c91
L84ec
	dey
 	bne L84dd
 	lda #$ee
 	sta $95a2
 	sta $9c21
 	sta $979a
 	lda #$9c
 	sta $979b
 	lda #$00
 	sta $979c
 	lda #$00
 	sta $95a0
 	sta $9799
 	lda #$ff
 	sta $9c96
 	sta $9c97
 	lda #$0a
 	sta $9c1d
 	jsr S8c9e
 	lda $8cf4
 	sta $8ce9
L8522
	lda #$00
	sta $8cea
	lda #$9c
	sta $8ceb
	lda $8ce6
	sta $8cec
	jsr S8cf7
L8535
	lda $8cea
 	sta staAndIncDest + 1
 	lda $8ceb
 	sta staAndIncDest + 2
 	lda #$00
 	jsr staAndIncDest
 	lda $8ce7
 	jsr staAndIncDest
 	lda $8ce8
 	jsr staAndIncDest
 	clc
 	lda $8cea
 	adc $8ce5
 	sta $8cea
 	bcc L8561
 	inc $8ceb
L8561
	lda $8ce8
	clc
	adc $8ce4
	sta $8ce8
	bcc L8570
	inc $8ce7
L8570
	dec $8ce9
 	beq L8580
 	dec $8cec
 	bne L8535
 	jsr S8c9e
 	jmp L8522
                    
L8580
	lda $8ceb
 	sta staAndIncDest + 2
 	lda $8cea
 	sta staAndIncDest + 1
 	lda #$ff
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr S8c9e
 	jsr S8cf7
 	ldx #$0a
L859f
	lda L90de,x
 	sta $9c00,x
 	dex
 	bpl L859f
 	lda #$ee
 	sta $9c11
 	lda $9bba
 	sta $9c19
 	lda $9bbb
 	sta $9c16
 	lda $9bbc
 	sta $9c17
 	lda #$0a
 	sta $9c1d
 	sta $9c28
 	lda $9bb7
 	sta $9c12
 	lda $9bb8
 	sta $9c13
 	lda $9bbe
 	sta $9c1a
 	lda $9bbd
 	sta $9c15
 	ldx #$01
 	stx $9c18
 	ldy #$07
L85e6               
	lda $9ba9,y
	sta $9df4,y
	dey
	bpl L85e6
	jsr S979e
	lda #$00
	sta $95a0
	sta $95a2
	sta $979a
	sta $9799
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	dec $9c2a
	dec $9c1e
	lda $9bb9
	sta $9c14
	lda $8cf4
	sta $9c36
	jsr S8c9e
	jsr S8cf7
L8622
	inc $979a
	lda $979a
	cmp #$1a
	beq L8622
	cmp #$ee
	beq L8636
	jsr S8c9e
	jmp L8622
                    
L8636
	lda #$01
	sta $9799
	lda #$ef
	sta $979a
	lda #$02
	sta $8c40
	lda #$9d
	sta $8c39
	jsr S8c28
	lda #$02
	sta $9799
	lda #$ae
	sta $979a
	lda #$05
	sta $8c40
	lda #$00
	sta $8c39
	jsr S8c28
	lda #$00
	sta $8cf1
	lda #$07
	sta $979d
	lda #$01
	ldx #$40
	ldy #$8e
	jsr sg_LoadFile
	lda #$08
	ldx #$4e
	ldy #$8f
	jsr sg_LoadFile
	lda #$ff
	sta $8cf1
	lda #$01
	sta $979d
	lda #$9c
	sta $979b
	lda #$00
	sta $979c
	lda #$ee
	sta $979a
	jsr S8c96
	jsr S979e
	jsr S8cf7
	ldx #$0a
L86a4
	lda L90e9,x
	sta $9c00,x
	dex
	bpl L86a4
	lda #$ff
	sta $8ced
	sta $9c11
	ldx #$01
	stx $9c18
	jsr S979e
	lda #$f0
	sta $979a
	sta $95a2
	lda #$00
	sta $9799
	sta $95a0
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	lda #$0a
	sta $9c1d
	jsr S8c9e
	dec $8ced
	lda #$10
	sta $8cee
	jsr S8cf7
	lda #$1d
	sta L86f8 + 1
	lda #$9c
	sta L86f8 + 2
L86f4               
	ldx #$03
	lda #$ff
L86f8               
	sta L86f8
	inc L86f8 + 1
	bne L8703
	inc L86f8 + 2
L8703               
	dex
	bne L86f8
	clc
	lda L86f8 + 1
	adc #$1d
	sta L86f8 + 1
	bcc L8714
	inc L86f8 + 2
L8714
	dec $8cee
	bne L86f4
L8719
	jsr S8c9e
	dec $8ced
	bne L8719
	lda #$00
	sta $8cef
	jsr S8cf7
	ldy #$0f
L872b
	lda L9104,y
	sta $9c00,y
	dey
	bpl L872b
	lda #$ae
	sta $9c11
	lda #$01
	sta $9c18
	jsr S979e
	lda $9c20
	sta $9799
	sta $8cf2
	lda $9c21
	sta $979a
	sta $8cf3
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	lda #$0a
	sta $9c1d
	jsr S8c9e
	jsr S8c4c
	jsr S8cf7
	ldy #$0f
L876d
	lda L90f4,y
	sta $9c00,y
	dey
	bpl L876d
	lda #$c8
	sta $9c11
	lda #$01
	sta $9c18
	jsr S979e
	lda $9c20
	sta $9799
	lda $9c21
	sta $979a
	lda #$00
	sta $979c
	lda #$9c
	sta $979b
	lda #$0a
	sta $9c1d
	jsr S8c9e
	jsr S8c4c
	lda #$00
	jsr S8c44
	beq L87ae
	jmp Break
                    
L87ae
	lda #$ee
	jsr S8c44
	beq L87b8
	jmp Break
                    
L87b8
	lda #$f0
	jsr S8c44
	beq L87c2
	jmp Break
                    
L87c2
	lda #$00
	sta $8cf0
	lda #$01
	sta $979d
	
	lda #$11
	ldx #<fname_Findfile
	ldy #>fname_Findfile ;$8db4
	jsr sg_LoadFile
	
	lda #$20
	ldx #<fname_FindFil2
	ldy #>fname_FindFil2 ;$8ecc
	jsr sg_LoadFile
	
	lda #$12
	ldx #<fname_LoadRand
	ldy #>fname_LoadRand ;$8dbe
	jsr sg_LoadFile
	
	lda #$26
	ldx #<fname_LoadRnd2 
	ldy #>fname_LoadRnd2 ;$8fe4
	jsr sg_LoadFile
	
	lda #$27
	ldx #<fname_LoadRnd3 
	ldy #>fname_LoadRnd3 ;$8ff8
	jsr sg_LoadFile
	
	lda #$13
	ldx #$c8
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$14
	ldx #$d2
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$15
	ldx #$dc
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$16
	ldx #$e6
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$17
	ldx #$f0
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$18
	ldx #$fa
	ldy #$8d
	jsr sg_LoadFile
	
	lda #$19
	ldx #$4a
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$1a
	ldx #$54
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$1b
	ldx #$72
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$1c
	ldx #$7c
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$1d
	ldx #$86
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$1e
	ldx #$90
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$21
	ldx #$d6
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$22
	ldx #$e0
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$23
	ldx #$ea
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$25
	ldx #$8a
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$24
	ldx #$3a
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$1f
	ldx #$ae
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$28
	ldx #$02
	ldy #$90
	jsr sg_LoadFile
	
	lda #$29
	ldx #$48
	ldy #$90
	jsr sg_LoadFile
	
	lda #$2a
	ldx #$84
	ldy #$90
	jsr sg_LoadFile
	
	lda #$2f
	ldx #$98
	ldy #$90
	jsr sg_LoadFile
	
	lda #$00
	sta $8cf1
	lda #$04
	sta $979d
	
	lda #$44
	ldx #$68
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$48
	ldx #$5e
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$4c
	ldx #$04
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$9a
	ldx #$58
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$50
	ldx #$0e
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$9e
	ldx #$62
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$54
	ldx #$18
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$a2
	ldx #$6c
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$58
	ldx #$22
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$5c
	ldx #$2c
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$ca
	ldx #$52
	ldy #$90
	jsr sg_LoadFile
	
	lda #$60
	ldx #$36
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$08
	sta $979d
	lda #$3b
	ldx #$9a
	
	ldy #$8e
	jsr sg_LoadFile
	lda #$08
	sta $979d
	
	lda #$e6
	ldx #$a4
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$04
	sta $979d
	
	lda #$6a
	ldx #$b8
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$ce
	ldx #$5c
	ldy #$90
	jsr sg_LoadFile
	
	lda #$7e
	ldx #$f4
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$82
	ldx #$fe
	ldy #$8e
	jsr sg_LoadFile
	
	lda #$86
	ldx #$08
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$8a
	ldx #$12
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$8e
	ldx #$1c
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$92
	ldx #$26
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$96
	ldx #$30
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$d2
	ldx #$66
	ldy #$90
	jsr sg_LoadFile
	
	lda #$a6
	ldx #$94
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$aa
	ldx #$9e
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$ae
	ldx #$a8
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$b2
	ldx #$b2
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$b6
	ldx #$bc
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$ba
	ldx #$c6
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$be
	ldx #$d0
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$02
	sta $979d
	
	lda #$0f
	ldx #$44
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$31
	ldx #$76
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$04
	sta $979d
	
	lda #$c6
	ldx #$80
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$64
	ldx #$a2
	ldy #$90
	jsr sg_LoadFile
	
	lda #$02
	sta $979d
	
	lda #$2d
	ldx #$da
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$72
	ldx #$ee
	ldy #$8f
	jsr sg_LoadFile
	
	lda #$01
	sta $979d
	
	lda #$c2
	ldx #$0c
	ldy #$90
	jsr sg_LoadFile
	
	lda #$01
	jsr S8be7
	
	lda #$0c
	ldx #$16
	ldy #$90
	jsr S8bf8
	
	lda #$0d
	jsr S8be7
	
	lda #$0c
	ldx #$c0
	ldy #$90
	jsr S8bf8
	lda #$19
	jsr S8be7
	lda #$08
	ldx #$20
	ldy #$90
	jsr S8bf8
	lda #$21
	jsr S8be7
	lda #$08
	ldx #$2a
	ldy #$90
	jsr S8bf8
	lda #$29
	jsr S8be7
	lda #$08
	ldx #$34
	ldy #$90
	jsr S8bf8
	lda #$31
	jsr S8be7
	lda #$08
	ldx #$3e
	ldy #$90
	jsr S8bf8
	lda #$39
	jsr S8be7
	lda #$08
	ldx #$ca
	ldy #$90
	jsr S8bf8
	lda #$a3
	jsr S8be7
	lda #$0a
	ldx #$ac
	ldy #$90
	jsr S8bf8
	lda #$ad
	jsr S8be7
	lda #$01
	ldx #$b6
	ldy #$90
	jsr S8bf8
	
	lda #<fname_ptr_table_2 ;37
	sta S8d07 + 1
	lda #>fname_ptr_table_2 ;99
	sta S8d07 + 2
	jsr S8ad0
	jmp L8b40
                    
S8ad0  
	jsr S8d07
	beq S8ad0_return
	sta $b7
	jsr S8d07
	sta $bb
	jsr S8d07
	sta $bc
	lda #$08
	sta $ba
	lda #$01
	sta $b9
	jsr S8ccc
	cli
	lda #$00
	jsr LOAD
	bcc L8af7
	jmp Break2
                    
L8af7
	sei
	jsr S8cf7
	ldx $b7
	dex
	dex
	ldy #$00
L8b01
	lda ($bb),y
	sta $9c00,y
	sta $c000,y
	iny
	dex
	bne L8b01
	lda #$00
	sta $c000,y
	lda #$0a
	sta $9c1d
	jsr S8d07
	sta $9c1b
	jsr S8d07
	sta $9c1a
	jsr S8d07
	sta $9c11
	jsr S8d07
	sta $9c18
	cmp #$03
	bne L8b38
	lda #$c0
	sta $9c12
L8b38
	jsr S9179
	beq S8ad0
Break
	brk
                    
Break2
	brk
                    
S8ad0_return               rts
                    
L8b40               ldx #$14
                    ldy #$91
                    jsr printZTString
                    cli
L8b48               jsr GETIN
	tax
	beq L8b48
	cmp #$0d
	bne L8b40
	ldx #$59
	ldy #$91
	jsr printZTString
	lda #$10
	sta $979d
	lda #$d6
	ldx #$8e
	ldy #$90
	jsr sg_LoadFile
	lda #$2e
	sta $979a
	lda #$03
	sta $9799
	lda #$37
	ldx #$c2
	ldy #$8e
	jsr S8bf8
	lda #$33
	sta $979a
	lda #$00
	sta $9799
	lda #$08
	ldx #$7a
	ldy #$90
	jsr S8bf8
	lda $822a
	beq L8ba5
	lda #$9e
	sta $979a
	lda #$02
	sta $9799
	lda #$10
	ldx #$70
	ldy #$90
	jsr S8bf8
L8ba5
	lda #$1f
	sta S8d07 + 1
	lda #$9a
	sta S8d07 + 2
	jsr S8ad0
	ldx #$00
	stx $9799
	inx
	stx $979d
	lda #$ee
	sta $979a
	lda #$00
	sta $979c
	lda #$9e
	sta $979b
	jsr S8c96
	lda $9e94
	sta $8cf5
	lda $9e95
	sta $8cf6
	lda #$43
	sta S8d07 + 1
	lda #$9a
	sta S8d07 + 2
	jsr S8ad0
	rts
                    
S8be7
	ldx $8cf2
	clc
	adc $8cf3
	bcc L8bf1
	inx
L8bf1
	stx $9799
	sta $979a
	rts
                    
S8bf8
	sta $979d
	stx $bb
	sty $bc
	jsr S8cc0
	lda #$0a
	sta $b7
	lda #$08
	sta $ba
	lda #$00
	sta $b9
	ldx #$00
	ldy #$10
	cli
	lda #$00
	jsr LOAD
L8c18
	bcs L8c18
	lda #$10
	sta $979b
	lda #$00
	sta $979c
	jsr S969b
	rts
                    
S8c28
	jsr S969b
L8c2b
	bcs L8c2b
	inc $979a
	bne L8c35
	inc $9799
L8c35
	lda $979a
	cmp #$00
	bne S8c28
	lda $9799
	cmp #$00
	bne S8c28
	rts
                    
S8c44               sta $979a
                    lda #$00
                    sta $9799
S8c4c               lda #$00
                    sta $979c
                    lda #$9c
                    sta $979b
                    lda #$01
                    sta $979d
                    jsr S8c96
                    ldy #$10
L8c60               lda $9c00,y
                    sta $c000,y
                    dey
                    bpl L8c60
                    jsr S9179
                    cpx #$00
                    rts

;prints zero-terminated string pointed to in Y:X                    
printZTString               
	stx pzts_loop + 1
	sty pzts_loop + 2
	cli
pzts_loop
	lda pzts_loop
	beq pzts_done
	jsr CHROUT
	inc pzts_loop + 1
	bne pzts_loop
	inc pzts_loop + 2
	bne pzts_loop
pzts_done
	sei
	rts

;stores A and selfmods to inc address          
staAndIncDest               
	sta $9c00
	inc staAndIncDest + 1
	bne said_done
	inc staAndIncDest + 2
said_done
	rts
                    
	
S8c96               jsr S969f
                    bcc L8ca6
                    bcs S8c96
                    .byte $c0 
S8c9e               jsr S969b
                    bcc L8ca6
                    jsr $c000
L8ca6               lda $8cef
                    beq L8cbf
                    inc $95a2
                    bne L8cb3
                    inc $95a0
L8cb3               lda $95a2
                    sta $979a
                    lda $95a0
                    sta $9799
L8cbf               rts
                    
S8cc0               asl a
                    tax
                    lda #$00
                    sta $fb
                    lda #$10
                    sta $fc
                    bne L8cd6
S8ccc               lda #$01
                    sta $fb
                    lda #$08
                    sta $fc
                    ldx #$6e
L8cd6               ldy #$00
                    tya
L8cd9               sta ($fb),y
                    iny
                    bne L8cd9
                    inc $fc
                    dex
                    bne L8cd9
                    rts
                    
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00 
S8cf7               lda #$00
                    tay
L8cfa               sta $9c00,y
                    iny
                    bne L8cfa
L8d00               sta $9d00,y
                    iny
                    bne L8d00
                    rts
                    
S8d07               lda S8d07
                    inc S8d07 + 1
                    bne L8d12
                    inc S8d07 + 2
L8d12               cmp #$00
                    rts
                    
sg_LoadFile ;$8d15               
	sta $979a
	stx $bb		;stash addr of filename to $bb as if SETNAM was called
	sty $bc
	lda $979d
	jsr S8cc0
	lda #$0a
	sta $b7  ;filename length is 10 for all of the files this routine handles
	lda #$08 ; drive 8
	sta $ba
	lda #$00
	sta $b9
	ldx #$00
	ldy #$10 ;load address is $1000
	cli
	lda #$00
	jsr LOAD
	bcc sg_LoadFileSuccess
	jmp Break2
                    
sg_LoadFileSuccess               
	lda #$10
	sta $979b
	sta $f8
	ldx #$00
	stx $979c
	stx $f7
	stx $9799
	lda $8cf1
	beq L8d56

	stx $11ff
L8d56
	sei
	lda $8cf1
	beq L8dab
	lda $979a
	cmp #$1a
	bne L8d75
	lda $8228
	beq L8d8e
	ldy #$31
L8d6a
	lda $841a,y
	sta $1004,y
	dey
	bpl L8d6a
	bmi L8d8e
L8d75
	cmp #$22
	bne L8d8e
	jsr $1000
	ldy #$00
L8d7e
	lda $1000,y
	tax
	lda #$ea
	sta $1000,y
	iny
	inx
	bne L8d7e
	stx $11ff
L8d8e
	lda #$00
	tay
	ldx #$02
L8d93
	clc
	adc ($f7),y
	iny
	bne L8d93
	inc $f8
	dex
	bne L8d93
	sta $11ff
	sec
	lda $979a
	sbc $11ff
	sta $11ff
L8dab
	jsr S969b
	bcc L8db3
	jsr $c000
L8db3
	rts
                    
fname_Findfile ;$8db4
	.screen "FINDFILE.R"
	
fname_LoadRand ;$8dbe
	.screen "LOADRAND.R"
	
L8dc8
	.screen "ERRORHAN.R"
	
L8dd2
	.screen "LOADCNTG.R"
	
L8ddc
	.screen "ALOCATRN.R"
	
L8de6
	.screen "ALOCATCN.R"
	
L8df0
	.screen "APPENDRN.R"
	
L8dfa
	.screen "DEALOCRN.R"
	
L8e04
	.screen "DOSOVRLY.R"
	
L8e0e
	.screen "OPENFILE.R"
	
L8e18
	.screen "CLOSEFIL.R"
	
L8e22
	.screen "SAVETODV.R"
	
L8e2c
	.screen "CMNDCHN1.R"
	
L8e36
	.screen "DIRECTRY.R"
	
L8e40
	.screen "LTKERNAL.R"
	
L8e4a
	.screen "DEALOCCN.R"
	
L8e54
	.screen "LUCHANGE.R"
	
L8e5e
	.screen "OPENRELA.R"
	
L8e68
	.screen "RELAEXPN.R"
	
L8e72
	.screen "ALOCEXRN.R"
	
L8e7c
	.screen "EXPNRAND.R"
	
L8e86
	.screen "APNDEXRN.R"
	
L8e90
	.screen "DEALEXRN.R"
	
L8e9a
	.screen "CONFIGLU.R"
	
L8ea4
	.screen "MESSFILE.R"
	
L8eae
	.screen "ADJINDEX.R"
	
L8eb8
	.screen "COMMLOAD.R"
	
L8ec2
	.screen "MASTERCF.R"
	
fname_FindFil2 ;$8ecc
	.screen "FINDFIL2.R"
	
L8ed6
	.screen "CREDITSB.R"
	
L8ee0
	.screen "SCRAMIDN.R"
	
L8eea
	.screen "SUBCALLR.R"
	
L8ef4
	.screen "INDXMOD1.R"
	
L8efe
	.screen "INDXMOD2.R"
	
L8f08
	.screen "INDXMOD3.R"
	
L8f12
	.screen "INDXMOD4.R"
	
L8f1c
	.screen "INDXMOD5.R"
	
L8f26
	.screen "INDXMOD6.R"
	
L8f30
	.screen "INDXMOD7.R"
	
L8f3a
	.screen "CATALOGR.R"
	
L8f44
	.screen "SYSBOOTR.R"
	
L8f4e
	.screen "LTKRN128.R"
	
L8f58
	.screen "DOSOV128.R"
	
L8f62
	.screen "OPENF128.R"
	
L8f6c
	.screen "CLOSE128.R"
	
L8f76
	.screen "SYSBT128.R"
	
L8f80
	.screen "INITC128.R"
	
L8f8a
	.screen "SUBCL128.R"
	
L8f94
	.screen "IDXM1128.R"
	
L8f9e
	.screen "IDXM2128.R"
	
L8fa8
	.screen "IDXM3128.R"
	
L8fb2
	.screen "IDXM4128.R"
	
L8fbc
	.screen "IDXM5128.R"
	
L8fc6
	.screen "IDXM6128.R"
	
L8fd0
	.screen "IDXM7128.R"
	
L8fda
	.screen "GO64BOOT.R"
	
fname_LoadRnd2 ;$8fe4
	.screen "LOADRND2.R"
	
L8fee
	.screen "OPENRAND.R"
	
fname_LoadRnd3 ;$8ff8
	.screen "LOADRND3.R"
	
L9002
	.screen "CONVRTIO.R"
	
L900c
	.screen "AUTOUPDT.R"
	
L9016
	.screen "FASTFDOS.R"
	
L9020
	.screen "FASTCPY1.R"
	
L902a
	.screen "FASTCP1A.R"
	
L9034
	.screen "FASTCPY2.R"
	
L903e
	.screen "FASTCP2A.R"
	
L9048
	.screen "FILEPROT.R"
	
L9052
	.screen "CMNDCHN2.R"
	
L905c
	.screen "INDXMOD0.R"
	
L9066
	.screen "IDXM0128.R"
	
L9070
	.screen "DEFAULTS.R"
	
L907a
	.screen "CONFIGCL.R"
	
L9084
	.screen "GOCPMODE.R"
	
L908e
	.screen "CP/MBOOT.R"
	
L9098
	.screen "ALTSERCH.R"
	
L90a2
	.screen "INITC064.R"
	
L90ac
	.screen "FASTCPRM.R"
	
L90b6
	.screen "FASTCPQD.R"
	
L90c0
	.screen "FASTFD81.R"
	
L90ca
	.screen "FASTCPDD.R"
	
L90d4
	.screen "DISCBITMAP"
	
L90de
	.screen "SYSTEMTRACK"
	
L90e9
	.screen "SYSTEMINDEX"
	
L90f4
	.screen "SYSTEMCONFIGFILE"
	
L9104
	.screen "FASTCOPY.MODULES"
	
L9114
	.text "{clr}{return}{rvs on}please turn sysgen disk over to side b.{return}{return}press return when ready."
	.byte $00
	
L9159
	.text "{clr}{rvs on}thank you...sysgen continuing"
	.byte $00
	
S9179
	jsr S951c
                    beq L9181
                    ldx #$ff
                    rts
                    
L9181               sta $9493
                    lda $8cf0
                    bne L9191
                    jsr S979e
                    bcc L9191
                    jsr $c000
L9191               lda #$00
                    sta $979c
                    sta $9446
                    lda #$9e
                    sta $979b
                    sta $9445
                    lda $95a2
                    sta $979a
                    lda $95a1
                    sta $9799
                    ldx #$01
                    stx $979d
                    jsr S969f
                    bcc L91ba
                    jsr $c000
L91ba               lda #$10
                    sta $9492
                    lda #$00
                    sta $9442
                    sta $9443
L91c7               jsr S944d
                    jsr S9486
                    tay
                    and #$80
                    bne L91ee
                    jsr S93d8
                    bne L91e8
                    ldx #$00
                    ldy #$c0
                    jsr printZTString
                    ldx #$94
                    ldy #$94
                    jsr printZTString
                    ldx #$ff
                    rts
                    
L91e8               jsr S93fd
                    bne L91c7
                    brk
                    
L91ee               cpy #$ff
                    beq L91f5
                    jmp L9307
                    
L91f5               jsr S9486
                    cmp #$ff
                    beq L91ff
                    jmp L9307
                    
L91ff               jsr S9486
                    cmp #$ff
                    beq L9209
                    jmp L9307
                    
L9209               lda $9442
                    beq L923c
                    lda $95a1
                    ldx $95a2
                    cmp $9440
                    bne L921e
                    cpx $9441
                    beq L922d
L921e               sta $9799
                    sta $95a1
                    stx $979a
                    stx $95a2
                    jsr S8c96
L922d               lda $943e
                    sta $9445
                    lda $943f
                    sta $9446
                    jsr S944d
L923c               lda $9446
                    sta $924e
                    lda $9445
                    sta $924f
                    ldy #$0f
L924a               lda $9c00,y
                    sta $924d,y
                    dey
                    bpl L924a
                    lda #$00
                    jsr S947a
                    lda $9c20
                    jsr S947a
                    lda $9c21
                    jsr S947a
                    lda $9445
                    sta S92e4 + 2
                    lda $9446
                    sta S92e4 + 1
                    ldy #$10
                    lda $9c10
                    jsr S92e4
                    lda $9c11
                    jsr S92e4
                    lda $9c14
                    jsr S92e4
                    lda $9c15
                    jsr S92e4
                    lda $9c16
                    jsr S92e4
                    lda $9c17
                    jsr S92e4
                    lda $9c18
                    jsr S92e4
                    lda $9c1a
                    jsr S92e4
                    lda $9c1b
                    jsr S92e4
                    lda #$0a
                    jsr S92e4
                    inc $9e1c
                    jsr S8c9e
                    lda $9e1c
                    cmp #$01
                    bne L92c4
                    lda #$ff
                    jsr S92e9
                    beq L92c4
                    jmp $c000
                    
L92c4               lda $8cf0
                    bne L92cc
                    jsr S9327
L92cc               ldx #$1a
                    ldy #$95
                    jsr printZTString
                    ldx #$00
                    ldy #$c0
                    jsr printZTString
                    ldx #$b3
                    ldy #$94
                    jsr printZTString
                    ldx #$00
                    rts
                    
S92e4               sta S92e4,y
                    iny
                    rts
                    
S92e9               sta $9306
                    lda #$f0
                    sta $979a
                    lda #$00
                    sta $9799
                    jsr S8c96
                    ldy $95a3
                    lda $9306
                    sta $9e22,y
                    jsr S8c9e
                    rts
                    
                    .byte $00 
L9307               lda $9445
                    sta $943e
                    lda $9446
                    sta $943f
                    lda $95a1
                    sta $9440
                    lda $95a2
                    sta $9441
                    lda #$ff
                    sta $9442
                    jmp L91e8
                    
S9327               lda #$00
                    sta $9449
                    sta $944a
L932f               lda $944a
                    asl a
                    tax
                    lda $9c20,x
                    sta $9799
                    sta $95a1
                    lda $9c21,x
                    sta $979a
                    sta $95a2
                    lda $9443
                    bne L9385
                    lda #$00
                    sta $979c
                    lda #$9c
                    sta $979b
                    lda #$01
                    sta $979d
                    jsr S8c9e
                    lda $9c1a
                    ldx $9c1b
                    cmp #$95
                    bne L936b
                    lda #$40
                    ldx #$00
L936b               sta $944b
                    stx $944c
                    lda $9c10
                    sta $9447
                    lda $9c11
                    sta $9448
                    lda #$ff
                    sta $9443
                    jmp L93a6
                    
L9385               lda $95a2
                    sta $979a
                    lda $95a1
                    sta $9799
                    lda $944b
                    sta $979b
                    lda $944c
                    sta $979c
                    jsr S8c9e
                    inc $944b
                    inc $944b
L93a6               inc $944a
                    bne L93ae
                    inc $9449
L93ae               inc $95a2
                    bne L93bb
                    inc $95a1
                    bne L93bb
                    inc $95a0
L93bb               lda $944a
                    cmp $9448
                    bne L93ce
                    lda $9449
                    cmp $9447
                    bne L93ce
                    ldx #$00
                    rts
                    
L93ce               lda $9c18
                    cmp #$0a
                    bcc L9385
                    jmp L932f
                    
S93d8               ldx #$10
                    lda #$00
                    sta $93e8
                    lda #$9c
                    sta $93e9
L93e4               jsr S946e
                    cmp $93e7
                    beq L93ef
                    ldx #$ff
                    rts
                    
L93ef               inc $93e8
                    bne L93f7
                    inc $93e9
L93f7               dex
                    bne L93e4
                    ldx #$00
                    rts
                    
S93fd               lda $9446
                    clc
                    adc #$20
                    sta $9446
                    bcc L940b
                    inc $9445
L940b               dec $9492
                    beq L9411
                    rts
                    
L9411               inc $95a2
                    bne L9419
                    inc $95a1
L9419               lda $95a2
                    sta $979a
                    lda $95a1
                    sta $9799
                    jsr S8c96
                    lda #$10
                    sta $9492
                    lda #$00
                    sta $9446
                    lda #$9e
                    sta $9445
                    inc $95a3
                    dec $9493
                    rts
                    
                    .byte $00,$00,$00,$00,$00,$00,$00,$00
                    .byte $00,$00,$00,$00,$00,$00,$00 
S944d               ldx $9446
                    stx S946e + 1
                    ldy $9445
                    sty S946e + 2
                    txa
                    clc
                    adc #$1d
                    tax
                    bcc L9461
                    iny
L9461               stx S9486 + 1
                    sty S9486 + 2
                    stx S947a + 1
                    sty S947a + 2
                    rts
                    
S946e               lda S946e
                    inc S946e + 1
                    bne L9479
                    inc S946e + 2
L9479               rts
                    
S947a               sta S947a
                    inc S947a + 1
                    bne L9485
                    inc S947a + 2
L9485               rts
                    
S9486               lda S9486
                    inc S9486 + 1
                    bne L9491
                    inc S9486 + 2
L9491               rts
                    
                    .byte $00,$00
L9494               .text " - filename already exists !!{return}"
                    .byte $00 
L94b3               .text " file has been created.{return}"
                    .byte $00 
str_InitComplete ;$94cc
	.text "{return}system initialization complete !!!{return}{return}now do a full system reset{return}{return}{return}thank you.{return}"
	.byte $00
L951a               .text "{Return}"
                    .byte $00 
S951c               ldx #$00
                    ldy #$9c
                    sec
                    jsr S9641
                    lda #$10
                    sta $95a4
                    lda #$00
                    sta $95a5
                    sta $95a6
                    sta $95a1
                    sta $95a0
                    sta $963e
L953a               clc
                    jsr S9641
                    cmp #$00
                    beq L955d
                    ldx #$05
L9544               cmp L95a7,x
                    beq L9567
                    dex
                    bpl L9544
                    clc
                    adc $95a6
                    sta $95a6
                    bcc L9558
                    inc $95a5
L9558               dec $95a4
                    bne L953a
L955d               lda $95a6
                    bne L956a
                    lda $95a5
                    bne L956a
L9567               ldx #$ff
                    rts
                    
L956a               sec
                    lda $95a6
                    sbc #$01
                    sta $95a6
                    bcs L9578
                    dec $95a5
L9578               lda $95a6
                    ldx $95a5
                    ldy #$10
                    jsr S9603
                    sta $95a3
                    lda #$f0
                    sec
                    adc $95a3
                    sta $95a2
                    bcc L9594
                    inc $95a1
L9594               lda #$fe
                    sec
                    sbc $95a3
                    ldy $95a3
                    ldx #$00
                    rts
                    
                    .byte $00,$00,$00,$00,$00,$00,$00 
L95a7               .text "=:,*?"
		    .byte $a0 ;//"{Shift Space}"
S95ad               sta $95ff
                    stx $95fe
                    sty $95fc
                    lda #$00
                    sta $9600
                    sta $9601
                    sta $9602
                    ldx #$08
L95c3               clc
                    lsr $95fc
                    bcc L95e5
                    clc
                    lda $9602
                    adc $95ff
                    sta $9602
                    lda $9601
                    adc $95fe
                    sta $9601
                    lda $9600
                    adc $95fd
                    sta $9600
L95e5               clc
                    rol $95ff
                    rol $95fe
                    rol $95fd
                    dex
                    bne L95c3
                    ldy $9600
                    ldx $9601
                    lda $9602
                    rts
                    
                    .byte $00,$00,$00,$00,$00,$00,$00 
S9603               sta $9640
                    stx $963f
                    sty $963d
                    lda #$00
                    ldx #$18
L9610               clc
                    rol $9640
                    rol $963f
                    rol $963e
                    rol a
                    bcs L9622
                    cmp $963d
                    bcc L9632
L9622               sbc $963d
                    inc $9640
                    bne L9632
                    inc $963f
                    bne L9632
                    inc $963e
L9632               dex
                    bne L9610
                    tay
                    ldx $963f
                    lda $9640
                    rts
                    
                    .byte $00,$00,$00,$00
S9641               bcc L964a
                    stx L964a + 1
                    sty L964a + 2
                    rts
                    
L964a               lda L964a
                    inc L964a + 1
                    bne L9655
                    inc L964a + 2
L9655               rts
                    
S9656               lda #$c2
                    sta $9789
                    ldx $9bba
                    dex
                    stx $9792
                    lda $9bbb
                    sta $9793
                    ldx $9bbc
                    dex
                    stx $9794
                    lda $9bb7
                    and #$3f
                    sta $978f
                    lda $9bb8
                    sta $9790
                    lda $9bbd
                    sta $9795
                    lda $9bbe
                    sta $9796
                    jsr S9719
                    bne L9699
                    ldx #$10
                    ldy #$00
                    jsr S9735
                    jsr S9772
                    rts
                    
L9699               sec
                    rts
                    
S969b               lda #$0a
                    bne L96a1
S969f               lda #$08
L96a1               sta $9789
                    lda $9799
                    sta $978b
                    lda $979a
                    sta $978c
                    lda $979d
                    sta $978d
                    lda $979b
                    sta $f8
                    lda $979c
                    sta $f7
                    jsr S9719
                    bne L9699
                    ldx #$06
                    ldy #$00
                    jsr S9735
                    ldy #$00
                    lda $9789
                    cmp #$08
                    beq L96f3
                    lda #$2c
                    sta $df01
L96da
	lda $df02
                    bmi L96da
                    and #$04
                    beq L9711
                    lda ($f7),y
                    sta $df00
                    lda $df00
                    iny
                    bne L96da
                    inc $f8
                    jmp L96da
                    
L96f3               jsr S974b
                    lda #$2c
                    sta $df01
L96fb               lda $df02
                    bmi L96fb
                    and #$04
                    beq L9711
                    lda $df00
                    sta ($f7),y
                    iny
                    bne L96fb
                    inc $f8
                    jmp L96fb
                    
L9711               jsr S9772
                    txa
                    bne L9699
                    clc
                    rts
                    
S9719               jsr S974e
                    lda #$fe
                    sta $df00
                    lda #$50
                    sta $df02
L9726               lda $df02
                    and #$08
                    bne L9726
                    lda #$40
                    sta $df02
                    lda #$00
                    rts
                    
S9735               jsr S975e
                    lda $9789,y
                    eor #$ff
                    sta $df00
                    jsr S9764
                    iny
                    dex
                    bne S9735
                    jsr S975e
                    rts
                    
S974b               ldx #$00
                    .byte $2c ;again using a bit operation to allow two entry vectors to the same routine
S974e               ldx #$ff
                    lda #$38
                    sta $df01
                    stx $df00
                    lda #$3c
                    sta $df01
                    rts
                    
S975e               lda $df02
                    bmi S975e
                    rts
                    
S9764
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
S9772
	jsr S974b
	jsr S977b
	and #$9f
	tax
S977b
	jsr S975e
	lda $df00
	eor #$ff
	tay
	jsr S9764
	tya
	rts
                    
	.byte $00,$00,$00,$00,$00,$00,$04,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00 
S979e               
	ldx #$00
	stx $9936
	inx
	stx $979d
	lda #$00
	sta $9799
	lda #$ee
	sta $979a
	lda #$9e
	sta $979b
	lda #$00
	sta $979c
	jsr S969f
	bcc L97c3
	jsr $c000
L97c3
	lda $9e13
	sta $992d
	lda $9e15
	sta $992e
	lda $9e16
	sta $9930
	lda $9e17
	sta $9931
	lda $9e19
	sta $9932
L97e1
	inc $979a
	bne L97e9
	inc $9799
L97e9
	lda #$00
	sta $992f
	jsr S969f
	bcc L97f6
	jsr $c000
L97f6
	lda #$9e
	sta S9929 + 2
	sta $9891
	lda #$00
	sta S9929 + 1
	sta $9890
	lda $992d
	sta $9933
L980c
	lda #$00
	sta $9935
	ldy #$02
L9813
	iny
	lda #$80
	sta $9934
	jsr S9929
	cmp #$ff
	bne L9830
	lda #$08
	clc
	adc $9935
	sta $9935
	cmp $9932
	bcc L9813
	bcs L9847
L9830
	bit $9934
	beq L988c
L9835
	inc $9935
	ldx $9935
	cpx $9932
	beq L9847
	lsr $9934
	bne L9830
	beq L9813
L9847
	lda $992e
	clc
	adc S9929 + 1
	sta S9929 + 1
	sta $9890
	bcc L985c
	inc S9929 + 2
	inc $9891
L985c
	ldx #$ff
	dec $9931
	beq L986e
	cpx $9931
	bne L9877
	dec $9930
	jmp L9877
                    
L986e
	lda $9930
	bne L9877
	ldx #$fd
	sec
	rts
                    
L9877
	dec $9933
	bne L980c
	lda $992f
	beq L9889
	jsr S969b
	bcc L9889
	jsr $c000
L9889
	jmp L97e1
                    
L988c
	ora $9934
	sta $988f,y
	pha
	tya
	pha
	lda $9936
	beq L98a1
	ldx $9c18
	cpx #$0a
	bcc L98ba
L98a1
	asl a
	tax
	ldy #$01
	jsr S9929
	pha
	iny
	jsr S9929
	clc
	adc $9935
	sta $9c21,x
	pla
	adc #$00
	sta $9c20,x
L98ba
	lda #$ff
	sta $992f
	pla
	tay
	pla
	inc $9936
	ldx $9936
	cpx $9c11
	beq L98d0
	jmp L9835
	
L98d0
	jsr S969b
	bcc L98d8
	jsr $c000
L98d8
	lda #$ee
	sta $979a
	lda #$00
	sta $9799
	jsr S969f
	bcc L98ea
	jsr $c000
L98ea
	ldx #$ff
	lda $9e92
	sec
	sbc $9936
	sta $9e92
	bcs L9903
	dec $9e91
	cpx $9e91
	bne L9903
	dec $9e90
L9903
	lda $9936
	clc
	adc $9e95
	sta $9e95
	bcc L9917
	inc $9e94
	bne L9917
	inc $9e93
L9917
	lda #$ff
	sta $9e96
	sta $9e97
	jsr S969b
	bcc L9927
	jsr $c000
L9927
	clc
	rts
                    
S9929
	lda S9929,y
	rts
	
	;992d
	.byte $00,$00,$00                    
        ;9330
        .byte $00,$00,$00,$00,$00,$00,$00 
	; 00 00 00 00 00 00 00 
	;00 - String length
	;   00 - Lo-Byte of string address
	;      00 - Hi-Byte of string address
	;         00 - Unknown
	;            00 - Unknown
	;               00 - Unknown
	;                  00 - Unknown (Profit?)
fname_ptr_table_2 ;9937
	.byte $05,<fname_Dir	,>fname_Dir	,$e0,$95,$08,$03 
	.byte $03,<fname_S  	,>fname_S	,$e0,$95,$05,$02 ;993e
	.byte $05,<fname_Era	,>fname_Era	,$e0,$95,$03,$02 
	.byte $06,$6d,$9a,$e0,$95,$02,$02 
	.byte $03,$73,$9a,$e0,$95,$03,$02 
	.byte $03,$76,$9a,$e0,$95,$02,$02 
	.byte $08,$79,$9a,$e0,$95,$04,$02 
	.byte $06,$81,$9a,$e0,$95,$04,$02 
	.byte $0a,$87,$9a,$e0,$95,$03,$02 
	.byte $05,$91,$9a,$e0,$95,$02,$02 
	.byte $06,$96,$9a,$e0,$95,$03,$02 
	.byte $07,$9c,$9a,$e0,$95,$09,$03 
	.byte $06,$a3,$9a,$e0,$95,$07,$03 
	.byte $06,$a9,$9a,$e0,$95,$05,$03 
	.byte $05,$af,$9a,$e0,$95,$03,$03 
	.byte $07,$b4,$9a,$e0,$95,$04,$03 
	.byte $07,$bb,$9a,$e0,$95,$03,$03 
	.byte $04,$c2,$9a,$e0,$95,$02,$02 
	.byte $07,$c6,$9a,$e0,$95,$05,$02 
	.byte $08,$cd,$9a,$e0,$95,$05,$02 
	.byte $07,$d5,$9a,$e0,$95,$05,$03 
	.byte $0a,$dc,$9a,$e0,$95,$06,$03 
	.byte $0a,$e6,$9a,$e0,$95,$09,$03 
	.byte $09,$f0,$9a,$e0,$95,$07,$03 
	.byte $06,$f9,$9a,$e0,$95,$02,$02 
	.byte $07,$ff,$9a,$e0,$95,$03,$02 
	.byte $04,$06,$9b,$e0,$95,$05,$02 
	.byte $06,$0a,$9b,$e0,$95,$04,$02 
	.byte $0c,$10,$9b,$e0,$95,$05,$02 
	.byte $0a,$1c,$9b,$e0,$95,$03,$02 
	.byte $0a,$26,$9b,$e0,$95,$08,$03 
	.byte $09,$30,$9b,$e0,$95,$05,$02 
	.byte $0a,$39,$9b,$e0,$95,$09,$03 
        .byte $00 
	.byte $0a,$43,$9b,$e0,$95,$07,$03 
	.byte $07,$4d,$9b,$e0,$95,$02,$02 
	.byte $06,$54,$9b,$e0,$95,$07,$03 
	.byte $07,$5a,$9b,$e0,$95,$02,$02 
	.byte $06,$61,$9b,$e0,$95,$04,$02 
	.byte $00
	.byte $0e,$67,$9b,$01,$08,$12,$0b 
	.byte $07,$75,$9b,$01,$08,$17,$0b 
	.byte $0e,$7c,$9b,$01,$08,$08,$0b 
	.byte $00,$8a,$9b,$01,$08,$08,$0b 
	.byte $00 
fname_Dir
	.screen "DIR.R"	;9a60
fname_S
	.screen "S.R" ;$9a65               
fname_Era
	.screen "ERA.R" ;$9a68               
	.screen "SHIP.R" ;$9a6d               
	.screen "L.R" ;$9a73               
	.screen "D.R" ;$9a76               
	.screen "CHANGE.R" ;$9a79               
	.screen "COPY.R" ;$9a81               
	.screen "FASTCOPY.R" ;$9a87               
	.screen "NEW.R" ;$9a91               
	.screen "OOPS.R" ;$9a96               
	.screen "RENUM.R" ;$9a9c               
	.screen "TYPE.R" ;$9aa3               
	.screen "DUMP.R" ;$9aa9               
	.screen "DEL.R" ;$9aaf               
	.screen "FETCH.R" ;$9ab4               
	.screen "MERGE.R" ;$9abb               
	.screen "LU.R" ;$9ac2               
	.screen "QUERY.R" ;$9ac6               
	.screen "CONFIG.R" ;$9acd               
	.screen "BUILD.R" ;$9ad5               
	.screen "ACTIVATE.R" ;$9adc               
	.screen "AUTOCOPY.R" ;$9ae6               
	.screen "AUTODEL.R" ;$9af0               
	.screen "USER.R" ;$9af9               
	.screen "CLEAR.RDI.R" ;$9aff               
	.screen "DIAG.R" ;$9b0a               
	.screen "BUILDINDEX.R" ;$9b10               
	.screen "CHECKSUM.R" ;$9b1c               
	.screen "AUTOMOVE.R" ;$9b26               
	.screen "RECOVER.R" ;$9b30               
	.screen "VALIDATE.R" ;$9b39               
	.screen "BUILDCPM.R" ;$9b43               
	.screen "LKREV.R" ;$9b4d               
	.screen "FIND.R" ;$9b54               
	.screen "LKOFF.R" ;$9b5a               
	.screen "EXEC.R" ;$9b61               
	.screen "INSTALLCHECK.R" ;$9b67               
	.screen "ICQUB.R" ;$9b75               
	.screen "COPY-ALL.64L.R" ;$9b7c               
txt_LTKRev
	.screen "LT. KERNAL REV. 7.2 (12/18/90)" ;$9b8a               
	
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00 