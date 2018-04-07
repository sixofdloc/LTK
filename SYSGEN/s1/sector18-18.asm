	*=$0400 ; $strip for sysgen

; This file contains a data sector that resides at
;  track 18, sector 18 on the original install disk.
;
; sb2 loads this sector directly from disk to a
;  location in memory determined by a pointer in
;  setup.asm+3.
;
; Reference: http://www.floodgap.com/retrobits/ckb/ltk/drives_edit.htm
;  The following list describes Track 18, Sector 18, starting at position ZERO (of 
;  the 256 byte string). The only bytes listed are those related to your Serial 
;  Number and drive parameters. Changing any other byte values can render your
;  SYSGEN Disk inoperable, so it is strongly suggested that no other position 
;  values be changed. And, to keep things consistent with a sector editor, all 
;  Track and Sector position numbers are in HEX($). So, load T18, S18 with your 
;  favorite editor and look at the first $4D positions. You'll see that the first 
;  8 Bytes are your Serial Number followed by Eight (8) groups of 8-Byte drive 
;  table cells:
;
;    $00 - $07 is your Serial Number
;        MUST Match Serial Number contained in Host Adapter EPROM!
;        Remember your Serial Number is in EPROM at $A-$13 AND $100A-$1013
;        ALL below are Drive parameters Only
;        (note the gap from $07 to $0E - Don't edit)
;    $0E - $15 SCSI Drive Zero parameters (1st drive)
;        If you only install ONE drive, this is the only area that needs editing
;        All other cells should be: 128,0,0,0,0,0,0,0
;        Manually set the Drive to SCSI address Zero
;    $16 - $1D Drive One parameters (2nd drive)
;        If you add a second drive here, set drive to SCSI address One
;    $1E - $25 Drive Two parameters (3rd drive)
;        If you add a third drive here, set drive to SCSI address Two, etc.
;    $26 - $2D Drive three parameters (4th drive), etc.
;    $2E - $35 Drive four parameters (5th drive), etc.
;    $36 - $3D Drive five parameters (6th drive), etc.
;    $3E - $45 Drive six parameters (7th drive), etc.
;    $46 - $4D Drive seven parameters (8th drive), etc.
;    (as above, ALL unedited cells Must be "128,0,0,0,0,0,0,0". 
;     During startup, this 'string' is how LK DOS knows there 
;     are No other drives attached)
;
;    Drive entry is like so:
;	byte	function
;	0	bit 7=embedded controller, 0-6=pulse width for 3100
;	1	step period
;	2	sectors per track
;	3	number of heads
;	4	high byte, number of cylinders
;	5	low byte,  number of cylinders
;	6	write precomp in cylinders
;	7	unknown, always zero
;               99999999
;               bbbbbbbb
;               aaaaaaab
;	       9abcdef0 
serial	.text "87000999"					; 9ba9
	.byte $00,$a7,$87,$6b,$00,$68				; 9bb1
d1parm	.byte $c0,$00,$11,$04,$02,$64,$00,$00 ; SCSI ID 0	; 9bb7
d2parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 1	; 9bbf
d3parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 2	; 9bc7
d4parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 3	; 9bcf
d5parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 4	; 9bd7
d6parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 5	; 9bdf
d7parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 6	; 9be7
d8parm	.byte $80,$00,$00,$00,$00,$00,$00,$00 ; SCSI ID 7	; 9bef
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	;$80
	.byte $5b						; 9c20
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
	
	
	

