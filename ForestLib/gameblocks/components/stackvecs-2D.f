\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ Stack vector math (2D)
\ ========================= copyright 2014 Roger Levy ==========================


: log2 ( n -- n )   
   1e s>f y*log2(x) f>s ;

: plog2 ( n. -- n. )   
   1e p>f y*log2(x) f>p ;

: 2p* ( x. y. x. y. -- x. y. )   
   rot p* >r p* r> ;

aka 2p* scale2d

: 2p/ ( x. y. x. y. -- x. y. )   
   rot swap p/ >r p/ r> ;

: magnitude ( x. y. -- n. )   
   2p>f fdup f* fswap fdup f* f+ fsqrt f>p ;

: normalize ( x. y. -- x. y. )
   2dup .0 d= ?exit 2dup magnitude dup 2p/ 1 1 2+ ;

\ uniform scale
: uscale ( x. y. n. -- ) 
   dup 2p* ;

macro: proximity  ( x. y. x. y. -- n. ) 2- magnitude ;

: rotate ( x. y. angle. -- x. y. )
   dup pcos swap psin locals| sin(ang) cos(ang) y x |
   x cos(ang) p* y sin(ang) p* -
   x sin(ang) p* y cos(ang) p* + ;

: vecfrom ( angle. -- x. y. )
   pcos p* >r psin negate p* r> swap ;

: angfrom ( x. y. -- ang. )
   negate p>f p>f fatan2 r>d f>p ;

