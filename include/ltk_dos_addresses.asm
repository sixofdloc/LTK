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
LTK_SysRet_LKRT_AsIs	=	$805d ;system return - 'via lkrtnm' with registers as is **      
LTK_SysRet_LKRT_OldRegs	=	$8060 ;system return - 'via lkrtnm' with registers **            
LTK_SysRet_AbsJmp	=	$8063 ;system return - 'abs jmp' with registers as on entry **   
LTK_SaveRegs		=	$8066 ;register save routine **                                  
LTK_LoadRegs		=	$8069 ;register load routine **                                  
LTK_ClearHeaderBlock	=	$806c ;'hdrblk' area clearing routine                            
LTK_DosWedgeReturn	=	$806f ;doswedge returns here if another dos ovly is called **    
LTK_TPMultiply		=	$8072 ;triple precision multiply routine                         
LTK_KernalCall2		=	$8075 ;a kercal for use by type 3 trapped calls **               
LTK_AllocateRandomBlks	=	$8078 ;alocate random blocks                                     
LTK_AllocContigBlks	=	$807b ;alocate contiguous blocks                                 
LTK_AppendBlocks	=	$807e ;append block(s) to file                                   
LTK_DeallocateRndmBlks	=	$8081 ;deallocate blocks of a random type file                   
LTK_DeallocContigBlks	=	$8084 ;deallocate blocks of a contiguous type file               
LTK_MLReturn		=	$8087 ;machine language return **                                
LTK_LoadContigFile	=	$808a ;load contiguous type file                                 
LTK_CmdChnProcess	=	$808d ;command channel processor **                              
LTK_ProcessDirectory	=	$8090 ;disk directory processor **                               
LTK_CallExtDosOvl	=	$8093 ;entry point for calling an extended dos overlay           
LTK_MemSwapOut		=	$8096 ;memory/disk swapper routine                               
LTK_SetLuActive		=	$8099 ;set an lu active                                          
LTK_ExeExtMiniSub	=	$809c ;entry point for calling an extended mini-sub              
LTK_CmdChnPosition	=	$809f ;entry point for command channel position command **       
LTK_SwapWriteBuffer	=	$80a2 ;entry point for swap 'write' buffer routine **            
LTK_FatalError		=	$80a5 ;entry point for fatal error handler routine               
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
