\ Copyright 2014 - Leon Konings - Konings Software.
\ Created for Roger Levy

{ ---------------------------------------------------------------------------
Dynamic arrays

- Are resizable.
- Use regions and subregions for allocating memory.
- Words starting with "__" work on dynamic arrays.
- The corresponding words starting with "_" work on normal arrays.
- Words defined with xtpair can be used for both normal and dynamic arrays.
--------------------------------------------------------------------------- }

package dynarrays

[UNDEFINED] private? [IF] : private? private ;  ( cr s" PRIVATE? DEFINED" type ) [THEN]

\
\ Dynamic array structure
\

public

%array ~> %dynarray
   var autoresizeby#
   var subarrayitems#
   var subarrays#
   var subarrays
   var subarrays-region
   var region^
endp

: print-arraystructure  ( array -- )
   with cr
   ." #ITEMS: " #ITEMS ? cr
   ." MAXITEMS: " MAXITEMS ? cr
   ." ITEMSIZE: " ITEMSIZE ? cr
   ." 'item: " 'item ? cr
   ." stack?: " stack? ? cr
   ." (items): " (items) ? cr
   ." cols: " cols ? cr
   ." rows: " rows ? cr
   ." resizeable: " resizeable ? cr
;

: print-subarrays  ( dynarray -- )
   with
   ." subarrays: "
   subarrays# @ dup 1 > if
      subarrays @ swap cell * bounds do I ? cell +loop
   else
      1 = if subarrays @ ? then
   then
   cr
;

: print-dynstructure  ( dynarray -- )
   with cr
   ." #ITEMS: " #ITEMS ? cr
   ." MAXITEMS: " MAXITEMS ? cr
   ." ITEMSIZE: " ITEMSIZE ? cr
   ." 'item: " 'item ? cr
   ." stack?: " stack? ? cr
   ." (items): " (items) ? cr
   ." cols: " cols ? cr
   ." rows: " rows ? cr
   ." resizeable: " resizeable ? cr
   ." autoresizeby#: " autoresizeby# ? cr
   ." subarrayitems#: " subarrayitems# ? cr
   ." subarrays#: " subarrays# ? cr
   ." subarrays: " subarrays ? cr
   ." subarrays-region: " subarrays-region ? cr
   ." REGION^: " region^ ?
   region^ @ if
     region^ print-region
     region^ .lastsr @ print-subregions
     cr ." ---"
     cr ." available: " region^ @ available .
     cr ." reserved: " region^ @ reserved .
     cr ." ---"
     ." SUBARRAYS-REGION: " subarrays-region ?
     subarrays-region @ print-region
     subarrays-region .lastsr @ print-subregions     
     cr ." ---"
     cr s@ print-subarrays
   then
;

: /dynarray  ( -- size ) %dynarray sizeof ;

\
\ SUBARRAYS
\

{ ---------------------------------------------------------------------------
Create an array of subarrays at initialization, and when resizing.
--------------------------------------------------------------------------- }

private?

: (@subarray^)  ( subregion n | 0 -- .. n )
   over if
      1+ >r 
      dup .addr @  \ subregion ( = subarray )
      swap .regprev @ dup if r> recurse else drop r> then
   else nip then  \ .. subregion n
;

: @subarrays  ( region -- .. n )
   .lastsr @ 0 (@subarray^)
;

: subarrays-reserve  ( .. n subarrays-region -- n addr )
   over cell * reserve
   2dup 2>r  swap cell *  bounds do i ! cell +loop 2r>
;

public

: set-subarrays  ( dynarray -- )
   with
   subarrays-region @ ?dup if reclaim else here region, subarrays-region ! then
   region^ @ @subarrays  subarrays-region @ subarrays-reserve
   subarrays !
   subarrays# !
;

\
\ CLEANUP
\

: __VACATE  ( dynarray -- )
   with
   subarrays-region @ reclaim
   region^ @ reclaim
   #items off
   maxitems off
   itemsize off
   region^ off
   subarrayitems# off
   subarrays# off
   subarrays off
;
 
\
\ INITIALIZATION
\

{ ---------------------------------------------------------------------------
The main difference between the stack and the array is, that the array
  is always full, and the stack isn't. In an array #items = maxitems.
  In a stack #items <= maxitems.
  
When push is used on a dynamic stack, when the stack would normally overflow, 
  the stack grows by autoresizeby# bytes, maxitems is incremented by the 
  number of cells, that fit into autoresizeby# bytes, and #items is 
  incremented by one.

When push is used on a dynamic array, the array grows by autoresizeby# bytes,  
  #items is incremented by the number of cells, that fit into autoresizeby#
  bytes, and maxitems is set to the value of #items.
--------------------------------------------------------------------------- }

private?

: __*stack  ( max-items itemsize -- )
   2dup itemsize ! maxitems !
   itemsize @ 5 min 1 - cells []'s + @
   'item !
   stack? on
   here (items) !
   2drop  \ * /allot
;

: __(stack)  ( max-items  itemsize -- )
   here with /dynarray /allot  __*stack
;

: (dynarray-add-subarray)  ( region autoresizeby# -- )
   reserve drop
;

public

: dynarray-add-subarray  ( array -- )
  with
  region^ @  autoresizeby# @ (dynarray-add-subarray)
  s@ set-subarrays
  subarrayitems# @  dup maxitems +!
  stack? @ if drop else #items +! then
;

private?

: (reserve-subarrays)  ( array region autoresizeby# size -- )  \ recursive
   locals| size autoresizeby# region arr |
   size 0> if
     region autoresizeby# (dynarray-add-subarray)
     size autoresizeby# -  dup 0> if
        arr region autoresizeby# 3 roll recurse
     else drop then
   then
;

: reserve-subarrays  ( array region -- )
   over with
   0 subarrays# !
   autoresizeby# @  itemsize @
   2dup < abort" reserve-subarrays error: autoresizeby# < itemsize"
   2dup / subarrayitems# !
   maxitems @ *
   (reserve-subarrays)
   s@ set-subarrays
;

public

: dynarray-resize  ( array new#items -- )
   dup 0< abort" dynarray-resize error: Trying to resize to a negative size."
   dup 0= if drop __VACATE exit then
   swap with
   dup>r #items @ - dup 0> if                         \ difference  R: new#items
     subarrayitems# @  dup>r + r>  /                  \ new-subarrays#  R: new#items
     dup 0 do  s@ dynarray-add-subarray  loop
   else                                               \ difference  R: new#items
     dup 0= if r>drop drop exit then
     #items @ + subarrayitems# @   dup>r + r@  /      \ new-subarrays#  R: new#items subarrayitems#
     region^ @  over r> * itemsize @ * .s trim
   then                                               \ new-subarrays#  R: new#items
   subarrays# !
   r@ #items !
   r> maxitems !
   s@ set-subarrays
;

: DYNSTACK,  ( max-items -- )
   dup 1 < abort" DYNSTACK, error: Attempt to create a stack with no space in it."
   here with
   cell __(stack)
   cell resizeable !
   /segment autoresizeby# !
;

: INIT-DYNSTACK  ( max-items array )
   dup -rot with
   cell __*stack
   here region,  dup region^ !
   reserve-subarrays
;

: DYNARRAY,  ( #items item-size -- )
   over 1 < abort" DYNARRAY, error: Attempt to create an array with no items."
   here with
   over swap __(stack) #items !
   stack? off
   cell resizeable !
   /segment autoresizeby# !
;

: INIT-DYNARRAY  ( array -- )
   dup with
   here region,  dup region^ !
   reserve-subarrays
;

\
\ ADDRESSING
\

{ ---------------------------------------------------------------------------
Getting the address of an item in the dynamic array or stack.
--------------------------------------------------------------------------- }

private?

create pushing 0 ,

public

: stack-full?  ( stack -- flag ) 
   dup .#items @ swap .maxitems @ =
;

\ Range check.
\ Also looks if a new subarray is needed:
\ -  for a  stack in case of an overflow.
\ -  for an array always.
: valid-index  ( index array/stack -- flag )
   locals| arr index |
   index 0< if false exit then
   index arr .#items @ < if true exit then
   pushing @ not if false exit then
   arr .stack? @ if index arr .maxitems @ = else true then 
      if arr dynarray-add-subarray then
   true
;

private?

\ Get addres without range check.
\ Does not grow the stack!
: (dynaddress)  ( index array/stack -- addr )
   locals| arr index |
   index arr .subarrayitems# @ /mod  \ index-in-subarray index-in-subarrays
   cell *  arr .subarrays @  + @    \ index-in-subarray subarray-addr
   swap  arr .itemsize @ *  +
;

public

\ Get addres with range check.
: __[]  ( index array/stack -- addr )
   2dup valid-index not if cr ." index: " swap .  cr ." array:" . cr  true abort" __[] error" then
   (dynaddress)
;

\
\ ITERATION
\

{ -------------------------------------------------------------------------------
Words that iterate over an array, executing an execution token on each iteration. 

- EACH and <EACH give the execution token the item address to work with.
- those and <those give the execution token the item contents to work with.
------------------------------------------------------------------------------- }

private?

: subeach  ( XT array subarray subitems -- ) ( ... addr -- ... ) \ iterate forwards on subarray
   0 locals| itemsize subitems subarray  |
   arr >r   to arr
   arr .itemsize @ to itemsize
   subarray subitems itemsize * BOUNDS DO
      i over >r swap EXECUTE r>
   itemsize +LOOP
   DROP
   r> to arr ;

: <subeach  ( XT array subarray subitems -- ) ( ... addr -- ... ) \ iterate backwards on subarray
   0 locals| -itemsize subitems subarray  |
   arr >r   to arr
   arr .itemsize @ negate to -itemsize
   subarray subitems 1- -itemsize negate * BOUNDS swap DO
      i over >r swap EXECUTE r>
   -itemsize +LOOP
   DROP
   r> to arr ;

public

: __EACH  ( XT array -- ) ( ... addr -- ... ) \ iterate forwards on array or stack
   dup .#items @ 0= if 2drop EXIT then
   s@ >r
   arr >r   to arr
   arr .#items @
   arr .subarrayitems# @
   arr .subarrays @ arr .subarrays# @ cell * BOUNDS DO  \ XT items subarrayitems
      third ( XT ) arr i @ 4 pick 4 pick ( items subarrayitems ) min  subeach  \ XT items subarrayitems
      dup>r - r>
      over ( items ) 0 <= if leave then
   cell +LOOP 3drop
   r> to arr
   r> s! ;

: __<EACH  ( XT array -- ) ( ... addr -- ... ) \ iterate backwards on array or stack
   dup .#items @ 0= if 2drop EXIT then
   s@ >r
   arr >r   to arr
   arr .#items @ \ to items
   dup ( items ) arr .subarrayitems# @ dup>r mod \ to subarrayitems
   dup ( subarrayitems ) 0= if drop r> ( arr .subarrayitems# @ to subarrayitems ) else r>drop then
   arr .subarrays @ arr .subarrays# @ 1- cell * BOUNDS swap DO  \ XT items subarrayitems
      third ( XT ) arr i @  4 pick 4 pick ( items subarrayitems ) min  <subeach  \ XT items subarrayitems
      -  arr .subarrayitems# @
      over ( items ) 0 <= if leave then
   cell negate +LOOP 3drop
   r> to arr
   r> s! ;

: __those  ( xt stack -- ) ( ... contents -- ... ) \ iterate forwards on array or stack
   xt >r swap to xt
   [[ @ xt execute ]] swap __each
   r> to xt ; 

: __<those  ( xt stack -- ) ( ... contents -- ... ) \ iterate backwards on array or stack
   xt >r swap to xt
   [[ @ xt execute ]] swap __<each
   r> to xt ;
   
\
\ STACK HANDLING
\

{ ---------------------------------------------------------------------------
Working with the dynamic stack.

__PUSH might cause the dynamic array to grow.
__POP does not change the size of the dynamic array.

If __PUSH is used on an array, the array must grow. 
--------------------------------------------------------------------------- }

\ Puts value on top of stack.
: __PUSH  ( value array -- )
   locals| arr |
   pushing on
   arr .#items @ arr __[] ! arr .#items ++
   pushing off ;

\ Pops value from stack.
: __POP  ( array -- value )
   locals| arr |
   arr .#items dup>r @ 1-
   dup 0< abort" __POP error: Trying to pop from empty stack."
   arr __[] @
   -1 r> +! ;

\ Gets top value from stack.
\ The stack is not changed.
: __TOP@  ( array -- value )
   locals| arr |
   arr .#items @ 1- arr __[] @ ;

\ Gets addr of first item on stack.
\ The stack is not changed.
: __FIRST[]  ( array -- addr ) 0 swap __[] ;

\ Gets addr of first item on stack.
\ The stack is not changed.
: __LAST[]   ( array -- addr ) dup length 1 - swap __[] ;

\
\ RANDOM
\

\ Returns random item address and the corresponding item index
: __rnditem  ( array -- item item# )
   dup length rnd dup >r swap __[] r> ;

: __rnd@  ( array -- value ) __rnditem drop @ ;
: __rnd[]  ( array -- addr ) __rnditem drop ;

\
\ ADJUSTING INDICES
\

\ A too big index is made to fit by using mod.
\ When incrementing the index, this has the effect of starting again at
\  the beginning of the array.
: __[]wrap  ( index array -- item )
   dup>r  .#items @ mod
   r> __[] ;

\ A negative index becomes 0.
\ A too big index becomes the highest allowed index.
: __[]clamp  ( index array -- item )
   dup>r  0 swap .#items @ 1 - clamp
   r> __[] ;

\
\ TEMPORARILY COPY TO AND FROM MEMORY
\

{ ---------------------------------------------------------------------------
dynarray>memory copies to a normal array in temporary memory.
memory>dynarray copies back to the original dynamic array.

They are used in the sort and shuffle words to get good performance.
--------------------------------------------------------------------------- }

\ Copies dynarray to normal array in memory.
: dynarray>memory  ( dynarray -- allocated-array )
   %array sizeof
   over with
   #items @ itemsize @  2dup *  fourth +
   allocate abort" dynarray>memory allocate error"
   subarrayitems# @
   subarrays @
   locals| subarray^ subitems memory itemsize items %arraysize dynarray |
   memory  ( allocated-array )
   dynarray memory %arraysize cmove
   %arraysize +to memory
   memory over .(items) !  \ Fix (items)
   begin
     items 
   while
     subarray^ @  memory  items subitems min itemsize *  dup +to memory cmove
     cell +to subarray^
     items subitems - 0 max to items
   repeat
   dup .resizeable off  \ Make allocated-array non-resizable.
;

\ Copies data from array in memory to dynarray.
\ Frees memory afterwards.
: memory>dynarray  ( allocated-array dynarray -- )
   %array sizeof
   over with
   #items @ itemsize @  
   subarrayitems# @
   subarrays @
   locals| subarray^ subitems itemsize items %arraysize dynarray memory |
   memory  ( allocated-array )
   %arraysize +to memory
   begin
     items
   while
     memory  subarray^ @  items subitems min  itemsize * dup +to memory cmove
     cell +to subarray^
     items subitems - 0 max to items
   repeat
   free abort" memory>dynarray free error"
;

\
\ SORT & SHUFFLE
\

public

\ Does a sort on the dynarray.
\ An ascending sort can use > as xt.
\ A descending sort can use < as xt.
: __sort  ( xt dynarray -- ) ( item1 item2 -- flag )
   dup dynarray>memory
   locals| arr dynarray xt |
   xt arr _sort
   arr dynarray memory>dynarray
;

: __shuffle  ( dynarray -- )
   dup dynarray>memory
   locals| arr dynarray |
   arr _shuffle
   arr dynarray memory>dynarray
;

\
\ XT - PAIRS
\

{ --------------------------------------------------------------------------------
xtpair - Selects the right word to execute for either a normal or a dynamic array. 

The words created with xtpair expect an array on top of the stack.
They expect a table of two xt's after them. 
They get the offset at .resizabe to select the right word.
-------------------------------------------------------------------------------- }

\ Usage: xtpair name  ' xt1 , ' xt2 ,
: xtpair  ( -- <name> )  create does> over .resizeable @ + @execute ;

xtpair []  ' _[] , ' __[] ,
xtpair PUSH  ' _PUSH , ' __PUSH ,
xtpair POP  ' _POP , ' __POP ,
xtpair TOP@  ' _TOP@ , ' __TOP@ ,
xtpair FIRST[]  ' _FIRST[] , ' __FIRST[] ,
xtpair LAST[]  ' _LAST[] , ' __LAST[] ,

xtpair EACH  ' _EACH , ' __EACH ,
xtpair <EACH  ' _<EACH , ' __<EACH ,
xtpair those  ' _those , ' __those ,
xtpair <those  ' _<those , ' __<those ,

xtpair sort  ' _sort , ' __sort ,
xtpair shuffle  ' _shuffle , ' __shuffle ,

xtpair rnditem  ' _rnditem , ' __rnditem ,
xtpair rnd@  ' _rnd@ , ' __rnd@ ,
xtpair rnd[]  ' _rnd[] , ' __rnd[] ,

xtpair []wrap  ' _[]wrap , ' __[]wrap ,
xtpair []clamp  ' _[]clamp , ' __[]clamp ,

xtpair VACATE  ' _VACATE , ' __VACATE ,

aka []wrap wrap[]
aka []clamp clamp[]

end-package
