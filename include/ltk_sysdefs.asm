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
LTK_Command_Buffer	=	$0200 ;command buffer used by exec & processors                        
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;the following are system variable definitions                            
 ;                                                                         
 ;                                                                         
LTK_SysVarBase		=	$8000		;location of system variables                                                                                                        
LTK_Var_ActiveLU	=	LTK_SysVarBase	;current active logical unit                                 
LTK_Var_Active_User	=	$8001		;current active user                                       
LTK_Var_OrigCR		=	$8005		;original c.r. saved on initial entry from a trap *        
LTK_Unused_Byte		=	$8006		;currently unused byte (reserved for future use)           
LTK_DiskRWControl	=	$8007		;disk driver read/write loop control switch                
LTK_Var_CPUMode		= 	$8008		;cpu mode switch (0=c64  <>0=c128) *                       
LTK_Var_BASIC_ExtVec	=	$8009		;basic extensions vector                                   
LTK_Var_Ext_RetVec	=	$800b		;return vector used when calling external routines *      
LTK_Var_Kernel_Basin_Vec=	$800d		;vector to lt kernal basin wedge *                        
LTK_Var_Go64_Vec	=	$8023		;vextor to the go c64 routine                             
LTK_Var_SAndRData	=	$8025		;file's lu# & hdr. blk. adr. - used for save & replace    
LTK_Var_CurRoutine	=	$8028		;current kernal routine continuation number *             
LTK_BeepOnErrorFlag	=	$8029		;beep on error flag (0=no beep)                           
LTK_HD_DevNum		= 	$802a		;location of hard drive device number                     
LTK_ErrorTrapFlag	=	$802b		;location of error trap flag *                            
LTK_Save_Accu		=	$802c		;save location of 'a' for all 'lk' traps                   
LTK_Save_XReg		=	$802d		;save location of 'x' for all 'lk' traps                   
LTK_Save_YReg		=	$802e		;save location of 'y' for all 'lk' traps                   
LTK_Save_P		=	$802f		;save location of 'p' for all 'lk' traps                   
LTK_AutobootFlag	=	$8030		;auto boot flag *                                         
LTK_BLKAddr_DosOvl	=	$8031 		;blk. adr. of current dos overlay                         
LTK_BLKAddr_MiniSub	=	$8032 		;blk. adr. of current mini-sub                            
LTK_CTPOffsetCounter	=	$8033 		;offset counter used for command tail processing           
LTK_Save_PreconfigC	=	$8034 		;temp. storage for preconfiguration register 'c' *        
LTK_Save_PreconfigD	=	$8035		;temp. storage for preconfiguration register 'd' *        
LTK_ReadChanFPTPtr	=	$8036		;current read channel fpt pointer                         
LTK_WriteChanFPTPtr	=	$8037 		;current write channel fpt pointer                        
LTK_Default_CPU_Speed	=	$8038		;default cpu speed (0=1mhz  1=2mhz) *                     
 ;                                                                         
 ;* these locations may be used for reference purposes only.               
 ;  they should never be directly modified by a user written routine !!    
 
LTK_JumpTableBase = LTK_SysVarBase + $39;address of the l.k. jump table                           
LTK_KernalTrapSetup	=	$8039 ;kernal call setup for use trapped kernal routines           
LTK_KernalTrapRemove	=	$803c ;kernal call setup for use of non-trapped kernal routines  
LTK_KernalCall		=	$803f ;kernal calling routine                                    
LTK_ReadFileEntry_AB	=	$8042 ;read file entry for auto-boot sequence **                 
LTK_HDDiscDriver	=	$8045 ;hard drive disc driver routine (for reads & writes)       
LTK_Print		=	$8048 ;character output routine                                  
LTK_FindFile		=	$804b ;find file routine                                         
LTK_LoadRandFile	=	$804e ;load random block list type file                          
LTK_ErrorHandler	=	$8051 ;error handler routine                                     
LTK_CheckDevNum		=	$8054 ;check for hard disk device number routine **              
LTK_SysRet_AsIs		= 	$8057 ;system return - 'rts' with current registers as is **     
LTK_SysRet_OldRegs	=	$805a ;system return - 'rts' with original registers **          
sisrt3=$805d ;system return - 'via lkrtnm' with registers as is **      
sisrt4=$8060 ;system return - 'via lkrtnm' with registers **            
sisrt5=$8063 ;system return - 'abs jmp' with registers as on entry **   
LTK_SaveRegs		=	$8066 ;register save routine **                                  
LTK_LoadRegs		=	$8069 ;register load routine **                                  
clrhdr=$806c ;'hdrblk' area clearing routine                            
dosret=$806f ;doswedge returns here if another dos ovly is called **    
LTK_TPMultiply		=	$8072 ;triple precision multiply routine                         
krcal2=$8075 ;a kercal for use by type 3 trapped calls **               
LTK_AllocateRandomBlks	=	$8078 ;alocate random blocks                                     
alcont=$807b ;alocate contiguous blocks                                 
LTK_AppendBlocks	=	$807e ;append block(s) to file                                   
dealrn=$8081 ;deallocate blocks of a random type file                   
dealcn=$8084 ;deallocate blocks of a contiguous type file               
mlrtrn=$8087 ;machine language return **                                
lodcon=$808a ;load contiguous type file                                 
comchn=$808d ;command channel processor **                              
direct=$8090 ;disk directory processor **                               
dosext=$8093 ;entry point for calling an extended dos overlay           
swpout=$8096 ;memory/disk swapper routine                               
LTK_SetLuActive		=	$8099 ;set an lu active                                          
LTK_ExeExtMiniSub	=	$809c ;entry point for calling an extended mini-sub              
LTK_CmdChnPosition	=	$809f ;entry point for command channel position command **       
LTK_SwapWriteBuffer	=	$80a2 ;entry point for swap 'write' buffer routine **            
LTK_FatalError		=	$80a5 ;entry point for fatal error handler routine               
LTK_HardwarePage	=	$9e43 ;high byte of LTK hardware address (DE/DF)
LTK_GetPortNumber	=	$9f03 ;address of the get port number routine                       
 ;                                                                         
 ;                                                                         
 ;** these routines are used only by special run-time modules.             
 ;   they must never be called by a user written routine !!                
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
 ;                                                                         
LTK_LU_Param_Table = $80a8 ;address of ram resident lu parameter table                   
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
