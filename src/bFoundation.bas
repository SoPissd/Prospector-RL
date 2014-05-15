'bFoundation.

'Cls
On Error Goto errormessage
scope
#include "uVersion.bi"
Print __VERSION__
Print "Built on FB."+__FB_VERSION__+", "+__TIME__+" "+__DATE__
end scope

	#undef inc
	#Macro inc(file,comments)
		'#print -=- file  -=- comments
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
	#include once "bFoundation.bi"
