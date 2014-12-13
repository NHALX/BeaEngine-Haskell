#include <BeaEngine.h>
#include <stdio.h>
#include <inttypes.h>
#include <string.h>

void
print_EFL(EFLStruct *x)
{
    printf("EFLStruct:\n OF=%d, SF=%d, ZF=%d, AF=%d, PF=%d, CF=%d, TF=%d, IF=%d, DF=%d, NT=%d, RF=%d, alignment=%d\n\n",
        x->OF_, x->SF_, x->ZF_, x->AF_, x->PF_, 
        x->CF_, x->TF_, x->IF_, x->DF_, x->NT_, 
        x->RF_, x->alignment);
        
}

void print_memtype(MEMORYTYPE *x)
{
    printf("MEMORYTYPE:\n BaseRegister=%d, IndexRegister=%d, Scale=%d, Displacement=%"PRId64"\n\n", 
        x->BaseRegister, 
        x->IndexRegister, 
        x->Scale, 
        x->Displacement);
}

     
void
print_instruction(INSTRTYPE *x)
{
    printf("INSTRTYPE:\n Category=%d,\n Opcode=%d,\n Mnemonic=%s,\n BranchType=%d,\n Flags=...,\n AddrValue=%"PRId64"\n Immediat=%"PRId64"\n ImplicitModifiedRegs=%d\n\n", 
        x->Category, 
        x->Opcode,
        x->Mnemonic,
        x->BranchType,
        x->AddrValue,
        x->Immediat,
        x->ImplicitModifiedRegs); 
        
    print_EFL(&x->Flags);
}

void print_argument(ARGTYPE *x)
{
    printf("ARGTYPE:\n ArgMnemonic=%s,\n ArgType=%d,\n ArgSize=%d,\n ArgPosition=%d,\n AccessMode=%d,\n Memory=...,\n SegmentReg=%d\n\n",
        x->ArgMnemonic,
        x->ArgType,
        x->ArgSize,
        x->ArgPosition,
        x->AccessMode,
        x->SegmentReg);
    
    print_memtype(&x->Memory);
}


void print_rex(REX_Struct *x)
{
    printf("REX: W_=%d, R=%d, X=%d, B=%d, state=%d\n", x->W_, x->R_, x->X_, x->B_, x->state);
}


void print_prefix(PREFIXINFO *x)
{
    printf("PREFIXINFO:\n Number=%d,\n nbUndefined=%d,\n LockPrefix=%d,\n OperandSize=%d,\n AddressSize=%d,\n "
           "RepnePrefix=%d,\n RepPrefix=%d,\n FSPrefix=%d,\n SSPrefix=%d,\n GSPrefix=%d,\n "
           "ESPrefix=%d,\n CSPrefix=%d,\n DSPrefix=%d,\n BranchTaken=%d,\n BranchNotTaken=%d,\n REX=...\n\n",
           x->Number,
           x->NbUndefined,
           x->LockPrefix,
           x->OperandSize,
           x->AddressSize,
           x->RepnePrefix,
           x->RepPrefix,
           x->FSPrefix,
           x->SSPrefix,
           x->GSPrefix,
           x->ESPrefix,
           x->CSPrefix,
           x->DSPrefix,
           x->BranchTaken,
           x->BranchNotTaken);
    
    print_rex(&x->REX);
}

void
print_disasm(DISASM *d)
{
    printf("DISASM:\n EIP=%d,\n VirtualAddr=%"PRId64",\n SecurityBlock=%d,\n CompleteInstr=%s,\n Archi=%d,\n Options=%"PRId64",\n Instruction,Argument1,Argument2,Argument3,Prefix=...\n\n", 
        d->EIP, 
        d->VirtualAddr, 
        d->SecurityBlock,
        d->CompleteInstr, 
        d->Archi, 
        d->Options);
        
    print_instruction(&d->Instruction);
    print_argument(&d->Argument1);
    print_argument(&d->Argument2);
    print_argument(&d->Argument3);
    print_prefix(&d->Prefix);
}

       
#define T(K,V) if (x->K != V){ printf("failed: %s: %d != %d \n", #K, x->K, V); return -1; }
#define S(K,V) if (strcmp(x->K,V) != 0){ printf("failed: %s: %s != %s \n", #K, x->K, V); return -1; }


int test_efl(EFLStruct *x)
{
    T(OF_, 1);
    T(SF_, 2);
    T(ZF_, 3);
    T(AF_, 4);
    T(PF_, 5);
    T(CF_, 6);
    T(TF_, 7);
    T(IF_, 8);
    T(DF_, 9);
    T(NT_, 10);
    T(RF_, 11);
    T(alignment, 12);
    return 0;
}


int test_instr(INSTRTYPE *x)
{
    T(Category, 0);
    T(Opcode, 1);
    S(Mnemonic, "InstrMnemonic");
    T(BranchType, 2);

    if (test_efl(&x->Flags) != 0)
      return -1;

    T(AddrValue, 3);
    T(Immediat, 4);
    T(ImplicitModifiedRegs, 5);

    return 0; 
}


int test_memory(MEMORYTYPE *x)
{
    T(BaseRegister,0);
    T(IndexRegister,1);
    T(Scale,2);
    T(Displacement,3);
    return 0;
}


int test_argtype(ARGTYPE *x)
{                                         
    S(ArgMnemonic, "ArgMnemonic");
    T(ArgType, 1);
    T(ArgSize, 2);
    T(ArgPosition, 3);
    T(AccessMode, 4);
    
    if (test_memory(&x->Memory) != 0)
        return -1;

    T(SegmentReg, 5);
    return 0;
 }


int
test_rex(REX_Struct *x)
{
  T(W_, 0);
  T(R_, 1);
  T(X_, 2);
  T(B_, 3);
  T(state, 4);
  return 0; 
}


int
test_prefix(PREFIXINFO *x)
{
    T(Number, 0);
    T(NbUndefined, 1);
    T(LockPrefix, 2);
    T(OperandSize, 3);
    T(AddressSize, 4);
    T(RepnePrefix, 5);
    T(RepPrefix, 6);
    T(FSPrefix, 7);
    T(SSPrefix, 8);
    T(GSPrefix, 9);
    T(ESPrefix, 10);
    T(CSPrefix, 11);
    T(DSPrefix, 12);
    T(BranchTaken, 13);
    T(BranchNotTaken, 14);
    S(alignment, "8");

    if (test_rex(&x->REX) != 0)
        return -1;

    return 0;
}


int
test_marshal(DISASM *x)
{
    T(EIP,1);
    T(VirtualAddr,2);
    T(SecurityBlock,3);
    S(CompleteInstr, "inst");
    T(Archi,4);
    T(Options,5);

    if (test_instr(&x->Instruction) != 0)
        return -1;

    if (test_argtype(&x->Argument1) != 0)
        return -1;

    if (test_argtype(&x->Argument2) != 0)
        return -1;

    if (test_argtype(&x->Argument3) != 0)
        return -1;

    if (test_prefix(&x->Prefix) != 0)
        return -1;

    return 0;
}
