'tDefines
'#undef namespace

'
''
'''
#if defined(head) 

'Define True/False values.
#Ifndef FALSE
	#Define FALSE 0
	#Define TRUE (Not FALSE)
#EndIf

'Create a NULL value.
#Ifndef NULL
    #Define NULL 0
#EndIf

#endIf
'''
''
'