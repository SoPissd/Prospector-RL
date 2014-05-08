'tRng

'rng with retrievable seed
'algo from https://en.wikipedia.org/wiki/Random_number_generation

'
'm_w = <choose-initializer>;    /* must not be zero, nor 0x464fffff */
'm_z = <choose-initializer>;    /* must not be zero, nor 0x9068ffff */
' 
'uint get_random()
'{
'    m_z = 36969 * (m_z & 65535) + (m_z >> 16);
'    m_w = 18000 * (m_w & 65535) + (m_w >> 16);
'    return (m_z << 16) + m_w;  /* 32-bit result */
'}


'outputs 32bit but maintains
'random pool with a 64 bit state 
Type tRngSeed
	w as UInteger
	z as UInteger	
End Type

Type tRng
  declare constructor(ByVal aSeed as tRngSeed=(0,0))
  declare destructor()
  declare property Seed as tRngSeed
  declare property Seed(ByVal aSeed as tRngSeed)
  declare property uValue as uinteger
  declare property dValue as double
  declare function uRange(ByVal uLow As UInteger, ByVal uHigh As UInteger) as UInteger
Private:
  _w as UInteger
  _z as UInteger
  declare property isInvalidSeed as short
End Type

Constructor tRng(ByVal aSeed as tRngSeed=(0,0))
	Seed= aSeed	
End Constructor

Destructor tRng()
End Destructor

'on setting the seed we have to exclude 
'a couple of values that would break the cycling
Property tRng.isInvalidSeed as Short
  return (_w=0) or (_w=&h464fffffu) _
      or (_z=0) or (_z=&h9068ffffu)
End Property

Property tRng.Seed As tRngSeed
	' uh oh .. does it have to be like this?
	' can i not write this without a helper variable?
	dim x as tRngSeed
	x.w=_w
	x.z=_z
	Property= x
End Property

'use the built-in crypto generator to get two
'high quality numbers to initialize on invalid seeds
Property tRNG.Seed(ByVal aSeed as tRngSeed)
	_w=aSeed.w
	_z=aSeed.z
	while isInvalidSeed
		randomize timer,5
		_w= cuint(2^32*rnd())
		_z= cuint(2^32*rnd())
	wend
End Property

'Wikipedia cites this as an example of a simple pseudo-random number generator:
'"the multiply-with-carry method invented by George Marsaglia. It is computationally
' fast and has good (albeit not cryptographically strong) randomness properties"
Property tRNG.uValue as uInteger
	_z = 36969 * (_z and &hFFFF) + (_z shr 16)
	_w = 18000 * (_w and &hFFFF) + (_w shr 16)
	return (_z shl 16) + _w
End Property

Property tRNG.dValue as double
' uh oh ... why do i need the helper variables here? do i need both?
	dim as uInteger x,y
	x= uValue
	y= &hFFFFFFFF '2^33-1
	return x/y
End Property

Function tRng.uRange(ByVal uLow As UInteger, ByVal uHigh As UInteger) as UInteger
	if uLow>uHigh then
		return uRange(uHigh,uLow)
	else
		' i dont quite understand the rounding here. 
		' see the test graph, 0 and 10 never rise above the average!
		return dValue * (uHigh - uLow) + uLow   
	endif
End Function


#ifdef main

dim shared rng as tRng
dim shared seed as tRngSeed
seed = rng.Seed

'Returns a random short
Function rnd_range(first As Integer, last As Integer) As Integer
    return rng.uRange(first, last)
End Function


#else 'rng_test

#include once "string.bi"
sub test()
	cls
	? "exercising tRng": ?
	dim rng as tRng
	dim seed as tRngSeed
	dim i as Short
	'
	Seed= rng.Seed
	? "found seed: " &seed.w &" " &seed.z
	? "uValue ";
	for i= 1 to 6 : ? rng.uValue;" "; :next: ?
	'
	rng.Seed= Seed		
	? "reset: ";
	for i= 1 to 6 : ? rng.uValue;" "; :next: ?
	'
	?
	? "testing dValue:" 	
	for i= 1 to 9: ? format(rng.dValue,"0.#####");" "; :next: ?
	'
	?
	? "testing uRange 0..9:" 	
	for i= 1 to 38 : ? rng.uRange(9,0);" "; :next: ?
	for i= 1 to 38 : ? rng.uRange(0,9);" "; :next: ?
	'
	?
	dim as short n=10,m=(80-8)\2 -5
	? "testing distribution  0.." &n &":"
	dim as short r(0 to n)
	for i= 0 to n*m: r(rng.uRange(0,n)) +=1 :next 	
	for i= 0 to n  : ? format(i,"00: "); format(r(i),"00: "); spc(r(i));"*";
		if r(i)<>m then 
			locate CsrLin, 9+m :?"|"
		else
			?
		EndIf
	next
end sub

sub main()
	width 80,32	
	do 
		test()
		'
		?
		? "again? (y)"; 
		do while inkey<>"":loop
	loop while (getkey=asc("y"))	
	?"done"
End Sub
main()
#endif
