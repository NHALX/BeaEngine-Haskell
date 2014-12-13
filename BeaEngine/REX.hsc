{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.REX where
import Foreign.Ptr
import Data.Word
import Data.Int
#strict_import


{- typedef struct {
            UInt8 W_; UInt8 R_; UInt8 X_; UInt8 B_; UInt8 state;
        } REX_Struct; -}
        
#starttype REX_Struct
#field W_ , Word8
#field R_ , Word8
#field X_ , Word8
#field B_ , Word8
#field state , Word8
#stoptype
