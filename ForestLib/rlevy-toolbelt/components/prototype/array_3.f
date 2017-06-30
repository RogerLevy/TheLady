\ ==============================================================================
\ ForestLib
\ General purpose Arrays
\ ========================= copyright 2014 Roger Levy ==========================



\ Array

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
   
   var resizeable ( 0 or 4 )  \ Flag, but also offset in vector pairs defined with xtpair. 
endp

: /array   %array sizeof ;


: items   " (items) @ " evaluate ; immediate
: >items  " .(items) @ " evaluate ; immediate

0 value arr

: (#items)   dup .stack? @ if .#items @ else .maxitems @ then ;

aka (#items) length



: _EACH   ( XT array -- ) ( ... addr -- ... ) \ iterate on array
   dup .#items @ 0= if 2drop EXIT then
   s@ >r
   arr >r   to arr
   arr >items arr length arr .itemsize @ * BOUNDS DO
      i over >r swap EXECUTE r>
   arr .itemsize @ +LOOP
   DROP
   r> to arr
   r> s! ;

: _<EACH
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

: _[]   ( n array -- addr ) dup .'item @execute ;

: _FIRST[]  0 swap _[] ;
: _LAST[]   dup length 1 - swap _[] ;


: ITEMSBOUNDS
   dup _first[] swap with itemsize @ #items @ * bounds ;

: _PUSH  ( value array -- )
   locals| arr |
   arr .#items @ arr cell[] ! arr .#items ++ ;

: _POP  ( array -- value )
   locals| arr |
   arr .#items -- arr .#items @ arr cell[] @ ;

: _TOP@  ( array -- value )
   locals| arr |
   arr .#items @ 1 - arr _[] @ ;

: _VACATE  ( array -- ) .#items off ;

create []'s   ' char[] , ' half[] , ' (item) , ' cell[] , ' (item) ,

: *stack   ( max-items itemsize -- )
   2dup itemsize ! maxitems !
   itemsize @ 5 min 1 - cells []'s + @ 'item !
   stack? on
   here (items) !
   * /allot
;

: _(stack)   ( max-items  itemsize -- )
   here with /array /allot  *stack
;

: INIT-STACK   ( max-items array )  with cell *stack 0 #items ! ;

: STACK,   ( max-items -- ) cell _(stack) ;

: ARRAY,   ( #items item-size -- ) here with  over swap _(stack) #items !   stack? off  resizeable off ;

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

\ iterate on contents of stack
0 value xt
: _those ( xt stack -- )
   xt >r swap to xt
   [[ @ xt execute ]] swap _each
   r> to xt ;
: _<those ( xt stack -- )
   xt >r swap to xt
   [[ @ xt execute ]] swap _<each
   r> to xt ;


: _sort  ( xt array -- ) ( item1 item2 -- flag )
   with  (items) @ #items @ rot cellsort ;
\ if flag returned is true, then a is less than b.


: _rnditem  ( array -- item item# )
   dup length rnd dup >r swap _[] r> ;

: _rnd@   _rnditem drop @ ;
: _rnd[]  _rnditem drop ;


\ in interpret mode these will behave like this.
\ in compile mode they will have an IMMEDIATE behavior that returns an array stored
\ in a region.
: [array  here swap   0 over arrayheader, here ;
: array]  rot with   here swap - swap /   dup #items ! maxitems ! ;

: items!   ( array ) .(items) ! ;
: array!   ( mem #items item-size array ) with s@ init-array s@ items! ;
: stack!   ( mem #items array ) with s@ init-array s@ items! ;


: _[]wrap   with  #items @ mod            s@ 'item @execute ;
: _[]clamp   with  0 #items @ 1 - clamp   s@ 'item @execute ;

\ This was a pretty bad shuffle.
\ Only exchanges neighbours a few times.
\ : shuffle  ( array -- )  3 0 do [[ 2drop 2 rnd ]] over _sort loop drop ;

\ This shuffle switches the current item in the loop,
\   with a random item in the array.
: (shuffle)  ( array -- )
   dup .#items @
   locals| _items arr |
   _items 0 do
      i                   \ index1
      arr _[] dup>r @     \ x1 R: addr1
      _items rnd         \ x1 index2 R: addr1
      arr _[] dup @ >r    \ x1 addr2 R: addr1 x2
      ! r> r> !
   loop
;

\ Perform shuffle a few times to make it even better.
: _shuffle  ( array -- )  3 0 do dup (shuffle) loop drop ;
