'#define _debug 0

' validate target OS
#ifdef __FB_WIN32__						'windows ok
#elseif __FB_LINUX__					'linux ok
#else
	#error Unsupported compilation target
#endif


#if __FB_DEBUG__

	#ifdef __FB_WIN32__					'only under windows
		#print Windows Debug mode
		#define _DbgLoadMLD 0			'load the Memory Leak Detector
		#define _DbgLoadWin 0			'load the Windows headers
	#else
	#ifdef __FB_LINUX__					'only under linux
		#print Linux Debug mode
	#endif
	#endif

	#define _DbgPrintCSVs 0				'print csv's?
	#define _DbgLogExplorePlanet 1
	'
	#define _DbgPrintMode 0
	'				
	#if _DbgPrintMode =0				'=0: ignore
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
		open command(0)+".debug.txt" for output as #_DbgLog
		'
		#Macro DbgPrint(text)
			print #_DbgLog, __FUNCTION__ & "  " & text
			#if (_DbgPrintMode=3)
				rlprint(__FUNCTION__ & "  " & text)
			#endif
		#EndMacro
		'
		#define DbgEnd close #_DbgLog
		
	#elseif _DbgPrintMode =4			'=4: use console (experiment/sucks)	
		#print DbgPrints to console.
		'
		dim shared as Short _DbgLog
		_DbgLog= freefile
		open cons for output as #_DbgLog
		'
		#Macro DbgPrint(text)
			print #_DbgLog, __FUNCTION__ & "  " & text
		#EndMacro
		'
		#define DbgEnd close #_DbgLog
		
	#endif
	'
	sub DbgScreeninfo
	dim as Integer w,h,depth,bpp,pitch,rate
	dim as String driver 
	Screeninfo w,h,depth,bpp,pitch,rate,driver
	print "Screeninfo:"
	write w,h,depth,bpp,pitch,rate,driver
	End Sub	
	
#else
	#ifdef __FB_WIN32__					'windows
		#print Windows Release mode
	#else
	#ifdef __FB_LINUX__					'linux
		#print Linux Release mode
	#endif
	#endif
	#define _DbgLoadWin 0				'never in release			
	#define _DbgPrintCSVs 0
	'									'NOTICE!! these must be on their own line.  no IF x THEN DbgPrint()! 
	#define DbgPrint(text)
	#define DbgScreeninfo
	#define DbgEnd
#endif


#if _DbgLoadWin	<>1						'provide a substitute for debugbreak
	#define DebugBreak					'see.. nothing at all.  
#endif


' cut 'n paste

#if __FB_DEBUG__
#endif

#if __FB_DEBUG__
#else
#endif

#if __FB_DEBUG__
    dim as short debug=0
#else
    dim as short debug=0
#endif

>>>>>>> DEBUG now provides control over includes and debug-logging
