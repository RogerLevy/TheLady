\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ Vector tables [2]
\ ========================= copyright 2014 Roger Levy ==========================

\ for version 3:
\  [ ] use an external buffer to allow descendent vtables to add new actions freely (no need for max actions)

0 value vt  \ current defining vtable (for ACTION not ::)

pstruct %vtable
   var fetcher   ( action -- ofs vtable )
   var rootvt
   var nextv
   var #actions
   mark: actions

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
   
   \ fetcher: ( action -- offset vtable )
   
   : nextvofs>    vt .nextv @ cells    vt .nextv ++ ;
   : rootvt>      vt .rootvt @  ;   
   : default-action   swap - 2* dup 0< if abs 1 + then cells dse + @ ;
   
   : action>vt[]  dup  3 cells +  @ execute + ;
   
   : action   ( ins outs -- <name> )   \ nextv starts at 5 (skipping the vtable properties)
      >in @ exists if drop 2drop exit then >in !
      create
         nextvofs> , rootvt> , ( i o ) default-action , rootvt> .fetcher @ ,
      does> 
         dup >r action>vt[] @ ?dup if
            r> drop   execute
         else
            r> cell+ cell+ @ execute   \ if hasn't been defined (0) in current vtable, execute the action's default xt.
         then ;
   
   : actions: ( vtable -- ) to vt ;   
   : vcurrent[] ( action -- addr ) @ vt + ;
   : :: ( <name> ) & :noname swap vcurrent[] ! ;
   : >:: ( xt -- <name> ) & vcurrent[] ! ;
   : don't   [[ ]] >:: ;
   
   : vbeget  ( vtable -- new-vtable )
      with
      here dup to vt
         s@ %vtable sizeof copy,
         actions #actions @ cells copy, ;
   
   : vtable,  ( vtable-fetcher #maxmethods -- )
      here to vt  swap , vt , 0 .actions cell/ , dup , 0 , cells /allot ;

   : vtable   ( vtable-fetcher #maxmethods -- <name> ) create vtable, ;
   
   : action-type ( xt vtable -- ) .rootvt @ .fetcher ! ;

endp