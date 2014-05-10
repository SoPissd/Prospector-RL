'tTime

function display_time(t As UInteger,form As Byte=0) As String
    Dim As UInteger d,h,m
    Dim As String ms,hs
    h=Fix(t/60)
    d=Fix(h/24)
    h=h-d*24
    m=t-h*60-d*24*60
    If h<10 Then
        hs="0"& h
    Else
        hs=""& h
    EndIf
    If m<10 Then
        ms="0"&m
    Else
        ms=""&m
    EndIf
    Select Case form
    Case 0
        If d>0 Then
            Return "Day "&d &", "& hs &":"&ms 
        Else
            Return  hs &":"&ms
        EndIf
    Case 1
        Return d &" days, "& h &" hours and "& m &" minutes"
    Case 2
        If d>0 Then
            Return d &" days"
        Else
            Return  hs &":"&ms
        EndIf
    End Select
End function


function date_string() as string
    dim as string t,w(3)
    dim as short i,j
    t=date
    for i=1 to len(t)
        if mid(t,i,1)="-" then
            j+=1
        else
            w(j)=w(j)&mid(t,i,1)
        endif
    next
    if val(w(0))=1 then w(0)="JAN"
    if val(w(0))=2 then w(0)="FEB"
    if val(w(0))=3 then w(0)="MAR"
    if val(w(0))=4 then w(0)="APR"
    if val(w(0))=5 then w(0)="MAY"
    if val(w(0))=6 then w(0)="JUN"
    if val(w(0))=7 then w(0)="JUL"
    if val(w(0))=8 then w(0)="AUG"
    if val(w(0))=9 then w(0)="SEP"
    if val(w(0))=10 then w(0)="OKT"
    if val(w(0))=11 then w(0)="NOV"
    if val(w(0))=12 then w(0)="DEZ"
    return w(1)&"-"&w(0)&"-"&w(2)
end function
