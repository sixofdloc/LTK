; ****************************
; * 
; * Lieutenant Kernal resource project
; * 
; *         _                  _                                                    
; *    ___ | |__    ___   ___ | | __ ___  _   _  _ __ ___      __ _  ___  _ __ ___  
; *   / __|| '_ \  / _ \ / __|| |/ // __|| | | || '_ ` _ \    / _` |/ __|| '_ ` _ \ 
; *  | (__ | | | ||  __/| (__ |   < \__ \| |_| || | | | | | _| (_| |\__ \| | | | | |
; *   \___||_| |_| \___| \___||_|\_\|___/ \__,_||_| |_| |_|(_)\__,_||___/|_| |_| |_|
; *                                                                                 
; * 
; * Checksum verifies the integrity of the DOS
; *  files by running a checksum on them all.
; *
; ****************************

; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

;checksum.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen disk 
START
	ldx #<str_Checksumming
	ldy #>str_Checksumming
	jsr LTK_Print		; print Checksumming note
	
	lda #$0a		; LU 10
	ldx #$00		
	ldy #$00		; block 0
	clc			; read
	jsr LTK_HDDiscDriver	;  READ block to the file header area
	.word LTK_FileHeaderBlock 
	.byte $01		; one block
L95f4
	inx			; next block
L95f5
	lda #$0a		; LU 10
	stx lba_hi
	sty lba_lo		; Save current block
	clc			; read
	jsr LTK_HDDiscDriver	;  READ block to LTK Workspace area
	.word LTK_MiscWorkspace
	.byte $01		; one block
L9604
	lda #<LTK_MiscWorkspace
	sta $31
	lda #>LTK_MiscWorkspace
	sta $32
	ldy #$00
	ldx #$02
L9610
	lda ($31),y		; get byte
	pha			; save a copy for later

	; calculate running 16-bit checksum
	;  cs_16 = (cs_16 + byte) AND $ffff
	clc
	adc cs_16_l		; calculate low byte
	sta cs_16_l
	lda #$00
	adc cs_16_h		; handle overflow
	sta cs_16_h
	
	pla			; restore the original byte

	; calculate secondary checksum
	clc
	adc L96ad		; add new byte to running checksum
	asl a			;  and multiply by two
	sta L96ad
	lda L96ae		; get high byte
	rol a			;  rotate carry in
	bcc L9639		;  skip if no overflow
	
	inc L96ab		; increment if overflowed
	bne L9639
	
	inc L96ac		;  handle overflow
L9639
	sta L96ae
	iny			; increment index
	bne L9610		;  if we didn't overflow, loop
	inc $32			; fix up high byte of vector
	dex			; decrement page count
	bne L9610		;  and run until we're out of pages
	
	ldx lba_hi		; get our block back
	ldy lba_lo
	inx			;  select next block
	bne L964e		;  and head back if there's no overflow
	
	iny			;  handle block low byte overflow by incrementing high byte
L964e
	tya
	bne L9660
	
	cpx #$1a		; luchange.r
	bne L9656
	
	inx
L9656
	cpx #$ee		; DISCBITMAP
	bne L966c
	
	ldx #$ef
	ldy #$01
	bne L966c
	
L9660
	cpy #$02
	bne L966c
	
	cpx #$9e		; defaults.r
	bne L966c
	
	ldx #$2e
	ldy #$03
L966c
	cpy LTK_FileHeaderBlock+$94 ; 9274
	beq L9674
L9671
	jmp L95f5
                    
L9674
	cpx LTK_FileHeaderBlock+$95 ; 9275
	bne L9671
	ldy #$05
L967b
	lda LTK_FileHeaderBlock+$96,y ; 9276
	cmp cs_16_l,y
	bne ChksumBad
	dey
	bpl L967b
	
	dec LTK_FileHeaderBlock+$2A ; 920a
	lda #$0a		; LU 10
	ldx #$00
	ldy #$00		; block 0
	sec			; write
	jsr LTK_HDDiscDriver	;  WRITE sector 0, LU 10
	.word LTK_FileHeaderBlock
	.byte $01
	
ChksumGood			; Checksum is okay.  Print the okay message now
	ldx #<str_ChecksumsGood
	ldy #>str_ChecksumsGood
	bne L96a3
	
ChksumBad			; Checksums failed; warn the user and beep
	jsr Beep_If_Allowed	;  but not necessarily in that order.
	ldx #<str_ChecksumsBad
	ldy #>str_ChecksumsBad
L96a3
	jsr LTK_Print
	rts
                    
lba_lo
	.byte $00
lba_hi	.byte $00
cs_16_l	.byte $00		; 16bit checksum
cs_16_h	.byte $00
L96ab	.byte $00
L96ac	.byte $00
L96ad	.byte $00
L96ae	.byte $00 

str_Checksumming ;$96af
	.text "{clr}{return}{return}please wait... checksumming the dos."
	.byte $00
	
str_ChecksumsGood ;$96d7
	.text "{return}{return}all dos checksums on lu #10 are good.{return}{return}now reset your computer to force an{return}update of the dos on your other lu(s).{return}{return}{return}thank you."
	.byte $00
	
str_ChecksumsBad ;$9758
	.text "{return}{return}lu 10 has been corrupted !!!{return}{return}you must do a sysgen to correct it !!"
	.byte $00
	
Beep_If_Allowed ;$979e
	lda LTK_BeepOnErrorFlag
	beq No_Beep ;$97dd
	ldy #$18
	lda #$00
L97a7
	sta SID_V1_FreqLo,y
	dey
	bpl L97a7
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L97b9
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_delay_loop ;$97de
	iny
	tya
	cmp #$10
	bne L97b9
	ldx #$50
	jsr beep_delay_loop ;$97de
	ldy #$10
	sta SID_V1_Control
L97d1
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_delay_loop ;$97de
	tya
	bne L97d1
No_Beep ;$97dd 
	rts
                    
beep_delay_loop ;$97de               
	dec beep_delay_value ;$97e7
	bne beep_delay_loop ;$97de
	dex
	bne beep_delay_loop ;$97de
	rts
                    
beep_delay_value ;$97e7
	.byte $00 
