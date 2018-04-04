;****************************************
;*                                  _    _                                
;*    ___  ___   _ __ __   __ _ __ | |_ (_)  ___     __ _  ___  _ __ ___  
;*   / __|/ _ \ | '_ \\ \ / /| '__|| __|| | / _ \   / _` |/ __|| '_ ` _ \ 
;*  | (__| (_) || | | |\ V / | |   | |_ | || (_) |_| (_| |\__ \| | | | | |
;*   \___|\___/ |_| |_| \_/  |_|    \__||_| \___/(_)\__,_||___/|_| |_| |_|
;*                                                                        

;convrtio.r.prg

; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************


	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/relocate.asm"	; relocation tools.

	*=LTK_MiniSubExeArea ;$95e0, $4000 for sysgen
L93e0               
	jmp convrtio
                    
	.byte $af ; size of patch below
	; relocate to fa2c
	#relocate $fa2c
Lfa2c
	pha
	txa
	pha
	tya
	pha
	tsx
	lda $0104,x
	and #$10
	beq Lfa3c
	jmp ($0316)
                    
Lfa3c
	lda #$fa
	pha
	lda #$4b
	pha
	php
	pha
	lda $c5
	pha
	pha
	jmp $ea31
                    
Lfa4b
	sei
	ldy #$00
	lda $cb
	cmp #$40
	bne Lfab6
	lda #$ff
	sta $dc00
	sty $d02f
	lda $dc01
	cmp #$ff
	beq Lfab6
	stx $c5
	lda #$fe
Lfa67
	pha
	ldx #$08
	sta $d02f
Lfa6d
	lda $dc01
	cmp $dc01
	bne Lfa6d
Lfa75
	lsr a
	bcs Lfa81
	pha
	lda $fac1,y
	beq Lfa80
	sta $cb
Lfa80
	pla
Lfa81
	iny
	dex
	bne Lfa75
	pla
	sec
	rol a
	cpy #$17
	bcc Lfa67
	lda $cb
	cmp #$40
	beq Lfab6
	ldx #$81
	ldy #$00
	bcc Lfaa0
	and #$7f
	sta $cb
	ldx #$c2
	ldy #$01
Lfaa0
	lda #$eb
   	sty $028d
   	stx $f5
   	sta $f6
   	jsr $eae0
   	ldy #$00
   	ldx #$10
Lfab0 
	iny
	bne Lfab0
	dex
	bne Lfab0
Lfab6
	lda #$ff
	sta $d02f
	jsr $eb42
	jmp $ea81
                    
	#endr
L9479                                          
	.byte $00,$1b,$10,$00,$3b,$0b,$18,$38
	.byte $00,$28,$2b,$00,$01,$13,$20,$08
	.byte $00,$23,$2c,$87,$07,$82,$02,$00 
	.byte $00

convrtio
	ldy #$00
	jsr GetY_Inc		; get opcode
	ldx #$06
L9499
	cmp Opcode_Table,x	; compare with table
	beq L94a3		;  got a match?  Do some editing
	dex
	bpl L9499		;  continue comparing
	bmi L94c4		; done comparing, update pointers
L94a3
	jsr GetY_Inc		; get low byte
	cmp #$04
	bcs L94c4		; higher than 4: skip ahead
	jsr GetY_Inc		; get high byte
	cmp #$df		; DFxx?
	bne L94c4		;  no, skip
	lda #$de		; get DExx page address
	dey			; back up one
	sta ($31),y		; store
	lda $31			; get pointer
	clc
	adc #$03		; add 3
	sta $31
	bcc L94c1
	inc $32
L94c1
	clc
	bcc convrtio		; loop.
L94c4
	inc $31
	bne L94ca
	inc $32			; increment pointer
L94ca
	lda $32
	cmp $34
	bne convrtio
	lda $31
	cmp $33
	bcc convrtio		; loop until we're done
	rts
                    
GetY_Inc               
	lda ($31),y
	iny
	rts
                    
Opcode_Table
	.byte $8c,$8d,$8e,$ac,$ad,$ae,$2c 
