10 PRINT CHR$(14)"{clear}    SYSGEN{$a0}7.2 CUSTOMIZATION{$a0}ROUTINE":PRINT :PRINT  
20 PRINT "You must use a 1541 or 1571 set up" 
30 PRINT "for device #8 to perform this custom-" 
40 PRINT "ization.  Does your floppy match this?{reverse on}n{left}"; 
50 GET A$:IF A$="" THEN 50 
60 IF A$=CHR$(13) THEN STOP 
70 PRINT A$;"{left}";:IF A$<>"n" AND A$<>"y" THEN 50 
80 IF A$="n" THEN STOP 
90 PRINT  
100 OPEN 15,8,15,"l900":CLOSE 15:OPEN 15,8,15:INPUT#15,E,E$,T,S:CLOSE 15 
110 B1=49152:B2=B1+256:B=B1 
120 PRINT "{clear}Insert your WORKING 7.1 SYSGEN diskette" 
130 PRINT "in the drive.  The disk must EXACTLY" 
140 PRINT "MATCH the system you are now running." 
150 PRINT :PRINT "This is your OLD WORKING DOS 7.1 disk," 
160 PRINT "NOT your NEW 7.2 diskette.":PRINT :PRINT :PRINT  
170 PRINT "    Press 'C' to continue  "; 
180 A$="":GET A$:IF A$="" THEN 180 
190 IF A$<>"c" THEN 180 
200 OPEN 15,8,15,"i0":CLOSE 15 
210 OPEN 2,8,2,"#":OPEN 15,8,15,"u1,2,0,18,18":INPUT#15,E,E$,T,S:IF E THEN 590 
220 GOSUB 490: REM MOVE PARMS TO SAVE AREA 
230 INPUT#15,E,E$,T,S:IF E THEN 590 
240 CLOSE 2:CLOSE 15 
250 IF PEEK(B+157)<>55 OR PEEK(B+158)<>49 THEN E$="Not a 7.1 sysgen disk": GOTO 590 
256 PRINT "{clear}Insert an EXACT, BLOCK-FOR-BLOCK copy" 
260 PRINT " of  your NEW DOS 7.2 SYSGEN diskette" 
270 PRINT "in the drive.  This is a COPY of the" 
280 PRINT "diskette you just received FREE from" 
290 PRINT "FISCAL{$a0}INFORMATION, INC.":PRINT :PRINT  
295 PRINT "  DO{$a0}NOT{$a0}USE{$a0}THE{$a0}ORIGINAL DISKETTE !!":PRINT :PRINT  
300 PRINT "    Press 'C' to continue  "; 
310 A$="":GET A$:IF A$="" THEN 310 
320 IF A$<>"c" THEN 310 
330 OPEN 2,8,2,"#":OPEN 15,8,15,"u1,2,0,18,18":INPUT#15,E,E$,T,S:IF E THEN 600 
340 B=B2:GOSUB 490 
350 IF PEEK(B+157)<>55 OR PEEK(B+158)<>50 THEN E$="Not a 7.2 sysgen disk": GOTO 600 
360 GOSUB 520:REM MOVE PARMS TO WRITE AREA 
370 INPUT#15,E,E$,T,S:IF E THEN 600 
380 PRINT#15,"b-p 2 0" 
390 GOSUB 560: REM MOVE PARMS TO DEST BUFFER IN DRIVE 
400 PRINT "{clear}Your serial number is ";:FOR I=0 TO 7:PRINT CHR$(PEEK(B1+I));:NEXT :PRINT  
410 PRINT :PRINT "Is that correct ?"; 
420 A$="":GET A$:IF A$="" THEN 420 
430 IF A$<>"y" AND A$<>"n" THEN 430 
440 IF A$="n" THEN CLOSE 2:CLOSE 15:STOP 
450 PRINT#15,"u2,2,0,18,18":INPUT#15,E,E$,T,S:IF E THEN 530 
460 CLOSE 2:CLOSE 15 
470 OPEN 15,9,15,"l800":CLOSE 15 
480 PRINT "{clear}{down}{down}{down}{down}{down}   Customization complete:  Thank you.{down}{down}{down}{down}{down}":STOP 
490 PRINT :PRINT :PRINT " reading parameters... please wait" 
500 FOR I=0 TO 255:PRINT ".";:GET #2,A$:A$=A$+CHR$(0):POKE B+I,ASC(A$):NEXT  
510 PRINT :RETURN 
520 PRINT :PRINT :PRINT " saving parameters... please wait":PRINT  
530 FOR I=0 TO 7:POKE B2+I,PEEK(B1+I):NEXT  
540 FOR I=0 TO 63:POKE B2+14+I,PEEK(B1+14+I):NEXT  
550 RETURN 
560 PRINT :FOR I=1 TO 256:PRINT ".";:NEXT ::PRINT :PRINT "{up}{up}{up}{up}{up}{up}{up}"; 
570 FOR I=0 TO 255:PRINT " ";:PRINT#2,CHR$(PEEK(B2+I));:NEXT  
580 PRINT :RETURN 
590 CLOSE 15:CLOSE 2:PRINT :PRINT "error on source diskette !":PRINT E$:STOP 
600 CLOSE 15:CLOSE 2:PRINT :PRINT "error on destination diskette !":PRINT E$:STOP 
