; ****************************
; * 
; * Lieutenant Kernal resource project
; * 
; *             _                                         
; *  ___   ___ | |_  _   _  _ __     __ _  ___  _ __ ___  
; * / __| / _ \| __|| | | || '_ \   / _` |/ __|| '_ ` _ \ 
; * \__ \|  __/| |_ | |_| || |_) |_| (_| |\__ \| | | | | |
; * |___/ \___| \__| \__,_|| .__/(_)\__,_||___/|_| |_| |_|
; *                        |_|                            
; * 
; * Setup is responsible for the actual 'SYSGEN' work
; *  that prepares a new harddisk to run the LtK DOS.
; *
; * While the system supports both c64 and
; *  c128 systems, setup runs exclusively in 64 mode.
; *
; ****************************

; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

; ****************************
; * 
; * Includes
; *
; ****************************

	.include "../../include/kernal.asm"
	.include "../../include/zeropage.asm"
	.include "../../include/ltk_equates.asm"

; ****************************
; * 
; * Local labels
; *
; ****************************

BASIC_LoadAddr	=$0801

	; FIXME: Should we make an ltk_hwequates or add these to the ltk_equates file?
HA_data    =$df00	; SCSI data port: port or ddr
	; Control port bit map for port A (data):
	; bit	use	likelyhood
	; ca1
	; ca2	ACK	90%
HA_data_cr =$df01	; SCSI data port control reg
HA_ctrl    =$df02	; SCSI control port
        ; control port bit map: To be verifed (FIXME etc)
	; bit	use	likelyhood
        ;  0		
        ;  1		
        ;  2	C/D	60%	
        ;  3	BSY	90%
        ;  4	SEL	50%
        ;  5		
        ;  6	ATN	50%
        ;  7	REQ	60%
	; cb1
	; cb2
HA_ctrl_cr =$df03	; SCSI control port control reg

Sec_buf1 =$9c00		; Sector buffer #1
Sec_buf2 =$9e00		; Sector buffer #2

; ****************************
; * 
; * Documentation and notes
; *
; ****************************

; Keep related notes within one remark block
;  separate unrelated note blocks with a blank line.

; * This is the third program in a chain of programs to sysgen a new drive.
;    First, 'b' gets loaded, which loads 'sb2'.  Some interesting stuff in sb2:
; *  sb2 loads setup to $8000, and copies the pointer above at InBufPtr to itself.
;    Then track 18 sector 18 is loaded to that location ($9ba9 originally)
;    After that work is done, setup is started via jmp $8000
; InputBuf ($9ba9) will contain the contents of sector18-18.asm when the program
;  starts.

; SCSI control bits:
; name	location
; ack	ca2
; atn	pb6
; bsy	pb3
; c/d	 
; i/o	
; msg	
; req	pb7
; rst	
; sel	pb4

; ****************************
; * 
; * Program starts here
; *
; ****************************
 
	*=$8000
SETUP_Start
	jmp START

InBufPtr
	;.byte $a9,$9b
	.word InputBuf		; Used by sb2 to determine where to load sector 18,18
L8005	.byte $00
L8006	.byte $00
L8007	.byte $00
L8008	.byte $00
L8009	.byte $00
L800a	.byte $00 


START
	jsr DetectAndRewrite 	; find HA and rewrite this program for $de00 if necessary

	bit Drive0_Flags	; Check for a drive with a built-in controller (this is the case usually)
	bvc L802d		;  Bit6=0: normal drive?  Skip special drive code

	jsr SCSI_Select		; Select scsi 0
	lda #$7f		; ID 7?
	sta HA_data
	lda #$60		; %0110 0000 (FIXME: what's bit 5?)
	sta HA_ctrl		;  do some funkiness to wake a special type fo drive
	ldx #$00
L8022	inx
	bne L8022
L8025	inx
	bne L8025		; delay a bit
	lda #$40		; %0100 0000 - release bit 5
	sta HA_ctrl		; more funkiness...

L802d	bit Drive0_Flags	; bit7=1: Intelligent (modern) drive?
	bmi L8035		;  Yes, skip ahead again
	jsr SCSI_Set_geometry	;  Older controller.  Send drive geometry to the controller

L8035	ldx #$00		; And, we're all set.  Lets use our scsi disk!
	stx LBA_ms
	stx LBA_ls		; SCSI LBA 0 (SYSTEMTRACK sector)
	inx
	stx TransCt		; One sector to transfer
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH		; to sector buffer 1
	jsr SCSI_RD_And_Inc

	lda Sec_buf1+$1e	; check flag in sector 1 offset 1e
	beq L805e		; zero?
	cmp #$ac
	beq L805e		; $ac?
	cmp #$af
	beq L805e		; af? Jump for these
	dec DOS_MISSING		; none of the above, decrement 822a
L805e	lda #$ff
	sta Sec_buf1+$1e	; set flag to FF
	jsr SCSI_WR_And_Inc	; send block back to disk

	ldy #$07		; 8-byte serial number
	ldx #$00		;  unneeded.
L806a	lda Serialno,y		;  get serial number from 18,18
	cmp Sec_buf1+$1f4,y	;  compare with copy from rom?
	bne L8077		;  fail: print warning
	dey
	bpl L806a		;  continue checking
	bmi SerialOK		; success, skip warning and continue.

	;print warning about serial # on drive not matching sysgen disk
L8077	ldx #<str_SNMismatchWarning
	ldy #>str_SNMismatchWarning
	jsr printZTString
	cli
L807f	jsr GETIN
	tax
	beq L807f		; wait for a key
	sei
	cmp #$59		; Y to continue?
	beq SerialNotOk		;  got it, continue

HA_Fail ;$808a
	; We end up here if the host adapter can't be found.
	; Copy a routine to the tape buffer that will
	;  take the host adapter control lines inactive and
	;  reset the system.
	; FIXME: Should this reset stub also take the data 
	;  port offline?

	ldy #$00
L808c	lda Offline_And_Reset,y ;$818f
	sta $033c,y
	beq L8097
	iny
	bne L808c
L8097	jmp $033c	; never to be seen again [offline and reset]


	; All checks have been done at this point.  Let's do some SYSGEN work.
SerialNotOk
	dec lab_8229		; FIXME: apparently not used
	dec DOS_MISSING		; tell SYSGEN the dos isn't there.
	jmp L810a

	; serial number is verified, continuing here.
SerialOK
	lda #<Sec_buf2
	sta BufPtrL
	lda #>Sec_buf2
	sta BufPtrH
	lda #$1a
	sta LBA_ls		; lba=$1a (LuChange gets loaded here eventually)
	jsr SCSI_RD_And_Inc	; read block $1a (luchange) to Buffer 2
	ldx #$00		; .X=0
	lda Sec_buf1+$ad	; perform integrity checks
	cmp #$37
	bne L80c6
	lda Sec_buf1+$ae
	cmp #$2e
	bne L80c6		; (FIXME: These dont check out on lba $1a of six's hdd image)
	dex			; seems ok, x=$ff
L80c6	stx lutable_ok
	txa
	beq L80eb		; was .X 0?

	ldy #$31		; $31 (49) bytes
L80ce	lda Sec_buf2+4,y	; copy from luchange.r+$04 to save on-hdd data
	sta luchange_table,y    ; to our luchnage table
	dey
	bpl L80ce
	; working data for reference from luchange.asm offset 4:
        ;.byte $ff,$00,$1e,$40,$c8,$11,$00,$e6
        ;.byte $40,$c8,$11,$01,$ae,$40,$a6,$11
        ;.repeat $23,$ff	; $23 $ff's follow.


	ldx #$0a		; 9 entries (+1 because zero exits)
	ldy #$00		; init index
L80db	lda L841c,y		;  get byte from L841c
	and #$f7		;  strip high byte
	sta L841c,y		;  put it back
	iny			;  skip one
	iny			;  two
	iny			;  three
	iny			;  four
	iny			;  five bytes
	dex			;  all entries done?
	bne L80db		;  no, loop.
	; 9*6=54 ($36) bytes in the table

	; seems likely that sec buf 1 still has SYSTEMTRACK in it (FIXME)
L80eb	lda #>$9d02		; 29d is the SYSTEMCONFIGFILE sector
	sta LBA_ls
	lda #<$9d02		; the < and > are backwards because SCSI is opposite-endian
	sta LBA_ms
	jsr SCSI_RD_And_Inc	; read LBA $29d (SYSTEMCONFIGFILE) to buffer 2
	ldy #$0f

L80fa	lda Sec_buf2,y		; Check for the system config file's presense
	cmp fname_SystemConfigFile,y
	bne L8107		; Mismatch?  Set the flag at DOS_MISSING and sysgen. 
	dey
	bpl L80fa		; continue checking
	bmi L810a		; perfect match.  Leave flag at DOS_MISSING clear and sysgen.

L8107	dec DOS_MISSING		; tell SYSGEN that the DOS is missing and needs reinstalled.
	;print message "Please Wait, SYSGEN in progress"
L810a
	ldx #<str_SYSGENInProgress
	ldy #>str_SYSGENInProgress
	jsr printZTString
	jsr SYSGEN		; Perform the actual work

	ldx #$00		; set up the final bits
	stx LBA_ms
	stx LBA_ls		; LBA 0 (SYSTEMTRACK)
	inx
	stx TransCt		; one sector
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH		; to buffer 1
	jsr SCSI_RD_And_Inc	; Get the SYSTEMTRACK sector
	ldy #$37
L812f	lda Drive1_Geometry,y	; copy the remaining drives' geometry
	sta Sec_buf1+$100,y	;  to sector offset $100
	dey
	bpl L812f
	lda L8cf5		; copy L8cf5,L8cf6
	sta Sec_buf1+$94
	lda L8cf6		
	sta Sec_buf1+$95	;  to sector offset $94

				; run checksums to check integrity
	ldx #<str_Checksumming	; print "checksumming" message
	ldy #>str_Checksumming
	jsr printZTString
	jsr CHECKSUM		; Checksum the installed system.  Z=1 means ok.
	php			; save status for later
	ldy #$05

L8151	lda L9bb1,y
	sta Sec_buf1+$96,y
	dey
	bpl L8151
	iny
				; copy revision text to the block
L815b	lda txt_LTKRev,y
	beq L8166
	sta Sec_buf1+$9d,y
	iny
	bne L815b
L8166
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH		; Sector buffer 1
	lda #$00
	sta Sec_buf1+$1e	; filesystem clean flag?
	sta LBA_ms
	sta LBA_ls		; LBA 0
	jsr SCSI_WR_And_Inc	; write SYSTEMTRACK sector

	;print message that Initialization is complete...
	ldx #<str_InitComplete
	ldy #>str_InitComplete
	plp
	; or...
	beq L8189		; restore status.  0=ok.

	;print message that checksums did not match
	ldx #<str_CSMismatch
	ldy #>str_CSMismatch

L8189	; either way, the process is done.
	jsr printZTString

Done	jmp Done		; wait for reset.

Offline_And_Reset ; $818f
	; copied to $033c and run on failure.
	; This takes the scsi control bus offline
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

	; first, let's check at DF00 for the LtK hardware (specifically, the PIA)
	ldx #$08	; shift 8 times later
	lda #$01	; set bit 1
	sta HA_data	; the data port
L819f	cmp HA_data	; same?
	bne L81b3	; No, check at de00.
	clc		; 
	rol HA_data	; 
	rol a		; 
	dex		; 
	bne L819f	; Repeat until zero.
	lda #$df	; HA found at $df00.
	bne L8223	;  Return to START [always taken]
L81b0	jmp HA_Fail	;$808a	

	; We didn't find it at DF00, check DE00.
L81b3	ldx #$08	; See description earlier-
	lda #$01	;  this does the same at $de00.
	sta $de00	
L81ba	cmp $de00	
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

			; Here, we check for DF00-DF04 operand.
L81f0	jsr LDA_fb_Yinc ; Got a hit; get operand low byte
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
L820e	clc
 	bcc RewriteLoop	;  and continue searching

L8211	inc $fb		; incremnet high byte
 	bne L8217	;  and ocntinue searching
 	inc $fc		;  fix high byte
L8217	lda $fc		; get high byte
 	cmp #$a0	;  Above our program space?
 	bne RewriteLoop	;  No, continue searching.
 	lda $fb		; Check low byte
 	cmp #$00	
 	bcc RewriteLoop	;  continue searching
L8223	rts		; done rewriting the program.

LDA_fb_Yinc
	; Get a byte via (fb),y and iny.
	lda ($fb),y
 	iny
 	rts

lutable_ok
 	.byte $00
lab_8229
	.byte $00
DOS_MISSING	; flag is nonzero if the dos is determined to be missing.
		; this is checked by simple integreity checks of SYSTEMTRACK,
		; LUCHANGE, and SYSTEMCONFIGFILE sectors.
	.byte $00

	; Checksum routine.  Does checksum work
	;  on the installed system and returns
	;  z=1 if ok.
CHECKSUM
	lda #<Sec_buf2
	sta BufPtrL
	lda #>Sec_buf2
	sta BufPtrH	; buffer #2
	ldx #$01
	stx TransCt	; one sector	
	ldy #$00
L823c	stx LBA_ls
	sty LBA_ms
	jsr SCSI_RD_And_Inc
	lda #<Sec_buf2
	sta $fb
	lda #>Sec_buf2
	sta $fc
	ldy #$00
	ldx #$02
L8251	lda ($fb),y
	pha
	clc
	adc L8005
	sta L8005
	lda #$00
	adc L8006
	sta L8006
	pla
	clc
	adc L8009
	asl a
	sta L8009
	lda L800a
	rol a
	bcc L827a
	inc L8007
	bne L827a
	inc L8008
L827a	sta L800a
	iny
	bne L8251
	inc $fc
	dex
	bne L8251
	ldx LBA_ls
	ldy LBA_ms
	inx
	bne L828f
	iny
L828f	tya
	bne L82a1
	cpx #$1a
	bne L8297
	inx
L8297	cpx #$ee
	bne L82ad
	ldx #$ef
	ldy #$01
	bne L82ad
L82a1	cpy #$02
	bne L82ad
	cpx #$9e
	bne L82ad
	ldx #$2e
	ldy #$03
L82ad	cpy Sec_buf1+$94
	beq L82b5
L82b2	jmp L823c

L82b5	cpx Sec_buf1+$95
	bne L82b2
	ldy #$05
L82bc	lda L9bb1,y
	cmp L8005,y
	bne L82c8
	dey
	bpl L82bc
	iny
L82c8	rts

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
luchange_table ; $841a
	; luchange:$04-$35 gets copied here.  The commented data below is from luchange.asm (DO NOT DECOMMENT)
        ;.byte $ff,$00,$1e,$40,$c8,$11,$00,$e6
        ;.byte $40,$c8,$11,$01,$ae,$40,$a6,$11
        ;.repeat $23,$ff	; $23 $ff's follow.

	.byte $00			; ff
	.byte $00			; 00
	
	;L80db processes these as if they're entries of 6 bytes each, 10 entries.
	;      It strips the high bit of the first byte in each.
L841c	.byte $d0,$d0,$00,$c0,$50,$60	; 1 $1e,$40,$c8,$11,$00,$e6
	.byte $50,$06,$06,$00,$00,$30	; 2 $40,$c8,$11,$01,$ae,$40
	.byte $00,$f0,$00,$00,$00,$00	; 3 $a6,$11,$23,$ff,$ff,$ff
	.byte $06,$66,$06,$00,$60,$00	; 4 $ff,$ff,$ff,$ff,$ff,$ff
	.byte $06,$00,$00,$60,$00,$06	; 5 $ff,$ff,$ff,$ff,$ff,$ff
	.byte $66,$c6,$06,$06,$00,$00	; 6 $ff,$ff,$ff,$ff,$ff,$ff
	.byte $00,$00,$00,$06,$06,$60	; 7 $ff,$ff,$ff,$ff,$ff,$ff
	.byte $00,$f0,$60,$00,$00,$06	; 8 $ff,$ff,$ff,$ff,$ff,$ff
	; when copying data from sector $1a (luchange) during startup, this last entry doesn't get copied.
	.byte $06,$00,$06,$00,$60,$00	; 9

SYSGEN
	lda #$ff
	sta SCSI_RW_IncFlag	; increment LBA after work
	sta L8cf0
	sta SGLF_NoMods		; modify files while loading by default
	ldy Drive0_Heads	; mulitply drive0_heads by...
	ldx #$00
	stx Mul_o2l		; reset low byte of input
	lda Drive0_Sectors	; ...drive0_sectors
	jsr Multiply		; Multiply heads*sectors
	sta L8ce4		; save lsb
	ldy #$00
	sty L963e		; clear divide operand
	ldy #$08
	jsr Divide		; divide
	cpy #$00		; Set flags based on remainder
	clc			; clear carry
	beq L847e		; remainder=0?
	sec			;  No, set carry
L847e	adc #$03		; add 3
	sta L8ce5		;  save to L8ce5
	lda #$00
	sta L963e
	lda #$f8
	ldx #$07
	ldy L8ce4
	jsr Divide
	sta L8cf4
	ldy L8ce5
	ldx #$02
	lda #$00
	sta L963e
	jsr Divide
	sta L8ce6
	jsr Zero_Sec_buf1

	; prepare DISCBITMAP sector
	ldx #$09
L84aa
	lda fname_DiscBitmap,x ;$90d4
	sta Sec_buf1,x		; Copy 'DISCBITMAP' to sector
	dex
	bpl L84aa
	lda L8ce6
	sta Sec_buf1+$13
	lda L8ce5
	sta Sec_buf1+$15
	lda #$02
	sta Sec_buf1+$11
	lda L8cf4
	sta Sec_buf1+$17
	lda #$01
	sta TransCt
	lda #$01
	sta Sec_buf1+$18
	lda L8ce4
	sta Sec_buf1+$19
	ldy L8cf4
L84dd
	lda L8ce4
	clc
	adc Sec_buf1+$92
	sta Sec_buf1+$92
	bcc L84ec
	inc Sec_buf1+$91
L84ec
	dey
 	bne L84dd
 	lda #$ee
 	sta LBA_ls_tmp
 	sta Sec_buf1+$21
 	sta LBA_ls
 	lda #>Sec_buf1
 	sta BufPtrH
 	lda #<Sec_buf1
 	sta BufPtrL
 	lda #$00
 	sta LBA_ms_tmp
 	sta LBA_ms
 	lda #$ff
 	sta Sec_buf1+$96
 	sta Sec_buf1+$97
 	lda #$0a
 	sta Sec_buf1+$1d
 	jsr SCSI_WR_And_Inc
 	lda L8cf4
 	sta L8ce9
L8522
	lda #<Sec_buf1
	sta L8cea
	lda #>Sec_buf1
	sta L8ceb
	lda L8ce6
	sta L8cec
	jsr Zero_Sec_buf1
L8535
	lda L8cea
 	sta staAndIncDest + 1
 	lda L8ceb
 	sta staAndIncDest + 2
 	lda #$00
 	jsr staAndIncDest
 	lda L8ce7
 	jsr staAndIncDest
 	lda L8ce8
 	jsr staAndIncDest
 	clc
 	lda L8cea
 	adc L8ce5
 	sta L8cea
 	bcc L8561
 	inc L8ceb
L8561
	lda L8ce8
	clc
	adc L8ce4
	sta L8ce8
	bcc L8570
	inc L8ce7
L8570
	dec L8ce9
 	beq L8580
 	dec L8cec
 	bne L8535
 	jsr SCSI_WR_And_Inc
 	jmp L8522

L8580
	lda L8ceb
 	sta staAndIncDest + 2
 	lda L8cea
 	sta staAndIncDest + 1
 	lda #$ff
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr staAndIncDest
 	jsr SCSI_WR_And_Inc

	; Prepare SYSTEMTRACK sector
	;  This routine was used to start /doc/block-zero.txt
 	jsr Zero_Sec_buf1	; zero out the sector buffer
 	ldx #$0a		; 10 bytes
L859f	lda fname_SystemTrack,x ; copy 'SYSTEMTRACK' magic string to buf
 	sta Sec_buf1,x
 	dex
 	bpl L859f
 	lda #$ee
 	sta Sec_buf1+$11		; set (FIXME) to $ee
 	lda Drive0_Heads	; get geometry from sector 18,18
 	sta Sec_buf1+$19
 	lda Drive0_CylHi
 	sta Sec_buf1+$16
 	lda Drive0_CylLo
 	sta Sec_buf1+$17		
 	lda #$0a
 	sta Sec_buf1+$1d
 	sta Sec_buf1+$28
 	lda Drive0_Flags
 	sta Sec_buf1+$12
 	lda Drive0_StepPeriod
 	sta Sec_buf1+$13
 	lda Drive0_Unknown
 	sta Sec_buf1+$1a
 	lda Drive0_WPcomp
 	sta Sec_buf1+$15
 	ldx #$01
 	stx Sec_buf1+$18
 	ldy #$07
L85e6
	lda Serialno,y
	sta Sec_buf1+$1f4,y
	dey
	bpl L85e6
	jsr S979e		; read DISCBITMAP sector to 9e00 and copy some data out
	lda #$00
	sta LBA_ms_tmp
	sta LBA_ls_tmp
	sta LBA_ls
	sta LBA_ms		; SCSI LBA 0
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH		; buffer $9c00
	dec Sec_buf1+$2a
	dec Sec_buf1+$1e
	lda Drive0_Sectors	
	sta Sec_buf1+$14	; set sector count
	lda L8cf4
	sta Sec_buf1+$36
	jsr SCSI_WR_And_Inc	; send SYSTEMTRACK sector to disk

	; Clear sectors $01->$ed while skipping sector $1a
	jsr Zero_Sec_buf1	; clear the sector buffer at 9c00 to zero
L8622	inc LBA_ls		; set next sector
	lda LBA_ls
	cmp #$1a		; at sector 1a? (contains the system prompt and some code)
	beq L8622		;  yes, skip this sector
	cmp #$ee		; at sector ee? (DISCBITMAP)
	beq L8636		;  yes, exit the loop
	jsr SCSI_WR_And_Inc	; zero the sector out on disk.
	jmp L8622		; continue until sector $0000ed

L8636
	lda #$01
	sta LBA_ms
	lda #$ef
	sta LBA_ls		; start at sector $01ef
	lda #$02
	sta SCSI_MultiWrite_Last_ms
	lda #$9d
	sta SCSI_MultiWrite_Last_ls	; end at sector $029d
	jsr SCSI_MultiWrite	; Fill them all with zeros.
	lda #$02
	sta LBA_ms
	lda #$ae
	sta LBA_ls		; start at sector 2ae
	lda #$05
	sta SCSI_MultiWrite_Last_ms
	lda #$00
	sta SCSI_MultiWrite_Last_ls	; end at sector 500
	jsr SCSI_MultiWrite	; Fill them all with zeros.

	lda #$00
	sta SGLF_NoMods		; Don't modify these files while loading
	lda #$07		;7 scsi blocks (14 pages, 3584 bytes)
	sta TransCt
	lda #$01
	ldx #<fname_LtKernal	; 3168 bytes
	ldy #>fname_LtKernal
	jsr sg_LoadFile
	lda #$08
	ldx #<fname_LtKrn128 	; 3377 bytes
	ldy #>fname_LtKrn128
	jsr sg_LoadFile
	lda #$ff
	sta SGLF_NoMods		; Modify these files while loading
	lda #$01
	sta TransCt
	lda #>Sec_buf1
	sta BufPtrH
	lda #<Sec_buf1
	sta BufPtrL
	lda #$ee
	sta LBA_ls
	jsr SCSI_RD_And_Inc
	jsr S979e

	jsr Zero_Sec_buf1
	ldx #$0a
L86a4	lda fname_SystemIndex,x ;$L90e9
	sta Sec_buf1,x
	dex
	bpl L86a4
	lda #$ff
	sta L8ced
	sta Sec_buf1+$11
	ldx #$01
	stx Sec_buf1+$18
	jsr S979e
	lda #$f0
	sta LBA_ls
	sta LBA_ls_tmp
	lda #$00
	sta LBA_ms
	sta LBA_ms_tmp
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH
	lda #$0a
	sta Sec_buf1+$1d
	jsr SCSI_WR_And_Inc
	dec L8ced
	lda #$10
	sta L8cee

	jsr Zero_Sec_buf1
	lda #<Sec_buf1+$1d
	sta L86f8 + 1
	lda #>Sec_buf1
	sta L86f8 + 2
L86f4	ldx #$03
	lda #$ff
L86f8	sta L86f8
	inc L86f8 + 1
	bne L8703
	inc L86f8 + 2
L8703	dex
	bne L86f8
	clc
	lda L86f8 + 1
	adc #$1d
	sta L86f8 + 1
	bcc L8714
	inc L86f8 + 2
L8714	dec L8cee
	bne L86f4
L8719	jsr SCSI_WR_And_Inc
	dec L8ced
	bne L8719
	lda #$00
	sta SCSI_RW_IncFlag 	; don't increment LBA after work

	jsr Zero_Sec_buf1
	ldy #$0f
L872b	lda fname_Fastcopy_Modules,y ;$9104
	sta Sec_buf1,y
	dey
	bpl L872b
	lda #$ae
	sta Sec_buf1+$11
	lda #$01
	sta Sec_buf1+$18
	jsr S979e
	lda Sec_buf1+$20
	sta LBA_ms
	sta SAS_ms
	lda Sec_buf1+$21
	sta LBA_ls
	sta SAS_ls
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH
	lda #$0a
	sta Sec_buf1+$1d
	jsr SCSI_WR_And_Inc
	jsr S8c4c

	jsr Zero_Sec_buf1
	ldy #$0f
L876d	lda fname_SystemConfigFile,y ;$90f4
	sta Sec_buf1,y
	dey
	bpl L876d
	lda #$c8
	sta Sec_buf1+$11
	lda #$01
	sta Sec_buf1+$18
	jsr S979e
	lda Sec_buf1+$20
	sta LBA_ms
	lda Sec_buf1+$21
	sta LBA_ls
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH
	lda #$0a
	sta Sec_buf1+$1d
	jsr SCSI_WR_And_Inc
	jsr S8c4c
	lda #$00
	jsr S8c44
	beq L87ae
	jmp Break

L87ae	lda #$ee
	jsr S8c44
	beq L87b8
	jmp Break

L87b8	lda #$f0
	jsr S8c44
	beq L87c2
	jmp Break

L87c2	lda #$00
	sta L8cf0
	lda #$01
	sta TransCt		; one sector (2 pages, 512 bytes)
	
	lda #$11		; Sector for file start
	ldx #<fname_Findfile	; 147 bytes
	ldy #>fname_Findfile
	jsr sg_LoadFile
	
	lda #$20		; Sector for file start
	ldx #<fname_FindFil2	; 319 bytes
	ldy #>fname_FindFil2
	jsr sg_LoadFile
	
	lda #$12		; Sector for file start
	ldx #<fname_LoadRand	; 457 bytes
	ldy #>fname_LoadRand
	jsr sg_LoadFile
	
	lda #$26		; Sector for file start
	ldx #<fname_LoadRnd2	; 498 bytes
	ldy #>fname_LoadRnd2
	jsr sg_LoadFile
	
	lda #$27		; Sector for file start
	ldx #<fname_LoadRnd3	; 477 bytes
	ldy #>fname_LoadRnd3
	jsr sg_LoadFile
	
	lda #$13		; Sector for file start
	ldx #<fname_ErrorHan	; 500 bytes
	ldy #>fname_ErrorHan
	jsr sg_LoadFile
	
	lda #$14		; Sector for file start
	ldx #<fname_LoadCntg	; 392 bytes
	ldy #>fname_LoadCntg
	jsr sg_LoadFile
	
	lda #$15		; Sector for file start
	ldx #<fname_AlocAtRn	;  513 bytes (halp, oversized file)
	ldy #>fname_AlocAtRn
	jsr sg_LoadFile
	
	lda #$16		; Sector for file start
	ldx #<fname_AlocAtCn	;  509 bytes
	ldy #>fname_AlocAtCn
	jsr sg_LoadFile
	
	lda #$17		; Sector for file start
	ldx #<fname_AppendRn	; 499 bytes
	ldy #>fname_AppendRn
	jsr sg_LoadFile
	
	lda #$18		; Sector for file start
	ldx #<fname_DealocRn	; 500 bytes
	ldy #>fname_DealocRn
	jsr sg_LoadFile
	
	lda #$19		; Sector for file start
	ldx #<fname_DealocCn	; 479 bytes
	ldy #>fname_DealocCn
	jsr sg_LoadFile
	
	lda #$1a		; Sector for file start
	ldx #<fname_LuChange 	; 212 bytes
	ldy #>fname_LuChange
	jsr sg_LoadFile
	
	lda #$1b		; Sector for file start
	ldx #<fname_AlocExRn 	; 482 bytes
	ldy #>fname_AlocExRn
	jsr sg_LoadFile
	
	lda #$1c		; Sector for file start
	ldx #<fname_ExpnRand	; 416 bytes
	ldy #>fname_ExpnRand
	jsr sg_LoadFile
	
	lda #$1d		; Sector for file start
	ldx #<fname_ApndExRn	; 502 bytes
	ldy #>fname_ApndExRn
	jsr sg_LoadFile
	
	lda #$1e		; Sector for file start
	ldx #<fname_DealExRn	; 512 bytes
	ldy #>fname_DealExRn
	jsr sg_LoadFile
	
	lda #$21		; Sector for file start
	ldx #<fname_CreditsB	; 485 bytes
	ldy #>fname_CreditsB
	jsr sg_LoadFile
	
	lda #$22		; Sector for file start
	ldx #<fname_ScraMidn	; 278 bytes
	ldy #>fname_ScraMidn
	jsr sg_LoadFile
	
	lda #$23		; Sector for file start
	ldx #<fname_SubCallr	; 424 bytes
	ldy #>fname_SubCallr
	jsr sg_LoadFile
	
	lda #$25		; Sector for file start
	ldx #<fname_SubCl128	; 495 bytes
	ldy #>fname_SubCl128
	jsr sg_LoadFile
	
	lda #$24		; Sector for file start
	ldx #<fname_CatalogR	; 304 bytes
	ldy #>fname_CatalogR
	jsr sg_LoadFile
	
	lda #$1f		; Sector for file start
	ldx #<fname_AdjIndex	; 470 bytes
	ldy #>fname_AdjIndex
	jsr sg_LoadFile
	
	lda #$28		; Sector for file start
	ldx #<fname_ConvrtIO	; 260 bytes
	ldy #>fname_ConvrtIO
	jsr sg_LoadFile
	
	lda #$29		; Sector for file start
	ldx #<fname_FileProt	; 147 bytes
	ldy #>fname_FileProt
	jsr sg_LoadFile
	
	lda #$2a		; Sector for file start
	ldx #<fname_GoCPMode	; 503 bytes
	ldy #>fname_GoCPMode
	jsr sg_LoadFile
	
	lda #$2f		; Sector for file start
	ldx #<fname_AltSerch	; 367 bytes
	ldy #>fname_AltSerch
	jsr sg_LoadFile
	
	lda #$00
	sta SGLF_NoMods		; send these files unmodified
	lda #$04
	sta TransCt		; 4 sectors (8 pages, 2048 bytes)
	
	lda #$44		; Sector for file start
	ldx #<fname_RelaExpn	; 1230  bytes
	ldy #>fname_RelaExpn
	jsr sg_LoadFile
	
	lda #$48		; Sector for file start
	ldx #<fname_OpenRela	; 371 bytes
	ldy #>fname_OpenRela
	jsr sg_LoadFile
	
	lda #$4c		; Sector for file start
	ldx #<fname_DosOvrly	; 1510 bytes
	ldy #>fname_DosOvrly
	jsr sg_LoadFile
	
	lda #$9a		; Sector for file start
	ldx #<fname_DosOv128	; 1406 bytes
	ldy #>fname_DosOv128
	jsr sg_LoadFile
	
	lda #$50		; Sector for file start
	ldx #<fname_OpenFile	; 1506 bytes
	ldy #>fname_OpenFile
	jsr sg_LoadFile
	
	lda #$9e		; Sector for file start
	ldx #<fname_OpenF128	; 1530 bytes
	ldy #>fname_OpenF128
	jsr sg_LoadFile
	
	lda #$54		; Sector for file start
	ldx #<fname_CloseFil	; 786 bytes
	ldy #>fname_CloseFil
	jsr sg_LoadFile
	
	lda #$a2		; Sector for file start
	ldx #<fname_Close128	; 797 bytes
	ldy #>fname_Close128
	jsr sg_LoadFile
	
	lda #$58		; Sector for file start
	ldx #<fname_SaveToDv	; 1972 bytes
	ldy #>fname_SaveToDv
	jsr sg_LoadFile
	
	lda #$5c		; Sector for file start
	ldx #<fname_CmndChn1	; 1536 bytes
	ldy #>fname_CmndChn1
	jsr sg_LoadFile
	
	lda #$ca		; Sector for file start
	ldx #<fname_CmndChn2	; 1752 bytes
	ldy #>fname_CmndChn2
	jsr sg_LoadFile
	
	lda #$60		; Sector for file start
	ldx #<fname_Directry	; 1531 bytes
	ldy #>fname_Directry
	jsr sg_LoadFile
	
	lda #$08
	sta TransCt		; 8 sectors (16 pages, 4096 bytes)

	lda #$3b		; Sector for file start
	ldx #<fname_ConfigLU	; 3341 bytes
	ldy #>fname_ConfigLU
	jsr sg_LoadFile

	lda #$08
	sta TransCt		; 8 sectors (16 pages, 4096 bytes)
	
	lda #$e6		; Sector for file start
	ldx #<fname_MessFile	; 4098 bytes
	ldy #>fname_MessFile
	jsr sg_LoadFile
	
	lda #$04
	sta TransCt		; 4 sectors (8 pages, 2048 bytes)
	
	lda #$6a		; Sector for file start
	ldx #<fname_CommLoad	; 458 bytes
	ldy #>fname_CommLoad
	jsr sg_LoadFile
	
	lda #$ce		; Sector for file start
	ldx #<fname_IndxMod0	; 1236  bytes
	ldy #>fname_IndxMod0
	jsr sg_LoadFile
	
	lda #$7e		; Sector for file start
	ldx #<fname_IndxMod1	; 1496 bytes
	ldy #>fname_IndxMod1
	jsr sg_LoadFile
	
	lda #$82		; Sector for file start
	ldx #<fname_IndxMod2	; 1119 bytes
	ldy #>fname_IndxMod2
	jsr sg_LoadFile
	
	lda #$86		; Sector for file start
	ldx #<fname_IndxMod3	; 566 bytes
	ldy #>fname_IndxMod3
	jsr sg_LoadFile
	
	lda #$8a		; Sector for file start
	ldx #<fname_IndxMod4	; 645 bytes
	ldy #>fname_IndxMod4
	jsr sg_LoadFile
	
	lda #$8e		; Sector for file start
	ldx #<fname_IndxMod5	; 658 bytes
	ldy #>fname_IndxMod5
	jsr sg_LoadFile
	
	lda #$92		; Sector for file start
	ldx #<fname_IndxMod6	; 658 bytes
	ldy #>fname_IndxMod6
	jsr sg_LoadFile
	
	lda #$96		; Sector for file start
	ldx #<fname_IndxMod7	; 1382 bytes
	ldy #>fname_IndxMod7
	jsr sg_LoadFile
	
	lda #$d2		; Sector for file start
	ldx #<fname_IdxM0128	; 1266 bytes
	ldy #>fname_IdxM0128
	jsr sg_LoadFile
	
	lda #$a6		; Sector for file start
	ldx #<fname_IdxM1128	; 1511 bytes
	ldy #>fname_IdxM1128
	jsr sg_LoadFile
	
	lda #$aa		; Sector for file start
	ldx #<fname_IdxM2128	; 1149 bytes
	ldy #>fname_IdxM2128
	jsr sg_LoadFile
	
	lda #$ae		; Sector for file start
	ldx #<fname_IdxM3128	; 621 bytes
	ldy #>fname_IdxM3128
	jsr sg_LoadFile
	
	lda #$b2		; Sector for file start
	ldx #<fname_IdxM4128	; 697 bytes
	ldy #>fname_IdxM4128
	jsr sg_LoadFile
	
	lda #$b6		; Sector for file start
	ldx #<fname_IdxM5128	; 710 bytes
	ldy #>fname_IdxM5128
	jsr sg_LoadFile
	
	lda #$ba		; Sector for file start
	ldx #<fname_IdxM6128	; 710 bytes
	ldy #>fname_IdxM6128
	jsr sg_LoadFile
	
	lda #$be		; Sector for file start
	ldx #<fname_IdxM7128	; 1397 bytes
	ldy #>fname_IdxM7128
	jsr sg_LoadFile
	
	lda #$02
	sta TransCt		; 2 sectors (4 pages, 512 bytes)
	
	lda #$0f		; Sector for file start
	ldx #<fname_SysBootR	; 977 bytes
	ldy #>fname_SysBootR
	jsr sg_LoadFile
	
	lda #$31		; Sector for file start
	ldx #<fname_SysBt128 	; 1025 bytes
	ldy #>fname_SysBt128
	jsr sg_LoadFile
	
	lda #$04
	sta TransCt		; 4 sectors (8 pages, 2048 bytes)
	
	lda #$c6		; Sector for file start
	ldx #<fname_InitC128	; 1191 bytes
	ldy #>fname_InitC128
	jsr sg_LoadFile
	
	lda #$64		; Sector for file start
	ldx #<fname_InitC064	; 831 bytes
	ldy #>fname_InitC064
	jsr sg_LoadFile
	
	lda #$02
	sta TransCt		; 2 sectors (4 pages, 1024 bytes)
	
	lda #$2d		; Sector for file start
	ldx #<fname_Go64Boot	; 503 bytes
	ldy #>fname_Go64Boot
	jsr sg_LoadFile
	
	lda #$72		; Sector for file start
	ldx #<fname_OpenRand	; 305 bytes
	ldy #>fname_OpenRand
	jsr sg_LoadFile
	
	lda #$01
	sta TransCt		; one sector (2 pages, 512 bytes)
	
	lda #$c2		; Sector for file start
	ldx #<fname_AutoUpdt	; 365 bytes
	ldy #>fname_AutoUpdt
	jsr sg_LoadFile
	
	; all sg_LoadFile commands are finished. 

	lda #$01
	jsr SCSI_Advance_sectors
	lda #$0c		; transfer count ($c=12, 6144 bytes)
	ldx #<fname_FastFDos	; 6146 bytes
	ldy #>fname_FastFDos
	jsr sg_LoadFile2
	
	lda #$0d
	jsr SCSI_Advance_sectors
	lda #$0c		; sector count
	ldx #<fname_FastFD81	; 6146 bytes
	ldy #>fname_FastFD81
	jsr sg_LoadFile2

	lda #$19
	jsr SCSI_Advance_sectors
	lda #$08		; sector count
	ldx #<fname_FastCpy1	; 2619 bytes
	ldy #>fname_FastCpy1
	jsr sg_LoadFile2

	lda #$21
	jsr SCSI_Advance_sectors
	lda #$08		; sector count
	ldx #<fname_FastCp1a	; 2608 bytes
	ldy #>fname_FastCp1a
	jsr sg_LoadFile2

	lda #$29
	jsr SCSI_Advance_sectors
	lda #$08		; sector count
	ldx #<fname_FastCpy2	; 2784 bytes
	ldy #>fname_FastCpy2
	jsr sg_LoadFile2

	lda #$31
	jsr SCSI_Advance_sectors
	lda #$08		; sector count
	ldx #<fname_FastCp2a	; 3159 bytes
	ldy #>fname_FastCp2a
	jsr sg_LoadFile2

	lda #$39
	jsr SCSI_Advance_sectors
	lda #$08		; sector count
	ldx #<fname_FastCpDD	; 2426 bytes
	ldy #>fname_FastCpDD
	jsr sg_LoadFile2

	lda #$a3
	jsr SCSI_Advance_sectors
	lda #$0a		; sector count
	ldx #<fname_FastCpRm	; 5031 bytes
	ldy #>fname_FastCpRm
	jsr sg_LoadFile2

	lda #$ad
	jsr SCSI_Advance_sectors
	lda #$01		; sector count
	ldx #<fname_FastCpQD	; 260 bytes
	ldy #>fname_FastCpQD
	jsr sg_LoadFile2
	
	lda #<fname_ptr_table_2
	sta ReadTable + 1
	lda #>fname_ptr_table_2		; sector count
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
	jsr Zero_801_7601; clear some memory
	cli
	lda #$00	; .A=0 -> LOAD
	jsr LOAD	; load "fname",8,1
	bcc L8af7	; continue if no error
	jmp Break2

L8af7	sei
	jsr Zero_Sec_buf1
	ldx len_fname	; get file name length
	dex
	dex		; cut '.R' off the end
	ldy #$00
L8b01	lda (ptr_fname),y ; copy filename 
	sta Sec_buf1,y	;  to 9c00
	sta $c000,y	;  and c000
	iny
	dex
	bne L8b01
	lda #$00
	sta $c000,y	; zero-terminate c000 copy
	lda #$0a
	sta Sec_buf1+$1d
	jsr ReadTable	; Load address low
	sta Sec_buf1+$1b
	jsr ReadTable	; Load address high
	sta Sec_buf1+$1a
	jsr ReadTable	; field #6: unknown
	sta Sec_buf1+$11
	jsr ReadTable	; field #7: unknown
	sta Sec_buf1+$18
	cmp #$03
	bne L8b38
	lda #$c0
	sta Sec_buf1+$12
L8b38	jsr S9179
	beq LoadFromTable

Break	brk

Break2	brk

S8ad0_return
	rts

L8b40	ldx #<str_Flip_Disk
	ldy #>str_Flip_Disk
	jsr printZTString

	cli
L8b48	jsr GETIN
	tax
	beq L8b48 ; wait for a key to be pressed
	cmp #$0d
	bne L8b40 ; not return? Repeat the prompt.

	ldx #<str_Thankyou_Continuing
	ldy #>str_Thankyou_Continuing
	jsr printZTString

	lda #$10
	sta TransCt
	lda #$d6
	ldx #<fname_CP_MBoot
	ldy #>fname_CP_MBoot
	jsr sg_LoadFile

	lda #$2e
	sta LBA_ls
	lda #$03
	sta LBA_ms
	lda #$37
	ldx #<fname_MasterCF
	ldy #>fname_MasterCF
	jsr sg_LoadFile2

	lda #$33
	sta LBA_ls
	lda #$00
	sta LBA_ms
	lda #$08
	ldx #<fname_ConfigCl
	ldy #>fname_ConfigCl
	jsr sg_LoadFile2

	lda DOS_MISSING		; missing DOS?
	beq L8ba5		;  no, skip ahead
	lda #$9e
	sta LBA_ls
	lda #$02
	sta LBA_ms		; LBA $29e
	lda #$10		; 10 sectors
	ldx #<fname_Defaults
	ldy #>fname_Defaults	; defaults file
	jsr sg_LoadFile2

L8ba5
	lda #<fname_ptr_table_3
	sta ReadTable + 1
	lda #>fname_ptr_table_3
	sta ReadTable + 2
	jsr LoadFromTable
	ldx #$00
	stx LBA_ms
	inx
	stx TransCt
	lda #$ee
	sta LBA_ls
	lda #$00
	sta BufPtrL
	lda #$9e
	sta BufPtrH
	jsr SCSI_RD_And_Inc
	lda Sec_buf2+$94
	sta L8cf5
	lda Sec_buf2+$95
	sta L8cf6
	lda #<fname_ptr_table_4
	sta ReadTable + 1
	lda #>fname_ptr_table_4
	sta ReadTable + 2
	jsr LoadFromTable
	rts

SCSI_Advance_sectors
	ldx SAS_ms		; Get High byte
	clc
	adc SAS_ls		; Add .A to Low byte
	bcc L8bf1		; skip inx if carry clear
	inx			;  if carry increment high byte
L8bf1	stx LBA_ms		; Copy SAS_ms to sector address
	sta LBA_ls
	rts			; return

sg_LoadFile2 ;$8bf8 ;Obviously needs a better name
	sta TransCt		; set scsi transfer count
	stx ptr_fname		; 
	sty ptr_fname+1		; Set filename for kernal
	jsr Zero_1000_2xA	; clear space for file to zero
	lda #$0a		; all file names are $a (10) bytes long
	sta len_fname		; 
	lda #$08		; device 8
	sta $ba			; 
	lda #$00		; sa 0
	sta $b9			; 
	ldx #$00		; 
	ldy #$10		; load to $1000
	cli			; 
	lda #$00		; a=0=load to specified address
	jsr LOAD		; LOAD ptr_fname,8 to $1000
L8c18	bcs L8c18		;  didn't load?  Lets fail ever so elegantly.
	lda #$10		; 
	sta BufPtrH		; 
	lda #$00		; 
	sta BufPtrL		; Buffer set to $1000
	jsr SCSI_WRITE		; Write to disk for .A sectors
	rts			; 

	; SCSI_MultiWrite:
	; Writes sectors from the current LBA (LBA_Ms:LBA_Ls) to
	;  the caller's specified end sector (
SCSI_MultiWrite
	jsr SCSI_WRITE		; write current sector
L8c2b	bcs L8c2b		;  exit on error
	inc LBA_ls		; Incerement to next sector
	bne L8c35
	inc LBA_ms		;  optionally correct for overflow
L8c35	lda LBA_ls		; get current sector
SCSI_MultiWrite_Last_ls	=*+1	;  (parameter from caller)
	cmp #$00		;  does it match caller's request?
	bne SCSI_MultiWrite	;   no, loop.
	lda LBA_ms		;  continue checking sector
SCSI_MultiWrite_Last_ms	=*+1	;  (parameter from caller)
	cmp #$00		;  does it match caller's request?
	bne SCSI_MultiWrite	;   no, loop
	rts			; all done, return.

S8c44	sta LBA_ls
	lda #$00
	sta LBA_ms
S8c4c	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH
	lda #$01
	sta TransCt
	jsr SCSI_RD_And_Inc
	ldy #$10
L8c60	lda Sec_buf1,y
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
	sta Sec_buf1
	inc staAndIncDest + 1
	bne said_done
	inc staAndIncDest + 2
said_done
	rts

	
; ****************************
; * 
; * SCSI_RD_And_Inc: Read a sector from scsi and optionally increment LBA value
; * SCSI_WR_And_Inc: Write a sector to scsi and optionally increment LBA value
; * 
; * Inputs:
; * 	SCSI_RW_IncFlag	Flag to increment (nonzero) or hold (zero) the LBA after transaction
; * 	TransCt:	Number of sectors to write
; * 	LBA_*:		Logical block address
; * 	
; * 	
; * 	
; * 	

SCSI_RD_And_Inc			;$8c96 - label added to improve readability
	jsr SCSI_READ		; Perform the scsi read
	bcc SCSI_RW_Go		; was ok?  Recycle code below
	bcs SCSI_RD_And_Inc	; nope, retry until success.
	.byte $c0		; This never gets executed

SCSI_WR_And_Inc			; $8c9e- label added to improve code readability
S8c9e	jsr SCSI_WRITE		;$8c9e- label is for readability also.
	bcc SCSI_RW_Go		; write complete?  Proceed
	jsr $c000		; apparently there's an error handler loaded to $c000
SCSI_RW_Go
	lda SCSI_RW_IncFlag	;Read or write is successful.  Let's check to see if LBA needs updated
	beq L8cbf		; No.  Return
	inc LBA_ls_tmp		;increment LBA_ls_tmp
	bne L8cb3		; no overflow, proceed
	inc LBA_ms_tmp		;increment LBA_ms_tmp
L8cb3	lda LBA_ls_tmp		;get LBA_ls_tmp
	sta LBA_ls		; copy to LBA_ls
	lda LBA_ms_tmp		;get LBA_ms_tmp
	sta LBA_ms		; copy to LBA_ms
L8cbf	rts			;return

Zero_1000_2xA ; $8cc0
	; clear from $1000 to 2x .A and return
	;  Presets some alternates and jumps into
	;  Zero_801_7601 below
	asl a		; multiply .A*2 pages
	tax		; save for byte count
	lda #$00
	sta $fb
	lda #$10
	sta $fc		;start at $1000
	bne L8cd6	; always taken (lda #$10)

Zero_801_7601; $8ccc	; $0801+$6e00=$7601
	lda #<$0801	; clear memory?
	sta $fb
	lda #>$0801
	sta $fc		; start at $0801
	ldx #$6e	; count 110 pages
L8cd6	ldy #$00	;  clear index
	tya		;  clear .A
L8cd9	sta ($fb),y	;   zero memory
	iny		;   increment index
	bne L8cd9	;   256 bytes
	inc $fc		;  increment high byte
	dex		;  decrement page count
	bne L8cd9	; repeat until none left to do
	rts

L8ce4	.byte $00
L8ce5	.byte $00
L8ce6	.byte $00
L8ce7	.byte $00
L8ce8	.byte $00
L8ce9	.byte $00
L8cea	.byte $00
L8ceb	.byte $00
L8cec	.byte $00
L8ced	.byte $00
L8cee	.byte $00
SCSI_RW_IncFlag	.byte $00	; used by SCSI_[RD|WR]_And_Inc to determine if the target LBA should be incremented.
L8cf0	.byte $00
SGLF_NoMods	.byte $00	; used as a flag (either set $ff or $00)
SAS_ms	.byte $00
SAS_ls	.byte $00
L8cf4	.byte $00
L8cf5	.byte $00
L8cf6	.byte $00 

Zero_Sec_buf1 ; $8cf7
	lda #$00
	tay
L8cfa	sta Sec_buf1,y ; clear 9c00-9cff
	iny
	bne L8cfa
L8d00	sta Sec_buf1+$100,y ; clear 9d00-9dff
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


; ****************************
; * 
; * sg_loadfile:  Load a file into memory and write to LU 10
; * 
; * Inputs:
; * 	SGLF_NoMods:	Special edit flag (FIXME: not understood)
; * 	TransCt:	Number of sectors to write for this file
; * 	A register:	Starting LBA of the file to be loaded
; * 			Two special cases for .A:
; * 			$1a for luachange.r
; * 			$22 for scramidn.r
; * 	X register:	Low byte of address to filename
; * 	Y register:	High byte of address to filename
; * 
; * Because SCSI_WRITE will send data until the target says to stop,
; *  an arbitrary number of sequential sectors can be sent to it.
; * sg_LoadFile takes advantage of this to write files to the drive with ease.

sg_LoadFile ;$8d15
	sta LBA_ls		;Save .A for later (restored in sg_LoadFileSuccess)
	stx ptr_fname		;stash addr of filename to $bb as if SETNAM was called
	sty ptr_fname+1
	lda TransCt		;Get expected file size
	jsr Zero_1000_2xA	; clear memory before loading
	lda #$0a
	sta len_fname		;filename length is 10 for all of the files this routine handles
	lda #$08		; drive 8
	sta $ba
	lda #$00		
	sta $b9			; SA 0 (load to specified address)
	ldx #$00
	ldy #$10		;load address is $1000
	cli
	lda #$00
	jsr LOAD		;LOAD "fname",8 to $1000
	bcc sg_LoadFileSuccess	; all good, continue
	jmp Break2		; something broke.  Instead of telling the user lets just drop out.

sg_LoadFileSuccess		; we have the file in memory, now put it in the LtK filesystem.
	lda #$10
	sta BufPtrH
	sta $f8
	ldx #$00
	stx BufPtrL
	stx $f7			; start sending data from $1000
	stx LBA_ms
	lda SGLF_NoMods		; get special-case flag
	beq SGLF_1		;  flag clear. Skip store 0 to $11ff

	stx $11ff		; Store 0 at program offset $1ff
SGLF_1	sei
	lda SGLF_NoMods		; get special-case flag
	beq SGLF_W		;  zero: just write the file to disk
	lda LBA_ls		; restore .A to find out what file we're processing

	cmp #$1a		;  check .A ($1a = fnam_LuChange)
	bne L8d75		;   no match, skip to next check
	; special handling for luchange.r is done here.
	lda lutable_ok		; get flag from lutable_ok (FIXME: whats this)
	beq L8d8e		;  zero? skip all this work
	ldy #$31		; start at $844b
L8d6a	lda luchange_table,y	;  copy from our luchange table
	sta $1004,y
	dey			;  to luchange's data block
	bpl L8d6a		;  and continue
	bmi L8d8e		; Skip around handling scramidn.r

L8d75	cmp #$22		;check .A ($22 = fname_ScraMidn)
	bne L8d8e		; no match, skip to writing the file to disk.
	; special handling of scramidn.r is done here.
	jsr $1000		; call it.
	ldy #$00		; init index
	; FIXME:  Will need to correctly disassemble and comment scramidn.asm 
	;  to decypher the rest of this segment.  It's likely that scramidn
	;  modifies itself when called.
L8d7e	lda $1000,y		; Get count of bytes to change
	tax			;  Store in counter
	lda #$ea		; NOP
	sta $1000,y		;  replace the byte in the file 
	iny			;  point to next byte
	inx			;  increment counter
	bne L8d7e		;  more to do?
	stx $11ff		; x is zero now

	; all optional file handling has been done.  Lets check some integrity (FIXME: right?)
L8d8e	lda #$00		; Seed our checksum with a 0
	tay			;  clear index
	ldx #$02		;  Checksum first two pages

L8d93	clc			;   no overflows please
	adc ($f7),y		;    sum up next byte
	iny
	bne L8d93		;    for 256 bytes
	inc $f8			;   increment pointer high byte
	dex			;   enough pages done?
	bne L8d93		;    no, loop
	sta $11ff		;  store result in magic spot
	sec			;  prep for subtract
	lda LBA_ls		;  Restore original .A from caller
	sbc $11ff		;   subtract sector location of file (lowbyte)
	sta $11ff		;   and save
SGLF_W	jsr SCSI_WRITE		;  write scsi sector(s) to disk starting at LBA_ls
	bcc L8db3		;   ok? return.
	jsr $c000		; jump to error handler at $c000
L8db3	rts			; file's on disk now.  Return to caller

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
	
fname_LtKernal ;$8e40
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

L9181	sta L9493
	lda L8cf0
	bne L9191
	jsr S979e
	bcc L9191
	jsr $c000		; jump to error handler at $c000
L9191	lda #<Sec_buf2
	sta BufPtrL
	sta L9446
	lda #>Sec_buf2
	sta BufPtrH
	sta L9445
	lda LBA_ls_tmp
	sta LBA_ls
	lda L95a1
	sta LBA_ms
	ldx #$01
	stx TransCt
	jsr SCSI_READ
	bcc L91ba
	jsr $c000		; jump to error handler at $c000
L91ba	lda #$10
	sta L9492
	lda #$00
	sta L9442
	sta L9443
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

L9209	lda L9442
	beq L923c
	lda L95a1
	ldx LBA_ls_tmp
	cmp L9440
	bne L921e
	cpx L9441
	beq L922d
L921e	sta LBA_ms
	sta L95a1
	stx LBA_ls
	stx LBA_ls_tmp
	jsr SCSI_RD_And_Inc
L922d	lda L943e
	sta L9445
	lda L943f
	sta L9446
	jsr S944d
L923c	lda L9446
	sta L924e
	lda L9445
	sta L924e+1
	ldy #$0f
L924a	lda Sec_buf1,y
L924e	=*+1		; operand is the target
L924d	sta L924d,y	; This likely never overwrites itself.  It's done to satisfy the assembler.
	dey		
	bpl L924a	
	lda #$00	
	jsr S947a	
	lda Sec_buf1+$20	
	jsr S947a	
	lda Sec_buf1+$21	
	jsr S947a	
	lda L9445	
	sta Store_iny + 2
	lda L9446
	sta Store_iny + 1	;set address
	ldy #$10		;and offset
	lda Sec_buf1+$10
	jsr Store_iny
	lda Sec_buf1+$11
	jsr Store_iny
	lda Sec_buf1+$14
	jsr Store_iny
	lda Sec_buf1+$15
	jsr Store_iny
	lda Sec_buf1+$16
	jsr Store_iny
	lda Sec_buf1+$17
	jsr Store_iny
	lda Sec_buf1+$18
	jsr Store_iny
	lda Sec_buf1+$1a
	jsr Store_iny
	lda Sec_buf1+$1b
	jsr Store_iny
	lda #$0a
	jsr Store_iny
	inc Sec_buf2+$1c
	jsr S8c9e
	lda Sec_buf2+$1c
	cmp #$01
	bne L92c4
	lda #$ff
	jsr S92e9
	beq L92c4
	jmp $c000

L92c4	lda L8cf0
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

Store_iny
	sta Store_iny,y		;operand modified before call
	iny
	rts

S92e9	sta L9306
	lda #$f0
	sta LBA_ls
	lda #$00
	sta LBA_ms
	jsr SCSI_RD_And_Inc
	ldy L95a3
	lda L9306
	sta Sec_buf2+$22,y
	jsr S8c9e
	rts

L9306	.byte $00 
L9307	lda L9445
	sta L943e
	lda L9446
	sta L943f
	lda L95a1
	sta L9440
	lda LBA_ls_tmp
	sta L9441
	lda #$ff
	sta L9442
	jmp L91e8

S9327	lda #$00
	sta L9449
	sta L944a
L932f	lda L944a
	asl a
	tax
	lda Sec_buf1+$20,x
	sta LBA_ms
	sta L95a1
	lda Sec_buf1+$21,x
	sta LBA_ls
	sta LBA_ls_tmp
	lda L9443
	bne L9385
	lda #<Sec_buf1
	sta BufPtrL
	lda #>Sec_buf1
	sta BufPtrH
	lda #$01
	sta TransCt
	jsr S8c9e
	lda Sec_buf1+$1a
	ldx Sec_buf1+$1b
	cmp #$95
	bne L936b
	lda #$40
	ldx #$00
L936b	sta L944b
	stx L944c
	lda Sec_buf1+$10
	sta L9447
	lda Sec_buf1+$11
	sta L9448
	lda #$ff
	sta L9443
	jmp L93a6

L9385	lda LBA_ls_tmp
	sta LBA_ls
	lda L95a1
	sta LBA_ms
	lda L944b
	sta BufPtrH
	lda L944c
	sta BufPtrL
	jsr S8c9e
	inc L944b
	inc L944b
L93a6	inc L944a
	bne L93ae
	inc L9449
L93ae	inc LBA_ls_tmp
	bne L93bb
	inc L95a1
	bne L93bb
	inc LBA_ms_tmp
L93bb	lda L944a
	cmp L9448
	bne L93ce
	lda L9449
	cmp L9447
	bne L93ce
	ldx #$00
	rts

L93ce	lda Sec_buf1+$18
	cmp #$0a
	bcc L9385
	jmp L932f

S93d8	ldx #$10
	lda #<Sec_buf1
	sta L93e8
	lda #>Sec_buf1
	sta L93e8+1
L93e4	jsr S946e
L93e8	=*+1		; operand is the target
L93e7	cmp L93e7	; label is to satisfy assembly
	beq L93ef
	ldx #$ff	
	rts		

L93ef	inc L93e8
	bne L93f7
	inc L93e8+1
L93f7	dex
	bne L93e4
	ldx #$00
	rts

S93fd	lda L9446
	clc
	adc #$20
	sta L9446
	bcc L940b
	inc L9445
L940b	dec L9492
	beq L9411
	rts

L9411	inc LBA_ls_tmp
	bne L9419
	inc L95a1
L9419	lda LBA_ls_tmp
	sta LBA_ls
	lda L95a1
	sta LBA_ms
	jsr SCSI_RD_And_Inc
	lda #$10
	sta L9492
	lda #<Sec_buf2
	sta L9446
	lda #>Sec_buf2
	sta L9445
	inc L95a3
	dec L9493
	rts

L943e	.byte $00
L943f	.byte $00
L9440	.byte $00
L9441	.byte $00
L9442	.byte $00
L9443	.byte $00
L9444	.byte $00
L9445	.byte $00
L9446	.byte $00
L9447	.byte $00
L9448	.byte $00
L9449	.byte $00
L944a	.byte $00
L944b	.byte $00
L944c	.byte $00 

S944d	ldx L9446
	stx S946e + 1
	ldy L9445
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

L9492	.byte $00
L9493	.byte $00
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

S951c	ldx #<Sec_buf1
	ldy #>Sec_buf1		; start reading at 9c00
	sec			; sec = set source address
	jsr Read_Memory_xy	; set address to 9c00
	lda #$10
	sta L95a4		; scratch space?
	lda #$00
	sta L95a5		; setting up $1000?
	sta L95a6
	sta L95a1
	sta LBA_ms_tmp
	sta L963e
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
	adc L95a6
	sta L95a6
	bcc L9558
	inc L95a5
L9558	dec L95a4
	bne L953a
L955d	lda L95a6
	bne L956a
	lda L95a5
	bne L956a
L9567	ldx #$ff
	rts

L956a	sec
	lda L95a6
	sbc #$01
	sta L95a6
	bcs L9578
	dec L95a5
L9578	lda L95a6
	ldx L95a5
	ldy #$10
	jsr Divide
	sta L95a3
	lda #$f0
	sec
	adc L95a3
	sta LBA_ls_tmp
	bcc L9594
	inc L95a1
L9594	lda #$fe
	sec
	sbc L95a3
	ldy L95a3
	ldx #$00
	rts

LBA_ms_tmp	.byte $00
L95a1	.byte $00
LBA_ls_tmp	.byte $00
L95a3	.byte $00
L95a4	.byte $00
L95a5	.byte $00
L95a6	.byte $00 
L95a7	.text "=:,*?"
	.byte $a0 ;//"{Shift Space}"

	; Shift-and-add multiply engine
Multiply			; $95ad
	; TODO: Figure out which * which
	sta Mul_o2h		; input 1 (16 bits) (sectors)
	stx Mul_o2m		; input 1 (16 bits)
	sty Mul_o1		; input 2 (8 bits)  (heads)
	lda #$00
	sta Mul_mmsb		; reset our scratch space
	sta Mul_msb
	sta Mul_lsb
	ldx #$08		; eight bit multiply
Mul_add	clc
	lsr Mul_o1		; shift a bit out the right side of drive0_heads
	bcc Mul_shf		;  carry clear? Multiply by two (shift left)
	clc			;  not clear, prepare for addition
	lda Mul_lsb		;  Multiply final oputput 
	adc Mul_o2h		; 
	sta Mul_lsb		; 
	lda Mul_msb		; 
	adc Mul_o2m		; 
	sta Mul_msb		; 
	lda Mul_mmsb		; 
	adc Mul_o2l		;  by opeator 2
	sta Mul_mmsb		;  and save to output
Mul_shf	clc			; 
	rol Mul_o2h		; Get a bit from Operator 2 by two (o2h gets discarded)
	rol Mul_o2m		;  (this is a bit strange as the bits are done
	rol Mul_o2l		;   in reverse order)
	dex			; done eight times yet?
	bne Mul_add		;  no, continue.
	ldy Mul_mmsb
	ldx Mul_msb
	lda Mul_lsb
	rts

Mul_o1	.byte $00
Mul_o2l	.byte $00
Mul_o2m	.byte $00
Mul_o2h	.byte $00
Mul_mmsb .byte $00
Mul_msb	.byte $00
Mul_lsb	.byte $00 

	; Divide
Divide	sta L9640		; 
	stx L963f		; 
	sty L963d		; 
	lda #$00		; Clear 8-bit remainder
	ldx #$18		; Process 18 bits
L9610	clc
	rol L9640		; 
	rol L963f		; 
	rol L963e
	rol a
	bcs L9622		; 
	cmp L963d		; 
	bcc L9632		; 
L9622	sbc L963d		; 
	inc L9640		; 
	bne L9632		
	inc L963f		
	bne L9632
	inc L963e		; 
L9632	dex			; done?
	bne L9610		;  No, continue.
	tay			; remainder -> .Y
	ldx L963f		; 
	lda L9640		; A,X=result
	rts			;  return

L963d	.byte $00
L963e	.byte $00
L963f	.byte $00
L9640	.byte $00

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

SCSI_Set_geometry
	; Educated guesswork determines that this code sends the geometry
	;  of a scsi controller for simpler drives.  It seems the controller
	;  wouldn't have any form of nonvolatile storage as it would need
	;  the geometry sent during startup.
	lda #$c2	; not a scsi command (http://www.t10.org/lists/op-num.htm)
	sta CDBBuffer	; 9789
	ldx Drive0_Heads
	dex
	stx Heads	; +9
	lda Drive0_CylHi
	sta Cyl_Hi	; +10
	ldx Drive0_CylLo
	dex
	stx Cyl_Low	; +11
	lda Drive0_Flags
	and #$3f
	sta L978f	; +6
	lda Drive0_StepPeriod
	sta L9790	; +1
	lda Drive0_WPcomp
	sta WPcomp	; +15
	lda Drive0_Unknown
	sta D0_Unk	; +13
	jsr SCSI_Select	; FIXME: according to interpretation of scsi_select, bne will never branch.
	bne SetCarryRTS ;  Never happens.
	ldx #$10	; $10 bytes to send
	ldy #$00	; from beginning of buffer
	jsr SCSI_SEND	
	jsr SCSI_GetStatus
	rts

SetCarryRTS ; $9699
	sec
	rts

SCSI_WRITE ; $969b
	lda #$0a	; SCSI WRITE(6)
	bne L96a1	; Multiple programmer mark:  Some areas use .byte $2c [BIT] for this
SCSI_READ ; $969f
	lda #$08	; SCSI READ(6)
L96a1	sta SCSI_CMD	; set scsi command	; 9789
	lda LBA_ms
	sta SCSI_msb	; set lba msb
	lda LBA_ls
	sta SCSI_lsb	; set lba lsb
	lda TransCt
	sta SCSI_tc	; set transfer count
	lda BufPtrH
	sta $f8		; set buffer address
	lda BufPtrL
	sta $f7
	jsr SCSI_Select	; Select drive
	bne SetCarryRTS ;  This never happens.
	ldx #$06	; CDB is 6 bytes long
	ldy #$00	; and starts at buff offset 0
	jsr SCSI_SEND	; Send read command
	ldy #$00
	lda SCSI_CMD	; Wait, what were we doing? lol
	cmp #$08	; did we READ(6)?
	beq SCSI_DoRead	;  yes, perform read

	; Perform SCSI_WRITE
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; FIXME: pulse ca2 for ???
L96da
	lda HA_ctrl	; Get bus status
	bmi L96da	; wait for REQ to be set
	and #$04	; Did drive move back to control phase?
	beq SCSI_FinishRW ; exit when the target changes phase (will be done here)
	lda ($f7),y	; get byte from buffer
			; BIG FAT NOTE:  The SCSI interface is logically
			;  inverted.  This means the data is also inverted
			;  as it heads to the target.  If this is imaged
			;  all bits will be backwards (00=ff, 01=fe, etc).
			; This doesn't affect the DOS as the data gets re-
			;  inverted on the way back in.  Note how
			;  SCSI_SEND inverts data to ensure the targets
			;  understand the commands being sent.
	sta HA_data	; send byte to target
	lda HA_data	; pulse ACK (ca2 pulse on read)
	iny		; increment pointer
	bne L96da	; until 256 bytes
	inc $f8		; increase buff high address
	jmp L96da	; and read until target says done
	
	; Perform SCSI_READ
SCSI_DoRead
	jsr HA_SetDataInput
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr
L96fb	lda HA_ctrl	; Get bus status
	bmi L96fb	; wait for REQ to be set
	and #$04	; Did drive move back to control phase?
	beq SCSI_FinishRW ; exit when target changes phase (will be done here)
	lda HA_data	; get byte from target
	sta ($f7),y	; deposit in buffer
			; BIG FAT NOTE:  The SCSI interface is logically
			;  inverted.  This means the data is also inverted
			;  as it heads to the target.  If this is imaged
			;  all bits will be backwards (00=ff, 01=fe, etc).
			; This doesn't affect the DOS as the data gets re-
			;  inverted on the way back in.  Note how
			;  SCSI_SEND inverts data to ensure the targets
			;  understand the commands being sent.
	iny
	bne L96fb	; for 256 bytes
	inc $f8		; increase buff high address
	jmp L96fb	; repeat until target says done

SCSI_FinishRW
	jsr SCSI_GetStatus ; done read/writing, Get status byte and return.
	txa
	bne SetCarryRTS ;  Never happens.
	clc
	rts

SCSI_Select ; $9719
	; Select a SCSI target FIXME: Seems to be hardcoded for ID 0
	
	; Judging by how this is called, it's expected
	;  to return nonzero status if selection failed.
	; However it's hard-coded to return zero (lda #0:rts)
	;  and wait forever for device 0 to respond.

	jsr HA_SetDataOutput
	lda #$fe	; % 1111 1110 FIXME: targeting scsi ID 0?
	sta HA_data
	lda #$50	; %0101 0000	Assert ATN and SEL (http://www.staff.uni-mainz.de/tacke/scsi/SCSI2-06.html sect 6.1.3)
	sta HA_ctrl
L9726	lda HA_ctrl
	and #$08	; %0000 1000	Wait for BSY from target
	bne L9726
	lda #$40	; %0100 0000	Release SEL
	sta HA_ctrl
	lda #$00	; always returns z=1
	rts

SCSI_SEND ; $9735
	; send .X bytes starting at CDBBuffer+.Y to bus
	jsr CTSWait
	lda CDBBuffer,y	; get byte from buffer	; 9789
	eor #$ff	; invert for SCSI
	sta HA_data	; send data to bus
	jsr SCSI_ACK	; handshake
	iny		; increment pointer
	dex		; decrement count
	bne SCSI_SEND	; repeat until done
	jsr CTSWait	; FIXME: wait for data phase?
	rts

HA_SetDataInput ; $974b
	ldx #$00	; set data port as input
	.byte $2c 	;  BIT opcode causes cpu to skip ldx #$ff
HA_SetDataOutput ; $974e
	ldx #$ff	; set data port as output
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
	bmi CTSWait	; check bit 7: FIXME is this C/D?
	rts

SCSI_ACK
	lda #$2c
	;0010 1100
	;00     ; irq off
	;101    ; ca2 pulse out low on read
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; set port A to pulse ca2 on read
	lda HA_data	; pulse ACK
	lda #$3c
	;0011 1100
	;00     ; irq off
	;111    ; ca2 high
	;1      ; port register on
	;00; ca1 high
	sta HA_data_cr	; set ca2 to high
	rts

SCSI_GetStatus
	; Gets scsi status and message bytes after read/write.
	;  Status is anded 9f and returned in .X
	;  Message is returned in .A
	jsr HA_SetDataInput
	jsr S977b	; get the status byte
	and #$9f	; mask %1001 1111
	tax		; return in .X
S977b	jsr CTSWait	; 
	lda HA_data	; Get message byte
	eor #$ff	;  correct for bus inversion
	tay		; keep safe (SCSI_ACK destroys .A)
	jsr SCSI_ACK	; 
	tya		; restore .A
	rts		; and return it

		; FIXME:  This is likely not only
		;  used by SCSI_WRITE and SCSI_READ
		; add duplicate labels later to
		;  improve code readability.

CDBBuffer	; $9789		; for read(6) and write(6):
SCSI_CMD
	.byte $00		; +0: opcode (08=read, 0a=write(6))
SCSI_mmsb
	.byte $00		; +1: lba mmsb (only accessed by SCSI_SEND)
SCSI_msb
	.byte $00		; +2: lba msb
SCSI_lsb
	.byte $00		; +3: lba lsb
SCSI_tc
	.byte $00		; +4: transfer count
SCSI_ctl
	.byte $00		; +5: control field
L978f	.byte $04		;  6
L9790	.byte $00		;  7
	.byte $00		;  8
Heads	.byte $00		;  9 Copied from the first
Cyl_Hi	.byte $00		;  a  drive entry in sector
Cyl_Low	.byte $00		;  b  18,18. 
WPcomp	.byte $00		;  c
D0_Unk	.byte $00		;  d
	.byte $00,$00 		;  e,f < Bytes 0-f are sent to the drive (s9656)
LBA_ms	.byte $00
LBA_ls	.byte $00
BufPtrH	.byte $00
BufPtrL	.byte $00
TransCt	.byte $00 

S979e	; does this code search for a free sector?
	ldx #$00
	stx L9936
	inx
	stx TransCt		; 1 sector
	lda #$00
	sta LBA_ms
	lda #$ee
	sta LBA_ls		; sector ee (DISCBITMAP)
	lda #>Sec_buf2
	sta BufPtrH 
	lda #<Sec_buf2
	sta BufPtrL		; Set up for buffer 2
	jsr SCSI_READ		; Read DISCBITMAP ($0000ee) to buffer 2
	bcc L97c3		;  branch if success
	jsr $c000		; jump to error handler at $c000

L97c3	lda Sec_buf2+$13	; offset 13 (15 in both hd images)
	sta L992d
	lda Sec_buf2+$15	; offset 15 (18 in both hd images)
	sta L992e
	lda Sec_buf2+$16	; offset 16 (00 in both hd images)
	sta L9930
	lda Sec_buf2+$17	; offset 17 (17 in both hd images)
	sta L9931
	lda Sec_buf2+$19	; offset 19 (a8 in both hd images)
	sta L9932
L97e1	inc LBA_ls		; next sector
	bne L97e9
	inc LBA_ms
L97e9	lda #$00
	sta L992f		; clear L992f
	jsr SCSI_READ		; still reading to Buffer 2
	bcc L97f6
	jsr $c000		; jump to error handler at $c000

L97f6	lda #>Sec_buf2
	sta LDA_Y + 2
	sta L9890 + 1
	lda #<Sec_buf2
	sta LDA_Y + 1		; set lda_y target
	sta L9890		;  and L9890 to Sector buffer 2
	lda L992d
	sta L9933		; FIXME: Is 9933 a count?
L980c	lda #$00
	sta L9935
	ldy #$02		; start at 9e02
L9813	iny
	lda #$80
	sta L9934
	jsr LDA_Y		; get byte
	cmp #$ff		; FF?
	bne L9830		; Nope, skip ahead
	lda #$08		; Get 8
	clc
	adc L9935		; and add to 9935
	sta L9935		;  save it
	cmp L9932		; check against 9932
	bcc L9813		; lower? Loop.
	bcs L9847		; Otherwise L9847.
L9830	bit L9934
	beq L988c
L9835	inc L9935
	ldx L9935
	cpx L9932
	beq L9847
	lsr L9934
	bne L9830
	beq L9813
L9847	lda L992e		; get L992e
	clc
	adc LDA_Y + 1		; add it to our source pointer
	sta LDA_Y + 1
	sta L9890
	bcc L985c		; no overflow? Skip ahead
	inc LDA_Y + 2
	inc L9890 + 1		; fix for overflow
L985c	ldx #$ff		; prep X to check for -1
	dec L9931		; Dec L9931
	beq L986e		;  zero?
	cpx L9931
	bne L9877		;  -1?
	dec L9930		; Not yet, dec L9930 too.
	jmp L9877		; skip ahead

L986e	lda L9930		; L9931 was zero after a dec
	bne L9877		; is L9930 nonzero? skip ahead
	ldx #$fd		; FIXME: why fd?
	sec			; indicate error?
	rts			; done.

L9877	dec L9933		; dec L9933
	bne L980c		; not zero yet? branch to L980c
	lda L992f		; get L992f
	beq L9889		; zero? Jump to 97e1
	jsr SCSI_WRITE		; write the sector to disk
	bcc L9889		; hopefully it went well.
	jsr $c000				; jump to error handler at $c000
L9889	jmp L97e1		; loop

L988c	ora L9934
L9890	=*+1		; target is operand
L988f	sta L988f,y	; label to satisfy assembler
	pha		
	tya		
	pha		
	lda L9936	
	beq L98a1	
	ldx Sec_buf1+$18	
	cpx #$0a	
	bcc L98ba	
L98a1	asl a
	tax
	ldy #$01
	jsr LDA_Y
	pha
	iny
	jsr LDA_Y
	clc
	adc L9935
	sta Sec_buf1+$21,x
	pla
	adc #$00
	sta Sec_buf1+$20,x
L98ba	lda #$ff
	sta L992f
	pla
	tay
	pla
	inc L9936
	ldx L9936
	cpx Sec_buf1+$11
	beq L98d0
	jmp L9835
	
L98d0	jsr SCSI_WRITE
	bcc L98d8
	jsr $c000		; jump to error handler at $c000
L98d8	lda #$ee
	sta LBA_ls
	lda #$00
	sta LBA_ms
	jsr SCSI_READ		; discbitmap
	bcc L98ea
	jsr $c000		; jump to error handler at $c000
L98ea	ldx #$ff
	lda Sec_buf2+$92
	sec
	sbc L9936
	sta Sec_buf2+$92
	bcs L9903
	dec Sec_buf2+$91
	cpx Sec_buf2+$91
	bne L9903
	dec Sec_buf2+$90
L9903	lda L9936
	clc
	adc Sec_buf2+$95
	sta Sec_buf2+$95
	bcc L9917
	inc Sec_buf2+$94
	bne L9917
	inc Sec_buf2+$93
L9917	lda #$ff
	sta Sec_buf2+$96
	sta Sec_buf2+$97
	jsr SCSI_WRITE
	bcc L9927
	jsr $c000		; jump to error handler at $c000
L9927	clc
	rts

LDA_Y	lda LDA_Y,y
	rts
	

L992d	.byte $00
L992e	.byte $00
L992f	.byte $00
L9930	.byte $00
L9931	.byte $00
L9932	.byte $00
L9933	.byte $00
L9934	.byte $00
L9935	.byte $00
L9936	.byte $00 
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
L9ba8	.byte $00
Serialno		; for routines that access the serial number
InputBuf.byte $00	;$9ba9	; sb2 will load sector 18,18 here.
L9baa	.byte $00	;  The sector will cover 9ba9 to 9ca8.
L9bab	.byte $00
L9bac	.byte $00
L9bad	.byte $00
L9bae	.byte $00
L9baf	.byte $00
L9bb0	.byte $00
L9bb1	.byte $00
L9bb2	.byte $00
L9bb3	.byte $00
L9bb4	.byte $00
L9bb5	.byte $00
L9bb6	.byte $00

			; According to the sector 18,18 layout, the first drive's
			;  geometry is stored here.
Drive0_Flags
	.byte $00 	; SCSI 0: flags (bit 7=embedded controller)
Drive0_StepPeriod
	.byte $00	; SCSI 0: step period (probably 0)
Drive0_Sectors
	.byte $00	; SCSI 0: Sectors per track
Drive0_Heads
	.byte $00	; SCSI 0: Heads per cylindr
Drive0_CylHi
	.byte $00	; SCSI 0: Cylinders, high byte (scsi order!)
Drive0_CylLo
	.byte $00	; SCSI 0: Cylinders, low byte
Drive0_WPcomp
	.byte $00	; SCSI 0: Write Precomp
Drive0_Unknown
	.byte $00 	; SCSI 0: unknown (zero)
; drive1++ geometry is here in memory.

; 9bbf is one past eof

; for temporary reference:
;
;9ba9    ;$00 - $07 is your Serial Number
;            ;MUST Match Serial Number contained in Host Adapter EPROM!
;          ;Remember your Serial Number is in EPROM at $A-$13 AND $100A-$1013
;          ;ALL below are Drive parameters Only
;          ;(note the gap from $07 to $0E - Don't edit)
;9bb7    ;$0E - $15 SCSI Drive Zero parameters (1st drive)
;          ;If you only install ONE drive, this is the only area that needs editing
;          ;All other cells should be: 128,0,0,0,0,0,0,0
;          ;Manually set the Drive to SCSI address Zero
;9bbf    ;$16 - $1D Drive One parameters   (2nd drive)
;9bc7    ;$1E - $25 Drive Two parameters   (3rd drive)
;9bcf    ;$26 - $2D Drive three parameters (4th drive), etc.
;9bd7    ;$2E - $35 Drive four parameters  (5th drive), etc.
;9bdf    ;$36 - $3D Drive five parameters  (6th drive), etc.
;9be7    ;$3E - $45 Drive six parameters   (7th drive), etc.
;9bef    ;$46 - $4D Drive seven parameters (8th drive), etc.
; as above, ALL unedited cells Must be "128,0,0,0,0,0,0,0". During
;  startup, this 'string' is how LK DOS knows there are No other drives attached)
;
;The following CELL chart shows each position, its purpose and the 
;  values of our ST1201N example (note the number of Heads,
;  Sectors/Track and HiByte/LoByte Cylinders) If you wanted to add 
;  an additional ST1201N drive, you would use the same values at
;  T18/S18, position $16 - $1D:
;offset	T/S/Pos	ST1201N	Byte Function
;0	$0E	128	BIT 7="N" embedded controller, BIT 0-6= Pulse Width for 3100
;1	$0F	0	Step Period
;2	$10	36	Sectors/Track
;3	$11	9	Number of Heads
;4	$12	4	Number of Cylinders - High Byte
;5	$13	44	Number of Cylinders - Low Byte
;6	$14	0	Write precomp Cylinders
;7	$15	0	unknown, but is ZERO on all (spare?)
Drive1_Geometry	=*	; for the SYSTEMTRACK init code

