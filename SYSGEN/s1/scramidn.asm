
;**********************************************************
;*
;*                                _     __
;*    ___ ____ ____ ___ _ __ _   (_)___/ /___      ____
;*   (_-</ __// __// _ `//  ' \ / // _  // _ \ _  / __/
;*  /___/\__//_/   \_,_//_/_/_//_/ \_,_//_//_/(_)/_/
;*
;* Scramidn.r has three sections:
;*  1: Runs at $1000 during sysgen.
;*     Some init code that's called by setup.asm to obfuscate a copyright message.
;*     After sysgen executes this code it overwrites the section from ENCODE to just before DECODE with NOPs.
;*  2: Runs at LTK_MiniSubExeArea during normal operation
;*     Some code to deobfuscate the same copyright message at some other date
;*  3: The copyright message.  This gets encoded by section 1 during sygen, and decoded by secion 2 during runtime.
;*

; ****************************
; *
; * VIM settings for David.
; *
; * vim:syntax=a65:hlsearch:background=dark:ai:
; *
; ****************************

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	; FIXME: This file will currently fail binary comparison as the load
	;  address is incorrect.  The rest was verified to match.

	*=$1000 ; This program is executed from $1000 by setup.asm during sysgen.
		; Previously it was disassembled to $93e0 (LTK_MiniSubExeArea).
		; The file's original on-disk origin is $4000

;**********************************************************
;*
;* Section 1:  Obfuscate the copyright message
;*  This is called by setup.asm during sysgen.
;*
;*  It appears to use an 8bitx8byte rotation transorm
;*   to hide the copyright message on disk.
;*
;*  This section is overwritten with NOPs by setup.asm during SYSGEN.
;*

ENCODE	lda #$14	; 20 groups (of 8 bytes, see below)
	sta $31		; set up group counter

	lda #<str_CopyrightMessage ; $1074: copyright message
	sta EnBit+1	; 
	lda #>str_CopyrightMessage ; $1074: copyright message
	sta EnBit+2	; Source = str_CopyrightMessage

	lda #<$1120	; 
	sta WrByte+1	; 
	lda #>$1120	; 
	sta WrByte+2	; Dest=$1120

	lda #$00	; Pre-set .A

EnGroup	 ldx #$08	; 	
	 stx $32	; set up byte counter

	; This section appears to do a rectangular transform of 8 bytes.
	;  If it were an 8x8 image it would be rotated 90 degrees.
EnByte	  tax		;   clear .X
	  pha		;   save .A
	  lda #$00	;   clear .A for shifting below
	  ldy #$08	;   8 bits

EnBit	   asl $9404,x	;    Shift high bit into carry   :: becomes $1074; str_CopyrightMessage
	   ror a	;     and then into high bit of .A
	   inx		;    next byte
	   dey		;    more bits?
	   bne EnBit	;    yes, loop (8 times.)

WrByte	  sta $940c,y	;   save scrambled byte to output.   :: becomes $1120; just beyond the end of this program
	  inc WrByte+1	;   Increment low byte to store next time ::  $102d just above
	  pla		;   restore .A
	  dec $32	;   decrement byte count
	  bne EnByte	;   did we do 8 bytes?  If not continue.
			;   transform done on this 8x8 group of bits.

	 txa		;  Increment read index so there's no overlap between group runs
	 dec $31	;  Have we completed 20 groups?
	 bne EnGroup	;  No, continue.
			; 20 groups are done.
	rts		; Return to setup.asm
	
	.byte $ff 	; This is a marker used by sg_LoadFile.  It replaces bytes from the
			;  beginning of scramidn.r to the first $ff with NOP's after executing it
			;  but before writing it to disk.

;**********************************************************
;*
;* Section 2:  deobfuscate the copyright message
;*  This is probably called by the DOS to display the copyright message
;*
;*  It appears to undo the 8bitx8byte rotation transorm done above.
;*   to reveal the copyright message on disk.
;*
;*  This section is disassembled with the assumption that scramidn.r is
;*   loaded and executed in the mini stub exec area at $93e0.  The assumption
;*   lines up with the targets of the self-modifying writes perfectly.
;*

;* Some defines to ensure targets below hit the right location during runtime.

DeGrp	= LTK_MiniSubExeArea+Tmp1-ENCODE	; will target one byte after rts below
DeBytes	= LTK_MiniSubExeArea+Tmp2-ENCODE	; will target the second byte after rts below
Write	= LTK_MiniSubExeArea+DeWrt+1-ENCODE	; one byte after WrByte below
Input	= LTK_MiniSubExeArea+$120		; encoded copyright message goes here
Output	= LTK_MiniSubExeArea+str_CopyrightMessage-ENCODE
						; our target buffer

DECODE	lda #$14	; 
	sta DeGrp	; Set number of groups to decode
	lda #$00	; 

DeGroup	 ldx #$08	; 
	 stx DeBytes	; Set number of bytes in this group

DeByte	  tax		; copy our index into .X
	  pha		;  save save a copy of the index to the stack
	  lda #$00	; init .A with 0
	  ldy #$08	; Set number of bits to process

DeBit	   lsr Input,x	; get a bit from the iput buffer
	   rol a	;  rotate it into .A
	   inx		; look at next byte
	   dey		; decrement our count
	   bne DeBit	;  loop until 8 bits are done.

DeWrt	  sta Output	; Save our byte
	  inc Write	; increment the save pointer (see defines above!)
	  pla		; restore our base pointer to the group's beginning
	  dec DeBytes	; Decrement bytes remaining in this group
	  bne DeByte	;  loop until done

	 txa		; Save pointer in .A
	 dec DeGrp	; Decrement group counter
	 bne DeGroup	;  loop until done

	ldx #<Output	; $9454 is the undecoded text output buffer
	ldy #>Output	; 
	jsr LTK_Print	; Print decoded copyright message

	rts		; 
	
Tmp1	.byte $00	; These two bytes will be where decgrp
Tmp2	.byte $00	;  and decbytes are pointing during assembly.

;**********************************************************
;*
;* Section 3: The copyright message
;*

str_CopyrightMessage	; $1074
	.text "{Clr}{Return}copyright(c) 1985 fiscal information inc{Return}        "	; 1074
	.text "designed and written by:{Return}{Return}           "			; 10a7
	.text "roy e. southwick{Return}{Return}                 "			; 10cc
	.text "and{Return}{Return}         lloyd e. sponenburgh"			; 10ef
	.text "{Return}{Return}"							; 1111
	.byte $00 									; 1113

