'tInit.bas

Randomize Timer,5

Cls
Print
Print "Prospector "&__VERSION__
Print "Built "+__DATE__+" "+__TIME__
Print "FB."+__FB_VERSION__
Print
DbgScreeninfo

' start

chdir exepath
