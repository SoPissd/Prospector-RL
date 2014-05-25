'tModule.
'#print "umodule.bas"
#include once "uDefines.bi"
DeclareDependenciesBasic()
#include "uDefines.bas"
#define test 
#endif'DeclareDependencies()
#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
#endif'types

'#ifndef tActionmethod
'#print uModule.bas: late including uDefines.bas
'#include "uDefines.bas"

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModule -=-=-=-=-=-=-=-
declare function LogOut(aText as string,fileno as integer=0) as integer
declare function ErrOut(aText as String) as Integer
#endif'head

namespace tModule

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-

Dim shared as tActionmethod	 		RunMethod		'this runs as 'the main program' 
Dim shared as tErrormethod 			ErrorMethod		'error handler (passed in)

Dim shared as tTextIntegermethod 	LogoutMethod	'logfilewriter methods
Dim shared as tTextmethod 			ErrLogMethod

#endif'types

	
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModule -=-=-=-=-=-=-=-


declare function Register(aName as string,_
	fInit as tActionmethod =null,_	
	fLoad as tActionmethod =null,_	
	fSave as tActionmethod =null) as integer
	
declare function Registertest(aName as string,fTest as tSub =null,aComment as string="") as integer


declare function LogWrite(aText as string,fileno as integer=0) as integer
declare function ErrorLog(aText as string) as integer

declare function Status() as string
declare function Run(iAction as integer) as Integer		'used as 'the run method'

#endif'head

#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tModule -=-=-=-=-=-=-=-

dim shared as integer fLogOut							'file-handles to system consoles
dim shared as integer fErrOut

const _maxModules = 128+32

'
type _Module											'the module now registering
	aName as string
	fInit as tActionmethod	
	fLoad as tActionmethod	
	fSave as tActionmethod	
End Type

dim shared modules(_maxModules) as _Module
dim shared lastmodule as integer = 0

'
type _Test											'the test now registering
	aName as string
	fTest as tSub	
	aComment as string
End Type

dim shared Tests(_maxModules) as _Test
dim shared lasttest as integer = 0


function Init(iAction as integer) as integer
	fErrOut=freefile
	open err for output as fErrOut
	fLogOut= fErrOut
	return true 'ErrorNr
End Function


function Register(aName as string,_
	fInit as tActionmethod =null,_	
	fLoad as tActionmethod =null,_	
	fSave as tActionmethod =null) as integer
	'
	Dim amodule As tModule._Module
	amodule.aName	=aName
	amodule.fInit	=fInit	
	amodule.fLoad	=fLoad	
	amodule.fSave	=fSave
	'
	modules(lastmodule)=amodule
	lastmodule+=1
	'
	'? amodule.aName +".Init()"
	'? amodule.aName +" ";
	'tError.ErrorNr= 	
	return amodule.fInit(0)
End Function

function Registertest(aName as string,fTest as tSub =null,aComment as string="") as integer
	Dim atest As _Test
	atest.aName	=aName
	atest.fTest =fTest	
	atest.aComment =aComment	
	tests(lasttest)=atest
	lasttest+=1
	return true
End Function


function LogWrite(aText as string,fileno as integer=0) as integer
	if fileno<=0 then fileno=fLogOut
	if fileno>0 then 
		print #fileno, aText
		return len(aText)
	else
		return 0
	EndIf
End Function

function ErrorLog(aText as string) as integer
	return LogWrite(aText,fErrOut)	
End Function

'
public function Status() as string
	return "" &lastmodule &" modules initialized." &iif(lasttest>0,"  "& lasttest &" tests loaded.", "")
End Function

function Run(iAction as integer) as Integer
	if RunMethod<>null then
		return RunMethod(iAction)
	elseif ErrorMethod<>null then
		return ErrorMethod()
	else 
		return 0
	EndIf
End Function

'
#endif'main

end namespace'tModule



#ifdef main

function LogOut(aText as string,fileno as integer=0) as integer
	return tModule.LogWrite(aText,fileno)
End Function

function ErrOut(aText as String) as Integer
	return tModule.ErrorLog(aText)
End Function

#endif'main
'#endif'actionmethod


#if defined(main) or defined(test)
'      -=-=-=-=-=-=-=- INIT: tModule -=-=-=-=-=-=-=-
	tModule.register("uDefines",@tDefines.init()) ',@tDefines.load(),@tDefines.save())
	tModule.register("uModule",@tModule.init()) ',@tModule.load(),@tModule.save())
#endif'main
#ifdef test
#print -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-
'	#undef test
'	#include "uDefines.bas"
'	#define test
#endif'test
#if (defined(test) or defined(registerTests))
#print -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-

	namespace tModule

	sub moduletest()
		? Status: ?
		'
		print #tModule.fLogOut,"#fLogOut: log console open as #" &tModule.fLogOut &"!"
		LogOut(chr(9)+"using log console.. ok!")
		print #tModule.fErrOut,"#fErrOut: error console open as #" &tModule.fErrOut &"!"
		ErrOut(chr(9)+"using error console.. ok!")
		'
		dim i as Integer
		?
		? "Modules:"
		for i= 0 to lastmodule-1
			? chr(9)+modules(i).aName
		Next
		?
		? "Tests:"
		for i= 0 to lasttest-1
			? chr(9)+tests(i).aName, tests(i).aComment
		Next
	End Sub

	end namespace'tModule
	
	#ifdef test
		tModule.registertest("uModule",@tModule.moduletest())
		tModule.moduletest()
		sleep
	#else
		tModule.registertest("uModule",@tModule.moduletest())
	#endif'test
#endif'test
