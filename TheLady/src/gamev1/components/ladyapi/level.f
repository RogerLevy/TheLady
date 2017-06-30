absent static ?fload static

%level reopen
   noop: oncompletelevel
   : complete-level   oncompletelevel @ execute ;
endp
0 to roomdef   \ somehow the above assigned roomdef :/


: boundaries  0 0 level> if roomw else vres then 2@ 2p ;
: ground      level> if roomh @ else vh then 1p ;

: lady-room-switch
   1152.0 letterbox!
   /player
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
   calm player emote player { idle }
   stage:deletions 
   static
;

' lady-room-switch is onroomswitch

: reset-hp   player { lady-startinghp hp ! } ;

: player-emotion   player { me emote idle } ;

[[
   stage:deletions
   can-pause on
   /player
   reset-hp
]] is onlevelload


: room-step   level> -exit rooment { step timer ++ lifetime ++ } ;
: level-step   level> -exit ?pause levelent { step timer ++ lifetime ++ } ;

\ in principle this is how reloading the current level should work.
: reload-level-restart
   level> -exit   levelpath count $reload   level @ loadlevel ;

: reload-level
   level> -exit   location reload-level-restart goto ;

: baseprops
   savei: flip
   savep: angle
   savep: scalex
   savep: scaley
   savep: red
   savep: green
   savep: blue
   savep: alpha ;

: save-room
   [[ " ' loadprops , :props " $+ baseprops saveprops " ;" $+ ]] is objprops$+ save-stage ;