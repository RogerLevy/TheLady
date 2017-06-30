absent static ?fload static


: boundaries  0 0 level> if roomw else vres then 2@ 2p ;
: ground      level> if roomh @ else vh then 1p ;

: lady-room-switch
   \ clear various engine arrays
   doors vacate
   bgchildren vacate
   fgchildren vacate
   clear-sounds clear-blood
   \ set bounds for player
   boundaries bounds 4!
   \ set default camera offset
   vres @ 1p -0.5 p* camofs !
   \ position the player and play default animation (calm, idle)
   startpos 2@ player >pos 2!
   calm player emote
   static
;

' lady-room-switch is onroomswitch


: room-step   level> -exit rooment { step timer ++ lifetime ++ } ;
: level-step   ; \ level> -exit levelent { step timer ++ lifetime ++ } ;

\ in principle this is how reloading the current level should work.
: reload-level-restart
   level> -exit   levelpath count $reload   level @ loadlevel ;

: reload-level
   level> -exit   location reload-level-restart goto ;

aka start: construct:
