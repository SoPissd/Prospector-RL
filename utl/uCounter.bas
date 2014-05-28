''=============================================================================
#Include "windows.bi"
''=============================================================================

Dim Shared As LongInt counter_cycles
Dim Shared As Integer _counter_loopcount_, _counter_loopcounter_
Dim Shared As Integer _process_priority_class_, _thread_priority_

#Macro COUNTER_BEGIN( loop_count, process_priority, thread_priority )
    _counter_loopcount_ = loop_count
    _process_priority_class_ = GetPriorityClass(GetCurrentProcess())
    _thread_priority_ = GetThreadPriority(GetCurrentProcess())
    SetPriorityClass(GetCurrentProcess(), process_priority)
    SetThreadPriority(GetCurrentProcess(), thread_priority)
    _counter_loopcounter_ = _counter_loopcount_
    Asm
        Xor eax, eax
        cpuid               '' serialize
        rdtsc               '' get reference loop start count
        push edx            '' preserve msd (most significant dword)
        push eax            '' preserve lsd
        Xor eax, eax
        cpuid               '' serialize
        .balign 16
      0:                    '' start of reference loop
        Sub DWORD Ptr _counter_loopcounter_, 1
        jnz 0b              '' end of reference loop
        Xor eax, eax
        cpuid               '' serialize
        rdtsc               '' get reference loop end count
        pop ecx             '' recover lsd of start count
        Sub eax, ecx        '' calc lsd of reference loop count
        pop ecx             '' recover msd of start count
        sbb edx, ecx        '' calc msd of reference loop count
        push edx            '' preserve msd of reference loop count
        push eax            '' preserve lsd of reference loop count
        Xor eax, eax
        cpuid               '' serialize
        rdtsc               '' get test loop start count
        push edx            '' preserve msd
        push eax            '' preserve lsd
    End Asm
    _counter_loopcounter_ = _counter_loopcount_
    Asm
        Xor eax, eax
        cpuid               '' serialize
        .balign 16
      1:                    '' start of test loop
    End Asm
#EndMacro

''=============================================================================

#Macro COUNTER_END()
    Asm
        Sub DWORD Ptr _counter_loopcounter_, 1
        jnz 1b              '' end of test loop
        Xor eax, eax
        cpuid               '' serialize
        rdtsc
        pop ecx             '' recover lsd of start count
        Sub eax, ecx        '' calc lsd of test loop count
        pop ecx             '' recover msd of start count
        sbb edx, ecx        '' calc msd of test loop count
        pop ecx             '' recover lsd of reference loop count
        Sub eax, ecx        '' calc lsd of corrected loop count
        pop ecx             '' recover msd of reference loop count
        sbb edx, ecx        '' calc msd of corrected loop count
        mov DWORD Ptr [counter_cycles], eax
        mov DWORD Ptr [counter_cycles+4], edx
    End Asm
    SetPriorityClass(GetCurrentProcess(),_process_priority_class_)
    SetThreadPriority(GetCurrentProcess(),_thread_priority_)
    counter_cycles /= _counter_loopcount_
#EndMacro

''=============================================================================

'COUNTER_BEGIN()
'COUNTER_END()