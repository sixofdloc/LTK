;initc064.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen 
L95e0               
	jmp L960a
                   
DisparageAndLockup               
	lda #<LOCKUP
	sta NMI_LO
	sta COLDSTART_LO
	lda #>LOCKUP
	sta NMI_HI
	sta COLDSTART_HI
                    
	;Loads the disparaging message about skipping the SN check in the ROM to $8fe0
	lda #$0a
	ldx #$ed
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$e0, $8f,$01
	
L9600               
	ldx #$e0
	ldy #$8f
	jsr LTK_Print ;print the disparaging message
                    
LOCKUP ; $9607               
	jmp LOCKUP
                    
	;Oh look, another SN check
L960a
	ldy #$07
L960c
	lda $8fd4,y
	cmp $93d4,y
	bne DisparageAndLockup
	dey
	bpl L960c
	lda $9e43
	cmp #$df
	beq L963d
	lda #$0a
	ldx #$28
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01
L962b               
	lda #$e0
	sta $31
	sta $33
	lda #$95
	sta $32
	clc
	adc #$06
	sta $34
	jsr $93e0
L963d
	lda #$0a
	ldx #$11
	ldy #$00
L9643               
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01
L964a               
	pha
	txa
	pha
	tya
	pha
	jsr S97f5
	pla
	tay
	pla
	tax
	pla
	inx
	dec $9850
	bne L9643
	lda $9be2
	ldx #$04
	ldy #$00
L9664
	sta $d800,y
	iny
	bne L9664
	inc L9664 + 2
	dex
	bne L9664
	sta $0286
	lda $9be0
	sta $d020
	lda $9be1
	sta $d021
	ldx #$00
	lda $9bfb
	beq L9687
	dex
L9687
	stx $fc60
	lda #$00
	sta $f7
	sta $f8
	sta $f9
	sta $fa
	lda #$08
	sta $ba
L9698
	lda #$00
	sta $990e
	lda $9851
	asl a
	asl a
	asl a
	tay
	lda $92e0,y
	bmi L96e5
	beq L96e5
	and #$3f
	sta $9913
	lda $92e1,y
	sta $9914
	ldx $92e3,y
	dex
	stx $9916
	lda $92e5,y
	sec
	sbc #$01
	sta $9918
	lda $92e4,y
	sbc #$00
	sta $9917
	lda $92e6,y
	sta $9919
	lda $92e7,y
	sta $991a
	jsr S9881
	lda #$20
	sta $990e
	jsr S9881
L96e5
	sec
	ror $9895
	dec $9851
	bpl L9698
	lda $920a
	beq $9709
	lda $c5
	cmp #$40
	bne $9709
	lda #$0a
	ldx #$c2
	ldy #$00
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01
L9706               
	jsr LTK_FileWriteBuffer ;$8de0
	ldx #$0a
	jsr S97e3
	ldx #$ff
	bcs L9735
	lda $91f8
	cmp #$04
	bne L9735
	lda $91f0
	bne L9735
	lda $91f1
	cmp #$19
	bne L9735
	lda $9200
	ora $91fc
	tax
	lda $9201
	clc
	adc #$05
	bcc L9735
	inx
L9735
	stx $9fac
	sta $9fad
	lda $9bec
	sta LTK_Var_Active_User
	lda $9bea
	jsr $8099
	bcc L974e
	lda #$0a
	sta LTK_Var_ActiveLU
L974e
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9e45
	lda #$00
	ldx $9bf4
	beq L9764
	lda #$80
L9764
	ldx $9bf6
	beq L976b
	ora #$40
L976b
	sta $9e44
	jsr S9852
	lda #$00
	sta $9de0
	lda #$80
	sta $9d
	ldy #$49
	jsr LTK_ErrorHandler
	lda #$00
	sta $9d
	clc
	jsr LTK_KernalTrapSetup
	jsr LTK_LoadRegs
	jsr LTK_KernalCall
	sec
	ldx #$63
	ldy #$a6
	jsr LTK_KernalTrapSetup
	ldx #$fc
	txs
	jsr LTK_KernalCall
	lda #$03
	sta $2d
	sta $2f
	sta $31
	lda #$08
	sta $2e
	sta $30
	sta $32
	lda $c5
	cmp #$40
	bne L97bb
	ldx #$00
	jsr S97e3
	bcs L97bb
	jmp LTK_ReadFileEntry_AB
                    
L97bb               
	ldx #$86
	ldy #$e3
	sec
	jsr LTK_KernalTrapSetup
	ldx #$fb
	stx LTK_AutobootFlag
	txs
	lda #$0a
	ldx #$21
	ldy #$00
	sty LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0
L97d9               
	ldx #$e2
	ldy #$93
	jsr LTK_Print
	jmp $8063
                    
S97e3
	jsr $806c
L97e6
	lda L9867,x
	beq L97f2
	sta LTK_FileHeaderBlock,y ;$91e0
	iny
	inx
	bne L97e6
L97f2
	jmp LTK_FindFile
                    
S97f5               
	stx $9811
	lda #$e0
	sta $2d
	lda #$8f
	sta $2e
	lda #$00
	tay
	ldx #$02
L9805
	clc
	adc ($2d),y
	iny
	bne L9805
	inc $2e
	dex
	bne L9805
	cmp #$00
	bne L9835
	cmp #$1a
	beq L9829
	cmp #$29
	bne L9834
	ldy #$00
L981e
	lda $8fe0,y
	sta $9f00,y
	iny
	bne L981e
	beq L9834
L9829
	ldy #$31
L982b
	lda $8fe4,y
	sta $80a8,y
	dey
	bpl L982b
L9834
	rts
                    
L9835
	ldy #$0c
L9837
	lda L9843,y
	sta $033c,y
	dey
	bpl L9837
	jmp $033c
                    
L9843
	lda #$40
	sta $df02
	lda #$3c
	sta $df03
	jmp $fce2
                    
	.byte $1a,$06
S9852               
	ldx #$00
	lda $9a
	cmp $802a
	bne L985d
	stx $9a
L985d
	lda $99
	cmp $802a
	bne L9866
	stx $99
L9866
	rts
                    
L9867               
	.text "autostart"
	.byte $00 
L9871
	.text "user.alternates"
	.byte $00 
S9881               
	jsr S9891
	bne L9890
	ldx #$10
	ldy #$00
	jsr S98b9
	jsr S98f6
L9890
	rts
                    
S9891
	jsr S98d2
	lda #$7f
	sta $df00
	lda #$50
	sta $df02
	ldx #$00
	ldy #$10
L98a2
	lda $df02
	and #$08
	beq L98b1
	inx
	bne L98a2
	dey
	bne L98a2
	pla
	pla
L98b1
	lda #$40
	sta $df02
	lda #$00
	rts
                    
S98b9
	jsr S98e2
	lda L990d,y
	eor #$ff
	sta $df00
	jsr S98e8
	iny
	dex
	bne S98b9
	jsr S98e2
	rts
                    
S98cf
	ldx #$00
	.byte $2c 
S98d2
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
                    
S98e2
	lda $df02
	bmi S98e2
	rts
                    
S98e8
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
S98f6
	jsr S98cf
	jsr S98ff
	and #$9f
	tax
S98ff
	jsr S98e2
	lda $df00
	eor #$ff
	tay
	jsr S98e8
	tya
	rts
                    
L990d
	.byte $c2,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 