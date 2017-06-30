module ~vtable

0 value vt  \ current defining vtable (for ACTION not ::)

0
protected
   var current     \ points to a vtable structure
   var fetcher
exposed
   var rootvt
   var nextv
   var #methods
   0 field actions
constant /vtable

\ : 1nul 0 ;
\ : 2nul 0 dup ;
\ : 3nul 0 dup dup ;
\ : 4nul 0 dup dup dup ;
\ It might not be a bad idea to abort with an error message
\   since the caller could very well expect a pointer.
\ So that's what we'll do for now, see how it goes.
: 1nul abort" Parameter-returning action not implemented by vtable." ;
aka 1nul 2nul
aka 1nul 3nul
aka 1nul 4nul



create dse        \ default stack effects
   ' noop , ' noop ,
   ' 1nul , ' drop ,
   ' 2nul , ' 2drop ,
   ' 3nul , ' 3drop ,
   ' 4nul , ' 4drop ,


\ action struct:   offset , root-vtable , default-xt , current-vtable-fetcher ,

: io>dse   swap - 2* dup 0< if abs 1 + then cells dse + @ ;

: default-action-vtable-fetch ( action -- ofs current-vtable )
   2@ @ ;


: action>vt[]  dup 3 cells + @ execute + ;

4 cells constant /action

\ can be extended with more info in the dictionary.
: action   ( ins outs -- )   \ nextv starts at 5 (skipping the vtable properties)
   >in @ exists if drop 2drop exit then >in !
   create
      vt >nextv @ cells ,
      vt >rootvt @ ,
      io>dse ,


      \ NOTE: The next line is a potential issue. Because the fetcher is COPIED here, rather than indirectly referenced,
      \       we are dependant on SET-VTABLE-FETCHER being called before defining actions.
      \       1/9 for now, I can fix this by moving the vtable root definition in audio.f, but
      \           I think this is still a bugger
      vt >fetcher @ ,
      

      vt >nextv ++
      does>
         \ quit
         dup >r action>vt[] @ ?dup if
            r> drop execute
         else
            r> cell+ cell+ @ execute   \ if hasn't been defined (0) in current vtable, execute the action's default xt.
         then ;

\ uses vtable fetcher, not VT
: ::  ( <name> )
   ' >body :noname swap action>vt[] !
;

: >::  ' >body action>vt[] ! ;

: don't  ( <name> )
   ' >body 3@ -rot @ + !
;


: set-vtable-fetcher  ( xt vtable -- ) >current @ >fetcher ! ;

\ : default-actions     ['] default-action-vtable-fetch is-vtable-fetcher ;

: vbeget  ( vtable -- new-vtable )
   =>   here dup rootvt @ >current !
      0 , fetcher @ , rootvt @ , nextv @ , #methods @ ,
      actions here #methods @ cells dup allot move
;

: vtable,  ( #maxmethods -- )
   here dup to vt , ['] default-action-vtable-fetch , vt , 5 , dup , cells /allot
;
\ to set current vtable:  ( vtable root-vtable ) !
\ but if you don't know the root table you can say this:
: vcurrent!   ( vtable vtable -- ) >rootvt @ >current ! ;

\ : vtable   create , does> to vt ;

\ "current vtable" in each vtable is used in "normal" actions to "select" vtables at runtime.
\  it is not currently used as of 1/9/2014
