
	.include "../../include/kernal.asm"
	*=$0810
	lda #$05
	ldx #<setupTxt
	ldy #>setupTxt
	jsr SETNAM 
	lda #$08	; file 8
	ldy #$08	; sa 8
	ldx #$08	; drive 8
	jsr SETLFS
	lda #$00	; LOAD, not VERIFY
	jsr LOAD 	; LOAD "setup",8,8
	lda $8003	; Get pointer from setup
	sta store+1	;  so we know where to put ts 18,18
	lda $8004
	sta store+2
	jsr CLRCHN
	lda #$00
	jsr SETNAM
	ldx #$08	; drive 8
	lda #$0f	; file 15
	ldy #$0f	; sa 15
	jsr SETLFS
	jsr $ffc0	;OPEN 15,8,15
	lda #$01
	ldx #<fname_pound
	ldy #>fname_pound
	jsr SETNAM
	lda #$08	; file 8
	ldy #$08	; SA 8
	ldx #$08	; device 8
	jsr SETLFS
	jsr $ffc0	;OPEN 8,8,8,"#"		;0859 20 c0 ff 
	ldx #$0f
	jsr CHKOUT	; command channel
	ldy #$00
loop	lda unitTxt,y
	cmp #$ff	; end of string?
	beq done
	jsr CHROUT	; send "u1: 8, 0, 18, 18" to command
	iny
	bne loop	
done	jsr CLRCHN	; ready to read ts 18,18 from file 8
	ldx #$08
	jsr $ffc6	;CHKIN file 8
	ldy #$00
rdloop	jsr CHRIN
store	sta $087d,y	; read sector to setup [selfmodded earlier]
	iny 
	lda $90		; Check ST
	beq rdloop	; repeat until not ok
	lda #$08
	jsr CLOSE
	lda #$0f
	jsr CLOSE	; close everything out.
	jsr CLRCHN
	sei 		; init hardware:
	ldx #$ff	; 1=inactive in scsi-land!
	lda #$38
		;0011 1000
		;00       ; irq off
		;  111    ; ca2 low
		;     0   ; ddr on
		;      00 ; ca1 high
	sta $de01
	sta $df01	; bad behavior but it works: Hit both possible HA locations
	stx $de00
	stx $df00
	lda #$3c
		;0011 1100
		;00       ; irq off
		;  111    ; ca2 low
		;     1   ; port register on
		;      00 ; ca1 high
	sta $de01
	sta $df01
	jmp $8000	; Start SETUP!
;$08ae
fname_pound
	.text "#"
setupTxt
	.screen "SETUP"
unitTxt
	.screen "U1: 8, 0, 18, 18"
	.byte $0d,$ff
	
