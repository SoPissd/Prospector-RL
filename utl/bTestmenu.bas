'bTestmenu.bas
'print "bTestmenu.bas"
'
#define makesound					'are we even going to bind in any sound-library code 

'bFoundation.

	#if __FB_OUT_LIB__ 
		#print compiling static library   ... not
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
	
	'build the core pieces
	
	inc("uSound.bi",				"first, include the sound drivers")
	inc("fbGfx.bi",					"")
	inc("file.bi",					"")
	#ifdef makezlib	
		inc("zlib.bi",				"")
	#endif
	'#include once "win\psapi.bi"

 	'build the utilities including all test-code. make a menu.

	#undef both
	#undef test	
	#undef types
	#undef head
	#undef main
	
	#print loading types and head..
	#define types
	#define head
		#include "bFoundation.bi"
	#undef types
	#undef head
	#print loading test and main
	#define main		
	#define registerTests
	#undef test
	#undef intest
		#include "bFoundation.bi"
	#undef main
	#undef registerTests
	
	'sleep
	
	
dim shared Fpsshow as short =1

function Fpsupdate(iAction as Integer) as integer
	'?"updatefps"
	dim atime as string
	'
	if Fpsshow then		
		aTime=LeadingZero(3,uConsole.Fps)
		if tScreen.isGraphic then
		    tScreen.xy(tScreen.gtw-3,tScreen.gth,aTime)
		else
			tScreen.pushpos()
		    tScreen.xy(uconsole.ttw-3,uconsole.tth,aTime)
			tScreen.poppos()
		endif
		endif
	return iAction
end function

'

function testmenu(iAction as Integer) as Integer	
	dim t as tModule._Test
	dim aMenu as tMainmenu

	tScreen.mode

	with aMenu
		.Clearchoices()
		.title="Choose test"
		for i as Integer= 0 to tModule.lasttest-1
			t=tModule.Tests(i)
			.Addchoice(t.aName+" - "+t.aComment,t.aComment)
		Next
		.Addchoice("Exit","Exit the menu")

		.bIdx=true
	    .index= 0
		.bScrollbar=false
		.bDrawborder=false

		.x= (uconsole.ttw - .lTe -2) \3
		.y= 5
		.Height= 16
		.mhy= .Height
	End With

	while not uConsole.Closing
		'prepare next graphic mode
		tScreen.x=800
		tScreen.y=600
		'switch (back?) to text console
		tScreen.mode
		'clear the menu and get a new choice
		cls
		tScreen.res

		with aMenu
? .x,.y,.lTe,.lTh,.Height,.mhy
			dim aKey as string= .menu()
			dim m as Integer= .index
			if uConsole.Closing orelse (m<1) orelse (m=.nLines-1) then exit while
		End With

		'get the test and run it
		dim pSub as tSub= tModule.Tests(m-1).fTest
		cls
? m, aMenu.lines(m)
uConsole.Pressanykey()
		pSub()						'run the test
		uConsole.Closing=false		'stay even if we pressed Alt-F4
		tScreen.xy(60,24)
		uConsole.Pressanykey(0)

	Wend
	return 0
end function



uConsole.IdleMethod= @Fpsupdate	'just because
tModule.TestMethod= @testmenu	'testmethod supercedes run-method ;) 	
tModule.run(0)					'here is where the magic happens as main runs module runs game.run(0)