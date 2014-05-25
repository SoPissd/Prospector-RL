'uWindows.bas
#include once "uDefines.bi"
DeclareDependencies()
#define test 
#endif'DeclareDependencies()

#ifndef __WINDOWS_BI__
#undef DebugBreak
#print uWindows.bas: late including windows.bi
#include once "windows.bi"
#endif
#ifndef __win_psapi_bi__
#print uWindows.bas: late including win\psapi.bi
#include once "win\psapi.bi"
#endif

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: uWindows -=-=-=-=-=-=-=-

Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (_
	ByVal hwnd As HWND, ByVal lpOperation As String, ByVal lpFile As String, _
	ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

declare function Get_hWnd(pid as integer) as hWnd
declare function MaximizeWindow(hWindow as hWnd) as integer

declare function KillProcess(pid as integer) as integer
declare function FindProcessId (ProcessName as string) as DWORD

declare function HaveConsoleWindow() as integer
declare function ReplaceConsole(bMaximize as short= true) as Integer

declare function KillCMD() as Integer

declare function Popup overload (aTitle as string,aMsg as string) as integer
declare function Popup overload (aMsg as string="") as integer
declare function Popup overload (iMsg as integer) as integer

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: uWindows -=-=-=-=-=-=-=-

namespace nsWindows
	
type tWinEnd extends object
	declare Destructor()
	dim as integer WindowsConsoleAutoClose = true
End Type

Destructor tWinEnd()
	if WindowsConsoleAutoClose then KillCMD()
End Destructor

#if _WindowsConsoleAutoClose =1
	#print Activating Console Auto-close!
	dim WinEnd as tWinEnd
#endif

'

function init(iAction as integer) as integer
	return 0
end function
end namespace'nsWindows

'

function HaveConsoleWindow() as integer
	'figure out if we're compiled as a console or gui application by the presence of a console window
	dim as UInteger mf
	return (GetConsoleDisplayMode(@mf)=1) ' 0= no console window, 1= compiled with consolewindow
end function	

function ReplaceConsole(bMaximize as short= true) as Integer
    dim as integer ac
	if HaveConsoleWindow() then
		FreeConsole
	EndIf	
	KillCMD()
	ac=(AllocConsole=1)
	if ac and bMaximize then MaximizeWindow(Get_hWnd(GetCurrentProcessID))
	return ac
End Function

'
function MaximizeWindow(hWindow as hWnd) as integer
	SendMessage(hWindow, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
	return 0
End Function

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


function KillCMD() as Integer
	'this is to run only in debug builds
	'will kill the first unattended CMd.exe
	return KillProcess(FindProcessId("CMD.EXE"))  
End Function


function Popup overload (aTitle as string,aMsg as string) as integer
	if aTitle="" then aTitle= "Info"
	return MessageBox(HWND_DESKTOP,aMsg,aTitle,MB_OK)	
End Function

function Popup overload (aMsg as string="") as integer
	return Popup("",aMsg)
End Function

function Popup overload (iMsg as integer) as integer
	return Popup("",""& iMsg)
End Function


#endif'main



#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: uWindows -=-=-=-=-=-=-=-
	tModule.register("nsWindows",@nsWindows.init()) ',@uWindows.load(),@uWindows.save())
#endif'main

#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-

	namespace nsWindows

	sub windowstest()
		ReplaceConsole()
		
		'ShellExecute(HWND_DESKTOP,"open","cmd.exe","","",SW_SHOW)
		#if __FB_Debug__
		? "this console will close when you click ok the MessageBox.."
		#endif
		
		MessageBox(HWND_DESKTOP,"Test","Hello",MB_OK)
	End Sub

	end namespace'nsWindows
	
	#ifdef test
		nsWindows.windowstest()
		'? "sleep": sleep
	#else
		tModule.registertest("uWindows",@nsWindows.windowstest())
	#endif'test
#endif'test
