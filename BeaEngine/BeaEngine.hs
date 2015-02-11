module BeaEngine 
    (MachineCode(..),dasm,mc_id,
     module BeaEngine.Disasm,
     module BeaEngine.REX,
     module BeaEngine.PrefixInfo,
     module BeaEngine.MemoryType,
     module BeaEngine.InstrType,
     module BeaEngine.ArgType,
     module BeaEngine.Constants,
     module BeaEngine.EFL
    )
where
import Foreign.C.String
import Foreign.C.Types
import Foreign
import BeaEngine.Disasm
import BeaEngine.REX 
import BeaEngine.PrefixInfo hiding (palignment,calignment)
import BeaEngine.EFL        hiding (palignment,calignment)
import BeaEngine.MemoryType
import BeaEngine.InstrType
import BeaEngine.ArgType
import BeaEngine.Constants
import qualified Data.ByteString as B
import qualified Data.ByteString.Internal as B
import System.IO.Unsafe
import Debug.Trace

data MachineCode = X86_16 { mc_data :: B.ByteString }
                 | X86_32 { mc_data :: B.ByteString }
                 | X86_64 { mc_data :: B.ByteString }

mc_id :: MachineCode -> Word32
mc_id X86_32{} = 0
mc_id X86_16{} = 16
mc_id X86_64{} = 64



dasm a b = unsafePerformIO (dasmIO a b)

dasmIO :: Word64 -> MachineCode -> IO [C_Disasm]
dasmIO options code' = do --allocaBytes (length code) $ \c -> 
  let (b,bi,bn) = B.toForeignPtr (mc_data code')
  withForeignPtr b $ \c -> do
           alloca $ \d -> do           
             poke (pArchi d) (mc_id code')
             poke (pOptions d) options

             f bn d (fromIntegral $ ptrToIntPtr (c `plusPtr` bi)) 0

    where

      f :: Int -> Ptr C_Disasm -> Word64 -> WordPtr -> IO [C_Disasm]
      f codeN d vmbase offset
          | limit > 0 = do
                        poke (pEIP d) (fromIntegral vmbase + offset)
                        poke (pVirtualAddr d) vmbase
                        poke (pSecurityBlock d) limit

                        n <- cDisasm d
                       
                        if (n <= 0)
                           then error ("disasm: " ++ (show (n,limit,offset)))
                           else do
                             v <- peek d
                             return . (v:) =<< (unsafeInterleaveIO $ f codeN d vmbase (offset + fromIntegral n))
          where
            limit = max 0 (fromIntegral $ codeN - (fromIntegral offset))

      f _ _ _ _ = return []