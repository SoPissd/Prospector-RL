'tDisease.
'

'needs [head|main|both] defined,
' builds in test mode otherwise:
#if not (defined(types) or defined(head) or defined(main))
#define intest
#define both
#endif'test
#if defined(both)
#undef both
#define types
#define head
#define main
#endif'both
'
#ifdef intest
'     -=-=-=-=-=-=-=- TEST: tDisease -=-=-=-=-=-=-=-
#undef intest
#define test
#endif'test

#ifdef types
'     -=-=-=-=-=-=-=- TYPES:  -=-=-=-=-=-=-=-    

Type _disease
    no As UByte
    desig As String
    ldesc As String
    cause As String
    incubation As UByte
    duration As UByte
    fatality As UByte
    contagio As UByte
    causeknown As Byte
    cureknown As Byte
    att As Byte
    hal As Byte
    bli As Byte
    nac As Byte
    oxy As Byte
    wounds As Byte
End Type

Dim Shared disease(17) As _disease


#endif'types
#ifdef head
'     -=-=-=-=-=-=-=- HEAD: tDisease -=-=-=-=-=-=-=-

#endif'head
#ifdef main
'     -=-=-=-=-=-=-=- MAIN: tDisease -=-=-=-=-=-=-=-

namespace tDisease
function init(iAction as integer) as integer

    disease(1).no=1
    disease(1).desig="gets a light cough"
    disease(1).ldesc="a light cough"
    disease(1).incubation=2
    disease(1).duration=3
    disease(1).contagio=5
    disease(1).cause="bacteria"
    disease(1).fatality=5
    disease(1).att=-1
    
    disease(2).no=2
    disease(2).desig="gets a heavy cough"
    disease(2).ldesc="a heavy cough"
    disease(2).incubation=3
    disease(2).duration=4
    disease(2).contagio=5
    disease(2).cause="viri"
    disease(2).fatality=5
    
    disease(3).no=3
    disease(3).desig="gets a fever and a light cough"
    disease(3).ldesc="a light cough and fever"
    disease(3).incubation=3
    disease(3).duration=5
    disease(3).contagio=10
    disease(3).cause="bacteria"
    disease(3).fatality=8
    
    
    disease(4).no=4
    disease(4).desig="gets a heavy fever and a light cough"
    disease(4).ldesc="a heavy cough and fever"
    disease(4).incubation=3
    disease(4).duration=6
    disease(4).contagio=10
    disease(4).cause="bacteria"
    disease(4).fatality=12
    
    disease(5).no=5
    disease(5).desig="gets a fever and starts shivering"
    disease(5).ldesc="a light fever and shivering"
    disease(5).incubation=3
    disease(5).duration=15
    disease(5).contagio=5
    disease(5).cause="viri"
    disease(5).fatality=15
    
    disease(6).no=6
    disease(6).desig="suddenly gets shivering and boils"
    disease(6).ldesc="shivering and boils"
    disease(6).incubation=1
    disease(6).duration=15
    disease(6).contagio=15
    disease(6).cause="microscopic parasitic lifeforms"
    disease(6).fatality=25
    
    disease(7).no=7
    disease(7).desig="gets muscle cramps"
    disease(7).ldesc="shivering and muscle cramps"
    disease(7).incubation=3
    disease(7).duration=15
    disease(7).contagio=15
    disease(7).cause="viri"
    disease(7).fatality=25
    disease(7).att=-4
    disease(7).oxy=4
    
    disease(8).no=8
    disease(8).desig="starts vomiting and coughing blood"
    disease(8).ldesc="vomiting and coughing of blood"
    disease(8).incubation=5
    disease(8).duration=15
    disease(8).contagio=15
    disease(8).cause="bacteria"
    disease(8).fatality=25
    
    disease(9).no=9
    disease(9).desig="suddenly turns blind"
    disease(9).ldesc="blindness"
    disease(9).incubation=5
    disease(9).duration=15
    disease(9).contagio=15
    disease(9).cause="bacteria"
    disease(9).fatality=5
    disease(9).bli=55
    
    disease(10).no=10
    disease(10).desig="has fever and suicidal thoughts"
    disease(10).ldesc="a strong fever, shivering and boils"
    disease(10).incubation=1
    disease(10).duration=15
    disease(10).contagio=15
    disease(10).cause="mircroscopic parasitic lifeforms"
    disease(10).fatality=5
    
    disease(11).no=11
    disease(11).desig="has a strong fever and balance impairment"
    disease(11).ldesc="a strong fever and balance impairment"
    disease(11).incubation=5
    disease(11).duration=15
    disease(11).contagio=15
    disease(11).cause="viri"
    disease(11).fatality=5
    disease(11).att=-7
    
    disease(12).no=12
    disease(12).desig="gets a rash"
    disease(12).ldesc="a rash caused"
    disease(12).incubation=2
    disease(12).duration=25
    disease(12).contagio=35
    disease(12).cause="bacteria"
    disease(12).fatality=5
    
    disease(13).no=13
    disease(13).desig="suffers from hallucinations"
    disease(13).ldesc="severe hallucinations"
    disease(13).incubation=1
    disease(13).duration=25
    disease(13).duration=45
    disease(13).cause="mircroscopic parasitic lifeforms"
    disease(13).fatality=5
    disease(13).hal=25
    
    disease(14).no=14
    disease(14).desig="starts falling asleep randomly"
    disease(14).ldesc="narcolepsy"
    disease(14).incubation=5
    disease(14).duration=255
    disease(14).contagio=25
    disease(14).cause="viri"
    disease(14).fatality=45
    disease(14).nac=45
    
    disease(15).no=15
    disease(15).desig="suddenly starts bleeding from eye sockets and mouth."
    disease(15).ldesc="bleeding from eye sockets, mouth, nose, ears and fingernails"
    disease(15).incubation=1
    disease(15).duration=3
    disease(15).contagio=40
    disease(15).cause="agressive bacteria"
    disease(15).fatality=65
    
    disease(16).no=16
    disease(16).desig="suffers from radiation sickness"
    disease(16).ldesc="radiation sickness"
    disease(16).incubation=0
    disease(16).duration=255
    disease(16).contagio=0
    disease(16).cause="radiation"
    disease(16).fatality=55
    
    disease(17).no=17
    disease(17).desig="gets a bland expression"
    disease(17).ldesc="a wierd brain disease"
    disease(17).incubation=5
    disease(17).duration=15
    disease(17).contagio=75
    disease(17).fatality=85
      
   	return 0
end function
end namespace'tDisease





#endif'main

#if (defined(main) or defined(test))
'      -=-=-=-=-=-=-=- INIT: tDisease -=-=-=-=-=-=-=-
	tModule.register("tDisease",@tDisease.init()) ',@tDisease.load(),@tDisease.save())
#endif'main

#ifdef test
#print -=-=-=-=-=-=-=- TEST: tDisease -=-=-=-=-=-=-=-
#endif'test
