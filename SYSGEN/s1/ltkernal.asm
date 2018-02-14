;ltkernal.r.prg
;re-sourced and cleaned by Six/DLoC (Oliver VieBrooks)
;February 2018

	.include "../../include/ltk_equates.asm"
	*=$8000 	;rewrite start address to $4000 for sysgen disk
	
;=============================================================================
;   LTK_Var_ActiveLU-$8038 VARIABLE STORAGE SPACE
;=============================================================================
LTK_SysVarBase

LTK_Var_ActiveLU 		;$8000 current active logical unit 
	.byte $0a 		;Default Active LU = 10

LTK_Var_Active_User 		;$8001 current active user
	.byte $00 		;Default Active User = 0

	.byte $00,$00,$00 	;Some unused/unknown space 

LTK_Var_OrigCR 			;$8005 original c.r. saved on initial entry from a trap *
	.byte $ea
LTK_Unused_Byte			;$8006 currently unused byte (reserved for future use) (wtf with this)	
	.byte $ea

LTK_DiskRWControl		;$8007 disk driver read/write loop control switch
	.byte $ea 

LTK_Var_CPUMode 		;$8008 cpu mode switch (0=c64  <>0=c128)
	.byte $00 

LTK_Var_BASIC_ExtVec 		;$8009 basic extensions vector
	.byte $58,$81

LTK_Var_Ext_RetVec 		;$800b return vector used when calling external routines
	.byte $03,$81 

LTK_Var_Kernel_Basin_Vec 	;$800d vector to lt kernal basin wedge *
	.byte $0e,$82

save_registers               
	sta LTK_Save_Accu
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	php
	php
	pla
	sta LTK_Save_P
	lda LTK_Save_Accu
	plp
	rts
                    
LTK_Var_Go64_Vec 		;$8023 vextor to the go c64 routine
	.byte $ea,$ea
	
LTK_Var_SAndRData 		;$8025 file's lu# & hdr. blk. adr. - used for save & replace 
	.byte $ff,$ff,$ff
	
LTK_Var_CurRoutine 		;$8028 current kernal routine continuation number	
	.byte $00 
	
LTK_BeepOnErrorFlag 		;$8029 beep on error flag (0=no beep)
	.byte $01 
	
LTK_HD_DevNum			;$802a Current LTK HD Device # (CBM DOS Drive #)
	.byte $08 
	
LTK_ErrorTrapFlag		;$802b location of error trap flag
	.byte $00 
	
LTK_Save_Accu			;$802c save location of 'a' for all 'lk' traps	
	.byte $00 
	
LTK_Save_XReg			;$802d save location of 'x' for all 'lk' traps
	.byte $00 
	
LTK_Save_YReg			;$802e save location of 'y' for all 'lk' traps	
	.byte $00
	
LTK_Save_P			;$802f save location of 'p' for all 'lk' traps
	.byte $00 
	
LTK_AutobootFlag		;$8030 autoboot flag
	.byte $00 
	
LTK_BLKAddr_DosOvl		;$8031 blk. adr. of current dos overlay	
	.byte $00 

LTK_BLKAddr_MiniSub		;$8032 blk. adr. of current mini-sub
	.byte $00 
	
LTK_CTPOffsetCounter		;$8033 offset counter used for command tail processing
	.byte $00 
	
LTK_Save_PreconfigC		;$8034 temp. storage for preconfiguration register 'c'
	.byte $00 
	
LTK_Save_PreconfigD		;$8035 temp. storage for preconfiguration register 'd'
	.byte $00 

LTK_ReadChanFPTPtr		;$8036 current read channel fpt pointer
	.byte $ff

LTK_WriteChanFPTPtr		;$8037 current write channel fpt pointer
	.byte $ff 
	
LTK_Default_CPU_Speed		;$8038 ;default cpu speed (0=1mhz  1=2mhz)
	.byte $00 
	
;=============================================================================
;   VECTOR TABLE
;=============================================================================
LTK_KernalTrapSetup 		;$8039 kernal call setup for use trapped kernal routines               
	jmp kernal_trap_setup
	
LTK_KernalTrapRemove		;$803c kernal call setup for use of non-trapped kernal routines
	jmp kernal_trap_remove
                    
LTK_KernalCall 			;$803f kernal calling routine  
	jmp kernal_call
                    
LTK_ReadFileEntry_AB 		;$8042 read file entry for auto-boot sequence ** 
	jmp read_file_entry_autoboot
                    
LTK_HDDiscDriver		;$8045 hard drive disc driver routine (for reads & writes)
	jmp hdd_driver
                    
LTK_Print               	;$8048 character output routine
	jmp ltkprint  	
                    
LTK_FindFile			;$804b find file routine
	jmp find_file
                    
LTK_LoadRandFile		;$804e load random block list type file               
	jmp load_rand_file
                    
LTK_ErrorHandler		;$8051 error handler routine
	jmp error_handler
                    
LTK_CheckDevNum			;$8054 check for hard disk device number routine
	jmp check_device_number
                    
LTK_SysRet_AsIs    		;$8057 system return - 'rts' with current registers as is           
	jmp sysret_asis
                    
LTK_SysRet_OldRegs		;$805a system return - 'rts' with original registers
	jmp sysret_oldregs
                    
LTK_SysRet_LKRT_AsIs		;$805d system return - 'via lkrtnm' with registers as is
	jmp sysret_lkrt_asis
                    
LTK_SysRet_LKRT_OldRegs		;$8060 system return - 'via lkrtnm' with registers
	jmp sysret_lkrt_oldregs
                    
LTK_SysRet_AbsJmp		;$8063 system return - 'abs jmp' with registers as on entry
	jmp sysret_abs_jmp
                    
LTK_SaveRegs               	;$8066 register save routine
	jmp save_registers
                    
LTK_LoadRegs               	;$8069 register load routine
	jmp load_registers
                    
LTK_ClearHeaderBlock          	;$806c 'hdrblk' area clearing routine     
	jmp clear_header_block
                    
LTK_DosWedgeReturn		;$806f doswedge returns here if another dos ovly is called 
	jmp dos_wedge_return
                    
LTK_TPMultiply			;$8072 triple precision multiply routine
	jmp tp_multiply
                    
LTK_KernalCall2               	;$8075 a kercal for use by type 3 trapped calls ** 
	jmp kernal_call
                    
LTK_AllocateRandomBlks  	;$8078 alocate random blocks             
	jmp allocate_random_blocks
                    
LTK_AllocContigBlks		;$807b ;alocate contiguous blocks
	jmp allocat_contig_blocks
                    
LTK_AppendBlocks        	;$807e append block(s) to file       
	jmp append_blocks
                    
LTK_DeallocateRndmBlks		;$8081 deallocate blocks of a random type file
	jmp deallocate_random_blocks
                    
LTK_DeallocContigBlks		;$8084 deallocate blocks of a contiguous type file
	jmp deallocate_contig_blocks
                    
LTK_MLReturn			;$8087 machine language return
	jmp ml_return
                    
LTK_LoadContigFile    		;$808a load contiguous type file           
	jmp load_contig_file
                    
LTK_CmdChnProcess		;$808d command channel processor
	jmp cmd_channel_process
                    
LTK_ProcessDirectory		;$8090 disk directory processor
	jmp process_directory
                    
LTK_CallExtDosOvl		;$8093 entry point for calling an extended dos overlay
	jmp call_extended_dos_overlay
                    
LTK_MemSwapOut			;$8096 memory/disk swapper routine
	jmp mem_swap
                    
LTK_SetLuActive               	;$8099 set an lu active
	jmp set_lu_active
                    
LTK_ExeExtMiniSub               ;$809c entry point for calling an extended mini-sub
	jmp exe_ext_minisub
                    
LTK_CmdChnPosition              ;$809f entry point for command channel position command
	jmp cmd_chn_pos
                    
LTK_SwapWriteBuffer		;$80a2 entry point for swap 'write' buffer routine           
	jmp swap_write_buffer
                    
LTK_FatalError               	;$80a5 "fatal error handler" is just a lockup
	jmp LTK_FatalError

;=============================================================================
;   PARAMETER TABLE
;=============================================================================
LTK_LU_Param_Table  ;$80a8 ram resident lu parameter table
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff 
	.byte $ff,$ff

;=============================================================================
;   CODE
;=============================================================================               
kernal_trap_setup
	bcs L80f8
        ldy LTK_Var_CurRoutine
                    
kernal_trap_remove
	cpy #$14
	bcs L80eb
	ldx $031a,y
	lda $031b,y
	bcc L80f7
L80eb
	bne L80f3
	ldx #$9e
	lda #$f4
	bne L80f7
L80f3
	ldx #$dd
	lda #$f5
L80f7
	tay
L80f8
	lda #$20
	sta $fc45
	stx $fc46
	sty $fc47
	rts
                    
sysret_asis
	sta LTK_Save_Accu
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	php
	pla
	sta LTK_Save_P
sysret_oldregs
	lda #$60
	bne L812a
sysret_lkrt_asis
	sta LTK_Save_Accu
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	php
	pla
	sta LTK_Save_P
sysret_lkrt_oldregs
	clc
	jsr kernal_trap_setup
sysret_abs_jmp
	lda #$4c
L812a
	sta $fc45
	lda LTK_Save_P
	pha
	lda LTK_Save_Accu
	pha
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
	jmp $fc3d
                    
kernal_call
	php
	pha
	jmp $fc3d
	
load_registers
	lda LTK_Save_P
	pha
	lda LTK_Save_Accu
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
	plp
	rts
                    
set_lu_active
	tax
	bpl L8196
L8155
	lda #$1a
	.byte $2c
L8158
	lda #$23
	.byte $2c
find_file
	lda #$11
	.byte $2c
load_rand_file
	lda #$12
	.byte $2c
error_handler
	lda #$13
	.byte $2c
load_contig_file
	lda #$14
	.byte $2c
allocate_random_blocks
	lda #$15
	.byte $2c
allocat_contig_blocks
	lda #$16
	.byte $2c
append_blocks
	lda #$17
	.byte $2c
deallocate_random_blocks
	lda #$18
	.byte $2c
deallocate_contig_blocks
	lda #$19
	
exe_ext_minisub               
	cmp LTK_BLKAddr_MiniSub
	beq L8193
L817a
	sta LTK_BLKAddr_MiniSub
	txa
	pha
	tya
	pha
	lda #$0a
	ldx LTK_BLKAddr_MiniSub
	ldy #$00
	clc
	jsr hdd_driver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 
L818f
	pla
	tay
	pla
	tax
L8193
	jmp LTK_MiniSubExeArea
                    
L8196
	cmp #$0a
	beq L81a6
	bcc L819e
L819c
	sec
	rts
                    
L819e
	jsr S81ab
	lda LTK_LU_Param_Table,y
	bmi L819c
L81a6
	stx LTK_Var_ActiveLU
	clc
	rts
                    
S81ab
	sta $81b2
	asl a
	asl a
	clc
	adc #$00
	tay
	rts
                    
S81b5
	lda #$4c
	.byte $2c 
S81b8
	lda #$50
	.byte $2c 
S81bb
	lda #$54
	.byte $2c 
S81be
	lda #$58
	.byte $2c 
cmd_channel_process
	lda #$5c
	.byte $2c 
process_directory
	lda #$60
	.byte $2c 
S81c7
	lda #$6a
	ldx #$03
call_extended_dos_overlay
	cmp LTK_BLKAddr_DosOvl
	beq L81e2
	sta LTK_BLKAddr_DosOvl
	stx $81e1
	tax
	ldy #$00
	lda #$0a
	clc
	jsr hdd_driver
	.byte <LTK_DOSOverlay,>LTK_DOSOverlay,$00 
L81e2 
	rts
                    
mem_swap
	bcc L81ee
	sta $8206
	stx $8204
	sty $8205
L81ee
	php
	jsr LTK_GetPortNumber
	asl a
	asl a
	asl a
	ldy #$02
	clc
	adc #$ae
	bcc L81fd
	iny
L81fd
	tax
	lda #$0a
	plp
	jsr hdd_driver
	.byte $00,$00,$00 
                    
L8207
	ldx $8204
	ldy $8205
	rts
                    
L820e
	sta LTK_Save_Accu
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	php
	pla
	sta LTK_Save_P
	pla
	sec
	sbc #$c2
	tay
	pla
	lda $82b6,y
	sta LTK_Var_CurRoutine
	lda $82b5,y
	pha
	lda L82b4,y
	pha
	rts
                    
L8231
	tay
	bne L8294
	clc
	jsr kernal_trap_setup
	lda LTK_Save_P
	pha
	lda LTK_Save_Accu
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
	plp
	jsr LTK_KernalCall
	sta LTK_Save_Accu
	stx LTK_Save_XReg
	sty LTK_Save_YReg
	php
	pla
	sta LTK_Save_P
	lda LTK_Save_Accu
	cmp #$0d
	beq L8261
L825e
	jmp sysret_oldregs
                    
L8261
	lda $9d
	bpl L825e

read_file_entry_autoboot               
	jsr S81b5
	jmp $95e0
                    
dos_wedge_return
	jsr S82a7
	lda LTK_CTPOffsetCounter
	jsr $95e0
	lda #$00
	sta idx64
	sta $0200

ml_return
	jsr load_registers
	clc
	lda #$0d
	jmp sysret_asis
                    
check_device_number
	php
	pha
	lda $ba
	cmp LTK_HD_DevNum
	bne L8290
	pla
	plp
	rts
                    
L8290
	pla
	pla
	pla
	pla
L8294
	jmp sysret_lkrt_oldregs
                    
clear_header_block
	lda #$00
	tay
L829a
	sta LTK_FileHeaderBlock,y
	iny
	bne L829a
L82a0
	sta $92e0,y
	iny
	bne L82a0
	rts
                    
S82a7
	lda $91f8
	cmp #$0a
	bcs L82b1
	jmp LTK_LoadContigFile
                    
L82b1
	jmp LTK_LoadRandFile
                    
L82b4               
	.byte $e9,$82,$00
	.byte $f1,$82,$02
	.byte $17,$85,$04
	.byte $34,$85,$06 
	.byte $68,$88,$08 
	.byte $a4,$85,$0a 
	.byte $e1,$85,$0c 
	.byte $0d,$83,$14 
	.byte $15,$83,$16 
	.byte $00,$00,$00 
	.byte $00,$00,$00 
	.byte $00,$00,$00 
	.byte $a4,$85,$10 
	.byte $1a,$83,$12 
	.byte $00,$00,$00 
	.byte $00,$00,$00 
	.byte $01,$00,$00 
	.byte $00,$00,$00
	
L82ea
	jsr check_device_number
	jsr S81b8
L82f0
	beq L8321
	jsr load_registers
	tax
	jsr S857d
	bcs L8294
	and #$0f
	tay
	txa
	pha
	cpy #$0f
	bne L8307
	jsr S8669
L8307
	jsr S81bb
	pla
	jmp $95e3
                    
L830e
	jsr check_device_number
	jsr S81c7
	beq L8321
	jsr S81be
	beq L8321
	jsr S8669
	jsr S81bb
L8321
	jmp $95e0
                    
hdd_driver
	and #$3f
	stx $8004
	stx $82e3
	sty $8003
	sty $82e2
	ldx #$08
	bcc L8338
	ldx #$0a
L8338
	stx $82e0
	ldx #$00
	stx $82e1
	stx $82d0
	ldx #$fe
	stx S846d + 1
	ldx #$0a
	sta $8002
	sta $8349
	cmp #$0a
	bne L8378
	tya
	bne L83cd
	ldy $8004
	cpy #$11
	bcc L83cd
	cpy #$ee
	bcs L83cd
	dec $82d0
	cpx #$0a
	beq L83cd
	txa
	jsr S81ab
	lda $80aa,y
	and #$08
	beq L83cd
	txa
	inc $82e2
L8378
	sta $8349
	jsr S81ab
	lda LTK_LU_Param_Table,y
	pha
	pha
	and #$1c
	lsr a
	lsr a
	tax
	beq L8391
L838a
	sec
	rol S846d + 1
	dex
	bne L838a
L8391
	pla
	and #$60
	sta $82e1
	pla
	and #$03
	tax
	lda $80ac,y
	sta $83b2
	lda $80a9,y
	pha
	lda $80aa,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	pla
	jsr tp_multiply
	ldy #$00
	jsr tp_multiply
	clc
	adc $82e3
	sta $82e3
	txa
	adc $82e2
	sta $82e2
	lda $82d2
	adc $82e1
	sta $82e1
L83cd               
	pla
	sta S8468 + 1
	pla
	sta S8468 + 2
	lda $31
	pha
	lda $32
	pha
	ldy #$01
	jsr S8468
	sta $31
	jsr S8468
	sta $32
	jsr S8468
	sta $82e4
	tya
	tax
	jsr S8468
	cmp #$b2
	bne L8404
	jsr S8468
	cmp #$c2
	bne L8404
	jsr S8468
	cmp #$d2
	beq L8412
L8404
	txa
	tay
	lda $82e0
	cmp #$08
	beq L8412
	lda $82d0
	bne L8442
L8412
	tya
	clc
	adc S8468 + 1
	sta S8468 + 1
	bcc L841f
	inc S8468 + 2
L841f
	jsr S849d
	jsr S846d
	bne L8442
	ldx #$06
	ldy #$00
	jsr S8486
	ldy #$00
	lda $82e0
	cmp #$08
	beq L8445
	lda #$2c
	sta $df01
	jsr $fc65
	jmp L8450
                    
L8442               
	jsr LTK_FatalError
L8445
	jsr S849a
	lda #$2c
	sta $df01
	jsr $fc62
L8450
	jsr S84c1
	txa
	bne L8442
	pla
	sta $32
	pla
	sta $31
	lda $8002
	ldx $8004
	ldy $8003
	jmp (S8468 + 1)
                    
S8468  
	lda S8468,y
	iny
	rts
                    
S846d
	lda #$fe
	sta $df00
L8472
	lda #$50
	sta $df02
	lda $df02
	and #$08
	bne L8472
	lda #$40
	sta $df02
	lda #$00
	rts
                    
S8486
	jsr S84ad
	lda $82e0,y
	eor #$ff
	sta $df00
	jsr S84b3
	iny
	dex
	bne S8486
	beq S84ad
S849a
	ldx #$00
	.byte $2c 
S849d
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
                    
S84ad
	lda $df02
	bmi S84ad
	rts
                    
S84b3
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
                    
S84c1
	jsr S849a
	jsr S84ca
	and #$9f
	tax
S84ca
	jsr S84ad
	lda $df00
	eor #$ff
	tay
	jsr S84b3
	tya
	rts
                    
tp_multiply
	sta $84ea
	stx $84ee
	lda #$00
	sta $82d2
	tax
	cpy #$00
	beq L84f9
L84e8
	clc
	adc #$00
	pha
	txa
	adc #$00
	tax
	bcc L84f5
	inc $82d2
L84f5
	pla
	dey
	bne L84e8
L84f9
	rts
                    
ltkprint
	stx L8505 + 1
	sty L8505 + 2
	ldy #$0c
	jsr kernal_trap_remove
L8505
	lda L8505
	beq L8517
	jsr LTK_KernalCall
	inc L8505 + 1
	bne L8505
	inc L8505 + 2
	bne L8505
L8517
	rts
                    
L8518
	jsr S8564
	stx $82e6
	lda $ba
	sta $99
	bcs L855a
	cpx #$e0
	bne L855a
	lda $9dfc,x
	beq L855a
	ldy #$00
	jsr LTK_ErrorHandler
	clc
	bcc L855a
	jsr S8564
	lda $ba
	sta $9a
	lda $82e7
	sta $82e8
	stx $82e7
	cpx #$e0
	beq L854b
	bcs L855a
L854b
	lda $82e8
	cmp $82e7
	beq L855a
	cmp #$e0
	bne L855a
	jsr S8669
L855a
	clc
	lda $ba
	tax
	ldy LTK_Save_YReg
	jmp sysret_asis
                    
S8564
	jsr load_registers
	jsr S857d
	ldy #$00
	sty $90
	bcc L8575
	pla
	pla
	jmp sysret_lkrt_oldregs
                    
L8575
	jsr S8a8d
	bcc L857c
	ldx #$fe
L857c 
	rts
                    
S857d
	sec
	txa
	pha
	ldx #$14
	ldy #$f3
	jsr kernal_trap_setup
	pla
	jsr LTK_KernalCall
	beq L858f
L858d
	sec
	rts
                    
L858f
	lda $0259,x
	sta $b8
	ldy $0263,x
	sty $ba
	lda $026d,x
	sta $b9
	cpy LTK_HD_DevNum
	bne L858d
	clc
	rts
                    
L85a5
	lda $99
	cmp LTK_HD_DevNum
	bne L85df
	ldx $82e6
	lda $9df9,x
	cmp #$0f
	bne L85be
	lda $9dfa,x
	bmi L85be
	jsr S87d4
L85be
	ldy #$00
	jsr S88e6
	sta LTK_Save_Accu
	php
	cpx #$e0
	bne L85d6
	cmp #$0d
	bne L85d6
	lda #$40
	sta $90
	sta $9dfc,x
L85d6
	pla
L85d7
	and #$fe
	sta LTK_Save_P
	jmp sysret_oldregs
                    
L85df
	jmp L8231
                    
L85e2
	ldx $9a
	cpx LTK_HD_DevNum
	beq L8623
	cpx #$03
	bne L8620
	lda LTK_Save_Accu
	cmp #$52
	bne L8617
	tsx
	lda $0105,x
	cmp #$2f
	bne L8620
	lda $0106,x
	cmp #$ab
	bne L8620
	lda $22
	cmp #$76
	bne L8620
	lda $23
	cmp #$a3
	bne L8620
	lda #$ff
	jsr set_lu_active
	jmp sysret_lkrt_oldregs
                    
L8617
	cmp #$07
	bne L8620
	ldy #$ff
	jsr LTK_ErrorHandler
L8620
	jmp sysret_lkrt_oldregs
                    
L8623
	ldx $82e7
	stx $9de4
	lda $9df9,x
	cmp #$0f
	bne L8640
	lda $9dfa,x
	asl a
	bpl L8640
	lda #$44
	ldx #$03
	jsr LTK_CallExtDosOvl
	jsr $95e0
L8640
	lda $b9
	and #$0f
	cmp #$0f
	bne L865a
	lda LTK_Save_Accu
	ldx $87d2
	sta LTK_CMDChannelBuffer,x
	cpx #$29
	bcs L8660
	inc $87d2
	bne L8660
L865a
	lda LTK_Save_Accu
	jsr S8ab9
L8660
	lda LTK_Save_P
L8663
	jmp L85d7
                    
cmd_chn_pos
	stx $87d2
S8669
	ldx $87d2
	bne L866f
	rts
                    
L866f
	ldx #$00
	jsr S87c8
	cmp #$50
	beq L8684
	jsr cmd_channel_process
	lda $87d2
	jsr $95e0
	jmp L8704
                    
L8684
	jsr S87c8
	bcs L86ea
	and #$0f
	sta $87d3
	jsr S87c8
	bcs L86ea
	tay
	jsr S87c8
	bcs L86ea
	cmp #$00
	bne L86a2
	cpy #$00
	bne L86a2
	iny
L86a2
	sta $9e03
	sty $9e04
	jsr S87c8
	bcs L86ea
	tay
	jsr S87c8
	bcs L86b7
	cmp #$0d
	bcc L86b9
L86b7
	lda #$00
L86b9
	cpy #$00
	bne L86c1
	cmp #$00
	beq L86c9
L86c1
	dey
	cpy #$ff
	bne L86c9
	sec
	sbc #$01
L86c9
	sta $9e05
	sty $9de5
	ldx #$00
	ldy #$07
L86d3
	lda $9dff,x
	and #$0f
	cmp $87d3
	beq L86f5
	pha
	txa
	clc
	adc #$20
	tax
	pla
	dey
	bne L86d3
L86e7
	ldy #$46
	.byte $2c 
L86ea
	ldy #$1e
	.byte $2c
L86ed
	ldy #$40
	jsr LTK_ErrorHandler
	jmp L8704
                    
L86f5
	lda LTK_FileParamTable,x
	beq L86e7
	lda $9df9,x
	cmp #$0f
	bne L86ed
	jsr S870a
L8704
	lda #$00
	sta $87d2
	rts
                    
S870a
	stx $9de4
	lda $9e03
	ldy $9e04
	jsr S877f
	pha
	pha
	txa
	pha
	tya
	ldx $9de4
	sta $9df4,x
	sta $9ded,x
	pla
	tay
	pla
	clc
	adc $9df8,x
	sta $9df6,x
	tya
	adc $9df7,x
	sta $9df5,x
	bcc L873a
	inc $9df4,x
L873a
	pla
	clc
	adc $9de5
	sta $9def,x
	tya
	adc $9e05
	sta $9dee,x
	bcc L874e
	inc $9ded,x
L874e
	lda #$00
	tay
	sta $9dfc,x
	sta $9dfa,x
	lda $9e03
	cmp $9df2,x
	bcc L877c
	bne L8769
	lda $9e04
	cmp $9df3,x
	bcc L877c
L8769
	lda $9df4,x
	bne L8775
	lda $9df5,x
	cmp #$02
	bcc L8777
L8775
	ldy #$32
L8777
	lda #$40
	sta $9dfa,x
L877c
	jmp LTK_ErrorHandler
                    
S877f
	sta $87b2
	sta $9de1,x
	sty $87ae
	tya
	sta $9de2,x
	lda $9df7,x
	sta $9e23
	lda $9df8,x
	sta $9e24
	lda #$0c
	sta $9e25
	lda #$00
	sta $87b6
	tax
	tay
L87a4
	lsr $9e23
	ror $9e24
	bcc L87b9
	clc
	adc #$00
	pha
	txa
	adc #$00
	tax
	tya
	adc #$00
	tay
	pla
L87b9
	asl $87ae
	rol $87b2
	rol $87b6
	dec $9e25
	bne L87a4
	rts
                    
S87c8
	cpx $87d2
	bcs L87d1
	lda LTK_CMDChannelBuffer,x
	inx
L87d1
	rts
                    
	.byte $00,$00 
S87d4
	lda $9ded,x
	pha
	sta $9e23
	lda $9dee,x
	pha
	sta $9e24
	lda $9def,x
	pha
	sta $9e25
	lda #$00
	sta $9dfc,x
	lda $9df4,x
	sta $9ded,x
	lda $9df5,x
	sta $9dee,x
	lda $9df6,x
	sta $9def,x
L8800
	sec
	lda $9def,x
	sbc #$01
	sta $9def,x
	lda $9dee,x
	sbc #$00
	sta $9dee,x
	lda $9ded,x
	sbc #$00
	sta $9ded,x
	ldy #$ff
	jsr S88e6
	bne L883d
	lda $9e23
	cmp $9ded,x
	bne L8800
	lda $9e24
	cmp $9dee,x
	bne L8800
	lda $9e25
	cmp $9def,x
	bne L8800
	dec $9dfc,x
	bne L8845
L883d
	jsr S8a5e
	lda #$00
	sta $9dfc,x
L8845
	lda $9ded,x
	sta $9df4,x
	lda $9dee,x
	sta $9df5,x
	lda $9def,x
	sta $9df6,x
	pla
	sta $9def,x
	pla
	sta $9dee,x
	pla
	sta $9ded,x
	lda #$80
	sta $9dfa,x
L8868
	rts
                    
L8869
	lda $9a
	cmp LTK_HD_DevNum
	bne L8889
	ldx $82e7
	lda #$00
	sta $9a
	jsr S88a3
	lda $82e7
	cmp #$e0
	bne L8884
	jsr S8669
L8884
	lda #$ff
	sta $82e7
L8889
	lda $99
	cmp LTK_HD_DevNum
	bne L88a0
	ldx $82e6
	lda #$ff
	jsr S88a3
	ldx #$00
	stx $99
	dex
	stx $82e6
L88a0
	jmp sysret_lkrt_oldregs
                    
S88a3
	sta $88d6
	tay
	cpx #$ff
	beq L8868
	lda $9df9,x
	cmp #$0f
	bne L8868
	tya
	beq L88ba
	lda $9dfc,x
	beq L8868
L88ba
	lda $9de1,x
	tay
	lda $9de2,x
	clc
	adc #$01
	bcc L88c7
	iny
L88c7
	sty $9e03
	sta $9e04
	lda #$00
	sta $9e05
	sta $9de5
	ldy #$00
	bne L88de
L88d9
	jsr S8ab9
	bcc L88d9
L88de
	jsr S870a
	ldy #$00
	jmp LTK_ErrorHandler
                    
S88e6
	ldx $82e6
	stx $82d4
	sty $82de
	lda #$0d
	cpx #$fe
	bcc L88ff
	bne L88fc
	inc $82e6
	lda #$c7
L88fc
	jmp L8ab3
                    
L88ff
	lda $9dfe,x
	tay
	cmp #$24
	bne L8910
	jsr process_directory
	ldx $82d4
	jmp $95e0
                    
L8910
	lda $9dfc,x
	beq L891a
	sta $90
	lda #$0d
	rts
                    
L891a
	tya
	bmi L8931
	bne L8925
	lda $9de2,x
	jmp L892c
                    
L8925
	cmp #$01
	bne L8931
	lda $9de1,x
L892c
	inc $9dfe,x
	tay
	rts
                    
L8931
	lda #$e0
	ldy #$9e
	cpx #$e0
	beq L895a
	lda $9df9,x
	cmp #$0f
	bne L894e
	cpx LTK_WriteChanFPTPtr
	beq L8948
	jsr swap_write_buffer
L8948
	lda #$e0
	ldy #$8d
	bne L895a
L894e
	cpx LTK_ReadChanFPTPtr
	beq L8956
	jsr S8bae
L8956
	lda #$e0
	ldy #$9b
L895a
	jsr S897d
	beq L896c
	lda $9df9,x
	cmp #$0f
	bne L8969
	jsr S8c4c
L8969
	jsr S89cd
L896c
	bit $82de
	bmi L8979
	jsr S8a5e
	lda $9dfc,x
	sta $90
L8979
	lda L8979
	rts
                    
S897d
	sta L8979 + 1
	sty L8979 + 2
	sta $8a3a
	sty $8a3b
	lda $9def,x
	sta $82d7
	clc
	adc L8979 + 1
	sta L8979 + 1
	sta $8b5c
	lda $9dee,x
	sta $82d6
	and #$01
	adc L8979 + 2
	sta L8979 + 2
	sta $8b5d
	lda $9ded,x
	sta $82d5
	ldy #$09
L89b2
	lsr $82d5
	ror $82d6
	ror $82d7
	dey
	bne L89b2
	lda $9dea,x
	ldy $9de9,x
	cpy $82d6
	bne L89cc
	cmp $82d7
L89cc
	rts
                    
S89cd
	clc
	jsr S8bf5
	lda $82d7
	sta $8a5d
	sta $9dea,x
	lda $82d6
	sta $8a5c
	sta $9de9,x
	lda #$02
	ldy #$92
	jsr S8a44
	lda $9df0,x
	bne L89f6
	lda $9df1,x
	cmp #$f1
	bcc L8a26
L89f6
	ldy #$08
L89f8
	lsr $8a5c
	ror $8a5d
	dey
	bne L89f8
	lda $9de6,x
	and #$0f
	pha
	lda $8a5d
	jsr S8a4b
	pha
	tya
	tax
	pla
	tay
	beq L8a41
	pla
	clc
	jsr hdd_driver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01
L8a1e = * + 2       
L8a1c               
	ldx $82d4
L8a1f
	lda #$e0
L8a21
	ldy #$91
	jsr S8a44
L8a26
	lda $82d7
	jsr S8a4b
	sta $9deb,x
	tya
	sta $9dec,x
	jsr S8be3
	clc
	jsr hdd_driver
	.byte $00,$00,$01
                    
L8a3d
	ldx $82d4
	rts
                    
L8a41
	jsr LTK_FatalError
S8a44
	sta S8aae + 1
	sty S8aae + 2
	rts
                    
S8a4b
	asl a
	tay
	bcc L8a52
	inc S8aae + 2
L8a52
	jsr S8aae
	pha
	jsr S8aae
	tay
	pla
	rts
                    
	.byte $00,$00 
S8a5e
	inc $9def,x
	bne L8a6b
	inc $9dee,x
	bne L8a6b
	inc $9ded,x
L8a6b
	lda $9ded,x
	cmp $9df4,x
	bcc L8a8c
	bne L8a87
	lda $9dee,x
	cmp $9df5,x
	bcc L8a8c
	bne L8a87
	lda $9def,x
	cmp $9df6,x
	bcc L8a8c
L8a87
	lda #$40
	sta $9dfc,x
L8a8c
	rts
                    
S8a8d
	ldx #$e0
	lda $b9
	and #$0f
	cmp #$0f
	beq L8aac
	ldx #$00
	ldy #$07
L8a9b
	lda LTK_FileParamTable,x ;$9de0
	cmp $b8
	beq L8aac
	txa
	clc
	adc #$20
	tax
	dey
	bne L8a9b
	sec
	rts
                    
L8aac
	clc
	rts
                    
S8aae
	lda S8aae,y
	iny
	rts
                    
L8ab3
	ldy #$42
	sty $90
L8ab7
	sec
	rts
                    
S8ab9
	sta $82e9
	tay
	ldx $82e7
	stx $82d4
	cpx #$fe
	bcc L8ace
	bne L8ab3
	inc $82e7
	bne L8ab7
L8ace
	lda $9df9,x
	bmi L8ad7
	cmp #$0f
	bne L8ab3
L8ad7
	lda $9dfe,x
	bmi L8af2
	bne L8ae5
	tya
	sta $9de2,x
	jmp L8aed
                    
L8ae5
	cmp #$01
	bne L8af2
	tya
	sta $9de1,x
L8aed
	inc $9dfe,x
	clc
	rts
                    
L8af2
	cpx LTK_WriteChanFPTPtr
	beq L8afa
	jsr swap_write_buffer
L8afa
	lda $9df9,x
	cmp #$0f
	bne L8b09
	lda $9dfc,x
	beq L8b3c
	sec
	bcs L8b6a
L8b09
	lda $9de9,x
	cmp #$ff
	bne L8b3c
	lda $9dea,x
	cmp #$fe
	bcc L8b3c
	bne L8b39
	lda #$e0
	ldy #$8d
	jsr S897d
	jsr S89cd
	lda $9deb,x
	bne L8b58
	lda $9dea,x
	sec
	sbc #$01
	sta $9dea,x
	lda $9de9,x
	sbc #$00
	sta $9de9,x
L8b39
	jsr S8b6e
L8b3c
	lda #$e0
	ldy #$8d
	jsr S897d
	beq L8b58
	jsr S8c4c
	lda $9df9,x
	cmp #$0f
	bne L8b55
	jsr S89cd
	jmp L8b58
                    
L8b55
	jsr S8b6e
L8b58
	lda $82e9
	sta $8b5b
	jsr S8a5e
	lda #$40
	ora $9dfe,x
	sta $9dfe,x
	clc
L8b6a
	lda $82e9
	rts
                    
S8b6e
	lda LTK_Var_ActiveLU
	pha
	lda $9de6,x
	and #$0f
	sta LTK_Var_ActiveLU
	clc
	jsr S8bf5
	jsr LTK_AppendBlocks
	bcs L8bf2
	txa
	ldx $82d4
	sta $9deb,x
	tya
	sta $9dec,x
	inc $9dea,x
	bne L8b96
	inc $9de9,x
L8b96
	sec
	jsr S8bf5
	pla
	sta LTK_Var_ActiveLU
	lda #$00
	tay
L8ba1
	sta LTK_FileWriteBuffer,y
	iny
	bne L8ba1
L8ba7
	sta $8ee0,y
	iny
	bne L8ba7
	rts
                    
S8bae
	stx LTK_ReadChanFPTPtr
	lda #$e0
	ldy #$9b
	bne L8bcf
swap_write_buffer
	lda LTK_WriteChanFPTPtr
	stx LTK_WriteChanFPTPtr
	stx $82d4
	tax
	cpx #$ff
	beq L8bc8
	jsr S8c4c
L8bc8
	ldx $82d4
	lda #$e0
	ldy #$8d
L8bcf
	sta $8bdc
	sty $8bdd
	jsr S8be3
	clc
	jsr hdd_driver
	.byte $00,$00,$01
                    
L8bdf
	ldx $82d4
	rts
                    
S8be3
	lda $9de6,x
	and #$0f
	pha
	ldy $9deb,x
	lda $9dec,x
	tax
	pla
	rts
                    
L8bf2
	jsr LTK_FatalError
S8bf5
	bcs L8c32
	lda $91fd
	cmp $9de6,x
	bne L8c31
	lda $9200
	cmp $9de7,x
	bne L8c31
	lda $9201
	cmp $9de8,x
	bne L8c31
	lda $91f0
	cmp $9df0,x
	bne L8c31
	lda $91f1
	cmp $9df1,x
	bne L8c31
	lda $9df9,x
	and #$7f
	cmp $91f8
	bne L8c31
	lda $91fc
	cmp $9dfb,x
	beq L8c48
L8c31
	clc
L8c32
	lda $9de6,x
	and #$0f
	pha
	ldy $9de7,x
	beq L8bf2
	lda $9de8,x
	tax
	pla
	jsr hdd_driver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01

L8c48
	ldx $82d4
	rts
                    
S8c4c
	jsr S8be3
	cpy #$00
	beq L8c5a
	sec
	jsr hdd_driver
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01
	
L8c5a   
	ldx $82d4
	rts