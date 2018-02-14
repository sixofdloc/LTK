	.include "include/kernal.asm"
	*=$0100
	.repeat $100,$02
	.byte $00,$00,$00
START
	sei 
	lda #$3c	;	0204 a9 3c    
	sta $df03	;	0206 8d 03 df 
	sta $de03	;	0209 8d 03 de 
	lda #$40	;	020c a9 40    
	sta $df02	;	020e 8d 02 df 
	sta $de02	;	0211 8d 02 de 
	lda #$03	;	0214 a9 03    
	ldx #<filename	;	0216 a2 2e    
	ldy #>filename	;	0218 a0 02    
	jsr SETNAM	;	021a 20 bd ff 
	lda #$08	;	021d a9 08    
	ldy #$08	;	021f a0 08    
	ldx #$08	;	0221 a2 08    
	jsr SETLFS	;	0223 20 ba ff 
	lda #$00	;	0226 a9 00    
	jsr LOAD	;	0228 20 d5 ff 
	jmp $0810	;	022b 4c 10 08 
filename
	.text "sb2"
	
