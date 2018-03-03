;new.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_DOSOverlay ; $95e0, $4000 for sysgen
	lda #$ff
	sta LTK_Var_SAndRData
	sta LTK_Var_SAndRData+1
	sta LTK_Var_SAndRData+2
	pla
	pla
	jmp LTK_SysRet_OldRegs
