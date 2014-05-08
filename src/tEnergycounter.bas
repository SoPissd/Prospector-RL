'tEnergycounter

Type _energycounter
    e As Integer
    Declare Function add_action(v As Integer) As Integer
    Declare Function tick() As Integer
End Type

Function _energycounter.add_action(v As Integer) As Integer
    e+=v
    Return 0
End Function

Function _energycounter.tick() As Integer
    If e>0 Then
        e-=1
        Return 0
    Else
        e=0
        Return -1
    End If
End Function


