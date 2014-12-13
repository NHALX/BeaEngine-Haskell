module Main where
import Foreign.C.String
import Foreign.C.Types
import Foreign
import BeaEngine
import qualified Data.ByteString as B
import qualified Data.ByteString.Internal as B
import System.Exit (exitFailure,exitSuccess)
import System.IO.Unsafe
import Debug.Trace

{-- objdump (gnu binutils):
  4013c0:	55                   	push   %ebp
  4013c1:	89 e5                	mov    %esp,%ebp
  4013c3:	83 ec 10             	sub    $0x10,%esp
  4013c6:	c7 45 fc 88 77 66 55 	movl   $0x55667788,-0x4(%ebp)
  4013cd:	b8 c3 f5 48 40       	mov    $0x4048f5c3,%eax
  4013d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  4013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  4013d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  4013db:	8b 45 f8             	mov    -0x8(%ebp),%eax
--}

asm32 = [ "push ebp",
          "mov ebp, esp",
          "sub esp, 10h",
          "mov dword ptr [ebp-04h], 55667788h",
          "mov eax, 4048F5C3h",
          "mov dword ptr [ebp-0Ch], eax",
          "lea eax, dword ptr [ebp-0Ch]",
          "mov dword ptr [ebp-08h], eax",
          "mov eax, dword ptr [ebp-08h]" ]


code32 :: MachineCode
code32 = X86_32 $ B.pack [0x55,0x89,0xe5,0x83,0xec,0x10,0xc7,0x45,0xfc,0x88,0x77,0x66,0x55,0xb8,0xc3,0xf5,0x48,0x40,0x89,0x45,0xf4,0x8d,0x45,0xf4,0x89,0x45,0xf8,0x8b,0x45,0xf8]


{- dumpbin (visual studio):
  0000000140001000: 48 89 4C 24 08     mov         qword ptr [rsp+8],rcx
  0000000140001005: 48 83 EC 28        sub         rsp,28h
  0000000140001009: 48 B8 88 77 66 55  mov         rax,1122334455667788h
                    44 33 22 11
  0000000140001013: 48 89 44 24 08     mov         qword ptr [rsp+8],rax -}

asm64 = [ "mov qword ptr [rsp+08h], rcx",
          "sub rsp, 28h",
          "mov rax, 1122334455667788h",
          "mov qword ptr [rsp+08h], rax" ]

code64 :: MachineCode
code64 = X86_64 $ B.pack [0x48,0x89,0x4C,0x24,0x08,0x48,0x83,0xEC,0x28,0x48,0xB8,0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,0x48,0x89,0x44,0x24,0x08]


toAsm = map cCompleteInstrS . dasm cATSyntax

main = if (toAsm code64 /= asm64) 
       then exitFailure  
       else if (toAsm code32 /= asm32)
            then exitFailure  
            else exitSuccess