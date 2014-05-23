'libFoundation.bi

'copy the next line into a new file to get started using the utilities
'#include "utl/libFoundation.bi"	'use core utilities from utl/libFoundation.a
'#include "utl/libFoundation.bi"	'use core utilities from utl/libFoundation.a
'#include "utl/libFoundation.bi"	'use core utilities from utl/libFoundation.a

#print using libFoundation
#define types						'include consts, types, enums and dims
#define head						'include public method declarations
#include once "utl/bFoundation.bas"	'headers of the core utilities  
#libpath "utl"						'utility path
#inclib "bFoundation"				'library with the core utilities
#undef types						'release the symbols
#undef head							'that's all there is to using utl/libFoundation.a 