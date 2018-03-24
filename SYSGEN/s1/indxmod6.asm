;indxmod6.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$4000 for sysgen 
	
L95e0
	.repeat $0290,$00
	