;Out-of-DOS routines
LTK_GetPortNumber	=	$9f03 ;address of the get port number routine                       


;Buffers and Work Areas
LTK_CMDChannelBuffer	=	$8db6 ;location of command channel buffer                           
LTK_FileWriteBuffer	=	$8de0 ;location of file write buffer                                
LTK_MiscWorkspace	=	$8fe0 ;misc work area                                               
LTK_FileHeaderBlock	=	$91e0 ;file header block work area                                  
LTK_MiniSubExeArea	=	$93e0 ;mini-sub program execution area                              
LTK_DOSOverlay		=	$95e0 ;dos overlay area for system processors and run-time modules  
LTK_FileReadBuffer	=	$9be0 ;location of file read buffer                                 
LTK_FileParamTable	=	$9de0 ;location of the file parameter table (fpt)                   
LTK_ErrMsgBuffer	=	$9ee0 ;error channel message buffer                                 
LTK_DirPtnMatchBuffer	=	$9fe0 ;directory ($) pattern match buffer (32 bytes long)           
 
;File Header Block (FHB) offsets
LTK_FHB_Filename	=	$00 ;filename                                                         
LTK_FHB_NumBlocks	=	$10 ;number of blocks in file (including header)                    
LTK_FHB_NumRecs		=	$12 ;number of records per block                                    
LTK_FHB_BytesPerRec	=	$14 ;number of bytes per record                                     
LTK_FHB_RecsInFile	=	$16 ;number of records in file                                      
LTK_FHB_FileType	=	$18 ;file type code (see table below                                
LTK_FHB_BlocksPerCyl	=	$19 ;number of blocks per cylinder (bitmap only)                    
 ;for other type files, "LTK_FHB_BlocksPerCyl" contains the hi order bit of the          
 ;# of bytes in last block counter (lo order is 'LTK_FHB_LastBlockBytes').                 
 ;this bit is kept in the least sig. bit                                   
LTK_FHB_LoadAddress	=	$1a ;load address of this file                                      
LTK_FHB_LastBlockBytes	=	$1c ;# of bytes in last block (lo order part)                       
LTK_FHB_UserAndLU	=	$1d ;user/logical unit                                              
LTK_FHB_HeaderBlockAct	=	$1e ;header block active flag ($ac or $af = active header)          
LTK_FHB_BLMiLo		=	$20 ;block list (middle & low order bytes)                          
LTK_FHB_BlocksAvail	=	$90 ;start of a 3 prec. # of blocks available counter (map only)    
LTK_FHB_BlocksUsed	=	$93 ;start of a 3 prec. # of blocks used counter (map only)         
LTK_FHB_AltLoadAddr	=	LTK_FHB_NumRecs ;alternate load address (used by special proc. only, type 3) 

;File types, contiguous
LTK_FileType_SYS	=	$01 ;contiguous dos system file (ex. discmap & index)                 
LTK_FileType_PROC	=	$02 ;contiguous dos processor file (ex. save,dir,del  etc.)           
LTK_FileType_SPEC	=	$03 ;special dos processor, runs outside dosovl area (via swapper)    
LTK_FileType_MDI	=	$04 ;multiple directory index file                                    
LTK_FileType_CDF	=	$05 ;contiguous data file                                             
 ;                                                                         
 ;                                                                         
 ;random block list type files                                             
 ;                                                                         
 ;                                                                         
LTK_FileType_BASIC	=	$0b ;basic language program file                                     
LTK_FileType_PRG	=	$0c ;random m.l. file                                                
LTK_FileType_SEQ	=	$0d ;random sequential file (ex. text files)                         
LTK_FileType_USR	=	$0e ;user file                                                       
LTK_FileType_REL	=	$0f ;relative file                                                   
LTK_FileType_RND	=	$10 ;random file (#) - one per lu allowed                            


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
dosm00=$00 ;00,ok,00,00                                                     
dosm01=$01 ;01,files scratched,00,00                                        
dosm02=$02 ;01,files scratched,01,00                                        
dosm30=$1e ;30,syntax error,00,00                                           
dosm31=$1f ;31,syntax error,00,00                                           
dosm33=$21 ;33,illegal filename,00,00                                       
dosm50=$32 ;50,record not present,00,00                                     
dosm51=$33 ;51,overflow in record                                           
dosm52=$34 ;52,file too large,00,00                                         
dosm60=$3c ;60,file open for write,00,00                                    
dosm61=$3d ;61,file not open,00,00                                          
dosm62=$3e ;62,file not found,00,00                                         
dosm63=$3f ;63,file exists,00,00                                            
dosm64=$40 ;64,file type mismatch,00,00                                     
dosm65=$41 ;65,no block,00,00                                               
dosm70=$46 ;70,no channel available,00,00                                   
dosm72=$47 ;72,disk/directory full,00,00                                    
dosm73=$48 ;73,power up message                                             
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
LTK_FPT_LFN		=	$00 ;logical file number(1 byte - $ff=unused fpt)                   
LTK_FPT_LoadAddr	=	$01 ;file's load address(2 bytes - hi,lo order)                     
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
 ;                                                                         
 ;                                                                         
 ;misc. system vectors and control locations                               
 ;                                                                         
LTK_Krn_BankOut		=	$fc4e 	;address of the kernal bank-out routine in shadow ram         
LTK_Krn_BankControl	=	$fc5f 	;kertrap bank control switch                                  
LTK_Krn_KeypadEnable	=	$fc60 	;numeric keypad enable flag ($ff=enabled 0=disabled)          
LTK_Krn_BankIn		=	$fc71 	;bankin=$fc71 ;kertrap bank in routine                                      
LTK_Krn_BasExtTrap	=	$fc74 	;basic extensions trap vector (ex. key file routines)         
LTK_Krn_Go64		=	$fc7a 	;go 64 mode entry point (used by c128 mode)    

idx64			=	$c8 	;index to current position in the basic input buffer @ $0200     
idx128			=	$ea 	;index to current position in the basic input buffer @ $0200    
errchn			=	$e0 	;error channel fpt offset                                       
LTK_Command_Buffer	=	$0200 	;command buffer used by exec & processors            