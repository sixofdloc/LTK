;openrand.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
	
START
	ldy #$00
L95e2
	lda L9702,y
	beq L95ed
	sta LTK_FileHeaderBlock,y ;$91e0
	iny
	bne L95e2
L95ed
	lda #$1d
	sta $91f1
	lda #$10
	sta $91f8
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $91fd
	jsr LTK_FindFile
	sta L9682
	stx L9685
	sty L9684
	bcs L9615
	jmp L9686
                    
L9615               
	lda L9682
	bne L9623
	txa
	bne L9623
	tya
	bne L9623
	jmp L96f4
                    
L9623
	jsr LTK_AllocateRandomBlks
	bcc L962b
	jmp L96f7
                    
L962b
	lda L9682
	pha
	ldx L9685
	ldy L9684
	lda #$24
	jsr LTK_ExeExtMiniSub
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0
L964a
	lda #$00
                    
	tay
L964d
	sta $8fe0,y
	iny
	bne L964d
L9653
	sta $90e0,y
	iny
	bne L9653
	lda #$00
	sta L9683
L965e
	lda L9683
	asl a
	tay
	lda $9203,y
	tax
	lda $9202,y
	tay
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver
        .byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
L9675               
	inc L9683
	lda L9683
	cmp #$1c
	bne L965e
	jmp L9686
                    
L9682
	.byte $00 
L9683
	.byte $00 
L9684
	.byte $00 
L9685
	.byte $00 
L9686
	lda $91f8
	cmp #$10
	beq L9690
	jmp L96fa
                    
L9690
	ldx $9de4
	lda $9200
	sta $9de7,x
	lda $9201
	sta $9de8,x
	lda $91f0
	sta $9df0,x
	lda $91f1
	sta $9df1,x
	lda $91fd
	sta $9de6,x
	lda #$01
	sta $9df5,x
	lda #$1c
	asl a
	tay
	lda $9200,y
	sta $9deb,x
	lda $9201,y
	sta $9dec,x
	lda #$00
	sta $9de9,x
	sta $9dea,x
	lda $91f8
	sta $9df9,x
	lda L9682
	sta $9dfd,x
	lda $b8
	sta $9de0,x
	ldy #$00
	jsr LTK_ErrorHandler                   
	clc
L96e5
	php
	lda $9de3
	sta LTK_Var_ActiveLU
	tax
	jsr LTK_SetLuActive
	plp
	jmp LTK_SysRet_AsIs
                    
L96f4               
	ldy #$48
	.byte $2c 
L96f7
	ldy #$48
	.byte $2c 
L96fa
	ldy #$40
	jsr LTK_ErrorHandler
	sec
	bcs L96e5
L9702
	.text "#random file"
	.byte $00 