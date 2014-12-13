{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.custom.h>
#include <BeaEngine.h>
module BeaEngine.PrefixInfo where
import Foreign.Ptr
import Data.Word
import Data.Int
import BeaEngine.REX
#strict_import



{- typedef struct {
            int Number;
            int NbUndefined;
            UInt8 LockPrefix;
            UInt8 OperandSize;
            UInt8 AddressSize;
            UInt8 RepnePrefix;
            UInt8 RepPrefix;
            UInt8 FSPrefix;
            UInt8 SSPrefix;
            UInt8 GSPrefix;
            UInt8 ESPrefix;
            UInt8 CSPrefix;
            UInt8 DSPrefix;
            UInt8 BranchTaken;
            UInt8 BranchNotTaken;
            REX_Struct REX;
            char alignment[2];
        } PREFIXINFO; -}
        
#starttype PREFIXINFO
#field Number , CInt
#field NbUndefined , CInt
#field LockPrefix , Word8
#field OperandSize , Word8
#field AddressSize , Word8
#field RepnePrefix , Word8
#field RepPrefix , Word8
#field FSPrefix , Word8
#field SSPrefix , Word8
#field GSPrefix , Word8
#field ESPrefix , Word8
#field CSPrefix , Word8
#field DSPrefix , Word8
#field BranchTaken , Word8
#field BranchNotTaken , Word8
#field REX , <REX_Struct>
#array_field alignment , CChar
#stoptype
