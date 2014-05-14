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
#if not (defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-

#undef intest
#define test
#endif'test

namespace tModule

#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tModule -=-=-=-=-=-=-=-


'private function tModule
'private function tModule

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tModule -=-=-=-=-=-=-=-


type tInitFunction As Function() As Integer
type tSaveFunction As Function(fileno as Integer) As Integer

type _Module
	aName as string
	fInit as tInitFunction	
	fLoad as tSaveFunction	
	fSave as tSaveFunction	
End Type

const _maxModules = 128'+32

dim shared modules(_maxModules) as _Module
dim shared lastmodule as integer = 0

'


public function Init() as integer
	return 0
End Function


public function Register(aName as string,_
	fInit as tInitFunction =null,_	
	fLoad as tSaveFunction =null,_	
	fSave as tSaveFunction =null) as integer
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
	amodule.fInit()
	return 0
End Function

public function status() as string
	return "" &lastmodule &" modules initialized."
End Function


'
#endif'main
end namespace

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tModule -=-=-=-=-=-=-=-
	tModule.register("tModule",@tModule.init()) ',@tModule.load(),@tModule.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tModule -=-=-=-=-=-=-=-
#endif'test
