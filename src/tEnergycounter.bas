'tEnergycounter

Type _energycounter
    e As Integer
    Declare function add_action(v As Integer) As Integer
    Declare function tick() As Integer
End Type

function _energycounter.add_action(v As Integer) As Integer
    e+=v
    Return 0
End function

function _energycounter.tick() As Integer
    If e>0 Then
        e-=1
        Return 0
    Else
        e=0
        Return -1
    End If
End function


