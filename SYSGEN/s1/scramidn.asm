
;scramidn.r.prg
        .include "../../include/ltk_dos_addresses.asm"
        .include "../../include/ltk_equates.asm"

	; BIG NOTE: This file will currently fail binary comparison as the load
	;  address is incorrect.  The rest was verified to match.

	*=$1000 ; This program is executed from $1000 by setup.asm during sysgen.
		; Previously it was disassembled to $93e0 (LTK_MiniSubExeArea).
		; The file's original on-disk origin is $4000
 
	; START gets called by setup.asm during SYSGEN.
	; Ultimately scramidn.r gets loaded to sector $22.
	; [ref: setup.asm:sg_LoadFile]

	; Excerpt from setup.asm, after scramidn.r is loaded to $1000
	; L8d75   cmp #$22                ;check .A ($22 = fname_ScraMidn)
        	; bne L8d8e               ; no match, skip to writing the file to disk.
        	; ; special handling of scramidn.r is done here.
        	; jsr $1000               ; call it.

START	lda #$14	; 20 groups (of 8 bytes, see below)
	sta $31		; set up group counter

	lda #<str_CopyrightMessage ; $1074: copyright message
	sta L1024 + 1	; 
	lda #>str_CopyrightMessage ; $1074: copyright message
	sta L1024 + 2	; Source = str+CopyrightMessage

	lda #<$1120	; 
	sta L102c+1	; 
	lda #>$1120	; 
	sta L102c+2	; Dest=$1120

	lda #$00	; 

L101a	 ldx #$08	; 	
	 stx $32		; set up byte counter

	; This section appears to do a rectangular transform of 8 bytes.
	;  If it were an 8x8 image it would be rotated 90 degrees.
L101e	  tax		; clear .X
	  pha		; save .A
	  lda #$00	; clear .A for shifting below
	  ldy #$08	; 8 bits
L1024	   asl $9404,x	; Shift high bit into carry   :: becomes $1074; str_CopyrightMessage
	   ror a	;  and then into high bit of .A
	   inx		; next byte
	   dey		; more bits?
	   bne L1024	; yes, loop (8 times.)
L102c	  sta $940c,y	; save scrambled byte to output.   :: becomes $1120; just beyond the end of this program
	  inc L102c+1	; Increment low byte to store next time ::  $102d just above
	  pla		; restore .A
	  dec $32	; decrement byte count
	  bne L101e	; did we do 8 bytes?  If not continue.
	; transform done on this 8x8 group of bits.

	 txa		; read index (.X) continues counting up
	 dec $31	; Have we completed 20 groups?
	 bne L101a	;  No, continue.
	rts		; Return to setup.asm
	
	.byte $ff 	; This is a marker used by sg_LoadFile.  It replaces bytes from the
			;  beginning of scramidn.r to the first $ff with NOP's after executing it
			;  but before writing it to disk.

	; This section does not get called by setup.asm and may be used by the DOS.
	; It looks at first glance like code to undo the rotation above.
	; FIXME:  Find out where this is loaded and run from so scramidn.r can be finished.

L103e	lda #$14	; 
	sta $9452	; 
	lda #$00	; 
L1045	ldx #$08	; 
	stx $9453	; 
L104a	tax		; 
	pha		; 
	lda #$00	; 
	ldy #$08	; 
L1050	lsr $9500,x	; 
	rol a		; 
	inx		; 
	dey		; 
	bne L1050	; 
	sta $9454	; 
	inc $9439	; 
	pla		; 
	dec $9453	; 
	bne L104a	; 
	txa		; 
	dec $9452	; 
	bne L1045	; 
	ldx #$54	; 
	ldy #$94	; 
	jsr $8048	; 
	rts		; 
	
	.byte $00,$00 
str_CopyrightMessage	; $1074
	.text "{Clr}{Return}copyright(c) 1985 fiscal information inc{Return}        "	; 1074
	.text "designed and written by:{Return}{Return}           "			; 10a7
	.text "roy e. southwick{Return}{Return}                 "			; 10cc
	.text "and{Return}{Return}         lloyd e. sponenburgh"			; 10ef
	.text "{Return}{Return}"							; 1111
	.byte $00 									; 1113

