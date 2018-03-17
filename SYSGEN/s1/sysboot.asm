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

	; 
	lda #$00
	sta $31
	lda #$80
	sta $32		; $8000
	lda #$07	; TransCt matches setup.asm data
	sta TransCt
	lda #$01	; LBA 1: ltkernal.r
	sta SCSI_lsb
	jsr SCSI_READ	; load ltkernal.r 3.5k (7 blocks) to $8000
	lda HA_Page	; check the host adapter page
	cmp #$df	; is it $df00?
	beq L047f	;  Good, skip ahead
	lda $8046	; 
	sta $31		; set start address for convrtio
	sta $33		; set end address for convrtio
	ldx $8047
	stx $32		; set start address for convrtio
	inx
	inx
	stx $34		; set end address for convrtio
	jsr ConvrtIO	; edit ltkernal.r for $de00

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
L04b3	sta $9de0,y	
	iny		
	bne L04b3	; clear 9de0-9edf
	stx HA_Page	; restore the HA page byte

	lda #$ff	
	sta $9de0
L04c3	=*+2		; High byte is the target
	lda $df04	
	and #$0f	
	pha		
	bne L04e4	

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
L04e4	pla		
	clc		
	adc #$9e	
	sta SCSI_lsb	
	lda #$02	
	adc #$00	
	sta SCSI_msb	
	lda #$e0	
	sta $31	
	lda #$9b	
	sta $32	
	lda #$01	
	sta TransCt	
	jsr SCSI_READ	; Read LBA $00009e (OpenF128.r) to $9be0
	lda $9bf9	; OpenF128+$19
	sta $d030	
	sta $8038	
	lda $9bee	; +$e
	sta $8029	
	lda $9be8	; +8
	sta $802a	

	; First kernal patch from sysbootr.r (that's this program)
	ldx #$4c	; $4c (76) bytes
	ldy #$00	
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

	lda #$ea	; FIXME: I think these patch K_Patch1.
	sta $fc44	
	sta $fc4e	

L0567	lda $9bfe	
 	beq L0576	

 	lda #$86	
 	sta $fffa	
 	lda #$fc	
 	sta $fffb	; NMI = $fc86

L0576	lda #$00	
	sta HA_ctrl	
L057b	sta $8004	; ltkernal.r+$04
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
	jsr $fc59

	; Code segments copied to the kernal

K_Patch1 ; copied to $fc3d.
	lda #$00	; 05ab -> fc3d
	sta HA_ctrl	; fc3f
	pla		; fc42
	plp		; fc43
	cli		; fc44 ; later patched to NOP (FIXME: verify)
S05b3	jsr S05b3	; fc45
	jsr $fc4e	; fc48
	jmp ($800b)	; fc4a

L05bc	sei		; fc4b
	php		; fc4c
	pha		; fc4d
	lda #$40	; fc4e	; later patched to NOP (FIXME: verify)
	sta HA_ctrl	; fc50
	pla		; fc53
	plp		; fc54
	rts		; fc55

L05c7	jsr $fc4e	; fc56
	jmp ($800d)	; fc59

L05cd
	.byte $40,$ff,$ea ; RTI?
	jmp $f92c	; fc5f
	jmp $f949	; fc62
	jmp $f981	; fc65
	jmp $f989	; fc68
	jmp $f991	; fc6b
	jmp $f9be	; fc6e
	jsr $fc4e	; fc71
	jmp ($8009)	; fc74
L05e8	jmp L05e8	; fc77
L05eb	jmp L05eb	; fc7a
	jmp $f999	; fc7d
	jmp $f9c8	; fc80
	jmp $f9cb	; fc83

	; end of K_Patch1

K_Patch2 ; copied to $fa2c
	jsr $f976	; 
L05fa	lda HA_ctrl	; 
	bmi L05fa	; 
	and #$04	; 
	beq L0634	; 
	ldx #$02	; 
L0605	lda HA_data	; 
	sta ($31),y	; 
	iny		; 
	bne L0605	; 
	inc $32		; 
	dex		; 
	bne L0605	; 
	beq L05fa	; 
	jsr $f976	; 
L0617	lda HA_ctrl	; 
	bmi L0617	; 
	and #$04	; 
	beq L0634	; 
	ldx #$02	; 
L0622	lda ($31),y	; 
	sta HA_data	; 
	lda HA_data	; 
	iny		; 
	bne L0622	; 
	inc $32		; 
	dex		; 
	bne L0622	; 
	beq L0617	; 
L0634	php		; 
	pha		; 
	lda #$40	; 
	sta HA_ctrl	; 
	sta $fc5f	; 
	pla		; 
	plp		; 
	rts		; 

L0641	php		; 
	pha		; 
	lda $fc5f	; 
	sta HA_ctrl	; 
	pla		; 
	plp		; 
	rts		; 

L064c	jsr $f9be	; 
	lda ($22),y	; 
	jmp $f969	; 

L0654	jsr $f9be	; 
	sta ($31),y	; 
	jmp $f969	; 

L065c	jsr $f9be	; 
	lda ($31),y	; 
	jmp $f969	; 

L0664	sta $f9b3	; 
	pla		; 
	sta $f9bc	; 
	pla		; 
	sta $f9bd	; 
	inc $f9bc	; 
	bne L0677	; 
	inc $f9bd	; 
L0677	lda #$00	; 
	sta HA_ctrl	; 
	tay		; 
	lda #$00	; 
	sta ($ae),y	; 
	lda #$40	; 
	sta HA_ctrl	; 
L0686	jmp L0686	; 

L0689	php		; 
	pha		; 
	lda #$00	; 
	sta HA_ctrl	; 
	pla		; 
	plp		; 
	rts		; 

L0693	clc		; 
	bcc L0697	; 
	sec		; 
L0697	bit HA_ctrl	; 
	bvc L06bf	; 
	pha		; 
	lda $8028	; 
	pha		; 
	lda $802c	; 
	pha		; 
	lda $802d	; 
	pha		; 
	lda $802e	; 
	pha		; 
	lda $802f	; 
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
	jmp $fe43	; 

L06c4	bvs L06cb	; 
	bit $fc60	; 
	bvs L06ce	; 
L06cb	jmp $ff48	; 

L06ce	jmp $fa2c	; 

L06d1	lda #$40	; 
	sta HA_ctrl	; 
	pla		; 
	sta $802f	; 
	pla		; 
	sta $802e	; 
	pla		; 
	sta $802d	; 
	pla		; 
	sta $802c	; 
	pla		; 
	sta $8028	; 
	pla		; 
	rti		; 

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

	; and we disappear into the ether
