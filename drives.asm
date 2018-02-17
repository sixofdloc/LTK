;Drive Geometry table for use in new SYSGEN
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
	;       |    |    |    |    Cylinders (hi-byte)
	;       |    |    |    |    |
	;       |    |    |    |    |    Cylinders (lo-byte)
	;       |    |    |    |    |    |    
	;       |    |    |    |    |    |    Write precomp cylinders
	;       |    |    |    |    |    |    |
	;       |    |    |    |    |    |    |    
	;       |    |    |    |    |    |    |    Unknown (zero always?)
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

	;Seagate ST-138n-0/1(32.2Mb)
	;- 615 Cylinders, 4 heads, 26 SPT 
geo_SeagateST138n
	 .byte $80, $00, $1a, $04, $02, $67, $00, $00

