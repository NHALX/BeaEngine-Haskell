{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.EFL where
import Foreign.Ptr
import Data.Word
import Data.Int
#strict_import


{- typedef struct {
            UInt8 OF_;
            UInt8 SF_;
            UInt8 ZF_;
            UInt8 AF_;
            UInt8 PF_;
            UInt8 CF_;
            UInt8 TF_;
            UInt8 IF_;
            UInt8 DF_;
            UInt8 NT_;
            UInt8 RF_;
            UInt8 alignment;
        } EFLStruct; -}
        
#starttype EFLStruct
#field OF_ , Word8
#field SF_ , Word8
#field ZF_ , Word8
#field AF_ , Word8
#field PF_ , Word8
#field CF_ , Word8
#field TF_ , Word8
#field IF_ , Word8
#field DF_ , Word8
#field NT_ , Word8
#field RF_ , Word8
#field alignment , Word8
#stoptype