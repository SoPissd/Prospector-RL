'tModule.
'
'namespace: tModule
'
'
'defines:
'Init=6, Register=0
'

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
'     -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-
#undef intest
#include "uDefines.bas"
#define test
#endif'test

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModule -=-=-=-=-=-=-=-
declare function LogOut(aText as string,fileno as integer=0) as integer
declare function ErrOut(aText as String) as Integer
#endif'head

namespace tModule

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-
type _Module											'the module now registering
	aName as string
	fInit as tActionmethod	
	fLoad as tActionmethod	
	fSave as tActionmethod	
End Type

const _maxModules = 128+32

dim shared modules(_maxModules) as _Module
dim shared lastmodule as integer = 0

Dim as tActionmethod	 	RunMethod					'this runs as 'the main program' 
Dim as tErrormethod 		ErrorMethod					'error handler (passed in)

Dim as tTextIntegermethod 	LogoutMethod				'logfilewriter methods
Dim as tTextmethod 			ErrLogMethod

#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModule -=-=-=-=-=-=-=-

declare function LogWrite(aText as string,fileno as integer=0) as integer
declare function ErrorLog(aText as string) as integer

declare function Status() as string
declare function Run(iAction as integer) as Integer		'used as 'the run method'

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tModule -=-=-=-=-=-=-=-
dim shared as integer fLogOut							'file-handles to system consoles
dim shared as integer fErrOut


public function Init(iAction as integer) as integer
	fErrOut=freefile
	open err for output as fErrOut
	fLogOut= fErrOut
	return 0 'ErrorNr
End Function


public function Register(aName as string,_
	fInit as tActionmethod =null,_	
	fLoad as tActionmethod =null,_	
	fSave as tActionmethod =null) as integer
	'
	Dim amodule As _Module
	amodule.aName	=aName
	amodule.fInit	=fInit	
	amodule.fLoad	=fLoad	
	amodule.fSave	=fSave
	'
	lastmodule+=1
	modules(lastmodule)=amodule
	'
	'? amodule.aName +".Init()"
	'? amodule.aName +" ";
	'tError.ErrorNr= 	
	return amodule.fInit(0)
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
	return "" &lastmodule &" modules initialized."
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


#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tModule -=-=-=-=-=-=-=-
	tModule.register("tModule",@tModule.init()) ',@tModule.load(),@tModule.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-
	#undef test
	#include "uDefines.bas"
	'
	? tModule.Status: ?
	'
	print #tModule.fLogOut,"#fLogOut: log console open as #" &tModule.fLogOut &"!"
	print #tModule.fErrOut,"#fErrOut: error console open as #" &tModule.fErrOut &"!"
	'
	LogOut("using log console")
	ErrOut("using error console")
	
#endif'test
