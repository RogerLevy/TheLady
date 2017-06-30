\ ==============================================================================
\ ForestLib
\ Fixed point (16.16) math and printing
\ ========================= copyright 2014 Roger Levy ==========================

[defined] x86 [if]
    fload fixedp-x86
[else]
    \ TODO: colon versions
[then]



: 4s>p   s>p >r 3s>p r> ;
: 4p>s   p>s >r 3p>s r> ;


\ convert from fixed 0...1.0 to 0...255 (int, suitable for byte storage)
: plim  dup if 1 - then $ffff and ;
macro: p>c   plim 8 >> ;
macro: c>p   8 <<  $10000 $ff00 */ ;

65536E FValue 65536E  \ makes fixed point conversion 1.33x faster
1E 65536E F/ FValue 1/65536E

macro: P>F   S>F 1/65536E F* ;
macro: F>P   65536E F* (F>S) ;

Pi F>P Constant Ppi
Pi/2 F>P Constant Ppi/2.
Pi/180 F>P Constant Ppi/180.
180E Pi F/ F>P Constant 180/Ppi

macro: p*  fixed-mul ;
: p/  swap p>f p>f f/ f>p ;

: pcos   p>f COS f>p ;
: psin   p>f SIN f>p ;

: lerp   ( src dest n. -- )
   >r over - r> p* + ;

: pSQRT   p>f fsqrt f>p ;

: 2floor floor >r floor r> ;
: 3floor floor >r floor >r floor r> r> ;
: p.    p>f f. ;
: p?    @ p. ;
: 2p.    swap p. p. ;
: 3p.    rot p. swap p. p. ;
: 2p?    2@ 2p. ;
: 3p?    3@ 3p. ;
: 4p?    dup 2p? 2 cells + 2p? ;


: 2p>f   swap p>f p>f ;
: 3p>f   >r >r p>f r> p>f r> p>f ;
macro: 2f>p   f>p f>p swap ;
: 4p@f   a!> @+ p>f @+ p>f @+ p>f @+ p>f ;
: 4p>f   >r >r swap p>f p>f r> p>f r> p>f  ;
: 4f>p   2f>p 2f>p 2swap ;

\ conditional conversion (provides some fake type-inference)
: ?p   dup abs 32768 <= if s>p then ;
: ?ps  dup abs 360 <= if s>p then ;
: 2?p  ?p swap ?p swap ;
: 2?ps  ?ps swap ?ps swap ;
: 4?p  2?p 2swap 2?p 2swap ;
