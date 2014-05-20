'tDebug.

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
'     -=-=-=-=-=-=-=- TEST: tDebug -=-=-=-=-=-=-=-
#undef intest
#include "uDefines.bas"
#include "uModule.bas"
#include "uDefines.bas"
#define test
#endif'test


#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tDebug -=-=-=-=-=-=-=-


' validate target OS
#ifdef __FB_WIN32__						'windows ok
#elseif __FB_LINUX__					'linux ok
#else
	#error Unsupported compilation target
#endif


#if __FB_Debug__

	#ifdef __FB_WIN32__					'only under windows
		#print Windows Debug mode
		#define _DbgOptLoadMLD 0		'load the Memory Leak Detector
		#define _DbgOptLoadWin 1		'load the Windows headers
	#else
	#ifdef __FB_LINUX__					'only under linux
		#print Linux Debug mode
	#endif
	#endif

	#define _DbgPrintCSVs 0				'print csv's?
	#define _DbgLogExplorePlanet 0
	'
	#define _DbgPrintMode 4
	'				
	#if _DbgPrintMode =-1				'=-1: do nothing
		#print DbgPrint is up to you. (do nothing)  
		
	#elseif _DbgPrintMode =0				'=0: ignore
		#print DbgPrint ignored.  
		#define DbgPrint(text)
		#define DbgEnd
		
	#elseif _DbgPrintMode =1			'=1: use rlprint	
		#print DbgPrints to game-window.
		#define DbgPrint(text) rlprint(__FUNCTION__ & "  " & text)
		#define DbgEnd
		
	#elseif (_DbgPrintMode=2) _			'=2: log to file
		 or (_DbgPrintMode=3) 			'=3: log to file and through rlprint
		'
		#if (_DbgPrintMode=3)
			#print DbgPrints to file and game-window.
		#else
			#print DbgPrint to file.
		#endif
		'
		dim shared as Short _DbgLog
		_DbgLog= freefile
		open command(0)+".Debug.txt" for output as #_DbgLog
		'
		#Macro DbgPrint(text)
			print #_DbgLog, __FUNCTION__ & "  " & text
			#if (_DbgPrintMode=3)
				rlprint(__FUNCTION__ & "  " & text)
			#endif
		#EndMacro
		'
		#define DbgEnd close #_DbgLog
		
	#elseif _DbgPrintMode =4			'=4: use console requires windows!	
		#ifdef __FB_WIN32__					'only under windows
			#define _DbgOptLoadWin 1		'load the Windows headers
			#print loading windows headers			
			#include once "windows.bi" 
			#include "uConprint.bas"
			#print DbgPrints to console.
			'
			dim shared conprint as tagConPrintObject ptr 
			conprint= new tagConPrintObject
			'
			#define DbgPrint(text) conprint->ConsolePrint(text)
			#define DbgEnd delete conprint
		#else
			#print Can not use _DbgPrintMode=4 on Linux
			#define DbgEnd
		#endif
		
	#elseif _DbgPrintMode =5			'=5: just print	
		#print DbgPrints just prints.
		#Define DbgPrint(Text) ? ucase(Namebase(__FILE__))+":"+__FUNCTION__+"." &__LINE__ &"> ";Text
	#else
		#define DbgEnd
	#endif
	'	
#else
	#ifdef __FB_WIN32__					'windows
		#print Windows Release mode
	#else
	#ifdef __FB_LINUX__					'linux
		#print Linux Release mode
	#endif
	#endif
	#define _DbgOptLoadWin 0			'never in release			
	#define _DbgOptLoadMLD 0		
	#define _DbgPrintCSVs 0
	'									'NOTICE!! these must be on their own line.  no IF x THEN DbgPrint()! 
	#define DbgPrint(text)
	#define DbgEnd
#endif

' always

#if _DbgOptLoadWin	<>1					'provide a substitute for DebugBreak
	'#print DebugBreak inactive
	#define DebugBreak					'see.. nothing at all.  
#else
	#print DebugBreak enabled.
#endif

#Macro DimDebug(Value)					'use DimDebug to setup the var for Debug mode only
	#if __FB_Debug__
	    dim as short Debug=Value
	#endif
#EndMacro

#Macro DimDebugL(Value)					'use DimDebugL to setup the var for either mode 
	#if __FB_Debug__
	    dim as short Debug=Value
	#else								' use dimDebugL for stuff like:  If <this> or Debug then <dothat>
	    dim as short Debug=0
	#endif
#EndMacro


#if _DbgOptLoadWin = 1			
	#print loading windows headers			
	#include once "windows.bi" ',		windows header mandatory for DebugBreak & console)
#else
#if _DbgOptLoadWin = 2			
	#print loading winbase headers			
	#include once "winbase.bi" ',		windows header mandatory for DebugBreak & console)
#endif							
#endif			
#if _DbgPrintMode =4					'use console requires windows.. and a console	
	AllocConsole
#endif			
				
'
#if _DbgOptLoadMLD = 1
	#print loading memory leak detector			
	'#include once "crt.bi"
	'#ifdef __FB_WIN32__
	''# inclib "msvcrt"
	'#endif
	''#include once "crt/string.bi"
	''#include once "crt/math.bi"
	''#include once "crt/time.bi"
	''#include once "crt/wchar.bi"
	''#include once "crt/ctype.bi"
	''#include once "crt/stdlib.bi"
	''#include once "crt/stdio.bi"
	''#include once "crt/fcntl.bi"
	''#include once "crt/errno.bi"
	'#if defined(__FB_WIN32__) or defined(__FB_DOS__)
	''# include once "crt/dir.bi"
	'#endif
	inc("fbmld.bi",				memory-leak-detector)
#endif							

'DbgPrint("testing DbgPrint output")


#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tDebug -=-=-=-=-=-=-=-
namespace tDebug
function init(iAction as integer) as integer
	return 0
end function
end namespace'tDebug
#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tDebug -=-=-=-=-=-=-=-
	tModule.register("tDebug",@tDebug.init()) ',@tDebug.load(),@tDebug.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDebug -=-=-=-=-=-=-=-
#undef test


AllocConsole
DbgPrint("uDebug loaded")		

sub s 
	DbgPrint("uDebug loaded")				
End Sub

s
		
#endif'test


' cut 'n paste

#if __FB_Debug__
#endif

#if __FB_Debug__
#else
#endif