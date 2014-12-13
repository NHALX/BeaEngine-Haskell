module Main where
import Foreign.C.String
import Foreign.C.Types
import Foreign
import BeaEngine.Disasm
import BeaEngine.REX
import BeaEngine.PrefixInfo
import BeaEngine.EFL
import BeaEngine.MemoryType
import BeaEngine.InstrType
import BeaEngine.ArgType
import BeaEngine.Constants

import System.Exit (exitFailure,exitSuccess)


testMEMORYTYPE = CMEMORYTYPE{
                 cBaseRegister = 0,
                 cIndexRegister = 1,
                 cScale = 2,
                 cDisplacement = 3
                }
                                        
testARGTYPE = CARGTYPE{
              cArgMnemonic = toCSTRZ "ArgMnemonic",
              cArgType = 1,
              cArgSize = 2,
              cArgPosition = 3,
              cAccessMode = 4,
              cMemory = testMEMORYTYPE,
              cSegmentReg = 5
            }

testEFLStruct = CEFLStruct{
                cOF_ = 1,
                cSF_ = 2,
                cZF_ = 3,
                cAF_ = 4,
                cPF_ = 5,
                cCF_ = 6,
                cTF_ = 7,
                cIF_ = 8,
                cDF_ = 9,
                cNT_ = 10,
                cRF_ = 11,
                BeaEngine.EFL.calignment = 12
                }
                
testINSTRTYPE = CINSTRTYPE{
                cCategory = 0,
                cOpcode = 1,
                cMnemonic = toCSTRZ "InstrMnemonic",
                cBranchType = 2,
                cFlags = testEFLStruct,
                cAddrValue = 3,
                cImmediat = 4,
                cImplicitModifiedRegs = 5
              }

testREXSTRUCT = CREX_Struct{
                  cW_ = 0,
                  cR_ = 1,
                  cX_ = 2,
                  cB_ = 3,
                  cstate = 4
                }

testPREFIXINFO = CPREFIXINFO{
                  cNumber = 0,
                  cNbUndefined = 1,
                  cLockPrefix = 2,
                  cOperandSize = 3,
                  cAddressSize = 4,
                  cRepnePrefix = 5,
                  cRepPrefix = 6,
                  cFSPrefix = 7,
                  cSSPrefix = 8,
                  cGSPrefix = 9,
                  cESPrefix = 10,
                  cCSPrefix = 11,
                  cDSPrefix = 12,
                  cBranchTaken = 13,
                  cBranchNotTaken = 14,
                  cREX = testREXSTRUCT,
                  BeaEngine.PrefixInfo.calignment = toCSTRZ "8"
                }
                 
test_Disasm :: C_Disasm
test_Disasm = C_Disasm{
                cEIP=1,
                cVirtualAddr=2,
                cSecurityBlock=3,
                cCompleteInstr=toCSTRZ "inst",
                cArchi=4,
                cOptions=5,
                cInstruction=testINSTRTYPE,
                cArgument1=testARGTYPE,
                cArgument2=testARGTYPE,
                cArgument3=testARGTYPE,
                cPrefix=testPREFIXINFO,
                cReserved_=[9,10,11]}

toCSTRZ x = (map castCharToCChar x) ++ [0]


        
foreign import ccall unsafe "print_disasm"
    c_print_disasm :: Ptr C_Disasm -> IO ()

foreign import ccall unsafe "test_marshal"
    c_test_marshal :: Ptr C_Disasm -> IO CInt

main = alloca $ \p -> do 
    poke p test_Disasm
    x <- c_test_marshal p 
    if (x /= 0)
      then exitFailure
      else exitSuccess
    --c_print_disasm p
    