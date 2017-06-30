\ untested

: file! ( addr count filename c -- )
   w/o create-file throw >r
   r@ write-file throw
   r> close-file throw ;

: file[]! ( addr count ofs filename c -- )
   2dup file-exists if w/o open-file else w/o create-file then
   throw >r
   0 r@ reposition-file throw
   r@ write-file throw
   r> close-file throw ;


: @file ( filename count dest -- size )
   -rot r/o open-file throw >r
   r@ file-size drop throw r@ read-file throw
   r> close-file throw ;


: []@file ( filename count srcofs dest count -- size )
   locals| cnt |
   2swap r/o open-file throw >r
   swap 0 r@ reposition-file throw
   cnt r@ read-file throw
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
