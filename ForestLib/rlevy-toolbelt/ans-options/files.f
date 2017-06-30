\ ==============================================================================
\ ForestLib > GameBlocks
\ File utilities
\ ========================= copyright 2014 Roger Levy ==========================

: file! ( addr count filename c -- )
   w/o create-file throw >r
   r@ write-file throw
   r> close-file throw ;

: @file ( filename count dest -- size )
   -rot r/o open-file throw >r
   r@ file-size drop throw r@ read-file throw
   r> close-file throw ;

\ system heap version
: file@ ( filename count -- allocated-mem size )
   r/o open-file throw >r
   r@ file-size throw d>s dup dup allocate throw dup rot
   r@ read-file throw drop
   r> close-file throw
   swap ;

\ dictionary version
: file>   ( filename c -- addr size )
   file@ 2dup here dup >r swap dup /allot move swap free drop r> swap ;

: file,   file> 2drop ;
