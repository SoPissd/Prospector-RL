'bFoundation.

	#if __FB_OUT_LIB__ 
		#print compiling static library
	#else	
		scope 
		#include "uVersion.bi"
		Print __VERSION__
		Print "Built on FB."+__FB_VERSION__+", "+__TIME__+" "+__DATE__
		end scope	
	#endif

	#undef inc
	#Macro inc(file,comments)
'		#print -=- file  -=- comments
		#include file
	#EndMacro
	
	#Macro make(file)
		#print loading types
		#define types
		#undef head
		#undef main
		#include file
		#undef types
	
		#print loading declarations
		#define head
		#undef main
		#include file
		
		#print loading implementations
		#undef head
		#define main
		#include file
	#EndMacro

	'build the core pieces
	
	inc("uSound.bi",				"first, include the sound drivers")
	inc("fbGfx.bi",					"")
	inc("file.bi",					"")
	#ifdef makezlib	
		inc("zlib.bi",				"")
	#endif
	'#include once "win\psapi.bi"
'
	#undef both
	#undef test	
	#undef types
	#undef head
	#undef main
	
	#if false
		#define types
		#define head
		#define main		
			#include once "bFoundation.bi"
		#undef types
		#undef head
		#undef main
	#else
		#print loading types and head..
		#define types
		#define head
			#include "bFoundation.bi"
		#undef types
		#undef head
		#print loading test and main
		#define main		
		#define testload
		#undef test
			#include "bFoundation.bi"
		#undef main
		#undef testload
		? tModule.Status
		sleep
	#endif