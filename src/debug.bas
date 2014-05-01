const _debug=0

Dim Shared _debugBuild As Integer
#if __FB_DEBUG__ <> 0
	#print Debug mode
	_debugBuild = 1
#else
	#print Release mode
	_debugBuild = 0
#endif