'tModule

'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
	#Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf

namespace tModule

type tInitFunction As Function() As Integer
type tSaveFunction As Function(fileno as Integer) As Integer

type _Module
	aName as string
	fInit as tInitFunction	
	fLoad as tSaveFunction	
	fSave as tSaveFunction	
End Type

const _maxModules = 128

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
	amodule.fInit()
	return 0
End Function

'
end namespace

tModule.Register("tModule",@tModule.Init())
