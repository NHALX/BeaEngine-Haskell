{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.MemoryType where
import Foreign.Ptr
import Data.Word
import Data.Int
#strict_import



{- typedef struct {
            Int32 BaseRegister;
            Int32 IndexRegister;
            Int32 Scale;
            Int64 Displacement;
        } MEMORYTYPE; -}
        
#starttype MEMORYTYPE
#field BaseRegister , Int32
#field IndexRegister , Int32
#field Scale , Int32
#field Displacement , Int64
#stoptype
