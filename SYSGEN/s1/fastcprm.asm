;fastcprm.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

 	*=$6c00
l6c00
	jmp l6c47
	
l6c03
	sta l6c1a + 1
	stx l6c23 + 1
	sty l6c23 + 2
	asl a
	tay
	lda l7dec,y
	sta s6c41 + 1
	lda l7dec+1,y
	sta s6c41 + 2
l6c1a
	ldy #$00
	ldx l7d96,y
	beq l6c3a
	ldy #$00
l6c23
	lda l6c23,y
	beq l6c33
	cmp #$0d
	beq l6c33
	jsr s6c41
	bne l6c23
	beq l6c3a
l6c33
	lda #$20
	jsr s6c41
	bne l6c33
l6c3a
	ldx s6c41 + 1
	ldy s6c41 + 2
	rts
	
s6c41
	sta s6c41,y
	iny
	dex
	rts
	
l6c47
	txa
	asl a
	pha
	tay
	ldx l6c61,y
	lda l6c61+1,y
	tay
	jsr LTK_Print 
	pla
	tay
	ldx l7dec,y
	lda l7dec+1,y
	tay
	jmp LTK_Print 
	
l6c61
	.byte $0d,$6d,$22,$6d,$50,$6d,$67,$6d,$82,$6d,$a1,$6d,$4e,$6e,$75 
	.byte $6e,$8d,$6e,$9e,$6e,$bc,$6e,$d6,$6e,$ef,$6e,$06,$6f,$27,$6f,$af 
	.byte $6f,$3e,$70,$49,$70,$63,$70,$67,$70,$6f,$70,$9a,$70,$c0,$70,$db 
	.byte $70,$10,$71,$2e,$71,$3b,$71,$4a,$71,$5d,$71,$71,$71,$94,$71,$aa 
	.byte $71,$c0,$71,$e7,$71,$13,$72,$66,$72,$69,$73,$8d,$73,$c3,$73,$e6 
	.byte $73,$1a,$74,$c8,$74,$f4,$74,$47,$75,$67,$75,$85,$75,$79,$76,$bb 
	.byte $76,$e4,$76,$fc,$76,$12,$77,$63,$77,$8b,$77,$d0,$77,$1c,$78,$43 
	.byte $78,$59,$78,$a3,$78,$d5,$78,$00,$79,$44,$79,$79,$79,$08,$7a,$25 
	.byte $7a,$32,$7a,$82,$7a,$c1,$7a,$dd,$7a,$0f,$7b,$37,$7b,$77,$7b,$ce 
	.byte $7b,$2a,$7c,$55,$7c,$68,$7c,$77,$7c,$83,$7c,$90,$7c,$a3,$7c,$af 
	.byte $7c,$d8,$7c,$f9,$7c,$30,$7d,$6b,$7d,$7c,$7d,$8d,$7d 
l6d0d
	.text "{clr}{rvs on}{$8e}fastcopy - backup"
	.byte $00
l6d22
	.text "{return}{return}{rvs on}a{rvs off}rchive, {rvs on}g{rvs off}lobal, {rvs on}m{rvs off}anual, or {rvs on}e{rvs off}xit ? "
	.byte $00
l6d50
	.text "{return}{return}verify copy (y/n) ? "
	.byte $00
l6d67
	.text "{return}{return}enter desired lu (0-10) "
	.byte $00
l6d82
	.text "{return}{return}enter desired user (al=all) "
	.byte $00
l6da1
	.text "{return}{return}k( 4) = key files{return}c( 5) = contiguous data files{return}b(11) = basic program files{return}m(12) = m.l. program files{return}s(13) = sequential files{return}u(14) = user files{return}r(15) = relative files{return}"
	.byte $00
l6e4e
	.text "{return}enter file type letter or # (cr=all) "
	.byte $00
l6e75
	.text "{return}{return}pattern match (cr=*) "
	.byte $00
l6e8d
	.text "{rvs on}input error !!{rvs off}"
	.byte $00
l6e9e
	.text "                             "
	.byte $00
l6ebc
	.text "{rvs on}invalid logical unit !!{rvs off}"
	.byte $00
	.text "{rvs on}invalid user number !!{rvs off}"
	.byte $00
	.text "{rvs on}invalid file type !!{rvs off}"
	.byte $00
	.text "{clr}{return}{$8e}no files selected hit any key"
	.byte $00
	.text "{return}{rvs on}{$68}ome{rvs off}=1st page {rvs on}{$6e}{rvs off}ext page {rvs on}{$70}{rvs off}rev.page {rvs on}{$71}{rvs off}uit{return}{rvs on}crsr keys{rvs off}=> {rvs on}{$73}pace{rvs off}=toggle tag {rvs on}{$63}{rvs off}opy files{return}{rvs on}{$74}{rvs off}his page toggle   {rvs on}{$65}{rvs off}very page toggle{return}"
	.byte $00
	.text "{clr}{return}{$8e}all files marked with the reverse video{return}tag will be copied from the selected{return}lu/user(s) to the selected serial drive{return}{return}{return}the selected lu is {rvs on}"
	.byte $00
	.text "{rvs off}   user {rvs on}"
	.byte $00
	.text "{return}{return}{return}ok to proceed (y/n) ? "
	.byte $00
	.text "all"
	.byte $00
	.text "   lu {rvs on}"
	.byte $00
	.text "{clr}{return}{$8e}device # of {rvs on}serial{rvs off} drive or {rvs on}q{rvs off}uit ? "
	.byte $00
	.text "{return}{return}your selected serial drive is a {rvs on}15"
	.byte $00 
	.text "1{return}configured as device # {rvs on}"
	.byte $00
	.text "{clr}{rvs on}please wait...{return}{return}{rvs on}downloading the serial routines.{rvs off}"
	.byte $00 
	.text "{clr}{$8e}            fast-copy mode{return}"
	.byte $00
	.text "            "
	.byte $00
	.text "{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}{$b8}"
	.byte $00
	.text "fast-copy backup{return}{return}"
	.byte $00
	.text "fast-copy restore{return}{return}"
	.byte $00
	.text "{clr}{return}serial drive did not respond !!{return}"
	.byte $00
	.text "exit fast-copy mode{return}{return}"
	.byte $00
	.text "{clr}{$0e}{rvs on}{$66}astcopy - {$62}{$61}{$63}{$6b}{$75}{$70}{rvs off}"
	.byte $00
	.text "{clr}{$8e}{rvs on}please wait - setting archive flags"
	.byte $00
	.text "{return}{rvs on}f{rvs off}ormat disk, {rvs on}a{rvs off}dd to disk, or {rvs on}q{rvs off}uit ? "
	.byte $00
	.text "{clr}{return}{return}floppy disk is write protected !!!{return}{return}please check it, then hit {rvs on}r{rvs off}etry or {rvs on}q{rvs off}uit"
	.byte $00
	.text "{clr}{return}{rvs on} warning   warning   warning   warning{return}{return} {rvs on}your destination diskette {$22}will{$22} be {return} {rvs on}formatted.  all preexisting files or{return} {rvs on}programs {$22}will{$22} be lost !!!!!!!!!!!!{return}{return}{return}please insert a {$22}write-enabled{$22} diskette{return}in your floppy drive.{return}{return}type {rvs on}r{rvs off}eady or {rvs on}q{rvs off}uit fast-copy"
	.byte $00
	.text "{clr}{return}{return}fast-copy complete - hit any key"
	.byte $00
	.text "{clr}{return}file verify error has occurred !!!{return}{return}filename is  {rvs on}{$0e}"
	.byte $00
	.text "{return}{return}type {rvs on}r{rvs off}etry or {rvs on}q{rvs off}uit fast-copy"
	.byte $00
	.text "{clr}{return}file write error has occurred !!{return}{return}filename is  {rvs on}{$0e}"
	.byte $00
	.text "{clr}{return}{rvs on}warniing !!{rvs off}  -  a fatal disk error has{return}occurred during the writing of the bam{return}and index.  it is {rvs on}highly{rvs off} recommemded{return}that you replace your diskette before{return}doing a retry."
	.byte $00
	.text "{return}{return}{rvs on}please wait ... formatting diskette !!{return}{return}"
	.byte $00
	.text "{clr}{return}{$8e}please insert the {rvs on}formatted{rvs off} disk you{return}wish to add to.{return}{return}{return}type {rvs on}r{rvs off}eady or {rvs on}q{rvs off}uit"
	.byte $00
	.text "{clr}{return}{rvs on}s{rvs off}ingle or {rvs on}d{rvs off}ouble sided ? "
	.byte $00
	.text "{return}{return}{rvs on}copying selected files !!{return}"
	.byte $00
	.text "{clr}{$dd}--------{$dd}---------{$dd}---------{$dd}---------{$dd}---------{$dd}---------{$dd}---------{$dd}---------{$dd}{return}{$dd}        {$dd}         {$dd}         {$dd}         {$dd}         {$dd}         {$dd}         {$dd}         {$dd}{return}1       10        20        30        40        50        60        70        80"
	.byte $00
	.text "{return}{$8e}error occurred while reading the bam !{return}{return}{return}type {rvs on}r{rvs off}etry or {rvs on}q{rvs off}uit"
	.byte $00
	.text "{clr}{$8e}{rvs on}please wait - clearing archive flags{rvs off}"
	.byte $00
	.text "reselect serial drive{return}{return}"
	.byte $00
	.text "{clr}{$0e}{rvs on}{$66}astcopy-{$72}{$65}{$73}{$74}{$6f}{$72}{$65}: "
	.byte $00
	.text "{return}{return}select pre-existing file option:{return}{return}{rvs on}a{rvs off}uto / {rvs on}m{rvs off}anual intervention, or {rvs on}e{rvs off}xit ? "
	.byte $00
	.text "{return}{return}{rvs on}s{rvs off}kip or {rvs on}r{rvs off}eplace existing files ? "
	.byte $00
	.text "{clr}{return}{$8e}insert a diskette in your floppy drive.{return}{return}{return}hit any key when ready."
	.byte $00
	.text "{clr}{return}{$8e}select destination lu/user option:{return}{return}{rvs on}o{rvs off}riginal or {rvs on}d{rvs off}ifferent lu/user ? "
	.byte $00
	.text "p     = basic and m.l. program files{return}{return}"
	.byte $00
	.text "{clr}{rvs on}{$8e}fastcopy - restore"
	.byte $00
	.text "{clr}{return}{return}sorry, your destination lu is full !!{return}{return}hit any key to abort fast-copy."
	.byte $00
	.text "{clr}{return}file read error has occurred !!{return}{return}filename is  {rvs on}"
	.byte $00
	.text "{return}{return}{rvs on}r{rvs off}etry {rvs on}s{rvs off}kip file, or {rvs on}q{rvs off}uit fast-copy"
	.byte $00
	.text "{rvs off} file already exists !!{return}{return}{rvs on}r{rvs off}eplace file, {rvs on}s{rvs off}kip file, or {rvs on}q{rvs off}uit ? "
	.byte $00
	.text "{clr}{return}{rvs on}copy complete !!{return}{return}is there another source disk ? "
	.byte $00
	.text "{clr}{return}{$8e}all files marked with the reverse video{return}tag will be copied from the selected{return}serial drive to the selected lu/user(s){return}{return}{return}the selected lu is {rvs on}"
	.byte $00
	.text "{return}{return}enter desired user (0-15) "
	.byte $00
	.text "{return}filename: {rvs on}"
	.byte $00
	.text "{return}{return}contains an invalid lu number !{return}{return}{return}type {rvs on}s{rvs off}kip file, {rvs on}n{rvs off}ew lu/user, or {rvs on}q{rvs off}uit "
	.byte $00
	.text "{clr}{return}{return}not enough contiguous blocks on lu !!{return}{return}hit any key to abort"
	.byte $00
	.text "fast-copy disk duplicator{return}{return}"
	.byte $00
	.text "{return}{return}{return}enter name of hard drive work file{return}filename ? "
	.byte $00
	.text "{return}{return}{rvs on}file not found{rvs off} - create it (y/n) ? "
	.byte $00
	.text "{clr}{return}please insert a {rvs on}protected source{rvs off} disk{return}{return}hit a key when ready"
	.byte $00
	.text "size of work file does not match the{return}serial drive selected !!!{return}{return}{return}hit a key to continue"
	.byte $00
	.text "{return}{return}select copy step to start with:{return}{return}     {rvs on}s{rvs off}ource disk{return}{return}     {rvs on}d{rvs off}estination disk{return}{return}     {rvs on}q{rvs off}uit"
	.byte $00
	.text "{clr}{return}{$8e}verify copy:  {rvs on}y{rvs off}es, {rvs on}n{rvs off}o, or {rvs on}q{rvs off}uit ? "
	.byte $00
	.text "{return}{return}{rvs on}copying from 15"
	.byte $00
	.text "to hard drive{return}"
	.byte $00
	.text "{clr}{return}data read"
	.byte $00
	.text "{clr}{return}data write"
	.byte $00
	.text " error on track: {rvs on}"
	.byte $00
	.text "{rvs off} sector: {rvs on}"
	.byte $00
	.text "{return}{return}     {rvs on}r{rvs off}etry{return}{return}     {rvs on}s{rvs off}kip{return}{return}     {rvs on}q{rvs off}uit"
	.byte $00
	.text "{return}{return}{rvs on}copying from hard drive to 15"
	.byte $00
	.text "{clr}{return}copy complete{return}{return}{return}another copy of {rvs on}same{rvs off} disk (y/n) ? "
	.byte $00
	.text "{clr}work file selected contains a copy of{return}a diskette named: {rvs on}"
	.byte $00
	.text "{return}creation date: "
	.byte $00
	.text "{return}descriptor   : "
	.byte $00
	.text "{clr}{return}verify"
	.byte $00
l7d96	             
	.byte $00,$01,$01,$02,$02,$00,$02,$10,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$02,$01,$02,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$01,$00,$00,$00,$00,$00,$00,$01,$01,$00,$01,$00,$00,$00,$00 
	.byte $00,$01,$01,$00,$02,$00,$01,$00,$00,$16,$01,$00,$00,$00,$01,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$01,$00,$08,$14,$00 
l7dec
	.byte $98,$7e,$99,$7e 
	.byte $9c,$7e,$9f,$7e,$a4,$7e,$a9,$7e,$aa,$7e,$af,$7e,$d0,$7e,$d1,$7e 
	.byte $d2,$7e,$d3,$7e,$d4,$7e,$d5,$7e,$d6,$7e,$d7,$7e,$d8,$7e,$d9,$7e 
	.byte $dc,$7e,$dd,$7e,$de,$7e,$e3,$7e,$e5,$7e,$e8,$7e,$e9,$7e,$ea,$7e 
	.byte $eb,$7e,$ec,$7e,$ed,$7e,$ee,$7e,$ef,$7e,$f0,$7e,$f1,$7e,$f2,$7e 
	.byte $f5,$7e,$f6,$7e,$f7,$7e,$f8,$7e,$f9,$7e,$fa,$7e,$fb,$7e,$fc,$7e 
	.byte $fd,$7e,$fe,$7e,$01,$7f,$02,$7f,$03,$7f,$04,$7f,$05,$7f,$06,$7f 
	.byte $07,$7f,$0a,$7f,$0d,$7f,$0e,$7f,$11,$7f,$12,$7f,$13,$7f,$14,$7f 
	.byte $15,$7f,$16,$7f,$19,$7f,$1c,$7f,$1d,$7f,$22,$7f,$23,$7f,$26,$7f 
	.byte $27,$7f,$28,$7f,$55,$7f,$58,$7f,$59,$7f,$5a,$7f,$5b,$7f,$5e,$7f 
	.byte $5f,$7f,$60,$7f,$61,$7f,$62,$7f,$63,$7f,$64,$7f,$65,$7f,$66,$7f 
	.byte $69,$7f,$6a,$7f,$7b,$7f,$a4,$7f 
l7e98
	.byte $00
l7e99
	.text "m{left}"
	.byte $00
l7e9c
	.text "y{left}"
	.byte $00
l7e9f
	.text "  {left}{left}"
	.byte $00
l7ea4
	.text "  {left}{left}"
	.byte $00
l7ea9
	.byte $00
l7eaa
	.text "  {left}{left}"
	.byte $00
l7eaf
	.text "                {left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}"
	.byte $00
l7ed0
	.byte $00
l7ed1
	.byte $00
l7ed2
	.byte $00
l7ed3
	.byte $00
l7ed4
	.byte $00
l7ed5
	.byte $00
l7ed6
	.byte $00
l7ed7
	.byte $00
l7ed8
	.byte $00
l7ed9
	.text "y{left}"
	.byte $00
l7edc
	.byte $00
l7edd
	.byte $00
l7ede
	.text "8 {left}{left}"
	.byte $00
l7ee3
	.text " "
	.byte $00
l7ee5
	.text "  "
	.byte $00
l7ee8
	.byte $00
l7ee9
	.byte $00
l7eea
	.byte $00
l7eeb
	.byte $00
l7eec
	.byte $00
l7eed
	.byte $00
l7eee
	.byte $00
l7eef
	.byte $00
l7ef0
	.byte $00
l7ef1
	.byte $00
l7ef2
	.text "a{left}"
	.byte $00
l7ef5
	.byte $00
l7ef6
	.byte $00
l7ef7
	.byte $00
l7ef8
	.byte $00
l7ef9
	.byte $00
l7efa
	.byte $00
l7efb
	.byte $00
l7efc
	.byte $00
l7efd
	.byte $00
l7efe
	.text "d{left}"
	.byte $00
l7f01
	.byte $00
l7f02
	.byte $00
l7f03
	.byte $00
l7f04
	.byte $00
l7f05
	.byte $00
l7f06
	.byte $00
l7f07
	.text "m{left}"
	.byte $00
l7f0a
	.text "s{left}"
	.byte $00
l7f0d
	.byte $00
l7f0e
	.text "o{left}"
	.byte $00
l7f11
	.byte $00
l7f12
	.byte $00
l7f13
	.byte $00
l7f14
	.byte $00
l7f15
	.byte $00
l7f16
	.text "s{left}"
	.byte $00
l7f19
	.text "y{left}"
	.byte $00
l7f1c
	.byte $00
l7f1d
	.text "  {left}{left}"
	.byte $00
l7f22
	.byte $00
	.text "n{left}"
	.byte $00
l7f26
	.byte $00
l7f27
	.byte $00
l7f28
	.text "                      {left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}"
	.byte $00
l7f55
	.text "y{left}"
	.byte $00
l7f58
	.byte $00
l7f59
	.byte $00
l7f5a
	.byte $00
l7f5b
	.text "y{left}"
	.byte $00
l7f5e
	.byte $00
l7f5f
	.byte $00
l7f60
	.byte $00
l7f61
	.byte $00
l7f62
	.byte $00
l7f63
	.byte $00
l7f64
	.byte $00
l7f65
	.byte $00
l7f66
	.text "y{left}"
	.byte $00
l7f69
	.byte $00
l7f6a
	.text "mm-dd-yy{left}{left}{left}{left}{left}{left}{left}{left}"
	.byte $00
l7f7b
	.text "--------------------{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{$9d}"
	.byte $00
l7fa4
	.byte $00


