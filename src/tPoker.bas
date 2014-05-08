'tPoker

Type _handrank
    rank As Short
    high(5) As Short
End Type

Type _cardcount
    rank As Short
    no As Short
    Pos As Short
End Type

Type _pokerplayer
    Name As String*16
    risk As Short
    bet As Byte
    fold As Byte
    pot As Byte
    rank As Byte
    money As Short
    card(5) As Integer
    ci As Byte
    in As Byte
    Declare Function firstempty() As Short
    win As _handrank
    qg As Short 'Which questguy is this?
End Type

Type _pokerrules
    bet As Byte
    limit As Byte
    closed As Byte
    Swap As Byte
End Type

