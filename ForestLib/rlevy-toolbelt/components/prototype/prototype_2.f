\ ==============================================================================
\ ForestLib
\ Prototype-based OOP
\ ========================= copyright 2014 Roger Levy ==========================

fload general-structs_2

16384 constant /buf

create prototype-bufs /buf 8 * /allot
variable >buf
: push-buf   >buf ++ ;
: pop-buf    >buf -- ;
: prototype  >buf @ 7 and /buf * prototype-bufs + ;

0
   var size
   var proto
   var onbeget        \ ( prototype -- prototype ) used to inherit any external data or do other tasks on BEGETS
   var ptype          \ XT - used to alter field behavior and do any state setting on BEGETS and REOPEN
   var pwl            \ innards wordlist - it's a factoring tool.  descendents "inherit" it.
   var ancestor
   var classclass
   256 field ppath      \ path to file the prototype was defined in
constant /class

[a] +order

previous

: derive     ( prototype -- prototype ) \ copies given prototype contents to the prototype buffer
   prototype /buf erase
   dup .size 2@ swap   prototype swap move \ copy prototype to buffer
   ;

\ -------------------------------------------------------------------------------------------
\ Instantiation
defer getmem

: initialize   ( class addr -- ) >r 2@ r> rot cell/ imove ;
: dict   [[ here swap allot ]] is getmem ;
: sysheap   [[ allocate throw ]] is getmem ;
: instantiate ( class -- addr ) with  size @ getmem >r  size 2@ r@ rot cell/ imove  r> ;
: instance    dict instantiate ;
: instance,   instance drop ;
: clone   ( src dest class -- )   .size @ cell/ imove ;
: object   create instance, ;

0 value pdef
0 value n
: ((innards))   ?dup -exit   dup .pwl @ 1 +to n swap .ancestor @ recurse ;
: (innards)  0 to n  ((innards))  drop ;
: innards   ( class )   (innards)   n 1 - 0 ?do +order loop ;
: -innards   ( class ) ?dup -exit   dup .pwl @ -order .ancestor @ recurse ;
: in   & innards ;
: fields   ( xt -- )   dup pdef .ptype ! execute ;

variable (current)
: [i   (current) @ >o    get-current (current) !   pdef .pwl @ set-current ;
: i]   (current) @ set-current   o> (current) ! ;

\ this is a really dangerous word and should only be used for debugging and experimentation in the IDE
\ or in very special circumstances where you know you haven't d anything that will use the
\ feature(s) you're about to add.
: reopen  ( class -- class size )
   dup innards
   dup s!   prototype /buf erase   proto @ prototype size @ cmove   size @   ptype @ execute ;

: sizeof   .size @ ;
: pstruct-fields   general-struct   prototype s! ;


fload prototype_2b
fload quicksort
fload array_2
