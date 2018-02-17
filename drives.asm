;Drive Geometry table for use in new SYSGEN
; With much thanks to Peter Bergeron for his 
; work in 1992 from which most of the root values for this
; table was taken.
;
;See http://www.floodgap.com/retrobits/ckb/ltk/drives_edit.htm
;
;Please add your drive to this list if it's not in it.
;

	;       Embedded Controller/Pulse Width
	;       | 
	;       |    Step Period
	;       |    |
	;       |    |    Sectors Per Track
	;       |    |    |
	;       |    |    |    Heads
	;       |    |    |    |
	;       |    |    |    |    Cylinders  - hi-byte)
	;       |    |    |    |    |
	;       |    |    |    |    |    Cylinders  - lo-byte)
	;       |    |    |    |    |    |    
	;       |    |    |    |    |    |    Write precomp cylinders
	;       |    |    |    |    |    |    |
	;       |    |    |    |    |    |    |    
	;       |    |    |    |    |    |    |    Unknown  - zero always?)
	;       |    |    |    |    |    |    |    |
	;       v    v    v    v    v    v    v    v
        ;.byte $00, $00, $00, $00, $00, $00, $00, $00
        
;Quantum Prodrive LPS 52 - 52Mb
;- 1219 Cylinders, 2 heads, 49 SPT, Precomp 65535, LZ ??? bPS 512
geo_QuantumLPS52
	 .byte $80, $00, $2a, $02, $04, $c3, $00, $00

;Quantum Prodrive LPS 105 - 105Mb
;- 1219 Cylinders, 4 heads, 49 SPT, Precomp 65535, LZ ??? bPS 512
geo_QuantumLPS105	
	 .byte $80, $00, $2a, $04, $04, $c3, $00, $00

;Seagate ST125n - 21.5Mb
;- 407 Cylinders, 4 heads, 26 SPT 
geo_SeagateST125n
	 .byte $80, $00, $1a, $04, $01, $97, $00, $00 

;Seagate ST-138n-0/1 - 32.2Mb)
;- 615 Cylinders, 4 heads, 26 SPT 
geo_SeagateST138n
	 .byte $80, $00, $1a, $04, $02, $67, $00, $00

;Seagate ST-157n-0/1 - 48.6Mb
;- 615 cylinders, 6 heads, 26 SPT
geo_SeagateST157n
	 .byte $80, $00, $1a, $06, $02, $67, $00, $00
	  
;Seagate ST-177n - 60.8Mb
;- 921 Cylinders, 5 heads?, 26 SPT
geo_SeagateST177n
	 .byte $80, $00, $1a, $05, $03, $99, $00, $00

;Seagate ST-1096n - 83.9Mb
;- 906 Cylinders, 7 heads?, 26 SPT
geo_SeagateST1096n
	 .byte $80, $00, $1a, $07, $03, $8a, $00, $00

;Seagate ST-1111n - 98.0Mb
;- 1068 Cylinders, 5 heads?, 36 SPT
geo_SeagateST1111n
	 .byte $80, $00, $24, $05, $04, $2c, $00, $00

;Seagate ST-1126n - 111.0Mb
;- 1068 Cylinders, 7 heads?, 29 SPT
geo_SeagateST1126n
	 .byte $80, $00, $1d, $07, $04, $2c, $00, $00

;Seagate ST-1156n - 138.0Mb
;- 1068 Cylinders, 7 heads?, 36 SPT
geo_SeagateST1156n
	 .byte $80, $00, $24, $07, $04, $2c, $00, $00

;Seagate ST-1162n - 142.0Mb
;- 1068 Cylinders, 9 heads?, 36 SPT
geo_SeagateST1162n
	 .byte $80, $00, $24, $09, $04, $2c, $00, $00

;Seagate ST-1201n - 177.0Mb
;- 1068 Cylinders, 9 heads?, 36 SPT
geo_SeagateST1201n	 
	 .byte $80, $00, $24, $09, $04, $2c, $00, $00

;Seagate ST-225n - 21.3Mb
;- 615 Cylinders, 4 heads?, 17 SPT
geo_SeagateST225n
	 .byte $80, $00, $11, $04, $02, $67, $00, $00

;Seagate ST-251n-0 - 43.1Mb
;- 820 Cylinders, 4 heads?, 26 SPT
geo_SeagateST251n0
	 .byte $80, $00, $1a, $04, $03, $34, $00, $00

;Seagate ST-251n-1 - 43.2Mb
;- 630 Cylinders, 4 heads?, 34 SPT
geo_SeagateST251n1
	 .byte $80, $00, $22, $04, $02, $76, $00, $00

;Seagate ST-277n-0 - 64.9Mb
;- 820  Cylinders, 6 heads?, 26 SPT
geo_SeagateST227n0
	 .byte $80, $00, $1a, $06, $03, $34, $00, $00

;Seagate ST-277n-1 - 64.9Mb
;- 274 Cylinders, 6 heads?, 34 SPT
geo_SeagateST227n1
	 .byte $80, $00, $22, $06, $02, $74, $00, $00

;Seagate ST-296n - 84.9Mb
;- 820 Cylinders, 6 heads?, 34 SPT
geo_SeagateST296n	 
	 .byte $80, $00, $22, $06, $03, $34, $00, $00
