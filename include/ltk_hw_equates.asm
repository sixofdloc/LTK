

;*   _  _    _          _                                         _             
;*  | || |_ | | __     | |__ __      __ ___   __ _  _   _   __ _ | |_  ___  ___ 
;*  | || __|| |/ /     | '_ \\ \ /\ / // _ \ / _` || | | | / _` || __|/ _ \/ __|
;*  | || |_ |   <      | | | |\ V  V /|  __/| (_| || |_| || (_| || |_|  __/\__ \
;*  |_| \__||_|\_\_____|_| |_| \_/\_/  \___| \__, | \__,_| \__,_| \__|\___||___/
;*               |_____|                        |_|                             

; Hardware equates for the LTK host adapter (copied from setup.asm)

HA_data    =$df00	; SCSI data port: port or ddr
	; Control port bit map for port A (data):
	; bit	use	likelyhood
	; ca1
	; ca2	ACK	90%
HA_data_cr =$df01	; SCSI data port control reg
HA_ctrl    =$df02	; SCSI control port
        ; control port bit map: To be verifed (FIXME etc)
	; bit	use	likelyhood
        ;  0		
        ;  1		
        ;  2	C/D	60%	
        ;  3	BSY	90%
        ;  4	SEL	50%
        ;  5		
        ;  6	ATN	50%
        ;  7	REQ	60%
	; cb1
	; cb2
HA_ctrl_cr =$df03	; SCSI control port control reg
