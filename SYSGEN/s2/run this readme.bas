1 PRINT CHR$(14)"{clear}Please: You MUST PRINT this documen-" 
2 PRINT "tation file.  It is too complex to be" 
3 PRINT "properly used on the screen." 
4 PRINT :PRINT :PRINT :INPUT "DO{$a0}YOU{$a0}HAVE{$a0}A{$a0}PRINTER{$a0}ATTACHED{$a0}(Y/N)";A$:IF LEFT$(A$,1)<>"y" THEN STOP 
5 PRINT "{clear}printer device #   4{left}{left}{left}";:INPUT D:IF D<4 OR D>7 THEN 5 
6 PRINT "{home}{down}printer sec. adr   7{left}{left}{left}";:INPUT S:IF S<0 OR S>15 THEN 6 
7 OPEN 4,D,S 
8 OPEN 2,8,2,"7.2 Update Docs,s,r" 
9 SYS 2560 
