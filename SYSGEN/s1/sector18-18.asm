	*=$0400 ; $strip for sysgen
	
	.text "87000999"
	.byte $00,$a7,$87,$6b,$00,$68,$c0,$00
	;$10
	.byte $11,$04,$02,$64,$00,$00,$80,$00
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	;$20
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	;$30
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	;$40
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$50
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$60
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$70
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$80
	.byte $5b
	cpy #$5a
	jmp $fffe
	.byte $00,$00,$00,$00,$00,$00,$03,$10
	.byte $11,$00
	;$90
	.text "sysgen 12189072 "
	;$a0
	.byte $a0,$a0
	.text "01"
	.byte $a0
	.text "2a"
	.byte $a0
	.byte $a0,$a0,$a0,$00,$00,$00,$00,$00
	;$b0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$c0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$d0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$e0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$f0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	
	
	
