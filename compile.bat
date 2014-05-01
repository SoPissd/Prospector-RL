@echo off
fbc %1 %2 %3 %4 %5 %6 -s console prospector.bas
rem fbc %1 %2 %3 %4 %5 %6 -s gui prospector.bas
if errorlevel==1 goto pause
goto end
:pause
pause
:end
