
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
	sta $df00
Lcd20
	cmp $df00
	bne IOAddrRewrite
	clc
	rol $df00
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
Lcd3b
	cmp $de00
	bne ShutdownAndReboot_1
	clc
	rol $de00
	rol a
	dex
	bne Lcd3b
	
	lda #<DOSSTART
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
Lcd8f
	clc
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
	
	;so any needed changes from IO2->IO1 in our DOS are done now, and we carry on 
NoRelocate
	sta $0400
	lda #$30
	sta $df03
	lda #$70
	sta $df02
	lda #$34
	sta $df03
	lda #$40
	sta $df02
	lda #$3c
	sta $df03
	lda #$30
	sta $df01
	lda #$00
	sta $df00
	lda #$34
	sta $df01
	jsr Scf0c
	lda #$7f
	sta $df00
	lda #$60
	sta $df02
	ldx #$00
Lcde0
	inx
	bne Lcde0
Lcde3
	inx
	bne Lcde3
	lda #$40
	sta $df02
	lda #$30
	sta $31
	lda #$00
	sta $32
	beq Lcdf8
Lcdf5
	jsr Delay
Lcdf8
	lda $df02
	and #$08
	bne Lce04
	jsr Scf71
	bne Lcdf8
Lce04
	jsr SCSI_TEST_UNIT_READY
	beq Lce13
	inc $32
	bne Lcdf8
	dec $31
	bne Lcdf5
	beq Lce30
Lce13
	lda #$0f
	sta $31
	jsr SCSI_REZERO_UNIT
	lda #$00
	sta $32
	beq Lce23
Lce20
	jsr Delay
Lce23
	jsr SCSI_TEST_UNIT_READY
	beq Lce32
	inc $32
	bne Lce23
	dec $31
	bne Lce20
Lce30               
	beq ShutdownAndReboot
Lce32
	inc CDBBuffer+4  ;increment transfer length?
	
	lda #$e0    ; read operation destination is $91e0
	sta $31
	lda #$91
	sta $32
	
	lda #$34
	sta $df03
	
	lda $0400
	sta $9e43
	jsr SCSI_READ	
	
	bne ShutdownAndReboot
	
	ldy #$0a
	; This is where it checks the block it just read to see if it's LTK DOS
systrack_check_loop
	lda sysTrackText,y
	cmp $91e0,y
	bne ShutdownAndReboot
	dey
	bpl systrack_check_loop

	; Here's the first serial # check
	ldy #$07
snumcheckloop
	lda serialNumBuffer,y
	sta $8fd4,y
	cmp $93d4,y
	bne lockUp
	dey
	bpl snumcheckloop
                    
	lda #$e0
	sta $31
	lda #$93
	sta $32     ;read destination is $93e0
	
	lda #$28
	sta CDBBuffer+3
	jsr SCSI_READ     ;Not sure what we're reading here, but it's at LBA 0x0028
	inc $cf9a
	lda #$0f
	sta $cf99
	
	lda #$00    ;read destination is $0400
	sta $31
	lda #$04
	sta $32
	
	jsr SCSI_READ
	jmp $0400
                    
                    ; This is where it goes if the serial #s don't match
lockUp
	inc vBorderCol
	bne lockUp
	beq lockUp
                    
ShutdownAndReboot
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
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
	lda #$00
	sta CDBBuffer
	jsr Scf0c
	bne Lcf0b
	ldx #$06
	ldy #$00
	jsr SendCDB
	jsr Scf7f
	txa
	rts
                    
                    ; Operation code for SCSI (8) is READ(6)
SCSI_READ
	lda #SCSI_OPCODE_READ
	sta CDBBuffer
	jsr Scf0c
	bne Lcf0b
	ldx #$06    ;length of this cdb
	ldy #$00    ;start at beginning of CDB buffer
	jsr SendCDB
	ldy #$00
	jsr Scf58
	lda #$2c
	sta $df01
Lcef2
	lda $df02
	bmi Lcef2
	and #$04
	beq Lcf07
	lda $df00	;read a byte from the PIA?
	sta ($31),y	;store it in our outbuffer
	iny
	bne Lcef2
	inc $32
	bne Lcef2
Lcf07
	jsr Scf7f
	txa
Lcf0b
	rts
                    
Scf0c               
	lda #$3c
	sta $34
	jsr Scf5b
	lda #$fe
	sta $df00
	lda #$50
	sta $df02
Lcf1d
	ldx #$00
Lcf1f
	lda $df02
	and #$08
	beq Lcf3a
	inx
	bne Lcf1f
	dec $34
	bne Lcf35
	lda #$40
	sta $df02
	jmp ShutdownAndReboot
Lcf35
	jsr Delay
	beq Lcf1d
Lcf3a
	ora #$40
	sta $df02
	lda #$00
	rts
                    
SendCDB   ;# of bytes in x, offset in y
	jsr CTSWait
	lda CDBBuffer,y
	; It inverts all writes to the drive? wtf
	eor #$ff
	sta $df00
	jsr Scf71
	iny
	dex
	bne SendCDB
	jsr CTSWait
	rts
                    
Scf58
	ldx #$00
	.byte $2c
Scf5b
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
                    
CTSWait
	lda $df02
	bmi CTSWait
	rts
                    
	; Assuming this is some PIA twiddlery to handle the actual send to the bus
Scf71
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
Scf7f
	jsr Scf58
	jsr Scf88
	and #$9f
	tax
Scf88
	jsr CTSWait
	lda $df00
	eor #$ff
	tay
	jsr Scf71
	tya
	rts
                    
CDBBuffer
	.byte  $00,$00,$00,$00,$00,$00 
sysTrackText
	.screen "SYSTEMTRACK"
