\ this are being done so often i broke down and made this.

0 value (freestack)
0 value (proto)

: pool   ( n prototype -- <name> ) ( -- array )
   to (proto)
   create locals| n |
   here to (freestack) 0 ,
   n (proto) sizeof array,
   here (freestack) ! n stack,
   [[ (proto) over initialize (freestack) @ push ]] (freestack) cell+ each
   does> cell+ ;

: pool-one   cell- @ pop ;

: pool-return   cell- @ push ;

0 value (pool)
0 value (freestack)
: reset-pool
   to (pool) (pool) cell- @ to (freestack)
   (freestack) vacate   [[ (freestack) push ]] (pool) each ;

: pool-free?  ( n pool -- flag )
   cell- @ length <= ;
