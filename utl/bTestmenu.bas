'bTestmenu.bas
'print "bTestmenu.bas"
'
dim shared Fpsshow as short =1

function Fpsupdate(iAction as Integer) as integer
	'?"updatefps"
	dim atime as string
	'
	if Fpsshow then		
		aTime=LeadingZero(3,uConsole.Fps)
		if tScreen.isGraphic then
		    tScreen.xy(tScreen.gtw-3,1,aTime)
		else
			tScreen.pushpos()
		    tScreen.xy(uconsole.ttw-3,1,aTime)
			tScreen.poppos()
		endif
		endif
	return iAction
end function

'

function testmenu(iAction as Integer) as Integer
	dim s as tSub
	dim m as Integer

		dim aMenu as tMainmenu
		aMenu.Addchoice("Choose test")
		dim i as Integer
		dim t as tModule._Test
		for i=0 to tModule.lasttest-1
			t=tModule.Tests(i)
			aMenu.Addchoice(t.aName,t.aComment)
		Next
		if tScreen.isGraphic then
  			amenu.x= (tscreen.gtw - amenu.lTe -2) \2
			amenu.y= (tscreen.gth - tModule.lasttest - 10)
		else
  			amenu.x= (uconsole.ttw - amenu.lTe -2) \2
			amenu.y= (uconsole.tth - tModule.lasttest -2) \2
		endif

	while not uConsole.Closing
	'tScreen.res
		tScreen.mode
		aMenu.e=0		
		m=aMenu.menu()
		if m<1 then exit while
		aMenu.loca=m
		s= tModule.Tests(m-1).fTest
		cls
		s()
		tScreen.xy(60,24)
		uConsole.Pressanykey(0)		
	Wend
	return 0
end function



uConsole.IdleMethod= @Fpsupdate	'just because
tModule.RunMethod= @testmenu 	'here is where the magic happens as main runs module runs game.run(0)
tModule.run(0)