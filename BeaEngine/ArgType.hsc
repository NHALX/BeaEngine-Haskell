{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.ArgType where
import Foreign.Ptr
import Foreign.C.String
import Data.Word
import Data.Int
import Data.List
import BeaEngine.MemoryType
#strict_import


{- typedef struct {
            char ArgMnemonic[64];
            Int32 ArgType;
            Int32 ArgSize;
            Int32 ArgPosition;
            UInt32 AccessMode;
            MEMORYTYPE Memory;
            UInt32 SegmentReg;
        } ARGTYPE; -}
        
#starttype ARGTYPE
#array_field ArgMnemonic , CChar
#field ArgType , Int32
#field ArgSize , Int32
#field ArgPosition , Int32
#field AccessMode , Word32
#field Memory , <MEMORYTYPE>
#field SegmentReg , Word32
#stoptype

cArgMnemonicS = map castCCharToChar . takeWhile (/=0) . cArgMnemonic
