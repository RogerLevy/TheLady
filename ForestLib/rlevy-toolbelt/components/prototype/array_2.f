\ ==============================================================================
\ ForestLib
\ General purpose Arrays
\ ========================= copyright 2014 Roger Levy ==========================

pstruct %array
   var #ITEMS
   var MAXITEMS
   var ITEMSIZE
   var 'item
   var stack?
   var (items)

\ for 2D support
   var cols
   var rows
endp

: /array   %array sizeof ;

: items   " (items) @ " evaluate ; immediate
: >items  " .(items) @ " evaluate ; immediate

0 value arr

: (#items)   dup .stack? @ if .#items @ else .maxitems @ then ;

aka (#items) length

: EACH   ( XT array -- ) ( ... addr -- ... ) \ itterate on array
   dup .#items @ 0= if 2drop EXIT then
   s@ >r
   arr >r   to arr
   arr >items arr length arr .itemsize @ * BOUNDS DO
      i over >r swap EXECUTE r>
   arr .itemsize @ +LOOP
   DROP
   r> to arr
   r> s! ;

: <EACH
   dup .#items @ 0= if 2drop EXIT then
   s@ >r
   arr >r   to arr
   arr >items arr (#items) 1 - arr .itemsize @ * BOUNDS swap DO
      i over >r swap EXECUTE r>
   arr .itemsize @ negate +LOOP
   DROP
   r> to arr
   r> s! ;

: (item)
   with itemsize @ * items + ;

: cell[]
   >items >r cells r> + ;

: half[]
   >items >r 1 << r> + ;

: char[]
   >items + ;

: []   ( n array -- addr ) dup .'item @ execute ;

: FIRST[]   0 swap [] ;
: LAST[]   dup length 1 - swap [] ;


: ITEMSBOUNDS
   dup first[] swap with itemsize @ #items @ * bounds ;

: PUSH ( value array -- )
   locals| arr |
   arr .#items @ arr cell[] ! arr .#items ++ ;

: POP ( array -- value )
   locals| arr |
   arr .#items -- arr .#items @ arr cell[] @ ;

: TOP@ ( array -- value )
   locals| arr |
   arr .#items @ 1 - arr [] @ ;

: VACATE   .#items off ;

create []'s   ' char[] , ' half[] , ' (item) , ' cell[] , ' (item) ,

: *stack   ( max-items itemsize -- )
   2dup itemsize ! maxitems !
   itemsize @ 5 min 1 - cells []'s + @ 'item !
   stack? on
   here (items) !
   * /allot
;

: (stack)   ( max-items  itemsize -- )
   here with /array /allot  *stack
;

: INIT-STACK   ( max-items array )  with cell *stack 0 #items ! ;

: STACK,   ( max-items -- ) cell (stack) ;

: ARRAY,   ( #items item-size -- )   here with  over swap (stack) #items !   stack? off ;

: INIT-ARRAY  ( #items item-size array -- )
   with itemsize !   dup #items ! maxitems !
   here (items) !
   itemsize @ 5 min 1 - cells []'s + @ 'item ! ;

\ compile array header into dictionary - doesn't allocate the space for the actual items
: arrayheader,   ( #items item-size -- )
   here /array /allot init-array ;

\ step through without EACH - does not preserve s@
create arrs 32 cells cell+ /allot
: arrs>   arrs cell+ arrs @ 31 cells and + ;

: /each   ( s@=array -- s@=item ) s@  arr arrs> !  cell arrs +!  dup to arr  >items s! ;
: each/   ( -- ) -cell arrs +!   arrs> @ to arr  ;
: +item   arr .itemsize @ s@ + s! ;

: check  ( ... xt array -- ... flag ) ( ... break? -- ... )
   with  locals| xt | /each arr length 0 do xt execute ?dup if unloop exit then loop false ;

\ : ?NXT   nxt   s@ arr >items - arr .itemsize @ /   arr .#items @ >= ;

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
   with  (items) @ #items @ rot cellsort ;
\ if flag returned is true, then a is less than b.

: rnditem  ( array -- item item# )
   dup length rnd dup >r swap [] r> ;

: rnd@   rnditem drop @ ;
: rnd[]   rnditem drop ;

\ in interpret mode these will behave like this.
\ in compile mode they will have an IMMEDIATE behavior that returns an array stored
\ in a region.
: [array  here swap   0 over arrayheader, here ;
: array]  rot with   here swap - swap /   dup #items ! maxitems ! ;

: items!   .(items) ! ;
: array!   ( mem #items item-size array ) with s@ init-array s@ items! ;
: stack!   ( mem #items array ) with s@ init-array s@ items! ;

: []wrap   with  #items @ mod            s@ 'item @ execute ;
: []clamp   with  0 #items @ 1 - clamp   s@ 'item @ execute ;
aka []wrap wrap[]
aka []clamp clamp[]

\ this is a pretty bad shuffle.
: shuffle   3 0 do [[ 2drop 2 rnd ]] over sort loop drop ;