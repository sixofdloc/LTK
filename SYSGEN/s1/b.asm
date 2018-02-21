	.include "../../include/kernal.asm"
	*=$0100		; autoload by crashing the stack
	.repeat $100,$02; we start at $0203 so store $0202 for rts.
	.byte $00,$00,$00
START
	sei 
	lda #$3c	; FIXME: appears to be an idle/offline state
                        ;0011 1100
                        ;00     ; irq off
                        ;111    ; cb2 high
                        ;1      ; port register on
                        ;00     ; cb1 high
	sta $df03	; set port b on both
	sta $de03	;  adapters to idle/offline
	lda #$40	;
                        ;0010 0000
                        ;00     ; irq off
                        ;100    ; handshake [ca2: pulse low on read; cb2: go low on write]
                        ;0      ; ddr on
                        ;00     ; ca1 high
	sta $df02	; set port a on both
	sta $de02	;  adapters to idle state
	lda #$03	; filename is 3 chars long
	ldx #<filename	;
	ldy #>filename	;
	jsr SETNAM	; set file name
	lda #$08	;
	ldy #$08	;
	ldx #$08	;
	jsr SETLFS	; set file up (dev,sa,file #8)
	lda #$00	;
	jsr LOAD	; LOAD "sb2",8,8
	jmp $0810	;  start sb2 up.
filename
	.text "sb2"
	
