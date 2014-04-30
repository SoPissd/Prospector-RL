..\..\fb\FreeBASIC-0.90.1-win32\fbc %1 %2 %3 %4 %5 %6 %7 %8 %9 -s console prospector.bas
if errorlevel==1 goto pause
goto end
:pause
pause
:end
