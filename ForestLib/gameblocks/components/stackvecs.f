\ ==============================================================================
\ ForestLib > GameBlocks
\ Stack vector math
\ ========================= copyright 2014 Roger Levy ==========================

: 3p* ( x. y. z. x. y. z. -- x. y. z. )
   3 roll p* >r
   rot p* >r p* r> r> ;

: log2  ( n -- n )   
   1e s>f y*log2(x) f>s ;

: plog2  ( n. -- n. )   
   1e p>f y*log2(x) f>p ;

: 2p* ( x. y. x. y. -- x. y. )   
   rot p* >r p* r> ;

: 2p/ ( x. y. x. y. -- x. y. )   
   rot swap p/ >r p/ r> ;

: 2length  ( x. y. -- n. )   
   2p>f fdup f* fswap fdup f* f+ fsqrt f>p ;

: 2normalize ( x. y. -- x. y. )
   2dup .0 d= ?exit 2dup 2length dup 2p/ 1 1 2+ ;

: 2chop   ( x. y. length -- ) 
   >r 2normalize r> dup 2p* ;

macro: 2proximity  ( x. y. x. y. -- n. ) 2- 2length ;

: 2rotate   ( x. y. angle. -- x. y. )
   dup pcos swap psin locals| sin(ang) cos(ang) y x |
   x cos(ang) p* y sin(ang) p* -
   x sin(ang) p* y cos(ang) p* + ;

: 2vec  ( angle. length. -- x. y. )
   swap 2dup pcos p* >r psin negate p* r> swap ;

: 2ang   ( x. y. -- ang. )
   negate p>f p>f fatan2 r>d f>p ;

macro: 2,  swap , , ;
macro: 3,  rot , swap , , ;
