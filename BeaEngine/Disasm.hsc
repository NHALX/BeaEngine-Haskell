{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.Disasm where
import Foreign.Ptr
import Foreign.C.String
import Data.Word
import Data.Int
import Data.List
import BeaEngine.REX
import BeaEngine.PrefixInfo
import BeaEngine.EFL
import BeaEngine.MemoryType
import BeaEngine.InstrType
import BeaEngine.ArgType
import BeaEngine.Constants
#strict_import



{- typedef struct _Disasm {
            UIntPtr EIP;
            UInt64 VirtualAddr;
            UInt32 SecurityBlock;
            char CompleteInstr[64];
            UInt32 Archi;
            UInt64 Options;
            INSTRTYPE Instruction;
            ARGTYPE Argument1;
            ARGTYPE Argument2;
            ARGTYPE Argument3;
            PREFIXINFO Prefix;
            UInt32 Reserved_[40];
        } DISASM, * PDISASM, * LPDISASM; -}
        
#starttype struct _Disasm
#field EIP , WordPtr
#field VirtualAddr , Word64
#field SecurityBlock , Word32
#array_field CompleteInstr , CChar
#field Archi , Word32
#field Options , Word64
#field Instruction , <INSTRTYPE>
#field Argument1 , <ARGTYPE>
#field Argument2 , <ARGTYPE>
#field Argument3 , <ARGTYPE>
#field Prefix , <PREFIXINFO>
#array_field Reserved_ , Word32
#stoptype

#synonym_t DISASM , <struct _Disasm>
#synonym_t PDISASM , <struct _Disasm>
#synonym_t LPDISASM , <struct _Disasm>

#ccall Disasm , Ptr <struct _Disasm> -> IO CInt
#ccall BeaEngineVersion , IO CString
#ccall BeaEngineRevision , IO CString

cCompleteInstrS = map castCCharToChar . takeWhile (/=0) . cCompleteInstr

beaEngineVersion = peekCString =<< cBeaEngineVersion

beaEngineRevision = peekCString =<< cBeaEngineRevision


disasm :: WordPtr -> Word64 -> WordPtr -> Word32 -> Word64 -> IO (Either Int (Int,C_Disasm))
disasm eip vma limit arch opt = alloca $ \p -> do
    (#poke struct _Disasm, EIP) p eip
    (#poke struct _Disasm, VirtualAddr) p vma
    (#poke struct _Disasm, SecurityBlock) p limit
    (#poke struct _Disasm, Archi) p arch
    (#poke struct _Disasm, Options) p opt
    
    wrap p =<< cDisasm p
    
    where 
        wrap p x
            | x == cUNKNOWN_OPCODE = return $ Left (fromIntegral x)
            | x == cOUT_OF_BLOCK   = return $ Left (fromIntegral x)
            | otherwise            = do 
                                        d2 <- peek p 
                                        return $ Right (fromIntegral x,d2)



                                        