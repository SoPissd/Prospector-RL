'tCommandString

Type _commandstring
    t As String
    comdead As Byte
    comalive As Byte
    comportal As Byte
    comitem As Byte
    page As Byte
    lastpage As Byte
    Declare function Reset() As Short
    Declare function display(wl As Short) As Short
    Declare function nextpage() As Short
End Type


Dim Shared comstr As _commandstring



function _commandstring.nextpage() As Short
    page+=1
    If page>lastpage Then page=0
    Return 0
End function

function _commandstring.Reset() As Short
    t=""
    comdead=0
    comalive=0
    comportal=0
    comitem=0
    page=0
    Return 0
End function

function _commandstring.display(wl As Short) As Short
    Dim As String ws(40)
    Dim As Short last,b,start,room,needed
    If comstr.t="" Then Return 0
    last=string_towords(ws(),comstr.t,";")
    room=_lines-wl
    needed=last
    lastpage=needed/room
    If lastpage>1 Then
        start=(last/lastpage)*page
        last=(last/lastpage)*(page+1)
    EndIf
    If last>40 Then last=40
    If start>last Then start=last-room
    If start<0 Then start=0
    For b=start To last
        set__color(15,0)
        Draw String(sidebar,(b+wl-start)*_fh2),ws(b),,Font2,custom,@_col
    Next
    Return 0
End function

