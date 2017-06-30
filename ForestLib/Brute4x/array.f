\ ==============================================================================
\ ForestLib > Brute4X
\ Private array object
\ ========================= copyright 2014 Roger Levy ==========================

\ Array

0
   var #ITEMS
   var MAXITEMS
   var ITEMSIZE
   var 'item
   var stack?
   var (items)
\    0 field ITEMS         \ depends on array size
constant /array 


: items   " (items) @ " evaluate ; immediate
: >items  " >(items) @ " evaluate ; immediate

0 value arr

: (#items)
   dup >stack? @ if >#items @ else >maxitems @ then ;

: EACH   ( XT array -- ) ( ... addr -- ... ) \ itterate on array
   dup >#items @ 0= if 2drop EXIT then
   struct >r
   arr >r   to arr
   arr >items arr (#items) arr >itemsize @ * BOUNDS DO
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
   dup >itemsize @ rot * swap >items + ;

: cell[]
   >items >r cells r> + ;

: half[]
   >items >r 1 << r> + ;

: char[]
   >items + ;

: []   ( n array -- addr ) dup >'item @ execute ;

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

: (stack)   ( max-items item-size -- )
   here => /array /allot
   itemsize ! maxitems !
   itemsize @ 5 min 1 - cells []'s + @ 'item !
   stack? on 
   here (items) !
;

: (array)  here =>  over swap (stack) #items ! stack? off ;

: ARRAY, ( #items item-size -- )
   2dup  (array)   * /allot ;

: STACK, ( max-items -- )
   cell 2dup (stack)  * /allot ;

\ : length   => stack? @ if #items else maxitems then @ ;
aka (#items) length


\ step through without EACH - does not preserve STRUCT
create arrs 32 cells cell+ /allot
: arrs>   arrs cell+ arrs @ 31 cells and + ;

: /each   ( struct=array -- struct=item ) struct  arr arrs> !  cell arrs +!  dup to arr >items to struct ;
: each/   ( -- ) -cell arrs +!   arrs> @ to arr  ;
: +item   arr >itemsize @ +to struct ;


: seek  ( ... xt array -- ... flag ) ( ... break? -- ... )
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



\ : sort  ( xt array -- )
\    =>  (items) @ #items @ rot cellsort ;
   