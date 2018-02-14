 ;systemdefs for use with the lt. kernal routines                          
 ;                                                                         
 ;                                                                         
 ;misc. host adapter buffers and work ares                                 
 ;                                                                         
cmdbuf=$8db6 ;location of command channel buffer                           
wrtbuf=$8de0 ;location of file write buffer                                
workar=$8fe0 ;misc work area                                               
hdrblk=$91e0 ;file header block work area                                  
minsub=$93e0 ;mini-sub program execution area                              
dosovl=$95e0 ;dos overlay area for system processors and run-time modules  
redbuf=$9be0 ;location of file read buffer                                 
fpttab=$9de0 ;location of the file parameter table (fpt)                   
mesbuf=$9ee0 ;error channel message buffer                                 
dirbuf=$9fe0 ;directory ($) pattern match buffer (32 bytes long)           
 ;                                                                         
 ;                                                                         
 ;file header block offset definitions                                     
 ;                                                                         
filnam=0 ;filename                                                         
nbinfl=$10 ;number of blocks in file (including header)                    
nrpblk=$12 ;number of records per block                                    
nbprec=$14 ;number of bytes per record                                     
nrinfl=$16 ;number of records in file                                      
filtyp=$18 ;file type code (see table below                                
nblkpc=$19 ;number of blocks per cylinder (bitmap only)                    
 ;for other type files, "nblkpc" contains the hi order bit of the          
 ;# of bytes in last block counter (lo order is 'nbytlb').                 
 ;this bit is kept in the least sig. bit                                   
loadad=$1a ;load address of this file                                      
nbytlb=$1c ;# of bytes in last block (lo order part)                       
usrlun=$1d ;user/logical unit                                              
hdrflg=$1e ;header block active flag ($ac or $af = active header)          
blmilo=$20 ;block list (middle & low order bytes)                          
blkavl=$90 ;start of a 3 prec. # of blocks available counter (map only)    
blkusd=$93 ;start of a 3 prec. # of blocks used counter (map only)         
altlod=nrpblk ;alternate load address (used by special proc. only, type 3) 
 ;                                                                         
 ;                                                                         
 ;the following are file type equates                                      
 ;                                                                         
 ;contiguous type files                                                    
 ;                                                                         
 ;                                                                         
sysfil=1 ;contiguous dos system file (ex. discmap & index)                 
prsfil=2 ;contiguous dos processor file (ex. save,dir,del  etc.)           
sprfil=3 ;special dos processor, runs outside dosovl area (via swapper)    
indfil=4 ;multiple directory index file                                    
cntfil=5 ;contiguous data file                                             
 ;                                                                         
 ;                                                                         
 ;random block list type files                                             
 ;                                                                         
 ;                                                                         
basfil=11 ;basic language program file                                     
rndfil=12 ;random m.l. file                                                
seqfil=13 ;random sequential file (ex. text files)                         
usrfil=14 ;user file                                                       
relfil=15 ;relative file                                                   
ranfil=16 ;random file (#) - one per lu allowed                            
 ;                                                                         
 ;                                                                         
 ;misc. system vectors and control locations                               
 ;                                                                         
bnkout=$fc4e ;address of the kernal bank-out routine in shadow ram         
bnkswt=$fc5f ;kertrap bank control switch                                  
keyenb=$fc60 ;numeric keypad enable flag ($ff=enabled 0=disabled)          
bankin=$fc71 ;kertrap bank in routine                                      
basext=$fc74 ;basic extensions trap vector (ex. key file routines)         
go64md=$fc7a ;go 64 mode entry point (used by c128 mode)                   
idx64=$c8 ;index to current position in the basic input buffer @ $0200     
idx128=$ea ;index to current position in the basic input buffer @ $0200    
errchn=$e0 ;error channel fpt offset                                       
buf=$0200 ;command buffer used by exec & processors                        
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following are system variable definitions                            
 ;                                                                         
 ;                                                                         
sysvar=$8000 ;location of system variables                                 
 ;                                                                         
activl=sysvar ;current active logical unit                                 
activu=sysvar+1 ;current active user                                       
origcr=sysvar+5 ;original c.r. saved on initial entry from a trap *        
unusd1=sysvar+6 ;currently unused byte (reserved for future use)           
drvswt=sysvar+7 ;disk driver read/write loop control switch                
modesw=sysvar+8 ;cpu mode switch (0=c64  <>0=c128) *                       
basvec=sysvar+9 ;basic extensions vector                                   
kerrtn=sysvar+11 ;return vector used when calling external routines *      
lkwedg=sysvar+13 ;vector to lt kernal basin wedge *                        
goto64=sysvar+35 ;vextor to the go c64 routine                             
savnam=sysvar+37 ;file's lu# & hdr. blk. adr. - used for save & replace    
lkrnum=sysvar+40 ;current kernal routine continuation number *             
beepfl=sysvar+41 ;beep on error flag (0=no beep)                           
hrdnum=sysvar+42 ;location of hard drive device number                     
ertrpf=sysvar+43 ;location of error trap flag *                            
origa=sysvar+44 ;save location of 'a' for all 'lk' traps                   
origx=sysvar+45 ;save location of 'x' for all 'lk' traps                   
origy=sysvar+46 ;save location of 'y' for all 'lk' traps                   
origp=sysvar+47 ;save location of 'p' for all 'lk' traps                   
autbot=sysvar+48 ;auto boot flag *                                         
crdsov=sysvar+49 ;blk. adr. of current dos overlay                         
crmins=sysvar+50 ;blk. adr. of current mini-sub                            
cntr1=sysvar+51 ;offset counter used for command tail processing           
svpcrc=sysvar+52 ;temp. storage for preconfiguration register 'c' *        
svpcrd=sysvar+53 ;temp. storage for preconfiguration register 'd' *        
redchn=sysvar+54 ;current read channel fpt pointer                         
wrtchn=sysvar+55 ;current write channel fpt pointer                        
cpuspd=sysvar+56 ;default cpu speed (0=1mhz  1=2mhz) *                     
 ;                                                                         
 ;                                                                         
 ;* these locations may be used for reference purposes only.               
 ;  they should never be directly modified by a user written routine !!    
 ;                                                                         
 ;                                                                         
 ;the following are the lkdos jump table subroutine equates:               
 ;                                                                         
 ;                                                                         
jumptb=sysvar+57 ;address of the l.k. jump table                           
 ;                                                                         
 ;                                                                         
kurset=jumptb ;kernal call setup for use trapped kernal routines           
kurst2=kurset+3 ;kernal call setup for use of non-trapped kernal routines  
kercal=kurst2+3 ;kernal calling routine                                    
redfil=kercal+3 ;read file entry for auto-boot sequence **                 
driver=redfil+3 ;hard drive disc driver routine (for reads & writes)       
output=driver+3 ;character output routine                                  
fnfile=output+3 ;find file routine                                         
lodrnd=fnfile+3 ;load random block list type file                          
erhand=lodrnd+3 ;error handler routine                                     
chekdv=erhand+3 ;check for hard disk device number routine **              
sisrt1=chekdv+3 ;system return - 'rts' with current registers as is **     
sisrt2=sisrt1+3 ;system return - 'rts' with original registers **          
sisrt3=sisrt2+3 ;system return - 'via lkrtnm' with registers as is **      
sisrt4=sisrt3+3 ;system return - 'via lkrtnm' with registers **            
sisrt5=sisrt4+3 ;system return - 'abs jmp' with registers as on entry **   
savrgs=sisrt5+3 ;register save routine **                                  
lodrgs=savrgs+3 ;register load routine **                                  
clrhdr=lodrgs+3 ;'hdrblk' area clearing routine                            
dosret=clrhdr+3 ;doswedge returns here if another dos ovly is called **    
mltply=dosret+3 ;triple precision multiply routine                         
krcal2=mltply+3 ;a kercal for use by type 3 trapped calls **               
alrand=krcal2+3 ;alocate random blocks                                     
alcont=alrand+3 ;alocate contiguous blocks                                 
apblok=alcont+3 ;append block(s) to file                                   
dealrn=apblok+3 ;deallocate blocks of a random type file                   
dealcn=dealrn+3 ;deallocate blocks of a contiguous type file               
mlrtrn=dealcn+3 ;machine language return **                                
lodcon=mlrtrn+3 ;load contiguous type file                                 
comchn=lodcon+3 ;command channel processor **                              
direct=comchn+3 ;disk directory processor **                               
dosext=direct+3 ;entry point for calling an extended dos overlay           
swpout=dosext+3 ;memory/disk swapper routine                               
setlun=swpout+3 ;set an lu active                                          
mnsext=setlun+3 ;entry point for calling an extended mini-sub              
percmd=mnsext+3 ;entry point for command channel position command **       
swpwrb=percmd+3 ;entry point for swap 'write' buffer routine **            
faterr=swpwrb+3 ;entry point for fatal error handler routine               
gtport=$9f03 ;address of the get port number routine                       
 ;                                                                         
 ;                                                                         
 ;** these routines are used only by special run-time modules.             
 ;   they must never be called by a user written routine !!                
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
ltable=$80a8 ;address of ram resident lu parameter table                   
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;lu table entries consist of 5 bytes each and are defined as follows:     
 ;                                                                         
 ;(byte 0)                                                                 
 ;                                                                         
 ;bit(s)       use                                                         
 ;-------------------------------                                          
 ; 7----------active lu flag (0=active)                                    
 ; 6,5--------physical drive number (0-3)                                  
 ; 4,3,2------physical controller number (0-7)                             
 ; 1,0--------beginning cylinder address (hi order)                        
 ;                                                                         
 ;(byte 1)                                                                 
 ;                                                                         
 ; beginning cylinder address (low order)                                  
 ;                                                                         
 ;(byte 2)                                                                 
 ;                                                                         
 ;bit(s)       use                                                         
 ;-------------------------------                                          
 ; 7,6,5,4----number of physical heads (0-15)                              
 ; 3----------dos image file flag (1=dos image does exist on this lu)      
 ; 2,1,0------number of cylinders (hi order)                               
 ;                                                                         
 ;(byte 3)                                                                 
 ;                                                                         
 ; number of cylinders (low order)                                         
 ;                                                                         
 ;(byte 4)                                                                 
 ;                                                                         
 ; number of sectors per track                                             
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following are kernal routine equates                                 
 ;they are used to get to normal kernal routines via a continuation        
 ;vector.  this is necessary for use of those kernal routines traped       
 ;by the host adapter logic.                                               
 ;refer to "kurset & kercal" calling procedures                            
 ;                                                                         
 ;                                                                         
lkopen=0 ;kernal open routine                                              
lkcloz=lkopen+2 ;kernal close routine                                      
lkchin=lkcloz+2 ;kernal open channel for input routine                     
lkchot=lkchin+2 ;kernal open channel for output routine                    
lkclch=lkchot+2 ;kernal close input & output channels routine              
lkchri=lkclch+2 ;kernal input character from channel routine               
lkchro=lkchri+2 ;kernal output character to channel routine                
lkgtin=lkchro+4 ;kernal get character routine                              
lkclal=lkgtin+2 ;kernal close all files & channels routine                 
lkload=lkclal+2 ;kernal load ram routine                                   
lksave=lkload+2 ;kernal save ram routine                                   
 ;                                                                         
 ;                                                                         
 ;                                                                         
catlog=$24 ;block containing index catalog routine                         
 ;                                                                         
 ;the following are error channel message file definitions:                
 ;refer to the "error handler" calling procedures                          
 ;                                                                         
 ;                                                                         
dosm00=00 ;00,ok,00,00                                                     
dosm01=01 ;01,files scratched,00,00                                        
dosm02=02 ;01,files scratched,01,00                                        
dosm30=30 ;30,syntax error,00,00                                           
dosm31=31 ;31,syntax error,00,00                                           
dosm33=33 ;33,illegal filename,00,00                                       
dosm50=50 ;50,record not present,00,00                                     
dosm51=51 ;51,overflow in record                                           
dosm52=52 ;52,file too large,00,00                                         
dosm60=60 ;60,file open for write,00,00                                    
dosm61=61 ;61,file not open,00,00                                          
dosm62=62 ;62,file not found,00,00                                         
dosm63=63 ;63,file exists,00,00                                            
dosm64=64 ;64,file type mismatch,00,00                                     
dosm65=65 ;65,no block,00,00                                               
dosm70=70 ;70,no channel available,00,00                                   
dosm72=72 ;72,disk/directory full,00,00                                    
dosm73=73 ;73,power up message                                             
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following parms. define the locations of system files                
 ;                                                                         
parmfl=$029e ;address of the port parameters file(1 block per port)        
swapfl=$02ae ;address of the port swapfile (8 blocks per port)             
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the folowing are offset defs. for each port's parameter block of the     
 ;system config file :                                                     
 ;                                                                         
 ;                                                                         
pbc064=0 ;border color (c64)                                               
psc064=pbc064+1 ;screen color (c64)                                        
pcc064=psc064+1 ;cursor color (c64)                                        
pbc428=pcc064+1 ;border color (c128/40col)                                 
psc428=pbc428+1 ;screen color (c128/40col)                                 
pcc428=psc428+1 ;cursor color (c128/40col)                                 
psc828=pcc428+1 ;screen color (c128/80col)                                 
pcc828=psc828+1 ;cursor color (c128/80col)                                 
pdn064=pcc828+1 ;drive number (c64)                                        
pdn128=pdn064+1 ;drive number (c128)                                       
plu064=pdn128+1 ;logical unit (c64)                                        
plu128=plu064+1 ;logical unit (c128)                                       
pus064=plu128+1 ;user number (c64)                                         
pus128=pus064+1 ;user number (c128)                                        
pbf064=pus128+1 ;beep flag (c64)                                           
pbf128=pbf064+1 ;beep flag (c128)                                          
ppd064=pbf128+1 ;printer device # (c64)                                    
ppd128=ppd064+1 ;printer device # (c128)                                   
pps064=ppd128+1 ;printer secondary address (c64)                           
pps128=pps064+1 ;printer secondary address (c128)                          
pal064=pps128+1 ;auto serial load flag (c64)                               
pal128=pal064+1 ;auto serial load flag (c128)                              
psf064=pal128+1 ;pattern match scratch flag (c64)                          
psf128=psf064+1 ;pattern match scratch flag (c128)                         
pcpumd=psf128+1 ;cpu mode                                                  
psp064=pcpumd+1 ;cpu speed (c64)                                           
psp128=psp064+1 ;cpu speed (c128)                                          
pkpden=psp128+1 ;keypad enable flag (c64 only)                             
pir064=pkpden+1 ;irq trap (c64)                                            
pir128=pir064+1 ;irq trap (c128)                                           
pnm064=pir128+1 ;nmi trap (c64)                                            
pnm128=pnm064+1 ;nmi trap (c128)                                           
plr064=pnm128+1 ;port lock retry count (c64)                               
plr128=plr064+1 ;port lock retry count (c128)                              
pcpmlu=plr128+1 ;this port's cp/m logical unit                             
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following are system index block equates:                            
 ;                                                                         
indnam=$00 ;file's name (16 characters)                                    
indnbl=$10 ;number of blocks in file (incl. header) hi,lo order            
indbpr=$12 ;number of bytes per record  hi,lo order                        
indrin=$14 ;number of records in file hi,lo order                          
indtyp=$16 ;file's type code                                               
indlod=$17 ;file's load address hi,lo order                                
indusr=$19 ;file's user/lu indicator                                       
indflg=$1a ;file's status flags (such as: changed since last backup bit)   
indrs1=$1b ;reserved for future use                                        
entcnt=$1c ;number of active entries in this index block (1st slot only)   
indacf=$1d ;active slot indicator for this index entry (***)               
indhba=$1e ;file's header block address  hi,lo order                       
 ;                                                                         
 ;                                                                         
 ; *** 0=currently active entry,$ff=never used entry,$80=deleted file      
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following are the file parameter table (fpt) equates.  each table    
 ;consists of 32 bytes.
 ;                                                                         
 ;                                                                         
logfln=$00 ;logical file number(1 byte - $ff=unused fpt)                   
fiload=$01 ;file's load address(2 bytes - hi,lo order)                     
resrvd=$03 ;bytes 3,4 and 5 are reserved for internal use                  
userlu=$06 ;file's user/lu indicator                                       
filhdr=$07 ;file's header block address(2 bytes - hi,lo order)             
crblok=$09 ;current block displacement from file's hdr. or from blk list   
absblk=$0b ;absolute blk. adr. of current block (2 bytes)                  
curbyt=$0d ;current byte of file(3 bytes i.e. next to be accessed)         
numblk=$10 ;number of blocks in file(incl. hdr.(2 bytes - hi,lo order)     
numrec=$12 ;number of records in file(2 bytes - hi,lo order)               
numbyt=$14 ;number of bytes in file(excl. hdr. 3 bytes - hi,mi,lo)         
numbpr=$17 ;number of bytes per record(2 bytes - hi,lo order)              
typfil=$19 ;type of file(1 byte - see file type equates above)             
filsts=$1a ;file's status(1 byte - hi order bit 0f # of bytes in           
 ;last block is the least sig. bit)                                        
numblb=$1b ;number of bytes in last block(1 byte - lo order part)          
eofflg=$1c ;end of file flag                                               
idxofs=$1d ;offset to index block containing file's entry                  
lodflg=$1e ;used as flag when passing a files load address                 
secadr=$1f ;file's secondary address                                       
 ;                                                                         
