\ ==============================================================================
\ ForestLib
\ General purpose Arrays
\ ========================= copyright 2014 Roger Levy ==========================

\ module ~array

\ Array

0
   var #ITEMS
   var MAXITEMS
   var ITEMSIZE
   var 'item
   var stack?
   var (items)
\    0 field ITEMS         \ depends on array size

\ for 2-d support
   var cols
   var rows

constant /array


: items   " (items) @ " evaluate ; immediate
: >items  " >(items) @ " evaluate ; immediate

0 value arr

: (#items)   dup >stack? @ if >#items @ else >maxitems @ then ;

aka (#items) length



: EACH   ( XT array -- ) ( ... addr -- ... ) \ itterate on array
   dup >#items @ 0= if 2drop EXIT then
   struct >r
   arr >r   to arr
   arr >items arr length arr >itemsize @ * BOUNDS DO
      i over >r swap EXECUTE r>
   arr >itemsize @ +LOOP
   DROP
   r> to arr
   r> to struct ;

: <EACH
   dup >#items @ 0= if 2drop EXIT then
   struct >r
   arr >r   to arr
   arr >items arr (#items) 1 - arr >itemsize @ * BOUNDS swap DO
      i over >r swap EXECUTE r>
   arr >itemsize @ negate +LOOP
   DROP
   r> to arr
   r> to struct ;



: (item)
   => itemsize @ * items + ;

: cell[]
   >items >r cells r> + ;

: half[]
   >items >r 1 << r> + ;

: char[]
   >items + ;

: []   ( n array -- addr ) dup >'item @ execute ;

: FIRST[]   0 swap [] ;
: LAST[]   dup length 1 - swap [] ;


: ITEMSBOUNDS
   dup first[] swap => itemsize @ #items @ * bounds ;

: PUSH ( value array -- )
   locals| arr |
   arr >#items @ arr cell[] ! arr >#items ++ ;

: POP ( array -- value )
   locals| arr |
   arr >#items -- arr >#items @ arr cell[] @ ;

: TOP@ ( array -- value )
   locals| arr |
   arr >#items @ 1 - arr [] @ ;

: VACATE   >#items off ;

create []'s   ' char[] , ' half[] , ' (item) , ' cell[] , ' (item) ,

: *stack   ( max-items item-size -- )
   2dup itemsize ! maxitems !
   itemsize @ 5 min 1 - cells []'s + @ 'item !
   stack? on
   here (items) !
   * /allot
;

: (stack)   ( max-items item-size -- )
   here => /array /allot  *stack
;

: STACK,   ( max-items -- ) cell (stack) ;


: ARRAY,   ( #items item-size -- )   here =>  over swap (stack) #items ! stack? off ;

: INIT-ARRAY  ( #items item-size array -- )
   => itemsize !   dup #items ! maxitems !
   here (items) !
   itemsize @ 5 min 1 - cells []'s + @ 'item ! ;

\ compile array header into dictionary - doesn't allocate the space for the actual items
: arrayheader,   ( #items item-size -- )
   here /array /allot init-array ;



\ step through without EACH - does not preserve STRUCT
create arrs 32 cells cell+ /allot
: arrs>   arrs cell+ arrs @ 31 cells and + ;

: /each   ( struct=array -- struct=item ) struct  arr arrs> !  cell arrs +!  dup to arr  >items to struct ;
: each/   ( -- ) -cell arrs +!   arrs> @ to arr  ;
: +item   arr >itemsize @ +to struct ;


: check  ( ... xt array -- ... flag ) ( ... break? -- ... )
   =>  locals| xt | /each arr length 0 do xt execute ?dup if unloop exit then loop false ;


\ : ?NXT   nxt   struct arr >items - arr >itemsize @ /   arr >#items @ >= ;

\ itterate on contents of stack
0 value xt
: those ( xt stack -- )
   xt >r swap to xt
   [[ @ xt execute ]] swap each
   r> to xt ;
: <those ( xt stack -- )
   xt >r swap to xt
   [[ @ xt execute ]] swap <each
   r> to xt ;


: sort  ( xt array -- ) ( item1 item2 -- flag )
   =>  (items) @ #items @ rot cellsort ;
\ if flag returned is true, then a is less than b.


: rnditem  ( array -- item item# )
   dup length rnd dup >r swap [] r> ;

: rnd@   rnditem drop @ ;
: rnd[]   rnditem drop ;


: [array  here swap   0 over arrayheader, here ;
: array]  rot =>   here swap - swap /   dup #items ! maxitems ! ;

: items!   >(items) ! ;
: array!   ( mem #items item-size array ) => struct init-array struct items! ;


: []wrap   =>  #items @ mod            struct 'item @ execute ;
: []clamp   =>  0 #items @ 1 - clamp   struct 'item @ execute ;
aka []wrap wrap[]
aka []clamp clamp[]


\ this is a pretty bad shuffle.
: shuffle   3 0 do [[ 2drop 2 rnd ]] over sort loop drop ;