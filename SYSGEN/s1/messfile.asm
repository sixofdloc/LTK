;messfile.r.prg
	*=$4000
	
	emptyslot	.macro
                    .byte $ff
                    .repeat $1f,$00
	.endm
 
Message_00
	#emptyslot
Message_01
	.text "01,files scratched,00,00{return}"
	.repeat 7,$00
Message_02
	.text "01,files scratched,01,00{return}"
	.repeat 7,$00
Message_03
	.text "03,file open for read,00,00{return}"
	.byte $00,$00,$00,$00
Message_04               
	.text "04,lu bitmap is locked,00,00{return}"
	.byte $00,$00,$00
Message_05               
	.text "05,lu index is locked ,00,00{return}"
	.byte $00,$00,$00
Message_06
	#emptyslot
Message_07
	#emptyslot
Message_08
	#emptyslot
Message_09
	#emptyslot
Message_10
	#emptyslot
Message_11
	#emptyslot
Message_12
	#emptyslot
Message_13
	#emptyslot
Message_14
	#emptyslot
Message_15
	#emptyslot
Message_16
	#emptyslot
Message_17
	#emptyslot
Message_18
	#emptyslot
Message_19
	#emptyslot
Message_20
	#emptyslot
Message_21
	#emptyslot
Message_22
	#emptyslot
Message_23
	#emptyslot
Message_24
	#emptyslot
Message_25
	#emptyslot
Message_26
	#emptyslot
Message_27
	#emptyslot
Message_28
	#emptyslot
Message_29
	#emptyslot
Message_30
	.text "30,syntax error,00,00{return}"
	.repeat 10,$00
Message_31
	.text "31,syntax error,00,00{return}"
	.repeat 10,$00
Message_32
	#emptyslot
Message_33
	.text "33,illegal filename,00,00{return}"
	.repeat 6,$00
Message_34
	#emptyslot
Message_35
	#emptyslot
Message_36
	#emptyslot
Message_37
	#emptyslot
Message_38
	#emptyslot
Message_39
	#emptyslot
Message_40
	#emptyslot
Message_41
	#emptyslot
Message_42
	#emptyslot
Message_43
	#emptyslot
Message_44
	#emptyslot
Message_45
	#emptyslot
Message_46
	#emptyslot
Message_47
	#emptyslot
Message_48
	#emptyslot
Message_49
	#emptyslot
Message_50
	.text "50,record not present,00,00{return}"
	.repeat 4,$0
Message_51
	.text "51,overflow in record,00,00{return}"
	.repeat 4,$0
Message_52
	.text "52,file is too large,00,00{return}"
	.repeat 5,$00
Message_53
	#emptyslot
Message_54
	#emptyslot
Message_55
	#emptyslot
Message_56
	#emptyslot
Message_57
	#emptyslot
Message_58
	#emptyslot
Message_59
	#emptyslot
Message_60
	.text "60,file open for write,00,00{return}"
	.byte $00,$00,$00
Message_61
	.text "61,file not open,00,00{return}"
        .repeat 9,$00 
Message_62
	.text "62,file not found,00,00{return}"
	.repeat 8,$00
Message_63
	.text "63,file exists,00,00{return}"
	.repeat 11,$00
Message_64
	.text "64,file type mismatch,00,00{return}"
	.repeat 4,$00
Message_65
	.text "65,no block,00,00{return}"
	.repeat 14,$00
Message_66
	#emptyslot
Message_67
	#emptyslot
Message_68
	#emptyslot
Message_69
	#emptyslot
Message_70
	.text "70,no channel available,00,00{return}"
	.byte $00,$00
Message_71
	#emptyslot
Message_72
	.text "72,disk/directory full,00,00{return}"
        .byte $00,$00,$00
Message_73
	.text "73,fii lt. kernal (v7.2),00,00{return}"
    	.byte $00
Message_74
	#emptyslot
Message_75
	#emptyslot
Message_76
	#emptyslot
Message_77
	#emptyslot
Message_78
	#emptyslot
Message_79
	#emptyslot
Message_80
	#emptyslot
Message_81
	#emptyslot
Message_82
	#emptyslot
Message_83
	#emptyslot
Message_84
	#emptyslot
Message_85
	#emptyslot
Message_86
	#emptyslot
Message_87
	#emptyslot
Message_88
	#emptyslot
Message_89
	#emptyslot
Message_90
	#emptyslot
Message_91
	#emptyslot
Message_92
	#emptyslot
Message_93
	#emptyslot
Message_94
	#emptyslot
Message_95
	#emptyslot
Message_96
	#emptyslot
Message_97
	#emptyslot
Message_98
	#emptyslot
Message_99
	#emptyslot
Message_100
	#emptyslot
Message_101
	#emptyslot
Message_102
	#emptyslot
Message_103
	#emptyslot
Message_104
	#emptyslot
Message_105
	#emptyslot
Message_106
	#emptyslot
Message_107
	#emptyslot
Message_108
	#emptyslot
Message_109
	#emptyslot
Message_110
	#emptyslot
Message_111
	#emptyslot
Message_112 ;disparagement
	.text "{clr}{return}{return}ok. so you got past the serial number{return}check in the boot rom.  big deal, my"
	.text "{return}grandmother could do that.  keep going{return}if you want, but we feel it is only fair"
	.text "to warn you that there are several more{return}traps along the way.{return}"
	.text "{return}by the time you figure out the last one,this {$22}operating system{$22} will have even{return}"
	.TEXT "less intelligence than you obviously do!{return}{return}{return}  ******* happy hunting sucker *******"
	.byte $00,$00,$00,$00,$00
Message_124
	#emptyslot
Message_125
	#emptyslot
Message_126
	#emptyslot
Message_127
	#emptyslot
