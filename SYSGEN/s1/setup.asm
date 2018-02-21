
	.include "../../include/kernal.asm"
	.include "../../include/zeropage.asm"
	.include "../../include/ltk_equates.asm"
	*=$8000

	; FIXME: Should we make an ltk_hwequates or add these to the ltk_equates file?
HA_data     =$df00	; SCSI data port: port or ddr
HA_data_cr  =$df01	; SCSI data port control reg
HA_ctrl     =$df02	; SCSI control port [TODO: Map these bits]
HA_ctrl_cr  =$df03	; SCSI control port control reg
	; setup.prg
	; Responsible for installing the LtK DOS to the disk.
 
SETUP_Start
	jmp START

L8003
	; 8003, 8004 are used by sb2 to determine where to load sector 18,18!
	.byte $a9,$9b,$00,$00,$00,$00,$00,$00 

; Notes to assist disassembly:
; * This is the third program in a chain of programs to sysgen a new drive.
;    First, 'b' gets loaded, which loads 'sb2'.  Some interesting stuff in sb2:
; *  sb2 loads setup to $8000, and copies the pointer above at L8003 to itself.
;    Then track 18 sector 18 is loaded to that location ($9ba9 originally)
;    After that work is done, setup is started via jmp $8000

; 9ba9 will contain the contents of sector18-18.asm.


START
	jsr DetectAndRewrite 	; find HA and rewrite if necessary
				; Returns $DF in .A if HA is at DF00
	bit L9bb7		; $c0 = %1100 0000; s=1, v=1
	bvc L802d
	jsr S9719		
	lda #$7f
	sta HA_data
	lda #$60
	sta HA_ctrl
	ldx #$00
L8022
	inx
	bne L8022
L8025
	inx
	bne L8025
	lda #$40
	sta HA_ctrl
L802d
	bit L9bb7		; $c0, S gets set
	bmi L8035		; branch taken with our sample t/s 18,18
	jsr S9656
L8035
	ldx #$00
	stx LBA_mms
	stx LBA_ms
	inx
	stx LBA_ls
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	jsr S8c96
	lda $9c1e
	beq L805e
	cmp #$ac
	beq L805e
	cmp #$af
	beq L805e
	dec $822a
L805e
	lda #$ff
	sta $9c1e
	jsr S8c9e
	ldy #$07
	ldx #$00
L806a
	lda $9ba9,y
	cmp $9df4,y
	bne L8077
	dey
	bpl L806a
	bmi L80a3

	;print warning about serial # on drive not matching sysgen disk
L8077
	ldx #<str_SNMismatchWarning
	ldy #>str_SNMismatchWarning
	jsr printZTString
	cli
L807f
	jsr GETIN
	tax
	beq L807f
	sei
	cmp #$59
	beq L809a
HA_Fail ;$808a
	; We end up here if the host adapter can't be found.
	; Copy a routine to the tape buffer that will
	;  take the host adapter control lines inactive and
	;  reset the system.
	; FIXME: Should this reset stub also take the data 
	;  port offline?
	ldy #$00
L808c
	lda Offline_And_Reset,y ;$818f
	sta $033c,y
	beq L8097
	iny
	bne L808c
L8097
	jmp $033c	; never to be seen again [offline and reset]

L809a
	dec $8229
	dec $822a
	jmp L810a

L80a3
	lda #$00
	sta BufPtrL
	lda #$9e
	sta BufPtrH
	lda #$1a
	sta LBA_ms
	jsr S8c96
	ldx #$00
	lda $9cad
	cmp #$37
	bne L80c6
	lda $9cae
	cmp #$2e
	bne L80c6
	dex
L80c6
	stx $8228
	txa
	beq L80eb
	ldy #$31
L80ce
	lda $9e04,y
	sta $841a,y
	dey
	bpl L80ce
	ldx #$0a
	ldy #$00
L80db
	lda $841c,y
	and #$f7
	sta $841c,y
	iny
	iny
	iny
	iny
	iny
	dex
	bne L80db
L80eb
	lda #$9d
	sta LBA_ms
	lda #$02
	sta LBA_mms
	jsr S8c96
	ldy #$0f
L80fa
	lda $9e00,y
	cmp fname_SystemConfigFile,y ;$90f4
	bne L8107
	dey
	bpl L80fa
	bmi L810a
L8107
	dec $822a
	;print message "Please Wait, SYSGEN in progress"
L810a
	ldx #<str_SYSGENInProgress
	ldy #>str_SYSGENInProgress
	jsr printZTString
	jsr S8452
	ldx #$00
	stx LBA_mms
	stx LBA_ms
	inx
	stx LBA_ls
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	jsr S8c96
	ldy #$37
L812f
	lda $9bbf,y
	sta $9d00,y
	dey
	bpl L812f
	lda $8cf5
	sta $9c94
	lda $8cf6
	sta $9c95
	;print "checksumming" message
	ldx #<str_Checksumming
	ldy #>str_Checksumming
	jsr printZTString
	jsr S822b
	php
	ldy #$05
L8151
	lda $9bb1,y
	sta $9c96,y
	dey
	bpl L8151
	iny
L815b
	lda txt_LTKRev,y
	beq L8166
	sta $9c9d,y
	iny
	bne L815b
L8166
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$00
	sta $9c1e
	sta LBA_mms
	sta LBA_ms
	jsr S8c9e
	;print message that Initialization is complete...
	ldx #<str_InitComplete
	ldy #>str_InitComplete
	plp
	; or...
	beq L8189
	;print message that checksums did not match
	ldx #<str_CSMismatch
	ldy #>str_CSMismatch
L8189
	jsr printZTString
LOCKUP
	jmp LOCKUP

Offline_And_Reset ; $818f
	; copied to $033c and run on failure.
	; This takes the scsi control bus offline [FIXME: I assume port B is scsi ctrl if A is data]
	lda #$3c 	; %0011 1100
	sta HA_ctrl_cr	; PIA CRB
			; [76]  00        = irq        [off]
			; [543]   11 1    = cb2 ctrl   [manual, high]
			; [2]         1   = ddr access [on]
			; [10]         00 = cb1 ctrl   [disable, high]
	jmp $fce2	; c64 kernal reset routine

	.byte $00	; This byte must be present to signal the end of Offline_And_Reset.

DetectAndRewrite ; $8198
	; Find the host adapter and rewrite setup.asm for $de00 if necessary.
	;  If the host adapter isn't found the system gets reset via $fce2.

	;  Note that the boot rom (ltkbootstub.asm) has nearly identical behavior.

	; first, let's check at DF00 for the LtK hardware (specifically, the PIA)
	ldx #$08	; shift 8 times later
	lda #$01	; set bit 1
	sta HA_data	; of PA (scsi data- ltkbootstub.asm SCSI_READ call)
L819f
	cmp HA_data	; same?
	bne L81b3	; No, check at de00.
	clc		; 
	rol HA_data	; 
	rol a		; 
	dex		; 
	bne L819f	; Repeat until zero.
	lda #$df	; HA found at $df00.
	bne L8223	;  Return to START [always taken]
L81b0
	jmp HA_Fail	;$808a	

	; We didn't find it at DF00, check DE00.
L81b3
	ldx #$08	; See description earlier-
	lda #$01	;  this does the same at $de00.
	sta $de00	
L81ba
	cmp $de00	
	bne L81b0	; no host adapter found.  Fail out and reset.
	clc
	rol $de00	
	rol a
	dex
	bne L81ba	

	; Rewrite setup.r to use a host adapter at $de00 instead of Df00.
	;  This works by scanning for lda/x/y sta/x/y or bit abs and replacing the high byte
	;  of the operand.
	lda #$00	
	sta $fb
	lda #$80	
	sta $fc		; start reading at $8000

RewriteLoop ;$81cf
	ldy #$00
	jsr LDA_fb_Yinc ; get opcode
	cmp #$8d	; sta abs?
	beq L81f0
	cmp #$8e	; stx abs?
	beq L81f0
	cmp #$8c	; sty abs?
	beq L81f0
	cmp #$ad	; lda abs?
	beq L81f0
	cmp #$ae	; ldx abs?
	beq L81f0
	cmp #$ac	; ldy abs?
	beq L81f0
	cmp #$2c	; bit abs?
	bne L8211	; none of the above; check next.

L81f0			; Here, we check for DF00-DF04 operand.
	jsr LDA_fb_Yinc ; Got a hit; get operand low byte
 	cmp #$04	;  is the target above $xx04?
 	bcs L8211	;  Yes, continue searching
 	jsr LDA_fb_Yinc	; Get operand high byte
 	cmp #$df	;  targeting DFxx?
 	bne L8211	;  No, check next.
 	lda #$de	;  Yes: set up for DExx
 	dey		;  back up one byte
 	sta ($fb),y	;  rewrite the program

 	lda $fb		; Get pointer
 	clc
 	adc #$03	;  skip to next opcode
 	sta $fb		;  save
 	bcc L820e	;  continue if no overflow
 	inc $fc		;  fix high byte
L820e
	clc
 	bcc RewriteLoop	;  and continue searching
L8211
	inc $fb		; incremnet high byte
 	bne L8217	;  and ocntinue searching
 	inc $fc		;  fix high byte
L8217
	lda $fc		; get high byte
 	cmp #$a0	;  Above our program space?
 	bne RewriteLoop	;  No, continue searching.
 	lda $fb		; Check low byte
 	cmp #$00	
 	bcc RewriteLoop	;  continue searching
L8223
	rts		; done rewriting the program.

LDA_fb_Yinc
	; Get a byte via (fb),y and iny.
	lda ($fb),y
 	iny
 	rts

 	.byte $00,$00,$00
S822b
	lda #$00
	sta BufPtrL
	lda #$9e
	sta BufPtrH
	ldx #$01
	stx LBA_ls
	ldy #$00
L823c
	stx LBA_ms
	sty LBA_mms
	jsr S8c96
	lda #$00
	sta $fb
	lda #$9e
	sta $fc
	ldy #$00
	ldx #$02
L8251
	lda ($fb),y
	pha
	clc
	adc $8005
	sta $8005
	lda #$00
	adc $8006
	sta $8006
	pla
	clc
	adc $8009
	asl a
	sta $8009
	lda $800a
	rol a
	bcc L827a
	inc $8007
	bne L827a
	inc $8008
L827a
	sta $800a
	iny
	bne L8251
	inc $fc
	dex
	bne L8251
	ldx LBA_ms
	ldy LBA_mms
	inx
	bne L828f
	iny
L828f
	tya
	bne L82a1
	cpx #$1a
	bne L8297
	inx
L8297
	cpx #$ee
	bne L82ad
	ldx #$ef
	ldy #$01
	bne L82ad
L82a1
	cpy #$02
	bne L82ad
	cpx #$9e
	bne L82ad
	ldx #$2e
	ldy #$03
L82ad
	cpy $9c94
	beq L82b5
L82b2
	jmp L823c

L82b5
	cpx $9c95
	bne L82b2
	ldy #$05
L82bc
	lda $9bb1,y
	cmp $8005,y
	bne L82c8
	dey
	bpl L82bc
	iny
L82c8
	rts

str_SYSGENInProgress ;$82c9
	.text "{clr}{return}{rvs on}please wait...sysgen in process{return}{return}"
	.byte $00
str_SNMismatchWarning ;$82ee
	.text "{clr}{return}warning - your drive serial number does not match this sysgen disk !!!{return}{return}if your drive fails to boot upon{return}completion, please call for assistance .{return}{return}do you wish to proceed ? "
	.byte $00
str_Checksumming ;$839d
	.text "{clr}{return}{rvs on}please wait...checksumming the dos.{return}{return}"
	.byte $00
str_CSMismatch ;$83c6
	.text "{clr}{return}sorry, the dos checksums did {rvs on}not{rvs off} verify.{return}{return}you must do the entire sysgen again.{return}"
	.byte $00
tab_841a
	.byte $00,$00,$d0,$d0,$00,$c0,$50,$60 
	.byte $50,$06,$06,$00,$00,$30,$00,$f0 
	.byte $00,$00,$00,$00,$06,$66,$06,$00 
	.byte $60,$00,$06,$00,$00,$60,$00,$06 
	.byte $66,$c6,$06,$06,$00,$00,$00,$00 
	.byte $00,$06,$06,$60,$00,$f0,$60,$00 
	.byte $00,$06,$06,$00,$06,$00,$60,$00 
S8452
	lda #$ff
	sta $8cef
	sta $8cf0
	sta $8cf1
	ldy $9bba
	ldx #$00
	stx $95fd
	lda $9bb9
	jsr S95ad
	sta $8ce4
	ldy #$00
	sty $963e
	ldy #$08
	jsr S9603
	cpy #$00
	clc
	beq L847e
	sec
L847e
	adc #$03
	sta $8ce5
	lda #$00
	sta $963e
	lda #$f8
	ldx #$07
	ldy $8ce4
	jsr S9603
	sta $8cf4
	ldy $8ce5
	ldx #$02
	lda #$00
	sta $963e
	jsr S9603
	sta $8ce6
	jsr Zero_9c00_9dff
	ldx #$09
L84aa
	lda fname_DiscBitmap,x ;$90d4
	sta $9c00,x
	dex
	bpl L84aa
	lda $8ce6
	sta $9c13
	lda $8ce5
	sta $9c15
	lda #$02
	sta $9c11
	lda $8cf4
	sta $9c17
	lda #$01
	sta LBA_ls
	lda #$01
	sta $9c18
	lda $8ce4
	sta $9c19
	ldy $8cf4
L84dd
	lda $8ce4
	clc
	adc $9c92
	sta $9c92
	bcc L84ec
	inc $9c91
L84ec
	dey
 	bne L84dd
 	lda #$ee
 	sta $95a2
 	sta $9c21
 	sta LBA_ms
 	lda #$9c
 	sta BufPtrH
 	lda #$00
 	sta BufPtrL
 	lda #$00
 	sta $95a0
 	sta LBA_mms
 	lda #$ff
 	sta $9c96
 	sta $9c97
 	lda #$0a
 	sta $9c1d
 	jsr S8c9e
 	lda $8cf4
 	sta $8ce9
L8522
	lda #$00
	sta $8cea
	lda #$9c
	sta $8ceb
	lda $8ce6
	sta $8cec
	jsr Zero_9c00_9dff
L8535
	lda $8cea
 	sta staAndIncDest + 1
 	lda $8ceb
 	sta staAndIncDest + 2
 	lda #$00
 	jsr staAndIncDest
 	lda $8ce7
 	jsr staAndIncDest
 	lda $8ce8
 	jsr staAndIncDest
 	clc
 	lda $8cea
 	adc $8ce5
 	sta $8cea
 	bcc L8561
 	inc $8ceb
L8561
	lda $8ce8
	clc
	adc $8ce4
	sta $8ce8
	bcc L8570
	inc $8ce7
L8570
	dec $8ce9
 	beq L8580
 	dec $8cec
 	bne L8535
 	jsr S8c9e
 	jmp L8522

L8580
	lda $8ceb
 	sta staAndIncDest + 2
 	lda $8cea
 	sta staAndIncDest + 1
 	lda #$ff
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr S8c9e
 	jsr Zero_9c00_9dff
 	ldx #$0a
L859f
	lda fname_SystemTrack,x ;$90de
 	sta $9c00,x
 	dex
 	bpl L859f
 	lda #$ee
 	sta $9c11
 	lda $9bba
 	sta $9c19
 	lda $9bbb
 	sta $9c16
 	lda $9bbc
 	sta $9c17
 	lda #$0a
 	sta $9c1d
 	sta $9c28
 	lda L9bb7
 	sta $9c12
 	lda $9bb8
 	sta $9c13
 	lda $9bbe
 	sta $9c1a
 	lda $9bbd
 	sta $9c15
 	ldx #$01
 	stx $9c18
 	ldy #$07
L85e6
	lda $9ba9,y
	sta $9df4,y
	dey
	bpl L85e6
	jsr S979e
	lda #$00
	sta $95a0
	sta $95a2
	sta LBA_ms
	sta LBA_mms
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	dec $9c2a
	dec $9c1e
	lda $9bb9
	sta $9c14
	lda $8cf4
	sta $9c36
	jsr S8c9e
	jsr Zero_9c00_9dff
L8622
	inc LBA_ms
	lda LBA_ms
	cmp #$1a
	beq L8622
	cmp #$ee
	beq L8636
	jsr S8c9e
	jmp L8622

L8636
	lda #$01
	sta LBA_mms
	lda #$ef
	sta LBA_ms
	lda #$02
	sta $8c40
	lda #$9d
	sta $8c39
	jsr S8c28
	lda #$02
	sta LBA_mms
	lda #$ae
	sta LBA_ms
	lda #$05
	sta $8c40
	lda #$00
	sta $8c39
	jsr S8c28
	lda #$00
	sta $8cf1
	lda #$07
	sta LBA_ls
	lda #$01
	ldx #<fname_LtKernal
	ldy #>fname_LtKernal ;$8e40
	jsr sg_LoadFile
	lda #$08
	ldx #<fname_LtKrn128 
	ldy #>fname_LtKrn128 ;$8f4e
	jsr sg_LoadFile
	lda #$ff
	sta $8cf1
	lda #$01
	sta LBA_ls
	lda #$9c
	sta BufPtrH
	lda #$00
	sta BufPtrL
	lda #$ee
	sta LBA_ms
	jsr S8c96
	jsr S979e
	jsr Zero_9c00_9dff
	ldx #$0a
L86a4
	lda fname_SystemIndex,x ;$L90e9
	sta $9c00,x
	dex
	bpl L86a4
	lda #$ff
	sta $8ced
	sta $9c11
	ldx #$01
	stx $9c18
	jsr S979e
	lda #$f0
	sta LBA_ms
	sta $95a2
	lda #$00
	sta LBA_mms
	sta $95a0
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$0a
	sta $9c1d
	jsr S8c9e
	dec $8ced
	lda #$10
	sta $8cee
	jsr Zero_9c00_9dff
	lda #$1d
	sta L86f8 + 1
	lda #$9c
	sta L86f8 + 2
L86f4
	ldx #$03
	lda #$ff
L86f8
	sta L86f8
	inc L86f8 + 1
	bne L8703
	inc L86f8 + 2
L8703
	dex
	bne L86f8
	clc
	lda L86f8 + 1
	adc #$1d
	sta L86f8 + 1
	bcc L8714
	inc L86f8 + 2
L8714
	dec $8cee
	bne L86f4
L8719
	jsr S8c9e
	dec $8ced
	bne L8719
	lda #$00
	sta $8cef
	jsr Zero_9c00_9dff
	ldy #$0f
L872b
	lda fname_Fastcopy_Modules,y ;$9104
	sta $9c00,y
	dey
	bpl L872b
	lda #$ae
	sta $9c11
	lda #$01
	sta $9c18
	jsr S979e
	lda $9c20
	sta LBA_mms
	sta $8cf2
	lda $9c21
	sta LBA_ms
	sta $8cf3
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$0a
	sta $9c1d
	jsr S8c9e
	jsr S8c4c
	jsr Zero_9c00_9dff
	ldy #$0f
L876d
	lda fname_SystemConfigFile,y ;$90f4
	sta $9c00,y
	dey
	bpl L876d
	lda #$c8
	sta $9c11
	lda #$01
	sta $9c18
	jsr S979e
	lda $9c20
	sta LBA_mms
	lda $9c21
	sta LBA_ms
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$0a
	sta $9c1d
	jsr S8c9e
	jsr S8c4c
	lda #$00
	jsr S8c44
	beq L87ae
	jmp Break

L87ae
	lda #$ee
	jsr S8c44
	beq L87b8
	jmp Break

L87b8
	lda #$f0
	jsr S8c44
	beq L87c2
	jmp Break

L87c2
	lda #$00
	sta $8cf0
	lda #$01
	sta LBA_ls
	
	lda #$11
	ldx #<fname_Findfile
	ldy #>fname_Findfile ;$8db4
	jsr sg_LoadFile
	
	lda #$20
	ldx #<fname_FindFil2
	ldy #>fname_FindFil2 ;$8ecc
	jsr sg_LoadFile
	
	lda #$12
	ldx #<fname_LoadRand
	ldy #>fname_LoadRand ;$8dbe
	jsr sg_LoadFile
	
	lda #$26
	ldx #<fname_LoadRnd2 
	ldy #>fname_LoadRnd2 ;$8fe4
	jsr sg_LoadFile
	
	lda #$27
	ldx #<fname_LoadRnd3 
	ldy #>fname_LoadRnd3 ;$8ff8
	jsr sg_LoadFile
	
	lda #$13
	ldx #<fname_ErrorHan 
	ldy #>fname_ErrorHan ;$8dc8
	jsr sg_LoadFile
	
	lda #$14
	ldx #<fname_LoadCntg 
	ldy #>fname_LoadCntg ;$8dd2
	jsr sg_LoadFile
	
	lda #$15
	ldx #<fname_AlocAtRn 
	ldy #>fname_AlocAtRn ;$8ddc
	jsr sg_LoadFile
	
	lda #$16
	ldx #<fname_AlocAtCn 
	ldy #>fname_AlocAtCn ;$8de6
	jsr sg_LoadFile
	
	lda #$17
	ldx #<fname_AppendRn
	ldy #>fname_AppendRn ;$8df0
	jsr sg_LoadFile
	
	lda #$18
	ldx #<fname_DealocRn
	ldy #>fname_DealocRn ;$8dfa
	jsr sg_LoadFile
	
	lda #$19
	ldx #<fname_DealocCn
	ldy #>fname_DealocCn ;$8e4a
	jsr sg_LoadFile
	
	lda #$1a
	ldx #<fname_LuChange 
	ldy #>fname_LuChange ;$8e54
	jsr sg_LoadFile
	
	lda #$1b
	ldx #<fname_AlocExRn 
	ldy #>fname_AlocExRn ;$8e72
	jsr sg_LoadFile
	
	lda #$1c
	ldx #<fname_ExpnRand
	ldy #>fname_ExpnRand ;$8e7c
	jsr sg_LoadFile
	
	lda #$1d
	ldx #<fname_ApndExRn
	ldy #>fname_ApndExRn ;$8e86
	jsr sg_LoadFile
	
	lda #$1e
	ldx #<fname_DealExRn
	ldy #>fname_DealExRn ;$8e90
	jsr sg_LoadFile
	
	lda #$21
	ldx #<fname_CreditsB
	ldy #>fname_CreditsB ;$8ed6
	jsr sg_LoadFile
	
	lda #$22
	ldx #<fname_ScraMidn
	ldy #>fname_ScraMidn ;$8ee0
	jsr sg_LoadFile
	
	lda #$23
	ldx #<fname_SubCallr
	ldy #>fname_SubCallr ;$8eea
	jsr sg_LoadFile
	
	lda #$25
	ldx #<fname_SubCl128
	ldy #>fname_SubCl128 ;$8f8a
	jsr sg_LoadFile
	
	lda #$24
	ldx #<fname_CatalogR
	ldy #>fname_CatalogR ;$8f3a
	jsr sg_LoadFile
	
	lda #$1f
	ldx #<fname_AdjIndex
	ldy #>fname_AdjIndex ;$8eae
	jsr sg_LoadFile
	
	lda #$28
	ldx #<fname_ConvrtIO
	ldy #>fname_ConvrtIO ;$9002
	jsr sg_LoadFile
	
	lda #$29
	ldx #<fname_FileProt
	ldy #>fname_FileProt ;$9048
	jsr sg_LoadFile
	
	lda #$2a
	ldx #<fname_GoCPMode
	ldy #>fname_GoCPMode ;$9084
	jsr sg_LoadFile
	
	lda #$2f
	ldx #<fname_AltSerch
	ldy #>fname_AltSerch ;$9098
	jsr sg_LoadFile
	
	lda #$00
	sta $8cf1
	lda #$04
	sta LBA_ls
	
	lda #$44
	ldx #<fname_RelaExpn
	ldy #>fname_RelaExpn ;$8e68
	jsr sg_LoadFile
	
	lda #$48
	ldx #<fname_OpenRela
	ldy #>fname_OpenRela ;$8e5e
	jsr sg_LoadFile
	
	lda #$4c
	ldx #<fname_DosOvrly
	ldy #>fname_DosOvrly ;$8e04
	jsr sg_LoadFile
	
	lda #$9a
	ldx #<fname_DosOv128
	ldy #>fname_DosOv128 ;$8f58
	jsr sg_LoadFile
	
	lda #$50
	ldx #<fname_OpenFile
	ldy #>fname_OpenFile ;$8e0e
	jsr sg_LoadFile
	
	lda #$9e
	ldx #<fname_OpenF128
	ldy #>fname_OpenF128 ;$8f62
	jsr sg_LoadFile
	
	lda #$54
	ldx #<fname_CloseFil
	ldy #>fname_CloseFil ;$8e18
	jsr sg_LoadFile
	
	lda #$a2
	ldx #<fname_Close128
	ldy #>fname_Close128 ;$8f6c
	jsr sg_LoadFile
	
	lda #$58
	ldx #<fname_SaveToDv
	ldy #>fname_SaveToDv ;$8e22
	jsr sg_LoadFile
	
	lda #$5c
	ldx #<fname_CmndChn1
	ldy #>fname_CmndChn1 ;$8e2c
	jsr sg_LoadFile
	
	lda #$ca
	ldx #<fname_CmndChn2
	ldy #>fname_CmndChn2 ;$9052
	jsr sg_LoadFile
	
	lda #$60
	ldx #<fname_Directry
	ldy #>fname_Directry ;$8e36
	jsr sg_LoadFile
	
	lda #$08
	sta LBA_ls

	lda #$3b
	ldx #<fname_ConfigLU
	ldy #>fname_ConfigLU ;$8e9a
	jsr sg_LoadFile

	lda #$08
	sta LBA_ls
	
	lda #$e6
	ldx #<fname_MessFile
	ldy #>fname_MessFile ;$8ea4
	jsr sg_LoadFile
	
	lda #$04
	sta LBA_ls
	
	lda #$6a
	ldx #<fname_CommLoad
	ldy #>fname_CommLoad ;$8eb8
	jsr sg_LoadFile
	
	lda #$ce
	ldx #<fname_IndxMod0
	ldy #>fname_IndxMod0 ;$905c
	jsr sg_LoadFile
	
	lda #$7e
	ldx #<fname_IndxMod1
	ldy #>fname_IndxMod1 ;$8ef4
	jsr sg_LoadFile
	
	lda #$82
	ldx #<fname_IndxMod2
	ldy #>fname_IndxMod2 ;$8efe
	jsr sg_LoadFile
	
	lda #$86
	ldx #<fname_IndxMod3
	ldy #>fname_IndxMod3 ;$8f08
	jsr sg_LoadFile
	
	lda #$8a
	ldx #<fname_IndxMod4
	ldy #>fname_IndxMod4 ;$8f12
	jsr sg_LoadFile
	
	lda #$8e
	ldx #<fname_IndxMod5
	ldy #>fname_IndxMod5 ;$8f1c
	jsr sg_LoadFile
	
	lda #$92
	ldx #<fname_IndxMod6
	ldy #>fname_IndxMod6; $8f26
	jsr sg_LoadFile
	
	lda #$96
	ldx #<fname_IndxMod7
	ldy #>fname_IndxMod7 ;$8f30
	jsr sg_LoadFile
	
	lda #$d2
	ldx #<fname_IdxM0128
	ldy #>fname_IdxM0128 ;$9066
	jsr sg_LoadFile
	
	lda #$a6
	ldx #<fname_IdxM1128
	ldy #>fname_IdxM1128 ;$8f94
	jsr sg_LoadFile
	
	lda #$aa
	ldx #<fname_IdxM2128
	ldy #>fname_IdxM2128 ;$8f9e
	jsr sg_LoadFile
	
	lda #$ae
	ldx #<fname_IdxM3128
	ldy #>fname_IdxM3128 ;$8fa8
	jsr sg_LoadFile
	
	lda #$b2
	ldx #<fname_IdxM4128
	ldy #>fname_IdxM4128 ;$8fb2
	jsr sg_LoadFile
	
	lda #$b6
	ldx #<fname_IdxM5128
	ldy #>fname_IdxM5128 ;$8fbc
	jsr sg_LoadFile
	
	lda #$ba
	ldx #<fname_IdxM6128
	ldy #>fname_IdxM6128 ;$8fc6
	jsr sg_LoadFile
	
	lda #$be
	ldx #<fname_IdxM7128
	ldy #>fname_IdxM7128 ;$8fd0
	jsr sg_LoadFile
	
	lda #$02
	sta LBA_ls
	
	lda #$0f
	ldx #<fname_SysBootR
	ldy #>fname_SysBootR ;$8f44
	jsr sg_LoadFile
	
	lda #$31
	ldx #<fname_SysBt128 
	ldy #>fname_SysBt128 ;$8f76
	jsr sg_LoadFile
	
	lda #$04
	sta LBA_ls
	
	lda #$c6
	ldx #<fname_InitC128
	ldy #>fname_InitC128 ;$8f80
	jsr sg_LoadFile
	
	lda #$64
	ldx #<fname_InitC064
	ldy #>fname_InitC064 ;$90a2
	jsr sg_LoadFile
	
	lda #$02
	sta LBA_ls
	
	lda #$2d
	ldx #<fname_Go64Boot
	ldy #>fname_Go64Boot ;$8fda
	jsr sg_LoadFile
	
	lda #$72
	ldx #<fname_OpenRand
	ldy #>fname_OpenRand ;$8fee
	jsr sg_LoadFile
	
	lda #$01
	sta LBA_ls
	
	lda #$c2
	ldx #<fname_AutoUpdt
	ldy #>fname_AutoUpdt ;$900c
	jsr sg_LoadFile
	
	lda #$01
	jsr S8be7
	lda #$0c
	ldx #<fname_FastFDos
	ldy #>fname_FastFDos ;$9016
	jsr sg_Load_8bf8
	
	lda #$0d
	jsr S8be7
	lda #$0c
	ldx #<fname_FastFD81
	ldy #>fname_FastFD81 ;$90c0
	jsr sg_Load_8bf8

	lda #$19
	jsr S8be7
	lda #$08
	ldx #<fname_FastCpy1
	ldy #>fname_FastCpy1 ;$9020
	jsr sg_Load_8bf8

	lda #$21
	jsr S8be7
	lda #$08
	ldx #<fname_FastCp1a
	ldy #>fname_FastCp1a ;$902a
	jsr sg_Load_8bf8

	lda #$29
	jsr S8be7
	lda #$08
	ldx #<fname_FastCpy2
	ldy #>fname_FastCpy2 ;$9034
	jsr sg_Load_8bf8

	lda #$31
	jsr S8be7
	lda #$08
	ldx #<fname_FastCp2a
	ldy #>fname_FastCp2a ;$903e
	jsr sg_Load_8bf8

	lda #$39
	jsr S8be7
	lda #$08
	ldx #<fname_FastCpDD
	ldy #>fname_FastCpDD ;$90ca
	jsr sg_Load_8bf8

	lda #$a3
	jsr S8be7
	lda #$0a
	ldx #<fname_FastCpRm
	ldy #>fname_FastCpRm ;$90ac
	jsr sg_Load_8bf8

	lda #$ad
	jsr S8be7
	lda #$01
	ldx #<fname_FastCpQD
	ldy #>fname_FastCpQD ;$90b6
	jsr sg_Load_8bf8
	
	lda #<fname_ptr_table_2
	sta ReadTable + 1
	lda #>fname_ptr_table_2 ;$9937
	sta ReadTable + 2
	jsr LoadFromTable
	jmp L8b40

LoadFromTable ; Loads files from a table using ReadTable to get file information
	jsr ReadTable	; get file name length
	beq S8ad0_return;  zero means end of table.
	sta len_fname	;  set kernal variable
	jsr ReadTable	; get name low byte
	sta ptr_fname	;  set kernal variable
	jsr ReadTable	; get name high byte
	sta ptr_fname+1	;  set kernal variable
	lda #$08
	sta $ba		; device 8
	lda #$01
	sta $b9		; secondary address 1
	jsr Zero_801_86f; clear some memory
	cli
	lda #$00	; .A=0 -> LOAD
	jsr LOAD	; load "fname",8,1
	bcc L8af7	; continue if no error
	jmp Break2

L8af7
	sei
	jsr Zero_9c00_9dff
	ldx len_fname	; get file name length
	dex
	dex		; cut '.R' off the end
	ldy #$00
L8b01
	lda (ptr_fname),y ; copy filename 
	sta $9c00,y	;  to 9c00
	sta $c000,y	;  and c000
	iny
	dex
	bne L8b01
	lda #$00
	sta $c000,y	; zero-terminate c000 copy
	lda #$0a
	sta $9c1d
	jsr ReadTable	; Load address low
	sta $9c1b
	jsr ReadTable	; Load address high
	sta $9c1a
	jsr ReadTable	; field #6: unknown
	sta $9c11
	jsr ReadTable	; field #7: unknown
	sta $9c18
	cmp #$03
	bne L8b38
	lda #$c0
	sta $9c12
L8b38
	jsr S9179
	beq LoadFromTable
Break
	brk

Break2
	brk

S8ad0_return
	rts

L8b40	ldx #<str_Flip_Disk
	ldy #>str_Flip_Disk ;$9114
	jsr printZTString

	cli
L8b48	jsr GETIN
	tax
	beq L8b48 ; wait for a key to be pressed
	cmp #$0d
	bne L8b40 ; not return? Repeat the prompt.

	ldx #<str_Thankyou_Continuing
	ldy #>str_Thankyou_Continuing ;$9159
	jsr printZTString

	lda #$10
	sta LBA_ls
	lda #$d6
	ldx #<fname_CP_MBoot
	ldy #>fname_CP_MBoot ;$908e
	jsr sg_LoadFile

	lda #$2e
	sta LBA_ms
	lda #$03
	sta LBA_mms
	lda #$37
	ldx #<fname_MasterCF
	ldy #>fname_MasterCF ;$8ec2
	jsr sg_Load_8bf8

	lda #$33
	sta LBA_ms
	lda #$00
	sta LBA_mms
	lda #$08
	ldx #<fname_ConfigCl
	ldy #>fname_ConfigCl ;$907a
	jsr sg_Load_8bf8

	lda $822a
	beq L8ba5
	lda #$9e
	sta LBA_ms
	lda #$02
	sta LBA_mms
	lda #$10
	ldx #<fname_Defaults
	ldy #>fname_Defaults ;$9070
	jsr sg_Load_8bf8

L8ba5
	lda #<fname_ptr_table_3
	sta ReadTable + 1
	lda #>fname_ptr_table_3 ;$9a1f
	sta ReadTable + 2
	jsr LoadFromTable
	ldx #$00
	stx LBA_mms
	inx
	stx LBA_ls
	lda #$ee
	sta LBA_ms
	lda #$00
	sta BufPtrL
	lda #$9e
	sta BufPtrH
	jsr S8c96
	lda $9e94
	sta $8cf5
	lda $9e95
	sta $8cf6
	lda #<fname_ptr_table_4
	sta ReadTable + 1
	lda #>fname_ptr_table_4 ;$9a43
	sta ReadTable + 2
	jsr LoadFromTable
	rts

S8be7
	ldx $8cf2
	clc
	adc $8cf3
	bcc L8bf1
	inx
L8bf1
	stx LBA_mms
	sta LBA_ms
	rts

sg_Load_8bf8 ;$8bf8 ;Obviously needs a better name
	sta LBA_ls
	stx ptr_fname
	sty ptr_fname+1
	jsr S8cc0
	lda #$0a
	sta len_fname
	lda #$08
	sta $ba
	lda #$00
	sta $b9
	ldx #$00
	ldy #$10
	cli
	lda #$00
	jsr LOAD
L8c18
	bcs L8c18
	lda #$10
	sta BufPtrH
	lda #$00
	sta BufPtrL
	jsr SCSI_WRITE
	rts

S8c28
	jsr SCSI_WRITE
L8c2b
	bcs L8c2b
	inc LBA_ms
	bne L8c35
	inc LBA_mms
L8c35
	lda LBA_ms
	cmp #$00
	bne S8c28
	lda LBA_mms
	cmp #$00
	bne S8c28
	rts

S8c44	sta LBA_ms
	lda #$00
	sta LBA_mms
S8c4c	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$01
	sta LBA_ls
	jsr S8c96
	ldy #$10
L8c60	lda $9c00,y
	sta $c000,y
	dey
	bpl L8c60
	jsr S9179
	cpx #$00
	rts

;prints zero-terminated string pointed to in Y:X
printZTString
	stx pzts_loop + 1
	sty pzts_loop + 2
	cli
pzts_loop
	lda pzts_loop
	beq pzts_done
	jsr CHROUT
	inc pzts_loop + 1
	bne pzts_loop
	inc pzts_loop + 2
	bne pzts_loop
pzts_done
	sei
	rts

;stores A and selfmods to inc address
staAndIncDest
	sta $9c00
	inc staAndIncDest + 1
	bne said_done
	inc staAndIncDest + 2
said_done
	rts

	
S8c96	jsr SCSI_READ
	bcc L8ca6
	bcs S8c96
	.byte $c0 ; This never gets executed
S8c9e	jsr SCSI_WRITE
	bcc L8ca6
	jsr $c000
L8ca6	lda $8cef
	beq L8cbf
	inc $95a2
	bne L8cb3
	inc $95a0
L8cb3	lda $95a2
	sta LBA_ms
	lda $95a0
	sta LBA_mms
L8cbf	rts

S8cc0	asl a
	tax
	lda #$00
	sta $fb
	lda #$10
	sta $fc
	bne L8cd6

Zero_801_86f; $8ccc
	lda #<$0801 ; clear memory?
	sta $fb
	lda #>$0801
	sta $fc	; destination
	ldx #$6e	; count 110 bytes
L8cd6	ldy #$00
	tya
L8cd9	sta ($fb),y ; zero memory
	iny
	bne L8cd9
	inc $fc
	dex
	bne L8cd9
	rts		; set 0801 to 86F=0

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00 

Zero_9c00_9dff ; $8cf7
	lda #$00
	tay
L8cfa	sta $9c00,y ; clear 9c00-9cff
	iny
	bne L8cfa
L8d00	sta $9d00,y ; clear 9d00-9dff
	iny
	bne L8d00
	rts

ReadTable; $8d07
	; Read a byte from a table and selfmod-increment to next byte
	; returns Z set if end of table (re: fname_ptr_table2)
	lda ReadTable		; Get a byte from the table (selfmod operand)
	inc ReadTable + 1	; increment 16 bit pointer
	bne L8d12
	inc ReadTable + 2
L8d12	cmp #$00		; set zero flag
	rts			; return

sg_LoadFile ;$8d15
	sta LBA_ms
	stx ptr_fname		;stash addr of filename to $bb as if SETNAM was called
	sty ptr_fname+1
	lda LBA_ls
	jsr S8cc0
	lda #$0a
	sta len_fname		;filename length is 10 for all of the files this routine handles
	lda #$08 ; drive 8
	sta $ba
	lda #$00
	sta $b9
	ldx #$00
	ldy #$10		;load address is $1000
	cli
	lda #$00
	jsr LOAD
	bcc sg_LoadFileSuccess
	jmp Break2

sg_LoadFileSuccess
	lda #$10
	sta BufPtrH
	sta $f8
	ldx #$00
	stx BufPtrL
	stx $f7
	stx LBA_mms
	lda $8cf1
	beq L8d56

	stx $11ff
L8d56
	sei
	lda $8cf1
	beq L8dab
	lda LBA_ms
	cmp #$1a
	bne L8d75
	lda $8228
	beq L8d8e
	ldy #$31
L8d6a
	lda $841a,y
	sta $1004,y
	dey
	bpl L8d6a
	bmi L8d8e
L8d75
	cmp #$22
	bne L8d8e
	jsr $1000
	ldy #$00
L8d7e
	lda $1000,y
	tax
	lda #$ea
	sta $1000,y
	iny
	inx
	bne L8d7e
	stx $11ff
L8d8e
	lda #$00
	tay
	ldx #$02
L8d93
	clc
	adc ($f7),y
	iny
	bne L8d93
	inc $f8
	dex
	bne L8d93
	sta $11ff
	sec
	lda LBA_ms
	sbc $11ff
	sta $11ff
L8dab
	jsr SCSI_WRITE
	bcc L8db3
	jsr $c000
L8db3
	rts

fname_Findfile ;$8db4
	.screen "FINDFILE.R"
	
fname_LoadRand ;$8dbe
	.screen "LOADRAND.R"
	
fname_ErrorHan ;$8dc8
	.screen "ERRORHAN.R"
	
fname_LoadCntg ;$8dd2
	.screen "LOADCNTG.R"
	
fname_AlocAtRn ;$8ddc
	.screen "ALOCATRN.R"
	
fname_AlocAtCn ;$8de6
	.screen "ALOCATCN.R"
	
fname_AppendRn ;$8df0
	.screen "APPENDRN.R"
	
fname_DealocRn ;$8dfa
	.screen "DEALOCRN.R"
	
fname_DosOvrly ;$8e04
	.screen "DOSOVRLY.R"
	
fname_OpenFile ;$8e0e
	.screen "OPENFILE.R"
	
fname_CloseFil ;$8e18
	.screen "CLOSEFIL.R"
	
fname_SaveToDv ;$8e22
	.screen "SAVETODV.R"
	
fname_CmndChn1 ;$8e2c
	.screen "CMNDCHN1.R"
	
fname_Directry ;$8e36
	.screen "DIRECTRY.R"
	
fname_LtKernal ;$L8e40
	.screen "LTKERNAL.R"
	
fname_DealocCn ;$8e4a
	.screen "DEALOCCN.R"
	
fname_LuChange ;$8e54
	.screen "LUCHANGE.R"
	
fname_OpenRela ;$8e5e
	.screen "OPENRELA.R"
	
fname_RelaExpn ;$8e68
	.screen "RELAEXPN.R"
	
fname_AlocExRn ;$8e72
	.screen "ALOCEXRN.R"
	
fname_ExpnRand ;$8e7c
	.screen "EXPNRAND.R"
	
fname_ApndExRn ;$8e86
	.screen "APNDEXRN.R"
	
fname_DealExRn ;$8e90
	.screen "DEALEXRN.R"
	
fname_ConfigLU ;$8e9a
	.screen "CONFIGLU.R"
	
fname_MessFile ;$8ea4
	.screen "MESSFILE.R"
	
fname_AdjIndex ;$8eae
	.screen "ADJINDEX.R"
	
fname_CommLoad ;$8eb8
	.screen "COMMLOAD.R"
	
fname_MasterCF ;$8ec2
	.screen "MASTERCF.R"
	
fname_FindFil2 ;$8ecc
	.screen "FINDFIL2.R"
	
fname_CreditsB ;$8ed6
	.screen "CREDITSB.R"
	
fname_ScraMidn ;$8ee0
	.screen "SCRAMIDN.R"
	
fname_SubCallr ;$8eea
	.screen "SUBCALLR.R"
	
fname_IndxMod1 ;$8ef4
	.screen "INDXMOD1.R"
	
fname_IndxMod2 ;$8efe
	.screen "INDXMOD2.R"
	
fname_IndxMod3 ;$8f08
	.screen "INDXMOD3.R"
	
fname_IndxMod4 ;$8f12
	.screen "INDXMOD4.R"
	
fname_IndxMod5 ;$8f1c
	.screen "INDXMOD5.R"
	
fname_IndxMod6 ;$8f26
	.screen "INDXMOD6.R"
	
fname_IndxMod7 ;$8f30
	.screen "INDXMOD7.R"
	
fname_CatalogR; $8f3a
	.screen "CATALOGR.R"
	
fname_SysBootR; $8f44
	.screen "SYSBOOTR.R"
	
fname_LtKrn128; $8f4e
	.screen "LTKRN128.R"
	
fname_DosOv128 ;$8f58
	.screen "DOSOV128.R"
	
fname_OpenF128 ;$8f62
	.screen "OPENF128.R"
	
fname_Close128 ;$8f6c
	.screen "CLOSE128.R"
	
fname_SysBt128 ;$8f76
	.screen "SYSBT128.R"
	
fname_InitC128; $8f80
	.screen "INITC128.R"
	
fname_SubCl128; $8f8a
	.screen "SUBCL128.R"
	
fname_IdxM1128 ;$8f94
	.screen "IDXM1128.R"
	
fname_IdxM2128 ;$8f9e
	.screen "IDXM2128.R"
	
fname_IdxM3128 ;$8fa8
	.screen "IDXM3128.R"
	
fname_IdxM4128 ;$8fb2
	.screen "IDXM4128.R"
	
fname_IdxM5128 ;$8fbc
	.screen "IDXM5128.R"
	
fname_IdxM6128 ;$8fc6
	.screen "IDXM6128.R"
	
fname_IdxM7128 ;$8fd0
	.screen "IDXM7128.R"
	
fname_Go64Boot ;$8fda
	.screen "GO64BOOT.R"
	
fname_LoadRnd2 ;$8fe4
	.screen "LOADRND2.R"
	
fname_OpenRand ;$8fee
	.screen "OPENRAND.R"
	
fname_LoadRnd3 ;$8ff8
	.screen "LOADRND3.R"
	
fname_ConvrtIO ;$9002
	.screen "CONVRTIO.R"
	
fname_AutoUpdt ;$900c
	.screen "AUTOUPDT.R"
	
fname_FastFDos ;$9016
	.screen "FASTFDOS.R"
	
fname_FastCpy1 ;$9020
	.screen "FASTCPY1.R"
	
fname_FastCp1a ;$902a
	.screen "FASTCP1A.R"
	
fname_FastCpy2 ;$9034
	.screen "FASTCPY2.R"
	
fname_FastCp2a ;$903e
	.screen "FASTCP2A.R"
	
fname_FileProt ;$9048
	.screen "FILEPROT.R"
	
fname_CmndChn2 ;$9052
	.screen "CMNDCHN2.R"
	
fname_IndxMod0 ;$905c
	.screen "INDXMOD0.R"
	
fname_IdxM0128 ;$9066
	.screen "IDXM0128.R"
	
fname_Defaults ;$9070
	.screen "DEFAULTS.R"
	
fname_ConfigCl ;$907a
	.screen "CONFIGCL.R"
	
fname_GoCPMode ;$9084
	.screen "GOCPMODE.R"
	
fname_CP_MBoot ;$908e
	.screen "CP/MBOOT.R"
	
fname_AltSerch ;$9098
	.screen "ALTSERCH.R"
	
fname_InitC064 ;$90a2
	.screen "INITC064.R"
	
fname_FastCpRm ;$90ac
	.screen "FASTCPRM.R"
	
fname_FastCpQD ;$90b6
	.screen "FASTCPQD.R"
	
fname_FastFD81; $90c0
	.screen "FASTFD81.R"
	
fname_FastCpDD; $90ca
	.screen "FASTCPDD.R"
	
fname_DiscBitmap ;90d4
	.screen "DISCBITMAP"
	
fname_SystemTrack ;$90de
	.screen "SYSTEMTRACK"
	
fname_SystemIndex ;$90e9
	.screen "SYSTEMINDEX"
	
fname_SystemConfigFile ;$90f4
	.screen "SYSTEMCONFIGFILE"
	
fname_Fastcopy_Modules ;$9104
	.screen "FASTCOPY.MODULES"
	
str_Flip_Disk ;$9114
	.text "{clr}{return}{rvs on}please turn sysgen disk over to side b.{return}{return}press return when ready."
	.byte $00
	
str_Thankyou_Continuing ;$9159
	.text "{clr}{rvs on}thank you...sysgen continuing"
	.byte $00
	
S9179
	jsr S951c
	beq L9181
	ldx #$ff
	rts

L9181	sta $9493
	lda $8cf0
	bne L9191
	jsr S979e
	bcc L9191
	jsr $c000
L9191	lda #$00
	sta BufPtrL
	sta $9446
	lda #$9e
	sta BufPtrH
	sta $9445
	lda $95a2
	sta LBA_ms
	lda $95a1
	sta LBA_mms
	ldx #$01
	stx LBA_ls
	jsr SCSI_READ
	bcc L91ba
	jsr $c000
L91ba	lda #$10
	sta $9492
	lda #$00
	sta $9442
	sta $9443
L91c7	jsr S944d
	jsr S9486
	tay
	and #$80
	bne L91ee
	jsr S93d8
	bne L91e8
	ldx #$00
	ldy #$c0
	jsr printZTString
	ldx #<str_FileExists
	ldy #>str_FileExists ;$9494
	jsr printZTString
	ldx #$ff
	rts

L91e8	jsr S93fd
	bne L91c7
	brk

L91ee	cpy #$ff
	beq L91f5
	jmp L9307

L91f5	jsr S9486
	cmp #$ff
	beq L91ff
	jmp L9307

L91ff	jsr S9486
	cmp #$ff
	beq L9209
	jmp L9307

L9209	lda $9442
	beq L923c
	lda $95a1
	ldx $95a2
	cmp $9440
	bne L921e
	cpx $9441
	beq L922d
L921e	sta LBA_mms
	sta $95a1
	stx LBA_ms
	stx $95a2
	jsr S8c96
L922d	lda $943e
	sta $9445
	lda $943f
	sta $9446
	jsr S944d
L923c	lda $9446
	sta $924e
	lda $9445
	sta $924f
	ldy #$0f
L924a	lda $9c00,y
	sta $924d,y
	dey
	bpl L924a
	lda #$00
	jsr S947a
	lda $9c20
	jsr S947a
	lda $9c21
	jsr S947a
	lda $9445
	sta S92e4 + 2
	lda $9446
	sta S92e4 + 1
	ldy #$10
	lda $9c10
	jsr S92e4
	lda $9c11
	jsr S92e4
	lda $9c14
	jsr S92e4
	lda $9c15
	jsr S92e4
	lda $9c16
	jsr S92e4
	lda $9c17
	jsr S92e4
	lda $9c18
	jsr S92e4
	lda $9c1a
	jsr S92e4
	lda $9c1b
	jsr S92e4
	lda #$0a
	jsr S92e4
	inc $9e1c
	jsr S8c9e
	lda $9e1c
	cmp #$01
	bne L92c4
	lda #$ff
	jsr S92e9
	beq L92c4
	jmp $c000

L92c4	lda $8cf0
	bne L92cc
	jsr S9327
L92cc	ldx #<str_CR
	ldy #>str_CR ;$951a
	jsr printZTString
	ldx #$00
	ldy #$c0
	jsr printZTString
	ldx #<str_FileCreated
	ldy #>str_FileCreated ;$94b3
	jsr printZTString
	ldx #$00
	rts

S92e4	sta S92e4,y
	iny
	rts

S92e9	sta $9306
	lda #$f0
	sta LBA_ms
	lda #$00
	sta LBA_mms
	jsr S8c96
	ldy $95a3
	lda $9306
	sta $9e22,y
	jsr S8c9e
	rts

	.byte $00 
L9307	lda $9445
	sta $943e
	lda $9446
	sta $943f
	lda $95a1
	sta $9440
	lda $95a2
	sta $9441
	lda #$ff
	sta $9442
	jmp L91e8

S9327	lda #$00
	sta $9449
	sta $944a
L932f	lda $944a
	asl a
	tax
	lda $9c20,x
	sta LBA_mms
	sta $95a1
	lda $9c21,x
	sta LBA_ms
	sta $95a2
	lda $9443
	bne L9385
	lda #$00
	sta BufPtrL
	lda #$9c
	sta BufPtrH
	lda #$01
	sta LBA_ls
	jsr S8c9e
	lda $9c1a
	ldx $9c1b
	cmp #$95
	bne L936b
	lda #$40
	ldx #$00
L936b	sta $944b
	stx $944c
	lda $9c10
	sta $9447
	lda $9c11
	sta $9448
	lda #$ff
	sta $9443
	jmp L93a6

L9385	lda $95a2
	sta LBA_ms
	lda $95a1
	sta LBA_mms
	lda $944b
	sta BufPtrH
	lda $944c
	sta BufPtrL
	jsr S8c9e
	inc $944b
	inc $944b
L93a6	inc $944a
	bne L93ae
	inc $9449
L93ae	inc $95a2
	bne L93bb
	inc $95a1
	bne L93bb
	inc $95a0
L93bb	lda $944a
	cmp $9448
	bne L93ce
	lda $9449
	cmp $9447
	bne L93ce
	ldx #$00
	rts

L93ce	lda $9c18
	cmp #$0a
	bcc L9385
	jmp L932f

S93d8	ldx #$10
	lda #$00
	sta $93e8
	lda #$9c
	sta $93e9
L93e4	jsr S946e
	cmp $93e7
	beq L93ef
	ldx #$ff
	rts

L93ef	inc $93e8
	bne L93f7
	inc $93e9
L93f7	dex
	bne L93e4
	ldx #$00
	rts

S93fd	lda $9446
	clc
	adc #$20
	sta $9446
	bcc L940b
	inc $9445
L940b	dec $9492
	beq L9411
	rts

L9411	inc $95a2
	bne L9419
	inc $95a1
L9419	lda $95a2
	sta LBA_ms
	lda $95a1
	sta LBA_mms
	jsr S8c96
	lda #$10
	sta $9492
	lda #$00
	sta $9446
	lda #$9e
	sta $9445
	inc $95a3
	dec $9493
	rts

	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00 
S944d	ldx $9446
	stx S946e + 1
	ldy $9445
	sty S946e + 2
	txa
	clc
	adc #$1d
	tax
	bcc L9461
	iny
L9461	stx S9486 + 1
	sty S9486 + 2
	stx S947a + 1
	sty S947a + 2
	rts

S946e	lda S946e
	inc S946e + 1
	bne L9479
	inc S946e + 2
L9479	rts

S947a	sta S947a
	inc S947a + 1
	bne L9485
	inc S947a + 2
L9485	rts

S9486	lda S9486
	inc S9486 + 1
	bne L9491
	inc S9486 + 2
L9491	rts

	.byte $00,$00
str_FileExists ;$9494
	.text " - filename already exists !!{return}"
	.byte $00 
str_FileCreated ;$94b3
	.text " file has been created.{return}"
	.byte $00 
str_InitComplete ;$94cc
	.text "{return}system initialization complete !!!{return}{return}now do a full system reset{return}{return}{return}thank you.{return}"
	.byte $00
str_CR ;$951a
	.text "{Return}"
	.byte $00 

S951c	ldx #<$9c00
	ldy #>$9c00		; start reading at 9c00
	sec			; sec = set source address
	jsr Read_Memory_xy	; set address to 9c00
	lda #$10
	sta $95a4		; scratch space?
	lda #$00
	sta $95a5		; setting up $1000?
	sta $95a6
	sta $95a1
	sta $95a0
	sta $963e
L953a	clc			; clc = read byte
	jsr Read_Memory_xy	; get the next byte
	cmp #$00   
	beq L955d
	ldx #$05
L9544	cmp L95a7,x
	beq L9567
	dex
	bpl L9544
	clc
	adc $95a6
	sta $95a6
	bcc L9558
	inc $95a5
L9558	dec $95a4
	bne L953a
L955d	lda $95a6
	bne L956a
	lda $95a5
	bne L956a
L9567	ldx #$ff
	rts

L956a	sec
	lda $95a6
	sbc #$01
	sta $95a6
	bcs L9578
	dec $95a5
L9578	lda $95a6
	ldx $95a5
	ldy #$10
	jsr S9603
	sta $95a3
	lda #$f0
	sec
	adc $95a3
	sta $95a2
	bcc L9594
	inc $95a1
L9594	lda #$fe
	sec
	sbc $95a3
	ldy $95a3
	ldx #$00
	rts

	.byte $00,$00,$00,$00,$00,$00,$00 
L95a7	.text "=:,*?"
	.byte $a0 ;//"{Shift Space}"
S95ad	sta $95ff
	stx $95fe
	sty $95fc
	lda #$00
	sta $9600
	sta $9601
	sta $9602
	ldx #$08
L95c3	clc
	lsr $95fc
	bcc L95e5
	clc
	lda $9602
	adc $95ff
	sta $9602
	lda $9601
	adc $95fe
	sta $9601
	lda $9600
	adc $95fd
	sta $9600
L95e5	clc
	rol $95ff
	rol $95fe
	rol $95fd
	dex
	bne L95c3
	ldy $9600
	ldx $9601
	lda $9602
	rts

	.byte $00,$00,$00,$00,$00,$00,$00 
S9603	sta $9640
	stx $963f
	sty $963d
	lda #$00
	ldx #$18
L9610	clc
	rol $9640
	rol $963f
	rol $963e
	rol a
	bcs L9622
	cmp $963d
	bcc L9632
L9622	sbc $963d
	inc $9640
	bne L9632
	inc $963f
	bne L9632
	inc $963e
L9632	dex
	bne L9610
	tay
	ldx $963f
	lda $9640
	rts

	.byte $00,$00,$00,$00

Read_Memory_xy ;$9641
	; Read a byte of memory using .x and .y as an address
	; set the address if carry is set or read next if not.
	bcc L964a       ; don't set address if carry clear
	stx L964a + 1   ; set address of selfmod store below
	sty L964a + 2
	rts
	
L964a	lda L964a       ; get a byte
	inc L964a + 1   ; increment/selfmod pointer
	bne L9655
	inc L964a + 2
L9655	rts		; return with the byte

S9656	lda #$c2
	sta CDBBuffer
	ldx $9bba
	dex
	stx $9792
	lda $9bbb
	sta $9793
	ldx $9bbc
	dex
	stx $9794
	lda L9bb7
	and #$3f
	sta $978f
	lda $9bb8
	sta $9790
	lda $9bbd
	sta $9795
	lda $9bbe
	sta $9796
	jsr S9719
	bne L9699
	ldx #$10
	ldy #$00
	jsr SCSI_Send
	jsr S9772
	rts

L9699	sec
	rts

SCSI_WRITE ; $969b
	lda #$0a	; SCSI WRITE(6)
	bne L96a1
SCSI_READ ; $969f
	lda #$08	; SCSI READ(6)
L96a1	sta CDBBuffer	; set scsi command
	lda LBA_mms
	sta CDBBuffer+1	; set lba mmsb
	lda LBA_ms
	sta CDBBuffer+2	; set lba msb
	lda LBA_ls
	sta CDBBuffer+3	; set lba lsb
	lda BufPtrH
	sta $f8		; set buffer address
	lda BufPtrL
	sta $f7
	jsr S9719
	bne L9699
	ldx #$06	; CDB is 6 bytes long
	ldy #$00	; and starts at buff offset 0
	jsr SCSI_Send
	ldy #$00
	lda CDBBuffer
	cmp #$08	; did we READ(6)?
	beq L96f3	;  yes, perform read
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; FIXME: pulse ca2 for ???
L96da
	lda HA_ctrl	; must be hanshaking
	bmi L96da
	and #$04
	beq L9711	; exit on error (done reading)
	lda ($f7),y	; get byte from buffer
	sta HA_data	; send byte to target
	lda HA_data	; handshake pulse out
	iny		; increment pointer
	bne L96da	; until 256 bytes
	inc $f8		; increase buff high address
	jmp L96da	; and read until target says done
	
	; this behaves like SCSI_READ in ROM/lktbootstub.asm, but
	;  it's not a subroutine and doesn't send a CDB.
L96f3	jsr HA_SetDataInput
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr
L96fb	lda HA_ctrl	; handshake
	bmi L96fb
	and #$04
	beq L9711	; exit when error (done)
	lda HA_data	; get byte from target
	sta ($f7),y	; deposit in buffer
	iny
	bne L96fb	; for 256 bytes
	inc $f8		; increase buff high address
	jmp L96fb	; repeat until target says done

L9711	jsr S9772	; done read/writing, cleanup (what does 9772 do?)
	txa
	bne L9699
	clc
	rts

	; FIXME: scsi select?
S9719	jsr HA_SetDataOutput
	lda #$fe	; FIXME: targeting scsi ID 0?
	sta HA_data
	lda #$50
	sta HA_ctrl
L9726	lda HA_ctrl
	and #$08
	bne L9726
	lda #$40
	sta HA_ctrl
	lda #$00
	rts

SCSI_Send ; $9735
	jsr CTSWait
	lda CDBBuffer,y	; get byte from buffer
	eor #$ff	; invert for SCSI
	sta HA_data	; send data to bus
	jsr S9764
	iny		; increment pointer
	dex		; decrement count
	bne SCSI_Send	; repeat until done
	jsr CTSWait
	rts

HA_SetDataInput ; $974b
	ldx #$00	; set data port as input
	.byte $2c 	;  BIT opcode causes cpu to skip ldx #$ff
HA_SetDataOutput ; $974e
	ldx #$ff	; set data port as output or skip
	lda #$38
	;0011 1000
	;00     ; irq off
	;111    ; ca2 high
	;0      ; ddr on
	;00; ca1 high
	sta HA_data_cr	;  turn port A DDR on
	stx HA_data	; set data port for input or output
	lda #$3c
	;0011 1100
	;00     ; irq off
	;111    ; ca2 high
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	;  turn port A DDR off
	rts
	
CTSWait	; 957e - name borrowed from ROM/ltkbootstub.asm
	lda HA_ctrl
	bmi CTSWait
	rts

S9764	; FIXME: This likely pulses SCSI ACK or something.
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; set port A to pulse ca2 on read
	lda HA_data	; pulse ca2
	lda #$3c
	;0011 1100
	;00     ; irq off
	;111    ; ca2 high
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; set ca2 to high
	rts

S9772
	jsr HA_SetDataInput
	jsr S977b
	and #$9f
	tax
S977b
	jsr CTSWait	;
	lda HA_data	;
	eor #$ff	;
	tay		;
	jsr S9764	;
	tya		;
	rts		;

		; FIXME:  This is likely not only
		;  used by SCSI_WRITE and SCSI_READ
		; add duplicate labels later to
		;  improve code readability.

CDBBuffer	; $9789
	.byte $00,$00,$00,$00,$00,$00
	.byte $04,$00 	; $978f
	.byte $00,$00,$00,$00,$00,$00,$00,$00 ; 9791
LBA_mms	.byte $00
LBA_ms	.byte $00
BufPtrH	.byte $00
BufPtrL	.byte $00
LBA_ls	.byte $00 

S979e
	ldx #$00
	stx $9936
	inx
	stx LBA_ls
	lda #$00
	sta LBA_mms
	lda #$ee
	sta LBA_ms
	lda #$9e
	sta BufPtrH 
	lda #$00
	sta BufPtrL
	jsr SCSI_READ
	bcc L97c3
	jsr $c000
L97c3
	lda $9e13
	sta $992d
	lda $9e15
	sta $992e
	lda $9e16
	sta $9930
	lda $9e17
	sta $9931
	lda $9e19
	sta $9932
L97e1
	inc LBA_ms
	bne L97e9
	inc LBA_mms
L97e9
	lda #$00
	sta $992f
	jsr SCSI_READ
	bcc L97f6
	jsr $c000
L97f6
	lda #$9e
	sta S9929 + 2
	sta $9891
	lda #$00
	sta S9929 + 1
	sta $9890
	lda $992d
	sta $9933
L980c
	lda #$00
	sta $9935
	ldy #$02
L9813
	iny
	lda #$80
	sta $9934
	jsr S9929
	cmp #$ff
	bne L9830
	lda #$08
	clc
	adc $9935
	sta $9935
	cmp $9932
	bcc L9813
	bcs L9847
L9830
	bit $9934
	beq L988c
L9835
	inc $9935
	ldx $9935
	cpx $9932
	beq L9847
	lsr $9934
	bne L9830
	beq L9813
L9847
	lda $992e
	clc
	adc S9929 + 1
	sta S9929 + 1
	sta $9890
	bcc L985c
	inc S9929 + 2
	inc $9891
L985c
	ldx #$ff
	dec $9931
	beq L986e
	cpx $9931
	bne L9877
	dec $9930
	jmp L9877

L986e
	lda $9930
	bne L9877
	ldx #$fd
	sec
	rts

L9877
	dec $9933
	bne L980c
	lda $992f
	beq L9889
	jsr SCSI_WRITE
	bcc L9889
	jsr $c000
L9889
	jmp L97e1

L988c
	ora $9934
	sta $988f,y
	pha
	tya
	pha
	lda $9936
	beq L98a1
	ldx $9c18
	cpx #$0a
	bcc L98ba
L98a1
	asl a
	tax
	ldy #$01
	jsr S9929
	pha
	iny
	jsr S9929
	clc
	adc $9935
	sta $9c21,x
	pla
	adc #$00
	sta $9c20,x
L98ba
	lda #$ff
	sta $992f
	pla
	tay
	pla
	inc $9936
	ldx $9936
	cpx $9c11
	beq L98d0
	jmp L9835
	
L98d0
	jsr SCSI_WRITE
	bcc L98d8
	jsr $c000
L98d8
	lda #$ee
	sta LBA_ms
	lda #$00
	sta LBA_mms
	jsr SCSI_READ
	bcc L98ea
	jsr $c000
L98ea
	ldx #$ff
	lda $9e92
	sec
	sbc $9936
	sta $9e92
	bcs L9903
	dec $9e91
	cpx $9e91
	bne L9903
	dec $9e90
L9903
	lda $9936
	clc
	adc $9e95
	sta $9e95
	bcc L9917
	inc $9e94
	bne L9917
	inc $9e93
L9917
	lda #$ff
	sta $9e96
	sta $9e97
	jsr SCSI_WRITE
	bcc L9927
	jsr $c000
L9927
	clc
	rts

S9929
	lda S9929,y
	rts
	
	;992d
	.byte $00,$00,$00
	;9330
	.byte $00,$00,$00,$00,$00,$00,$00 
	; 00 00 00 00 00 00 00 
	; 00 - File Name length
	;    00 - Lo-Byte of File Name address
	;       00 - Hi-Byte of File Name address
	;          00 - Lo-byte of load address: copied to $9c1b
	;             00 - Hi-byte of load address: copied to $9c1a
	;                00 - copied to $9c11
	;                   00 - copied to $9c18

; FIXME: temporarily defining basic load address here.
;  The assembler will eventually error out when we decide where it should go.
BASIC_LoadAddr	=$0801

fname_ptr_table_2
	.byte $05 ,<fname_Dir        ,>fname_Dir            ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$08 ,$03
	.byte $03 ,<fname_S          ,>fname_S              ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $05 ,<fname_Era        ,>fname_Era            ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $06 ,<fname_Ship       ,>fname_Ship           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $03 ,<fname_L          ,>fname_L              ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $03 ,<fname_D          ,>fname_D              ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $08 ,<fname_Change     ,>fname_Change         ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$04 ,$02
	.byte $06 ,<fname_Copy       ,>fname_Copy           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$04 ,$02
	.byte $0a ,<fname_FastCopy   ,>fname_FastCopy       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $05 ,<fname_New        ,>fname_New            ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $06 ,<fname_Oops       ,>fname_Oops           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $07 ,<fname_Renum      ,>fname_Renum          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$09 ,$03
	.byte $06 ,<fname_Type       ,>fname_Type           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$07 ,$03
	.byte $06 ,<fname_Dump       ,>fname_Dump           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$03
	.byte $05 ,<fname_Del        ,>fname_Del            ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$03
	.byte $07 ,<fname_Fetch      ,>fname_Fetch          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$04 ,$03
	.byte $07 ,<fname_Merge      ,>fname_Merge          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$03
	.byte $04 ,<fname_LU         ,>fname_LU             ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $07 ,<fname_Query      ,>fname_Query          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $08 ,<fname_Config     ,>fname_Config         ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $07 ,<fname_Build      ,>fname_Build          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$03
	.byte $0a ,<fname_Activate   ,>fname_Activate       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$06 ,$03
	.byte $0a ,<fname_Autocopy   ,>fname_Autocopy       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$09 ,$03
	.byte $09 ,<fname_Autodel    ,>fname_Autodel        ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$07 ,$03
	.byte $06 ,<fname_User       ,>fname_User           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $07 ,<fname_Clear      ,>fname_Clear          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $04 ,<fname_DI         ,>fname_DI             ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $06 ,<fname_Diag       ,>fname_Diag           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$04 ,$02
	.byte $0c ,<fname_BuildIndex ,>fname_BuildIndex     ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $0a ,<fname_Checksum   ,>fname_Checksum       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$03 ,$02
	.byte $0a ,<fname_Automove   ,>fname_Automove       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$08 ,$03
	.byte $09 ,<fname_Recover    ,>fname_Recover        ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$05 ,$02
	.byte $0a ,<fname_Validate   ,>fname_Validate       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$09 ,$03
	.byte $00		; end of table
fname_ptr_table_3 ; $9a1f = $9937+($21*7)+1; referenced by L8ba5
	.byte $0a ,<fname_BuildCPM   ,>fname_BuildCPM       ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$07 ,$03
	.byte $07 ,<fname_LKRev      ,>fname_LKRev          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $06 ,<fname_Find       ,>fname_Find           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$07 ,$03
	.byte $07 ,<fname_LKOff      ,>fname_LKOff          ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$02 ,$02
	.byte $06 ,<fname_Exec       ,>fname_Exec           ,<LTK_DOSOverlay ,>LTK_DOSOverlay ,$04 ,$02
	.byte $00		; end of table
fname_ptr_table_4 ; $9a43 = 91af+(5*7)+1; referenced by L8ba5
	.byte $0e ,<fname_InstallCheck ,>fname_InstallCheck ,<BASIC_LoadAddr ,>BASIC_LoadAddr ,$12 ,$0b
	.byte $07 ,<fname_ICQUB        ,>fname_ICQUB        ,<BASIC_LoadAddr ,>BASIC_LoadAddr ,$17 ,$0b
	.byte $0e ,<fname_CopyAll_64  ,>fname_CopyAll_64  ,<BASIC_LoadAddr ,>BASIC_LoadAddr ,$08 ,$0b
	.byte $00 ,<txt_LTKRev         ,>txt_LTKRev         ,<BASIC_LoadAddr ,>BASIC_LoadAddr ,$08 ,$0b
	.byte $00		; end of table
fname_Dir
	.screen "DIR.R"	;9a60
fname_S
	.screen "S.R" ;$9a65
fname_Era
	.screen "ERA.R" ;$9a68
fname_Ship
	.screen "SHIP.R" ;$9a6d
fname_L
	.screen "L.R" ;$9a73
fname_D
	.screen "D.R" ;$9a76
fname_Change
	.screen "CHANGE.R" ;$9a79
fname_Copy
	.screen "COPY.R" ;$9a81
fname_FastCopy
	.screen "FASTCOPY.R" ;$9a87
fname_New
	.screen "NEW.R" ;$9a91
fname_Oops
	.screen "OOPS.R" ;$9a96
fname_Renum
	.screen "RENUM.R" ;$9a9c
fname_Type
	.screen "TYPE.R" ;$9aa3
fname_Dump
	.screen "DUMP.R" ;$9aa9
fname_Del
	.screen "DEL.R" ;$9aaf
fname_Fetch
	.screen "FETCH.R" ;$9ab4
fname_Merge
	.screen "MERGE.R" ;$9abb
fname_LU
	.screen "LU.R" ;$9ac2
fname_Query
	.screen "QUERY.R" ;$9ac6
fname_Config
	.screen "CONFIG.R" ;$9acd
fname_Build
	.screen "BUILD.R" ;$9ad5
fname_Activate
	.screen "ACTIVATE.R" ;$9adc
fname_Autocopy
	.screen "AUTOCOPY.R" ;$9ae6
fname_Autodel
	.screen "AUTODEL.R" ;$9af0
fname_User
	.screen "USER.R" ;$9af9
fname_Clear
	.screen "CLEAR.R" ;9aff
fname_DI
	.screen "DI.R"    ;$9b06
fname_Diag
	.screen "DIAG.R" ;$9b0a
fname_BuildIndex
	.screen "BUILDINDEX.R" ;$9b10
fname_Checksum
	.screen "CHECKSUM.R" ;$9b1c
fname_Automove
	.screen "AUTOMOVE.R" ;$9b26
fname_Recover
	.screen "RECOVER.R" ;$9b30
fname_Validate
	.screen "VALIDATE.R" ;$9b39
fname_BuildCPM
	.screen "BUILDCPM.R" ;$9b43
fname_LKRev
	.screen "LKREV.R" ;$9b4d
fname_Find
	.screen "FIND.R" ;$9b54
fname_LKOff
	.screen "LKOFF.R" ;$9b5a
fname_Exec
	.screen "EXEC.R" ;$9b61
fname_InstallCheck
	.screen "INSTALLCHECK.R" ;$9b67
fname_ICQUB
	.screen "ICQUB.R" ;$9b75
fname_CopyAll_64
	.screen "COPY-ALL.64L.R" ;$9b7c
txt_LTKRev
	.screen "LT. KERNAL REV. 7.2 (12/18/90)" ;$9b8a

;$9ba8
	.byte $00,$00,$00,$00,$00,$00,$00,$00
;9bb0
	.byte $00,$00,$00,$00,$00,$00,$00
L9bb7	.byte $00 
;9bb8
	.byte $00,$00,$00,$00,$00,$00,$00 
