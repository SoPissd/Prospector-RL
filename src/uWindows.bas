'uWindows.bas

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: uWindows -=-=-=-=-=-=-=-
#undef intest
#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"

#define test
#endif'test
#ifndef HWND
#print uWindows.bas: late including windows.bi
#include "windows.bi"
#endif
#ifndef EnumProcesses
#print uWindows.bas: late including win\psapi.bi
#include "win\psapi.bi"
#endif

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uWindows -=-=-=-=-=-=-=-

Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (_
	ByVal hwnd As HWND, ByVal lpOperation As String, ByVal lpFile As String, _
	ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

declare function Get_hWnd(pid as integer) as hWnd
declare function KillProcess(pid as integer) as integer
declare function FindProcessId (ProcessName as string) as DWORD

#if __FB_Debug__
#print Activating Console Auto-close!
declare function KillCMD() as Integer
#endif

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uWindows -=-=-=-=-=-=-=-

namespace uWindows
function init(iAction as integer) as integer
	return 0
end function
end namespace'uWindows

function Get_hWnd(pid as integer) as hWnd
    dim as integer ProcID
    dim as HWND hWnd=0
    '    
    hWnd=FindWindow(NULL,NULL)
    do while hWnd>0
        if GetParent(hwnd)=0 then
            GetWindowThreadProcessId(hWnd,@ProcID)
            if ProcID=pid then
                return hWnd
            end if
        end if
        hWnd=GetWindow(hWnd,GW_HWNDNEXT)
    loop  
    return 0
end function

function KillProcess(pid as integer) as integer
'This brutally kills the instance
	dim as HWND kproc
	dim as integer res
	kproc=OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE,FALSE,pid)
	if kproc>0 then
	    res=TerminateProcess(kproc,0)        'fail if res=FALSE
	    CloseHandle(kproc)
	endif
	return res
End Function

function FindProcessId (ProcessName as STRING) as DWORD
       DIM ProcessIds (0 to 256) as DWORD
       DIM BytesReturned as DWORD
       DIM ProcessNumber as DWORD
       DIM TotalProcesses as DWORD
       DIM FileName as STRING * 128
       DIM ExecutableName as STRING
       DIM hProcess as HANDLE
       EnumProcesses(@ProcessIds(0), 1024, @BytesReturned)
       TotalProcesses = BytesReturned \ 4
       FOR ProcessNumber = 1 to TotalProcesses
          hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, ProcessIds(ProcessNumber))
          GetModuleFileNameEx(hProcess, NULL, cast(LPTSTR, @FileName), 128)
          ExecutableName = FileName
		  'if ExecutableName<>"" then ?ProcessNumber,ExecutableName          
          IF UCASE(RIGHT(ExecutableName,LEN(ProcessName))) = UCASE(ProcessName) THEN
             CloseHandle(hProcess)
             RETURN ProcessIds(ProcessNumber)
          ELSE
             CloseHandle(hProcess)
          END IF
       NEXT
       RETURN 0
END FUNCTION

#if __FB_Debug__
function KillCMD() as Integer
	'well, not really.
	'this is to run only in debug builds
	'will kill the first unattended CMd.exe
	return KillProcess(FindProcessId("CMD.EXE"))  
End Function
#endif

#endif'main

#if __FB_Debug__

type tTheEnd extends object
	declare Destructor()
End Type

Destructor tTheEnd()
	KillCMD()
End Destructor

dim TheEnd as tTheEnd
#endif


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: uWindows -=-=-=-=-=-=-=-
	tModule.register("uWindows",@uWindows.init()) ',@uWindows.load(),@uWindows.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: uWindows -=-=-=-=-=-=-=-
#undef test

'ShellExecute(HWND_DESKTOP,"open","cmd.exe","","",SW_SHOW)
#if __FB_Debug__
? "this cmd.exe console will close when you click ok.."
#endif

MessageBox(HWND_DESKTOP,"Test","Hello",MB_OK)

#endif'test
