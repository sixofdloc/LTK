;*              _                     _                                 
;*   _ __  ___ | |  ___    ___  __ _ | |_  ___     __ _  ___  _ __ ___  
;*  | '__|/ _ \| | / _ \  / __|/ _` || __|/ _ \   / _` |/ __|| '_ ` _ \ 
;*  | |  |  __/| || (_) || (__| (_| || |_|  __/ _| (_| |\__ \| | | | | |
;*  |_|   \___||_| \___/  \___|\__,_| \__|\___|(_)\__,_||___/|_| |_| |_|
;*                                                                      

; A macro set to assist with building code segments inline that will later be relocatd.

; Thanks to Elwix/Style for the macros!


; relocate: Set a code segment up to run at a location other than its build location
relocate .macro
a        *= \1
reloc_   .var a-*
         .offs reloc_
         .endm


; endr: Reset the assembler to no longer relocate code.
endr     .segment
         *= *+reloc_
         .offs 0
         .endm

; Usage:
;	*=$1000
;	lda foo
;	sta blah
		; normal code goes here

;	#relocate $c000
;	lda bar
;	sta blah
;bar	.byte $ea
;	rts
;	#endr


; The segment within #relocate to #endr will be built to run at $c000 but appear
;  immedately after 'sta blah' in the binary.
