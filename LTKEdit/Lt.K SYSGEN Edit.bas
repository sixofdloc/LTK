1 REM "Written by P.Bergeron 04/15/92  " 
2 REM "   Subter.Ntwk(203)5893273      " 
3 REM "                                " 
4 REM " Lt.Kernal SYSGEN Editor 1.01   " 
5 REM "          Modified on 08/25/92  " 
6 REM "                                " 
10 POKE 53280,0:POKE 53281,0:PRINT "{clear}" 
20 DIM A(10),B(10),D(20,7),D$(20),DT(7,7),DS(4,7),DS$(4) 
30 FOR I=1 TO 4:READ DS$(I):FOR J=0 TO 7:READ DS(I,J):NEXT :NEXT  
40 DV=8:X=0:SV=49152:DT=SV+14 
50 OPEN 15,DV,15:CLOSE 15 
60 IF ST=0 THEN X=X+1:B(X)=DV 
70 IF DV<15 THEN DV=DV+1: GOTO 50 
80 IF X=0 THEN 130 
90 DV=X:X=0:FOR I=1 TO DV 
100 OPEN 15,B(I),15:PRINT#15,"m-r"CHR$(198)CHR$(229)CHR$(1):GET #15,A$:A$=A$+CHR$(0) 
110 IF ASC(A$)=52 OR ASC(A$)=55 THEN X=X+1:A(X)=B(I):IF ASC(A$)=55 THEN A(X)=A(X)+128 
120 CLOSE 15:NEXT :IF A(1)>0 THEN 140 
130 PRINT "{reverse on}{pink}No 1541/71 Drives Found!{reverse off}":STOP 
140 IF A(2)=0 THEN I=1: GOTO 210 
150 PRINT "{clear}{down}{down}{down}{down}{down}{gray 2}[{reverse on}{light green} Drive Selections {reverse off}{gray 2}]{down}" 
160 FOR I=1 TO X:PRINT "{gray 2}[{reverse on}{yellow}"STR$(I)"{reverse off}{gray 2}]- {gray 3}15";:IF A(I) AND 128 THEN PRINT "71";: GOTO 180 
170 PRINT "41"; 
180 PRINT "{gray 2}: Device{gray 3}";A(I) AND 127:NEXT  
190 PRINT "{down}{reverse on}{gray 2}Drive to Use{reverse off} [{reverse on}{light blue}1-";MID$(STR$(X),2);"{reverse off}{gray 2}]  {gray 3}1{left}{left}{left}{gray 2}"; 
200 INPUT A$:I=VAL(A$):IF I<1 OR I>X THEN 150 
210 DV=A(I) AND 127:GOSUB 1790:GOSUB 1520 
220 REM MAIN MENU 
230 PRINT "{clear}{down}{down}{down}{down}{down}      {gray 2}[{reverse on}{light green} Main Menu {reverse off}{gray 2}]" 
240 PRINT "{down}{gray 2}[{reverse on}{yellow}1{reverse off}{gray 2}]-{reverse on}{green}Drive Table Editor  {reverse off}" 
250 PRINT "{gray 2}[{reverse on}{yellow}2{reverse off}{gray 2}]-{reverse on}{orange}Change Serial Number{reverse off}" 
260 PRINT "{gray 2}[{reverse on}{yellow}3{reverse off}{gray 2}]-{reverse on}{purple}Load Drive List     {reverse off}" 
270 PRINT "{gray 2}[{reverse on}{yellow}4{reverse off}{gray 2}]-{reverse on}{cyan}Load SYSGEN Table   {reverse off}" 
280 PRINT "{gray 2}[{reverse on}{yellow}5{reverse off}{gray 2}]-{reverse on}{blue}Save SYSGEN Table   {reverse off}" 
290 PRINT "{gray 2}[{reverse on}{yellow}6{reverse off}{gray 2}]-{reverse on}{orange}Display Drive Table {reverse off}" 
300 PRINT "{down}{gray 2}{reverse on}Your Selection{reverse off} [{reverse on}{light blue}1-6{reverse off}{gray 2},{reverse on}{pink}Q=Quit{reverse off}{gray 2}]"; 
310 A$="":INPUT A$:IF A$="q" THEN 400 
320 A=VAL(A$):IF A<1 OR A>6 THEN 230 
330 ON A GOTO 340,350,360,370,380,390 
340 GOSUB 440: GOTO 230 
350 GOSUB 1300: GOTO 230 
360 GOSUB 1390: GOTO 230 
370 GOSUB 1790:GOSUB 1520: GOTO 230 
380 GOSUB 1790:GOSUB 1600: GOTO 230 
390 GOSUB 1660: GOTO 230 
400 PRINT "{down}{down}{gray 2}[{reverse on}{pink}Exit SYSGEN Editor{reverse off}{gray 2}]" 
410 GOSUB 1850:IF A$="n" THEN 230 
420 END  
430 REM EDIT DRIVES 
440 FOR I=0 TO 7:FOR J=0 TO 7:DT(I,J)=PEEK(DT+I*8+J):NEXT :NEXT  
450 DI=0:FOR I=0 TO 7:X=0:FOR J=1 TO 7:IF DT(I,J)<>0 THEN X=1 
460 NEXT :IF X=1 THEN DI=DI+1 
470 NEXT  
480 PRINT "{clear}{down}{down}{down}{down}{down}  {gray 2}[{reverse on}{light green}Drive Table Editor{reverse off}{gray 2}]" 
490 PRINT "{down}{gray 2}[{reverse on}{yellow}1{reverse off}{gray 2}]-{reverse on}{orange}Add a Drive        {reverse off}" 
500 PRINT "{gray 2}[{reverse on}{yellow}2{reverse off}{gray 2}]-{reverse on}{cyan}Edit Existing Drive{reverse off}" 
510 PRINT "{gray 2}[{reverse on}{yellow}3{reverse off}{gray 2}]-{reverse on}{green}Remove a Drive     {reverse off}" 
520 PRINT "{down}{gray 2}[{reverse on}{white}Drives Installed{reverse off}{gray 2}]>{gray 3}";DI 
530 PRINT "{down}{gray 2}{reverse on}Your Selection{reverse off} [{reverse on}{light blue}1-3{reverse off}{gray 2},{reverse on}{pink}Q=Quit{reverse off}{gray 2}]  {gray 3}q{left}{left}{left}{gray 2}"; 
540 A$="":INPUT A$:IF A$="q" THEN 580 
550 A=VAL(A$):IF A<1 OR A>3 THEN 480 
560 ON AGOSUB 620,700,770 
570 GOTO 480 
580 PRINT "{down}{down}{gray 2}[{reverse on}{pink}Exit Drive Table Editor{reverse off}{gray 2}]" 
590 GOSUB 1850:IF A$="n" THEN 480 
600 FOR I=0 TO 7:FOR J=0 TO 7:POKE (DT+I*8+J),DT(I,J):NEXT :NEXT :RETURN 
610 REM ADD DRIVE 
620 IF DI=7 THEN PRINT "{down}{down}{reverse on}{pink}All Drives Installed!{reverse off}":GOSUB 1770:RETURN 
630 PRINT "{clear}{down}{down}{light blue}Drive{cyan}"DI"{light blue}is the next available empty" 
640 PRINT "drive slot. Hit 'y' to add a new hard" 
650 PRINT "drive at this location." 
660 GOSUB 1850:IF A$="n" THEN 680 
670 DE=DI:GOSUB 850:IF X THEN DI=DI+1 
680 RETURN 
690 REM EDIT EXISTING 
700 IF DI<1 THEN PRINT "{down}{down}{pink}{reverse on}None Installed!{reverse off}":GOSUB 1770: GOTO 750 
710 IF DI=1 THEN A=0: GOTO 740 
720 PRINT "{down}{down}{reverse on}{gray 2}Edit Which Drive{reverse off} [{reverse on}{light blue}0-"MID$(STR$(DI-1),2)"{reverse off}{gray 2}]"; 
730 A$="":INPUT A$:A=VAL(A$):IF A<0 OR A>DI-1 THEN 750 
740 DE=A:GOSUB 850 
750 RETURN 
760 REM DELETE DRIVE 
770 IF DI<1 THEN PRINT "{down}{down}{pink}{reverse on}None Installed!{reverse off}":GOSUB 1770: GOTO 830 
780 PRINT "{clear}{down}{down}{light blue}Drive{cyan}"DI-1"{light blue}is the last drive. Hit 'y'" 
790 PRINT "to delete the drive in this slot." 
800 GOSUB 1850:IF A$="n" THEN 780 
810 DI=DI-1:DT(DI,0)=128:FOR I=1 TO 7:DT(DI,I)=0:NEXT  
820 PRINT "{down}{down}{reverse on}{pink}Drive Deleted!{reverse off}":GOSUB 1770 
830 RETURN 
840 REM CHOOSE DRIVE 
850 X=0 
860 PRINT "{clear}{down}{down}{down}{down}{down}  {gray 2}[{reverse on}{light green}Choose a Hard Drive{reverse off}{gray 2}]" 
870 PRINT "{down}{gray 2}[{reverse on}{yellow}1{reverse off}{gray 2}]-{reverse on}{green}From Defaults       {reverse off}" 
880 PRINT "{gray 2}[{reverse on}{yellow}2{reverse off}{gray 2}]-{reverse on}{purple}From Loaded List    {reverse off}" 
890 PRINT "{gray 2}[{reverse on}{yellow}3{reverse off}{gray 2}]-{reverse on}{cyan}Manually            {reverse off}" 
900 GOSUB 1880:PRINT "{down}{gray 2}[{reverse on}{white}Editing Drive{reverse off}{gray 2}]>{gray 3}";DE; 
910 A$="{gray 2}({light green}"+A$+"Mb{gray 2})":IF A<1 THEN A$="{gray 2}({pink}none{gray 2})" 
920 PRINT A$:PRINT "{down}{gray 2}{reverse on}Your Selection{reverse off} [{reverse on}{light blue}1-3{reverse off}{gray 2},{reverse on}{pink}Q=Quit{reverse off}{gray 2}]  {gray 3}q{left}{left}{left}{gray 2}"; 
930 A$="":INPUT A$:IF A$="q" THEN RETURN 
940 A=VAL(A$):IF A<1 OR A>3 THEN 860 
950 ON AGOSUB 980,1060,1150 
960 GOTO 860 
970 REM SELECT STANDARD DRIVE 
980 PRINT "{clear}{down}{down}{down}{down}{down}{gray 2}[{reverse on}{light green}Select Standard Drive{reverse off}{gray 2}]{down}" 
990 FOR I=1 TO 4:PRINT "{gray 2}[{reverse on}{yellow}"MID$(STR$(I),2)"{reverse off}{gray 2}]-{gray 3}"DS$(I):NEXT  
1000 PRINT "{down}{gray 2}{reverse on}Your Selection{reverse off} [{reverse on}{light blue}1-4{reverse off}{gray 2},{reverse on}{pink}Q=Quit{reverse off}{gray 2}]  {gray 3}q{left}{left}{left}"; 
1010 A$="":INPUT A$:IF A$="q" THEN 1040 
1020 A=VAL(A$):IF A<1 OR A>4 THEN 980 
1030 FOR I=0 TO 7:DT(DE,I)=DS(A,I):NEXT :X=1:GOSUB 1760 
1040 RETURN 
1050 REM SELECT LIST DRIVE 
1060 PRINT "{clear}       {gray 2}[{reverse on}{light green}Drive Listings{reverse off}{gray 2}]{down}" 
1070 IF DL<1 THEN PRINT "{down}{down}{reverse on}{pink}None Loaded!":GOSUB 1770: GOTO 1130 
1080 FOR I=1 TO DL:PRINT "{gray 2}[{reverse on}{yellow}"RIGHT$(STR$(I),2)"{reverse off}{gray 2}]-{gray 3}"D$(I):NEXT  
1090 PRINT "{down}{gray 2}{reverse on}Your Selection{reverse off} [{reverse on}{light blue}1-"MID$(STR$(DL),2)"{reverse off}{gray 2},{reverse on}{pink}Q=Quit{reverse off}{gray 2}]  {gray 3}q{left}{left}{left}"; 
1100 A$="":INPUT A$:IF A$="q" THEN 1130 
1110 A=VAL(A$):IF A<1 OR A>DL THEN 1060 
1120 FOR I=0 TO 7:DT(DE,I)=D(A,I):NEXT :X=1:GOSUB 1760 
1130 RETURN 
1140 REM SELECT MANUAL 
1150 PRINT "{clear}{down}{down}     {gray 2}[{reverse on}{green}Manual Drive Select{reverse off}{gray 2}]{down}" 
1160 PRINT "{light blue}You must enter the 8-byte drive" 
1170 PRINT "specification manually. You will be" 
1180 PRINT "asked to enter the bytes one at a time." 
1190 PRINT "Enter 'quit' at any time to abort this" 
1200 PRINT "process.{down}" 
1210 FOR I=0 TO 7:A$="{left}{left}{left}{left}{left}{left}" 
1220 PRINT "{gray 2}Byte{gray 3}"I"{gray 2}[{reverse on}{light blue}0-255{reverse off}{gray 2}] {gray 3}"DT(DE,I)"{gray 2}"LEFT$(A$,LEN(STR$(DT(DE,I)))+2); 
1230 A$="":INPUT A$:IF A$="quit" OR A$="q" THEN I=7: GOTO 1260 
1240 A=VAL(A$):IF A<0 OR A>255 THEN 1220 
1250 A(I)=A 
1260 NEXT :IF A$="quit" THEN PRINT :PRINT "{reverse on}{pink}Entry Aborted!{reverse off}":GOSUB 1770: GOTO 1280 
1270 FOR I=0 TO 7:DT(DE,I)=A(I):NEXT :X=1:GOSUB 1760 
1280 RETURN 
1290 REM SERIAL # CHANGE 
1300 PRINT "{clear}{light blue} Your serial number is {cyan}"; 
1310 FOR I=0 TO 7:PRINT CHR$(PEEK(SV+I));:NEXT :PRINT  
1320 PRINT "{down}{gray 2}Is that correct [{reverse on}{light blue}Y/N{reverse off}{gray 2}]  {gray 3}y{left}{left}{left}{gray 2}"; 
1330 A$="":INPUT A$:IF A$<>"y" AND A$<>"n" THEN 1300 
1340 IF A$="y" THEN RETURN 
1350 PRINT "{down}{down}{reverse on}{gray 2}Input New Serial Number{reverse off} [{reverse on}{light blue}8 Digits{reverse off}{gray 2}]" 
1360 INPUT A$:IF LEN(A$)<>8 THEN 1350 
1370 FOR I=0 TO 7:POKE (SV+I),ASC(MID$(A$,I+1,1)):NEXT : GOTO 1300 
1380 REM READ DRIVE DATA 
1390 PRINT "{clear}{down}{down}{light blue}Please insert your DRIVE DATA DISK in":GOSUB 1810 
1400 A$="":INPUT "{down}{down}{gray 2}Name of File to Load  {gray 3}Seagate SCSI{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{left}{gray 2}";A$ 
1410 IF LEN(A$)<1 OR LEN(A$)>16 THEN 1400 
1420 IF LEFT$(A$,1)<>"-" THEN A$="-"+A$:A$=LEFT$(A$,16) 
1430 DL=0:PRINT "{down}{down}{gray 2}[{reverse on}{light blue}Reading Data{reverse off}{gray 2}]";:OPEN 2,DV,2,A$+",s,r" 
1440 INPUT#2,A$:DL=VAL(A$) 
1450 IF DL=0 THEN PRINT :PRINT "{down}{down}{reverse on}{pink}Not a Valid Data File!{reverse off}":GOSUB 1770: GOTO 1390 
1460 FOR I=1 TO DL:FOR J=0 TO 7 
1470 INPUT#2,A$:IF J=0 THEN D$(I)=A$:PRINT ".";:INPUT#2,A$ 
1480 D(I,J)=VAL(A$) 
1490 NEXT :NEXT  
1500 CLOSE 2:PRINT :GOSUB 1800:RETURN 
1510 REM READ SYSGEN 
1520 PRINT "{down}{down}{down}{gray 2}[{reverse on}{light blue}Reading Drive Table{reverse off}{gray 2}]"; 
1530 OPEN 2,DV,2,"#":OPEN 15,DV,15,"u1,2,0,18,18":INPUT#15,E,E$,T,S:IF E THEN 1730 
1540 FOR I=0 TO 255:PRINT ".";:GET #2,A$:A$=A$+CHR$(0):POKE SV+I,ASC(A$):NEXT  
1550 INPUT#15,E,E$,T,S:IF E THEN 1730 
1560 CLOSE 2:CLOSE 15 
1570 IF NOT(PEEK(SV+157)<>55 OR PEEK(SV+158)<49 OR PEEK(SV+158)>50) THEN PRINT :RETURN 
1580 E$="{reverse on}{pink}Not a 7.1/7.2 SYSGEN disk!{reverse off}": GOTO 1730 
1590 REM WRITE SYSGEN 
1600 PRINT "{down}{down}{down}{gray 2}[{reverse on}{light blue}Saving Drive Table{reverse off}{gray 2}]"; 
1610 OPEN 2,DV,2,"#":OPEN 15,DV,15:PRINT#15,"b-p 2 0" 
1620 FOR I=0 TO 255:PRINT ".";:PRINT#2,CHR$(PEEK(SV+I));:NEXT  
1630 PRINT#15,"u2,2,0,18,18":INPUT#15,E,E$,T,S:IF E THEN 1740 
1640 CLOSE 15:CLOSE 2:PRINT :RETURN 
1650 REM DISPLAY DRIVES 
1660 PRINT "{clear}{down}{down}{down}      {gray 2}[{reverse on}{orange}Drive Table{reverse off}{gray 2}]{down}{down}" 
1670 FOR DE=0 TO 6:GOSUB 1890 
1680 PRINT "    {gray 2}[{reverse on}{yellow}"MID$(STR$(DE),2)"{reverse off}{gray 2}]-";:A$="{light green}("+A$+"Mb)" 
1690 IF A<1 THEN A$="{pink}Not Installed" 
1700 PRINT A$:NEXT  
1710 PRINT "{down}{down} {light blue}Press {reverse on}RETURN{reverse off} to Continue":GOSUB 1820:RETURN 
1720 REM ERRORS 
1730 CLOSE 15:CLOSE 2:PRINT :PRINT "{down}{gray 2}Error on Source Disk!":PRINT E$:STOP 
1740 CLOSE 15:CLOSE 2:PRINT :PRINT "{down}{gray 2}Error on Destination Disk!":PRINT E$:STOP 
1750 REM DONE PROMPT/DELAY 
1760 PRINT "{down}{down}{reverse on}{pink}Changes Saved!{reverse off}" 
1770 FOR I=1 TO 2000:NEXT :RETURN 
1780 REM DISK PROMPT 
1790 PRINT "{clear}"; 
1800 PRINT "{down}{down}{light blue}Please insert your SYSGEN DISK copy in" 
1810 PRINT "drive{cyan}"DV"{light blue}and press {reverse on}RETURN{reverse off} to continue." 
1820 A$="":GET A$:IF A$<>CHR$(13) THEN 1820 
1830 RETURN 
1840 REM Y/N PROMPT 
1850 INPUT "{down}{gray 2}{reverse on}Are You Sure{reverse off} [{reverse on}{light blue}Y/N{reverse off}{gray 2}]  {gray 3}n{left}{left}{left}{gray 2}";A$:IF A$<>"y" AND A$<>"n" THEN 1850 
1860 RETURN 
1870 REM CALC DRIVE SIZE(MB) 
1880 A=DT(DE,2)*DT(DE,3)*(DT(DE,4)*256+DT(DE,5)): GOTO 1900 
1890 A=PEEK(DT+DE*8+2)*PEEK(DT+DE*8+3)*(PEEK(DT+DE*8+4)*256+PEEK(DT+DE*8+5)) 
1900 A=INT(A/204.8)/10:A$=MID$(STR$(A),2) 
1910 RETURN 
1920 REM DEFAULT DATA 
1930 DATA "Seagate ST-225n(20Mb)5.25H",128,0,17,4,2,100,0,0 
1940 DATA "MiniScribe 8425s(20Mb)3.5H",192,0,17,4,2,100,0,0 
1950 DATA "PCST225(20Mb)",4,0,17,4,2,100,128,0 
1960 DATA "PC8650(40Mb)",128,0,17,6,3,41,0,0 
1970 REM  
1980 REM "Please send any correspondence{$00}
1990 REM "such as drive specs, suggested{$00}
2000 REM "improvements, comments, or{$00}
2010 REM "requests to the author:{$00}
2020 REM "             P.Bergeron{$00}
2030 REM "             10 Iroquois Rd.{$00}
2040 REM "             Bristol, CT 06010{$00}
2050 REM "Or use the BBS line above.{$00}
