\ ==============================================================================
\ ForestLib
\ Prototype-based OOP
\ ========================= copyright 2014 Roger Levy ==========================

\ 6/5/2013  factored out of structs.f and made less universal by deleting some words and removing
\           coupling to general_struct.f (though it does depend on it)


fload general-structs



\ don't reduce the size of this buffer.
16384 constant /buf
create prototype /buf /allot


0
   var size
   var proto
   var onbeget        \ ( prototype -- prototype ) used to inherit any external data or do other tasks on BEGETS
   var ptype          \ XT - used to alter field behavior and do any state setting on BEGETS and REOPEN
   var pwl            \ innards wordlist - it's a factoring tool.  descendents "inherit" it.
   var ancestor
   0 field ppath      \ path to file the prototype was defined in
drop


[a] +order


previous

: derive     ( prototype -- prototype ) \ copies given prototype contents to the prototype buffer
   prototype /buf erase
   dup >size 2@ swap   prototype swap move \ copy prototype to buffer
   ;

: prototype+   dup /buf >= abort" Prototype buffer overrun" prototype + ;


\ -------------------------------------------------------------------------------------------
\ Instantiation
defer getmem

: initialize   ( prototype addr -- ) >r 2@ r> rot cell/ imove ;
: dict   [[ here swap allot ]] is getmem ;
: sysheap   [[ allocate throw ]] is getmem ;
: instantiate  ( prototype -- addr ) =>  size @ getmem >r size 2@ r@ rot cell/ imove  r> ;
aka instantiate instance
: instance,   dict instantiate drop ;
: build>   ( prototype ) r> swap instantiate => call ;
: clone   ( src dest prototype -- )   >size @ cell/ imove ;


\ -------------------------------------------------------------------------------------------
\ Prototype definition

0 value pdef

0 value n
: (innards) ?dup -exit dup >pwl @ 1 +to n swap >ancestor @ recurse ;

: innards   ( prototype ) 0 to n (innards) drop n 1 - 0 ?do +order loop ;

: -innards   ( prototype ) ?dup -exit dup >pwl @ -order >ancestor @ recurse ;

: begets   ( parent-prototype <name> -- new-prototype size )
   struct >o
   dup 1 strands locals| wl parent |
   derive  create here dup s! dup to pdef swap
   dup >r  >size @ dup , 0 ,
   r@ >onbeget @ dup ,
   r> >ptype @ dup ,
   wl ,
   parent ,
   including string,
   swap struct ( new-prototype ) swap execute drop execute
   over innards 
   ;

: fields   ( xt -- )
   dup execute pdef >ptype ! ;

\ finish up the prototype and copy the data into a unique buffer
: end-prototype ( new-prototype size -- )
   over -innards
   swap s! here over allot ( size prototype-data ) 2dup size 2!
   prototype -rot swap move   general-struct
   o> s!
   ;


variable (current)
\ define innards
: [i   get-current (current) ! over >pwl @ set-current ;
: i]   (current) @ set-current ;


: var:    ( new-prototype size value -- <name> new-prototype size+cell )
   over prototype+ ! var ;

: fvar:
   dup prototype+ f! dvar ;

: sfvar:
   dup prototype+ sf! var ;

: mark:   0 field ;
aka mark: init:

: ^   ( new-prototype size value -- new-prototype size+cell )  \ "hoist"
   over prototype+ ! cell+ ;

: 2^  ( new-prototype size value value -- new-prototype size+2cells )  \ "hoist"
   third prototype+ 2! cell+ cell+ ;

: string:  ( new-prototype size addr c -- new-prototype size+128 )
   third prototype+ place 128 field ;

\ this is a really dangerous word and should only be used for debugging and experimentation in the IDE
\ or in very special circumstances where you know you haven't instantiated anything that will use the
\ feature(s) you're about to add.
: reopen  ( prototype -- prototype size )
   dup innards
   dup s!   prototype /buf erase   proto @ prototype size @ cmove   size @   ptype @ execute ;

: noop:   ['] noop var: ;

: sizeof   >size @ ;

: inline:   ( new-prototype size prototype -- <name> new-prototype size+prototypesize )  \ nest prototype
   over ( size prototype size )
   prototype+ ( dest ) over ( dest prototype ) 2@ ( dest size proto ) -rot move sizeof field ;

: pstruct-fields   general-struct  prototype s! ;

create %object   0 , here , ' noop , ' pstruct-fields , 0 , 0 , 

: pstruct   %object begets ;

: begetting   pdef >onbeget ! ;

aka end-prototype endp

aka begets ~>

fload quicksort
fload array

