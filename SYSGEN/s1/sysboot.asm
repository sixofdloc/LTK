;**************************************
;*                    _                    _                            
;*   ___  _   _  ___ | |__    ___    ___  | |_     __ _  ___  _ __ ___  
;*  / __|| | | |/ __|| '_ \  / _ \  / _ \ | __|   / _` |/ __|| '_ ` _ \ 
;*  \__ \| |_| |\__ \| |_) || (_) || (_) || |_  _| (_| |\__ \| | | | | |
;*  |___/ \__, ||___/|_.__/  \___/  \___/  \__|(_)\__,_||___/|_| |_| |_|
;*        |___/                                                         
;*
;* AKA sysbootr.r
;*
;* sysbootr.r is loaded to LBA $f and $10 (1024 bytes) by setup.asm during SYSGEN.
;* ltkbootstub loads this program to $0400 after loading some other data and runs it.


;**************************************
;*
;* Memory map when we're called to finish bootstrapping the system.
;*
;* Loc     size    Usage
;* CD00            ltkbootstub.asm (bootstrap proc from rom)
;* 91e0    512     SYSTEMTRACK (lba 0)
;* 93e0    512     convrtio.r (lba $28)
;* 0400    1024    sysbootr.r (lba $f,$10)


; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_hw_equates.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"

	.include "../../include/relocate.asm" ; utility for relocating code segments during assembly.

	*=$0400 ;$4000 for sysgen

LTK_Buf	=$8000		; ltkernal.r is initially loaded here.
HA_Page	=$9e43		; Host adapter page is left here by ltkbootstub.  It should either be $DF or $DE.
SysTrk	=$91e0		; SYSTEMTRACK is loaded here.
ConvrtIO =$93e0		; from convrtio.r: Edits a range to change the code's HA IO address
	
START			; level TWO bootstrap
	lda HA_Page	; ltkbootstub.asm places the host adapter page byte here.
	sta L04c3	; Save for our own use.
	cmp #$df	; DF00?
	beq clear_roms_boot_stub

	lda #$00
	sta $31
	lda #$04
	sta $32		; start at $0400
	lda #$00
	sta $33
	lda #$08
	sta $34		; end at $0800
	jsr ConvrtIO	; call convrtio.r (edit us to use a host adapter at DE00)

clear_roms_boot_stub
	ldx #$03	; 3 pages
	lda #$00	; set to 00
	tay

clearbootstubloop	; Zero out the area originally occupied by ltkbootstub at $cd00
	sta $cd00,y
	iny
	bne clearbootstubloop
	inc clearbootstubloop + 2
	dex
	bne clearbootstubloop

	;copy kernal into shadow ram
	ldx #$20	; 8192 bytes to copy
	ldy #$00
L0432
	lda #$3c
			;0011 1010
			;00	; irq off
			;111	; cb2 high
			;0	; DDR on
			;10	; cb1 triggers on positive edge

	sta HA_ctrl_cr	;set normal c64 mem at $e000
L0439	=*+2		; high byte
	lda $e000,y
	pha
	lda #$34
			;0011 0010
			;00	; irq off
			;110	; cb2 low
			;0	; DDR on
			;10	; cb1 triggers on positive edge

	sta HA_ctrl_cr	;set shadow ram at $e000
	pla
L0443	=*+2		; high byte
	sta $e000,y
	iny		; next byte
	bne L0432	;  continue
	inc L0439	; increment high byte
	inc L0443
	dex		; decrement page count
	bne L0432	; keep going until done.
	; At this point, CB2 is still low, so shadow ram is still in place at $e000 (and likely $8000, see below)

	; Load ltkernal.r into shadow ram and set it up
	lda #<LTK_Buf	; $00
	sta $31
	lda #>LTK_Buf	; $80
	sta $32		; $8000
	lda #$07	; TransCt matches setup.asm data
	sta TransCt
	lda #$01	; LBA 1: ltkernal.r
	sta SCSI_lsb
	jsr SCSI_READ	; load ltkernal.r 3.5k (7 blocks) to $8000
	lda HA_Page	; check the host adapter page
	cmp #$df	; is it $df00?
	beq L047f	;  Good, skip ahead
	lda LTK_Buf+$46	; $8046	; hdd_driver starting address
	sta $31		; set start address for convrtio
	sta $33		; set end address for convrtio
	ldx LTK_Buf+$47	; $8047 ; hdd_driver starting address
	stx $32		; set start address for convrtio
	inx
	inx
	stx $34		; set end address for convrtio for two pages
	jsr ConvrtIO	; edit hdd_driver for $de00

	; ltkernal.r is loaded and optionally converted for $de00 now.
	; Copy some necessary data from the bootblock...
L047f	lda SysTrk+$12	; drive0 flags
	and #$3f	; Strip off the high bits
	sta drive0_flags 
	lda SysTrk+$13	; drive0 step period
	sta drive0_period 
	ldx SysTrk+$19	; drive0 heads
	dex		; 
	stx drive0_heads 
	lda SysTrk+$16	; drive0 cyl high
	sta drive0_cyl	; 
	ldx SysTrk+$17	; drive0 cyl low
	dex		; 
	stx drive0_cyl+1 
	lda SysTrk+$15	; drive0 wp comp
	sta drive0_wpcomp 
	lda SysTrk+$1a	; drive0 (unknown)
	sta drive0_unk	; 

	ldx HA_Page	; save the HA page byte
	lda #$00	; 
	tay		; 
L04b3	sta LTK_FileParamTable,y ;$9de0	
	iny		
	bne L04b3	; clear 9de0-9edf
	stx HA_Page	; restore the HA page byte

	lda #$ff	
	sta LTK_FileParamTable ;$9de0
L04c3	=*+2		; High byte is the target
	lda HA_PortNumber
	and #$0f	
	pha		; put our port number on the stack.
	bne L04e4	;  Not port zero, dont send geometry to the hdd controller

	bit $91f2	; Check high bit of drive flags
	bmi L04e4	;  Intelligent drive?  Skip geometry send below
	sta SCSI_lsb	
	sta TransCt	
	jsr SCSI_SendGeometry
	lda #$20	
	sta SCSI_mmsb	
	jsr SCSI_SendGeometry
	lda #$00	
	sta SCSI_mmsb	

	; All HW init should be done now.
L04e4	pla		; Restore our port number
	clc		; 
	adc #$9e	; add $9e
	sta SCSI_lsb	; 
	lda #$02	; 
	adc #$00	; Add $200
	sta SCSI_msb	; set msb
	lda #<LTK_FileReadBuffer ;$e0	; 
	sta $31		; 
	lda #>LTK_FileReadBuffer ;$9b	; 
	sta $32		; dest addr 9be0
	lda #$01	; 
	sta TransCt	; one block to transfer
	jsr SCSI_READ	; Read LBA $00029d (defaults.r+port#)

	lda LTK_FileReadBuffer+$19 ; systemconfigfile+$19 
	sta $d030	;  c128: Speed register
	sta LTK_Default_CPU_Speed
	lda LTK_FileReadBuffer+$e ; +$e
	sta LTK_BeepOnErrorFlag
	lda LTK_FileReadBuffer+$8 ; +8
	sta LTK_HD_DevNum

	; First kernal patch from sysbootr.r (that's this program)
	ldx #$4c	; $4c (76) bytes
	ldy #$00	;  start at 0
L051b	lda K_Patch1,y	; from 05ab
	sta $fc3d,y	;  to fc3d.
	iny	
	dex	
	bne L051b	

	; Second kernal patch from sysbootr.r (that's this program)
	ldx #$f5	
	ldy #$00	
L0529	lda K_Patch2,y	
	sta $f92c,y	
	iny	
	dex	
	bne L0529	

	; Third kernel patch from convrtio.r
	ldx $93e3	; convrtio.r+3 ($af originally)
	ldy #$00	
L0538	lda $93e4,y	; convrtio.r+4
	sta $fa2c,y	
	iny	
	dex	
	bne L0538	

	ldx #$09	; 9 patches (OPEN,CLOSE,CHKIN,CHKOUT,CLRCHN,CHRIN,CHROUT,LOAD,SAVE)
	ldy #$00	; start at 0

	jsr K_Patch4	; patchypatchy
	ldx #$02	; 2 patches (GETIN,CLALL)
	ldy #$24	; start at $24
	jsr K_Patch4	; patch
	
	lda $9bfc	
	beq L0567	

	lda #$83	
	sta $fffe	
	lda #$fc
	sta $ffff	; IRQ/BRK = $fcea

	lda #$ea	; these patch K_Patch1.
	sta P_Nop1	;  'cli' patched out
	sta P_Nop2	;  'cli' patched out

L0567	lda $9bfe	
 	beq L0576	

 	lda #<LTK_NMI	; $86	
 	sta $fffa	
 	lda #>LTK_NMI	; $fc	
 	sta $fffb	; NMI = $fc86

L0576	lda #$00	
	sta HA_ctrl	
L057b	sta $8004	; ltkernal.r+$04 (FIXME: What's this)
	jmp Exit	; exit to start the system up

L0581	lda #$3c
	sta HA_ctrl_cr
	lda #$40
	sta HA_ctrl
	lda #$00
	beq L057b

K_Patch4
	lda K_Patch4a	; jsr
	sta OPEN,y
	iny
	lda K_Patch4a+1	; 59
	sta OPEN,y
	iny
	lda K_Patch4a+2	; fc
	sta OPEN,y
	iny

	dex ; more jumps to patch?
	bne K_Patch4
	rts

K_Patch4a
	jsr Lfc59

	; Code segments copied to the kernal

K_Patch1 ; copied to $fc3d.
	; fc3d is in the middle of the casette write routine.
	#relocate $fc3d
	lda #$00	; 05ab -> fc3d
	sta HA_ctrl	; fc3f
	pla		; fc42
	plp		; fc43
P_Nop1	cli		; fc44 ; later patched to NOP
S05b3	jsr $05b3	; fc45 ; Direct address satisfies binary match requirement
	jsr Lfc4e	; fc48
	jmp (LTK_Var_Ext_RetVec)	; fc4b

P_Nop2
Lfc4e	sei		; fc4e	; later patched to NOP
	php		; fc4f
	pha		; fc50
	lda #$40	; fc51
	sta HA_ctrl	; fc53
	pla		; fc56
	plp		; fc57
	rts		; fc58

Lfc59	jsr Lfc4e	; fc59
	jmp (LTK_Var_Kernel_Basin_Vec)	; fc5c ; all K_Patch4 entries go through here.

L05cd
ha_ctrl_save		
	.byte $40	; fc5f
	.byte $ff	; fc60
	NOP  		; fc61
	jmp Lf92c	; fc62	; handle reads for ltkernal.asm:hd_driver
	jmp Lf949	; fc65	; handle writes for ltkernal.asm:hd_driver
	jmp Lf981	; fc68
	jmp Lf989	; fc6b
	jmp Lf991	; fc6e
	jmp Lf9be	; fc71
	jsr Lfc4e	; fc74
	jmp (LTK_Var_BASIC_ExtVec)	; fc77
L05e8	jmp $05e8	; fc7a ; Direct address satisfies binary match requirement
L05eb	jmp $05eb	; fc7d ; Direct address satisfies binary match requirement
	jmp Lf999	; fc80
	jmp Lf9c8	; fc83
LTK_NMI	jmp Lf9cb	; fc86
	#endr
	; end of K_Patch1

K_Patch2 ; copied to $f92c
	; f92c is in the middle of the casette read routine.
	#relocate $f92c
	; Handle reads for hd_driver (ltkernal.asm)
Lf92c	jsr SetCtl	; Set up the control port
L05fa	lda HA_ctrl	; get control port state
	bmi L05fa	;  wait for REQ to clear
	and #$04	; get C/D flag
	beq Lf969	;  exit when drive leaves data mode
	ldx #$02	; two pages (512 bytes)
L0605	lda HA_data	;   get a byte from the drive
	sta ($31),y	;   put it in the buffer
	iny		;   increment index
	bne L0605	;   256 bytes!
	inc $32		;  increment pointer high byte
	dex		;  and do two pages
	bne L0605	; 
	beq L05fa	; Loop for another 512 bytes.

	; Handle writes for hd_driver (ltkernal.asm)
Lf949	jsr SetCtl	; set scsi control port
L0617	lda HA_ctrl	; get control port state
	bmi L0617	;  wait for REQ to clear
	and #$04	; 0000 0100 = c/d flag
	beq Lf969	;  did target leave data mode? Exit.

	ldx #$02	; two pages (512 bytes)
L0622	lda ($31),y	;   get a byte from the buffer
	sta HA_data	;   send it to drive
	lda HA_data	;   poke the handshake lines
	iny		;   increment index
	bne L0622	;   keep going for 256 bytes
	inc $32		;  increment buffer high
	dex		;  increment page count
	bne L0622	;  until done
	beq L0617	; and repeat until target leaves data mode

Lf969	php		; save regs
	pha		; 
	lda #$40	; 
	sta HA_ctrl	; 
	sta ha_ctrl_save; set control port back to normal
	pla		; 
	plp		; restore regs
	rts		; and done.
	; writes for hd_driver are done.

SetCtl	php		; 
	pha		; 
	lda ha_ctrl_save
	sta HA_ctrl	; 
	pla		; 
	plp		; 
	rts		; 

Lf981	jsr Lf9be	; 
	lda ($22),y	; 
	jmp Lf969	; 

Lf989	jsr Lf9be	; 
	sta ($31),y	; 
	jmp Lf969	; 

Lf991	jsr Lf9be	; 
	lda ($31),y	; 
	jmp Lf969	; 

Lf999	sta Lf9b3	; 
	pla		; 
	sta Lf9bc	; 
	pla		; 
	sta Lf9bd	; 
	inc Lf9bc	; 
	bne L0677	; 
	inc Lf9bd	; 
L0677	lda #$00	; 
	sta HA_ctrl	; 
	tay		; 
Lf9b3	=*+1
	lda #$00	; 
	sta ($ae),y	; 
	lda #$40	; 
	sta HA_ctrl	; 
Lf9bc	=*+1
Lf9bd	=*+2
L0686	jmp $0686	;  ; Direct address satisfies binary match requirement

Lf9be	php		; 
	pha		; 
	lda #$00	; 
	sta HA_ctrl	; 
	pla		; 
	plp		; 
	rts		; 

Lf9c8	clc		; 
	bcc L0697	; 
Lf9cb	sec		; 
L0697	bit HA_ctrl	; 
	bvc L06bf	; 
	pha		; 
	lda LTK_Var_CurRoutine	; 
	pha		; 
	lda LTK_Save_Accu	; 
	pha		; 
	lda LTK_Save_XReg	; 
	pha		; 
	lda LTK_Save_YReg	; 
	pha		; 
	lda LTK_Save_P	; 
	pha		; 
	lda #$00	; 
	sta HA_ctrl	; 
	lda #$fa	; 
	pha		; 
	lda #$06	; 
	pha		; 
	lda #$04	; 
	pha		; 
L06bf	bcc L06c4	; 
	jmp $fe43	; stock NMI entry

L06c4	bvs L06cb	; 
	bit LTK_Krn_KeypadEnable	; 
	bvs L06ce	; 
L06cb	jmp $ff48	; stock IRQ entry

L06ce	jmp $fa2c	; patch from convrtio+4

L06d1	lda #$40	; 
	sta HA_ctrl	; 
	pla		; 
	sta LTK_Save_P	; 
	pla		; 
	sta LTK_Save_YReg	; 
	pla		; 
	sta LTK_Save_XReg	; 
	pla		; 
	sta LTK_Save_Accu	; 
	pla		; 
	sta LTK_Var_CurRoutine	; 
	pla		; 
	rti		; 
	#endr
	; FIXME: Unless calculations are off
	;  the first two instructions of
	;  scsi_sendgeometry are also copied.

SCSI_SendGeometry	; label based on lda #$c2 ... scsi select. ;)
	lda #$c2	; This is the same code used in setup.asm to send geometry out.
	sta CDB_Buffer
	jsr SCSI_SELECT
	bne L0736
	ldx #$10
	ldy #$00
	jsr S0753
	jsr S0790
	txa
	rts

SCSI_READ
	lda #$08	; scsi read
	sta CDB_Buffer
	jsr SCSI_SELECT
	bne L0736
	ldx #$06
	ldy #$00
	jsr S0753
	ldy #$00
	jsr S0769
	lda #$2c
	sta HA_data_cr
L071d
	lda HA_ctrl
	bmi L071d
	and #$04
	beq L0732
	lda HA_data
	sta ($31),y
	iny
	bne L071d
	inc $32
	bne L071d
L0732	jsr S0790
	txa
L0736	rts

SCSI_SELECT
	jsr S076c
	lda #$fe
	sta HA_data
	lda #$50
	sta HA_ctrl
L0744	lda HA_ctrl
	and #$08
	bne L0744
	ora #$40
	sta HA_ctrl
	lda #$00
	rts

S0753	jsr S077c
	lda CDB_Buffer,y
	eor #$ff
	sta HA_data
	jsr S0782
	iny
	dex
	bne S0753
	jsr S077c
	rts

S0769	ldx #$00
	.byte $2c 
S076c	ldx #$ff
	lda #$38
	sta HA_data_cr
	stx HA_data
	lda #$3c
	sta HA_data_cr
	rts

S077c	lda HA_ctrl
	bmi S077c
	rts

S0782	lda #$2c
	sta HA_data_cr
	lda HA_data
	lda #$3c
	sta HA_data_cr
	rts

S0790	jsr S0769
	jsr S0799
	and #$9f
	tax
S0799	jsr S077c
	lda HA_data
	eor #$ff
	tay
	jsr S0782
	tya
	rts

CDB_Buffer	.byte $00
SCSI_mmsb	.byte $00
SCSI_msb	.byte $00
SCSI_lsb	.byte $00
TransCt		.byte $00
		.byte $00
drive0_flags	.byte $00
drive0_period	.byte $00
		.byte $00
drive0_heads	.byte $00
drive0_cyl	.byte $00
		.byte $00
drive0_wpcomp	.byte $00
drive0_unk	.byte $00
		.byte $00
		.byte $00 
	
Exit	lda #$fc	; Overwrites sysbootr.r likely to avoid having it seen by a debugger.
	pha
	lda #$e2	; return address set to fce2 (reset)
	pha
	lda #$04	; with SR=$4 (interrupts disabled)
	pha

	lda #$40	; start filling memory with RTI's
	ldy #$00
L07c4	sta START,y	; from start
	iny
	bne L07c4
	inc L07c4 + 2
	bne L07c4	; until we write over oureslves.

	; and we disappear into the ether via RTI
