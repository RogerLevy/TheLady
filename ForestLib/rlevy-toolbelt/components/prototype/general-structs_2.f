\ ==============================================================================
\ ForestLib
\ General purpose structs
\ ========================= copyright 2014 Roger Levy ==========================

\ [defined] general_struct~ [if] \\ [then] plugin exposed

\ module ~general-structs

\ 4/24/13 created as structs.f
\ 6/5/13 pared down and saved as general_struct.f


0 value struct


defer ifield
   \ IFIELD is now defered which lets us use the same syntax to define fields for other struct systems
   \ the universal feature remaining explicit target syntax ( e.g. >FIELDNAME )
   \
   \ with and s. are NOT defered.  
   \  it's safe to do it with fields because it's compile time, but not anything in runtime code.
   \
   \ conceptually we need to regard "structs" as general purpose, stuff like arrays, vectors, and other "utilities"
   \  stuff where it makes most sense to "get in and get out".
   \  other kinds of structs, like entities, tasks, or other modal stuff where it's convenient
   \  to work with them as if they were global states, should have their own "set the current ____" words.


defer $create-field ( addr c )
defer +psize ( n )

: s!  to struct ;
aka struct s@ 

: ds-$create-field   $create over , ;
: ds+psize      + ;
: old-structs   ['] ds-$create-field is $create-field
                ['] ds+psize is +psize ; old-structs

: create-field   bl parse $create-field ;

\ implicit target
: struct-ifield  ( ... size -- <name> ... )
   create-field does> @ struct + ;

: general-struct    ['] struct-ifield is ifield ;   general-struct

\ explicit target
: create-efield    ( ... size -- <name> ... )
   " ." <$ bl parse $+ $> $CREATE-field immediate DOES> @ ?literal " + " evaluate ;

: EFIELD ( ... size -- <name> ... )
   >in @ >r   create-efield   r> >in ! ;
   
: field  ( ... size -- <name> ... )
   efield  ifield  +psize ;

: VAR   cell field ;

\ 4/27/13
: dvar   2 cells field ;



\ object stack - needed to play nice with locals, circular for stability, and supports multitasking 
\                by allowing relocation of the stack (just say TO OSTACK) 
\                note: both struct and OSP need to be saved/restored on task switches
32 cells constant /ostack
create ostack0   /ostack /allot
ostack0 value ostack
0 value osp \ offset into ostack

: >o    osp ostack + !   osp cell+ [ /ostack 1 - ]# and to osp ;
: o>    osp cell- [ /ostack 1 - ]# and to osp   osp ostack + @ ;

\ activate current object for definition
: (with)  struct over = if drop exit then struct >o to struct r> call o> to struct ;
: with
   state @ if postpone (with) else to struct then ; immediate

\ target given object in following word - useful for words that change the current object
\ i'm trying to phase this out
: (->).1   struct >o to struct ;
: (->).2   o> to struct ;
: ->
  state @ if postpone (->).1 bl parse evaluate postpone (->).2
   else struct >o to struct bl parse evaluate o> to struct then
; immediate



\ since i intend to implement objects that set the current whatever by invoking their name,
\ i'm providing for getting the address of such objects ...
: &   ' >body ;
: [&]  ' >body postpone literal ; immediate


: force-size   nip ;
