
;**************************************
;*   _  _    _     _                    _         _           _                             
;*  | || |_ | | __| |__    ___    ___  | |_  ___ | |_  _   _ | |__     __ _  ___  _ __ ___  
;*  | || __|| |/ /| '_ \  / _ \  / _ \ | __|/ __|| __|| | | || '_ \   / _` |/ __|| '_ ` _ \ 
;*  | || |_ |   < | |_) || (_) || (_) || |_ \__ \| |_ | |_| || |_) |_| (_| |\__ \| | | | | |
;*  |_| \__||_|\_\|_.__/  \___/  \___/  \__||___/ \__| \__,_||_.__/(_)\__,_||___/|_| |_| |_|
;*                                                                                          
;* This program initializes the host adapter, the disk at SCSI id 0, and
;*  bootstraps the system.  There are a few sanity checks along the way too.
;*


; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

	.include "../include/relocate.asm"	; provides the #relocate and #endr macros.


	; Set the assembler up to build ltkbootstub for execution at $cd00
	#relocate $cd00	


DOSSTART            
	clc
	bcc STARTUP
	
serialNumBuffer
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
          
STARTUP   ; copies the serial # to $cd03          
	ldy #$07
sncopyloop
	lda romSerialNumAddr,y
	sta serialNumBuffer,y
	dey
	bpl sncopyloop
                    
	jsr Delay

	ldx #$08
	lda #$01
	sta HA_data
Lcd20	cmp HA_data	; Look for the host adapter at IO2
	bne IOAddrRewrite ; Not found, look at IO1
	clc
	rol HA_data
	rol a
	dex
	bne Lcd20
	
	lda #>IO2
	bne NoRelocate
	
ShutdownAndReboot_1
	jmp ShutdownAndReboot
	
;This routine rewrites the dos to use IO1 instead of IO2	
IOAddrRewrite   
	ldx #$08
	lda #$01
	sta $de00
Lcd3b	cmp $de00	; Look for the host adapter at IO1
	bne ShutdownAndReboot_1; Not found, turn things off and reboot
	clc
	rol $de00
	rol a
	dex
	bne Lcd3b
	
	lda #<DOSSTART	; Prep to rewrite this boot stub for IO1 instead of IO2
	sta $31
	lda #>DOSSTART
	sta $32
	
IOAddrRewrite_loop
	ldy #$00
	jsr GetByteAtZP31Y
	cmp #OPCODE_STA
	beq CheckForIO2Addr
	cmp #OPCODE_STX
	beq CheckForIO2Addr
	cmp #OPCODE_STY
	beq CheckForIO2Addr
	cmp #OPCODE_LDA
	beq CheckForIO2Addr
	cmp #OPCODE_LDX
	beq CheckForIO2Addr
	cmp #OPCODE_LDY
	beq CheckForIO2Addr
	cmp #OPCODE_BIT
	bne NoOpcodeRewrite

CheckForIO2Addr
	jsr GetByteAtZP31Y
	cmp #$04
	bcs NoOpcodeRewrite
	jsr GetByteAtZP31Y
	cmp #>IO2
	bne NoOpcodeRewrite
	lda #>IO1
	dey
	sta ($31),y
	lda $31
	clc
	adc #$03
	sta $31
	bcc Lcd8f
	inc $32
Lcd8f	clc
	bcc IOAddrRewrite_loop

NoOpcodeRewrite
	inc $31
	bne Lcd98
	inc $32
Lcd98
	lda $32
	cmp #$d0
	bne IOAddrRewrite_loop
	lda $31
	cmp #$00
	bcc IOAddrRewrite_loop
	lda #>IO1
	
NoRelocate		;so any needed changes from IO2->IO1 in our DOS are done now, and we carry on 
	sta $0400	; Host adapter address high page gets stored at $0400

	lda #$30
			;0011 0000
			;00	; irq off
			;110	; cb2 low
			;0	; ddr on
			;00	; cb1 high
	sta HA_ctrl_cr
	lda #$70
	sta HA_ctrl
	lda #$34
			;0011 0100
			;00	; irq off
			;110	; cb2 low
			;1	; port register on
			;00	; cb1 high
	sta HA_ctrl_cr
	lda #$40
	sta HA_ctrl
	lda #$3c
                        ;0011 1100
                        ;00     ; irq off
                        ;111    ; cb2 high
                        ;1      ; port register on
                        ;00     ; cb1 high

	sta HA_ctrl_cr
	lda #$30
			;0011 0000
			;00	; irq off
			;110	; ca2 low
			;0	; ddr on
			;00	; ca1 high

	sta HA_data_cr
	lda #$00
	sta HA_data	; set data port as input
	lda #$34
                        ;0011 0100
                        ;00     ; irq off
                        ;110    ; ca2 low
                        ;1      ; port register on
                        ;00     ; ca1 high

	sta HA_data_cr
	jsr SCSI_SELECT

	lda #$7f
	sta HA_data
	lda #$60	;0110 0000 = ATN and (unknown, bit 6 FIXME etc)
	sta HA_ctrl

	ldx #$00
Lcde0	inx
	bne Lcde0
Lcde3	inx
	bne Lcde3	; a short delay.

	lda #$40	;0100 0000 = ATN only
	sta HA_ctrl
	lda #$30
	sta $31
	lda #$00
	sta $32		; $3000
	beq Lcdf8	; always jumps (LDA #00 above)

Lcdf5	jsr Delay

	; read the bus until there's no more data to get (aka pretend to listen so they'll shut up)
Lcdf8	lda HA_ctrl	; get bus status
	and #$08	; check BUSY
	bne Lce04	; bus is free, so proceed.
	jsr SCSI_ACK	; send ack pulse to clear things up?
	bne Lcdf8	; always jumps (SCSI_ACK always returns nonzero)

Lce04	jsr SCSI_TEST_UNIT_READY
	beq Lce13	; unit is ready
	inc $32
	bne Lcdf8	; retry right away
	dec $31
	bne Lcdf5	; delay a bit and retry
	beq Lce30	; will always be taken (shutdown and reboot)

Lce13	lda #$0f	; Drive tested ready
	sta $31
	jsr SCSI_REZERO_UNIT
	lda #$00
	sta $32
	beq Lce23	; always taken (lda #0)

Lce20	jsr Delay

Lce23	jsr SCSI_TEST_UNIT_READY
	beq Lce32
	inc $32
	bne Lce23
	dec $31
	bne Lce20
Lce30               beq ShutdownAndReboot

Lce32	inc TransCt	;Transfer count =1
	
	lda #$e0	; read operation destination is $91e0
	sta $31
	lda #$91
	sta $32
	
	lda #$34
			;0011 0100
			;00	irq off
			;110	cb2 low
			;1	port register on
			;00	cb1 high
	sta HA_ctrl_cr	; set up SCSI port for read operation
	
	lda $0400	; dummy read: SCSI_READ immediately reloads .A
	sta $9e43
	jsr SCSI_READ	; read sector 0 (SYSTEMTRACK sector) to $91e0-$93df
	
	bne ShutdownAndReboot
	
	ldy #$0a	; Check for SYSTEMTRACK signature
systrack_check_loop
	lda sysTrackText,y
	cmp $91e0,y
	bne ShutdownAndReboot	; Failed.
	dey
	bpl systrack_check_loop

	ldy #$07	; Here's the first serial # check
snumcheckloop
	lda serialNumBuffer,y
	sta $8fd4,y	; check the copy from ROM
	cmp $93d4,y	; against the copy from disk
	bne lockUp	; failed match
	dey
	bpl snumcheckloop
                    
	lda #$e0
	sta $31
	lda #$93
	sta $32		;read destination is $93e0
	
	lda #$28
	sta LBA_lsb
	jsr SCSI_READ	;Read LBA $000028 (convrtio.r) to $93e0-$95df
	inc TransCt	; two blocks to read
	lda #$0f
	sta LBA_lsb
	
	lda #$00	;read destination is $0400
	sta $31
	lda #$04
	sta $32
	
	jsr SCSI_READ	;Read LBA $00000f (sysbootr.r) to $0400-07ff (two blocks)
	jmp $0400	; STAGE ONE BOOTSTRAP COMPLETE.
                    
			; This is where it goes if the serial #s don't match

lockUp			; make a rainbow to indicate serial number failure.
	inc vBorderCol
	bne lockUp
	beq lockUp
                    
ShutdownAndReboot
	lda #$3c
                        ;0011 1100
                        ;00     ; irq off
                        ;111    ; ca2 high
                        ;1      ; port register on
                        ;00     ; ca1 high

	sta HA_ctrl_cr
	lda #$40
                        ;0010 0000
                        ;00     ; irq off
                        ;100    ; handshake [ca2: pulse low on read; cb2: go low on write]
                        ;0      ; ddr on
                        ;00     ; ca1 high

	sta HA_ctrl
	lda #$00
	sta $8004
	jmp $fce2
                    
GetByteAtZP31Y
	lda ($31),y
	iny
	rts
                    
Delay
	lda #$00
	tax
	ldy #$02
delay_loop
	sec
	adc #$00
	bne delay_loop
	inx
	bne delay_loop
	dey
	bne delay_loop
	rts
                    
SCSI_REZERO_UNIT
	lda #SCSI_OPCODE_REZERO_UNIT
	.byte $2c  ;bit used to negate the next lda
SCSI_TEST_UNIT_READY
	lda #$00	; test unit ready
	sta CDBBuffer	; fill out the CDB
	jsr SCSI_SELECT	; select id 0
	bne Lcf0b	;  fail out if necessary
	ldx #$06	; 6 bytes
	ldy #$00	; start at beginning
	jsr SendCDB	; send the command
	jsr SCSI_Done	;  and get the status
	txa		; status to .A
	rts		; finished.
                    
                    ; Operation code for SCSI (8) is READ(6)
SCSI_READ
	lda #SCSI_OPCODE_READ
	sta CDBBuffer
	jsr SCSI_SELECT	; select disk
	bne Lcf0b	; return z=1 if fail
	ldx #$06	; length of this cdb
	ldy #$00	; start at beginning of CDB buffer
	jsr SendCDB	; send command
	ldy #$00
	jsr HA_SetDatIn	; get off the data bus
	lda #$2c
                        ;0010 1100
                        ;00     ; irq off
                        ;101    ; handshake [ca2: pulse low on read; cb2: go low on write]
                        ;1      ; port register on
                        ;00     ; ca1 high

	sta HA_data_cr
Lcef2	lda HA_ctrl	; check for REQ from hdd (ready to go)
	bmi Lcef2	;  wait for it
	and #$04
	beq Lcf07
	lda HA_data	; get a byte from the drive
	sta ($31),y	; store it in our outbuffer
	iny		; increment write index
	bne Lcef2
	inc $32		; and optionally fix high byte of pointer
	bne Lcef2	; should never fail to loop (SHOULD...)

Lcf07	jsr SCSI_Done	; clean up and get status
	txa
Lcf0b	rts
                    
SCSI_SELECT
	lda #$3c	; retries
	sta $34
	jsr HA_SetDataOut
	lda #$fe	;1111 1110 = select scsi id 0
	sta HA_data	; assert target id (=0)
	lda #$50	; assert atn+sel (ltk_hw_equates)
	sta HA_ctrl
Lcf1d	ldx #$00
Lcf1f	lda HA_ctrl	; off the bus
	and #$08	; check for req
	beq Lcf3a	; asserted, jump out of the loop
	inx
	bne Lcf1f	; keep looking for a bit
	dec $34
	bne Lcf35	; delay a bit and retry
	lda #$40	; take the adapter offline
	sta HA_ctrl
	jmp ShutdownAndReboot ; and fail.

Lcf35	jsr Delay	; delay
	beq Lcf1d	; retry selection

Lcf3a	ora #$40	; assert c/d, we have the target's attention
	sta HA_ctrl
	lda #$00
	rts		; return with z=1
                    
SendCDB   ;# of bytes in x, offset in y
	jsr CTSWait
	lda CDBBuffer,y
	; It inverts all writes to the drive? wtf
	eor #$ff	; the host adapter inverts data on the way out, so invert it ahead of time to fix.
	sta HA_data
	jsr SCSI_ACK	; pulse ACK so the hdd knows there's a byte on the bus
	iny
	dex
	bne SendCDB
	jsr CTSWait
	rts
                    
HA_SetDatIn
	ldx #$00
	.byte $2c	; skip ldx #ff
HA_SetDataOut
	ldx #$ff
	lda #$38	; turn DDR on
	sta HA_data_cr
	stx HA_data
	lda #$3c	; turn DDR off
	sta HA_data_cr
	rts
                    
CTSWait
	lda HA_ctrl
	bmi CTSWait
	rts
                    
	; Assuming this is some PIA twiddlery to handle the actual send to the bus
SCSI_ACK
	lda #$2c	; enable pulse on reading the bus
	sta HA_data_cr
	lda HA_data
	lda #$3c	; back to normal (no pulse on read)
	sta HA_data_cr
	rts
                    
SCSI_Done
	jsr HA_SetDatIn
	jsr SCSI_GetStatus
	and #$9f
	tax

SCSI_GetStatus
	jsr CTSWait
	lda HA_data
	eor #$ff
	tay
	jsr SCSI_ACK
	tya
	rts
                    
CDBBuffer	; cf96.  Labels are for READ(6) and WRITE(6) codes.
	.byte $00	; SCSI opcode
	.byte $00	; SCSI LBA mmsb
	.byte $00	; SCSI LBA msb
LBA_lsb	.byte $00	; SCSI LBA lsb
TransCt	.byte $00	; SCSI transfer count
	.byte $00	; SCSI control field

sysTrackText
	.screen "SYSTEMTRACK"

	; reset the assembler back to normal
	#endr
