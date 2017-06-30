\ 12/29/13
\ Not used!!!

\ -----------------------------------------------------------------------------
\ Convenient dynamic parallel scripts
\   Cleared on room load
\   If the system runs out of slots, throws a warning

\  [ ] entity delete script cleanup - deferring this
\  [ ] room script cleanup

0 value script

max-entities 2 * constant max-scripts 
create scripts   max-scripts /entslot array,
create freescripts   max-scripts stack,   [[ freescripts push ]] scripts each

: script:delete   script freescripts push ;
: script:instance freescripts dup length 0= abort" Script pool exhausted." pop ;

%actor ~> %script
   be-prototype
   ' script:delete (delete) !
   ' script:instance (instance) !
   
endp

: scripts-sim
   me [[ be ?step ]] scripts each 
      [[ be ?post ]] scripts each be ;

: clear-scripts   me [[ dup >en @ if dup delete then drop ]] scripts each be ;
