'bFoundation.

'Cls
On Error Goto errormessage
scope
	Dim as Integer size
	Dim as string asize
	Dim as Integer f
	f=freefile
	if Open(Command(0), for input, as #f)>0 then
		size= LOF(f) \ 1024
        Close #f
	EndIf
	asize &= size
	size = len(asize)-(3-1)
	asize=mid(asize,1,size)+"."+mid(asize,size)
	if (size<1) and len(asize)=4 then asize="0"+asize

	#include "uVersion.bi"
	Print __VERSION__ +" "+ asize, size
	Print "Built on FB."+__FB_VERSION__+", "+__TIME__+" "+__DATE__
end scope

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
	#include once "bFoundation.bi"
