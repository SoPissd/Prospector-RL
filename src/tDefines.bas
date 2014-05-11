'tDefines
'#undef namespace

'
''
'''
#if defined(namespace)
	namespace tDefines
#endIf
#if defined(all) or defined(head) 
#if defined(namespace)'declare init load save
#endIf
'<your headers here>

#endIf
#if defined(all) or defined(body)
#if not defined(namespace)'do not define init load save
#endIf
'<your implementation here>

#endIf
#if not ( defined(all) or defined(body) or defined(head) )
#define ok2zap_codeabove
'''
''
'
'<your original code>

'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
	#Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf


'
''
'''
#define ok2zap_codebelow
#endIf
#if defined(namespace)
	end namespace
#endIf
#if defined(all) or defined(body)
	'<your initialization code>
	tModules.Register("tDefines")
#endIf
#if not (defined(head) or defined(body))'test
	'<your test code>
#endif

'''
'' :)
'