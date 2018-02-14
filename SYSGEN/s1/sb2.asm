
	.include "../../include/kernal.asm"
	*=$0810
	lda #$05	;0810 a9 05    
	ldx #<setupTxt	;0812 a2 af    
	ldy #>setupTxt	;0814 a0 08    
	jsr SETNAM 	;len in A, name in Y:X	;0816 20 bd ff 
	lda #$08	;0819 a9 08    
	ldy #$08	;081b a0 08    
	ldx #$08	;081d a2 08    
	jsr SETLFS 	;A=File,X=device,Y=command 	;081f 20 ba ff 
	lda #$00	;0822 a9 00    
	jsr LOAD 	; A=1 for verify	;0824 20 d5 ff 
	lda $8003	;0827 ad 03 80 
	sta $087e	;082a 8d 7e 08 
	lda $8004	;082d ad 04 80 
	sta $087f	;0830 8d 7f 08 
	jsr CLRCHN 	;0833 20 cc ff 
	lda #$00	;0836 a9 00    
	jsr SETNAM 	;len in A, name in Y:X	;0838 20 bd ff 
	ldx #$08	;083b a2 08    
	lda #$0f	;083d a9 0f    
	ldy #$0f	;083f a0 0f    
	jsr SETLFS 	;A=File,X=device,Y=command 	;0841 20 ba ff 
	jsr $ffc0	;0844 20 c0 ff 
	lda #$01	;0847 a9 01    
	ldx #$ae	;0849 a2 ae    
	ldy #$08	;084b a0 08    
	jsr SETNAM 	;len in A, name in Y:X	;084d 20 bd ff 
	lda #$08	;0850 a9 08    
	ldy #$08	;0852 a0 08    
	ldx #$08	;0854 a2 08    
	jsr SETLFS 	;A=File,X=device,Y=command 	;0856 20 ba ff 
	jsr $ffc0	;0859 20 c0 ff 
	ldx #$0f	;085c a2 0f    
	jsr CHKOUT 	; X=LFN#	;085e 20 c9 ff 
	ldy #$00	;0861 a0 00    
	lda $08b4,y	;0863 b9 b4 08 
	cmp #$ff	;0866 c9 ff    
	beq $0870	;0868 f0 06    
	jsr CHROUT	;086a 20 d2 ff 
	iny 		;086d c8       
	bne $0863	;086e d0 f3    
	jsr CLRCHN 	;0870 20 cc ff 
	ldx #$08	;0873 a2 08    
	jsr $ffc6	;0875 20 c6 ff 
	ldy #$00	;0878 a0 00    
	jsr CHRIN	;087a 20 cf ff 
	sta $087d,y	;087d 99 7d 08 
	iny 		;0880 c8       
	lda $90		;0881 a5 90    
	beq $087a	;0883 f0 f5    
	lda #$08	;0885 a9 08    
	jsr CLOSE 	;A=LFN#	;0887 20 c3 ff 
	lda #$0f	;088a a9 0f    
	jsr CLOSE 	;A=LFN#	;088c 20 c3 ff 
	jsr CLRCHN 	;088f 20 cc ff 
	sei 		;0892 78       
	ldx #$ff	;0893 a2 ff    
	lda #$38	;0895 a9 38    
	sta $de01	;0897 8d 01 de 
	sta $df01	;089a 8d 01 df 
	stx $de00	;089d 8e 00 de 
	stx $df00	;08a0 8e 00 df 
	lda #$3c	;08a3 a9 3c    
	sta $de01	;08a5 8d 01 de 
	sta $df01	;08a8 8d 01 df 
	jmp $8000	;08ab 4c 00 00
;$08ae
	.text "#"
setupTxt
	.screen "SETUP"
unitTxt
	.screen "U1: 8, 0, 18, 18"
	.byte $0d,$ff
	
