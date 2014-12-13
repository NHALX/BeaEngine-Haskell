{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.InstrType where
import Foreign.Ptr
import Foreign.C.String
import Data.Word
import Data.Int
import Data.List
import BeaEngine.EFL
#strict_import


{- typedef struct {
            Int32 Category;
            Int32 Opcode;
            char Mnemonic[16];
            Int32 BranchType;
            EFLStruct Flags;
            UInt64 AddrValue;
            Int64 Immediat;
            UInt32 ImplicitModifiedRegs;
        } INSTRTYPE; -}
        
#starttype INSTRTYPE
#field Category , Int32
#field Opcode , Int32
#array_field Mnemonic , CChar
#field BranchType , Int32
#field Flags , <EFLStruct>
#field AddrValue , Word64
#field Immediat , Int64
#field ImplicitModifiedRegs , Word32
#stoptype

cMnemonicS = map castCCharToChar . takeWhile (/=0) . cMnemonic
