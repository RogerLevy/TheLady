animdata scissors.scml data\scissors\animdata\scissors redo.scml
scissors.scml animation scissors_idle1 idle one
scissors.scml animation scissors_idle2 idle two
scissors.scml animation scissors_idle3 idle three
scissors.scml animation scissors_upright upright   
scissors.scml animation scissors_downward1 downward
scissors.scml animation scissors_downward2 downward violent
\ scissors.scml animation scissors_walk1 walking upright calm
\ scissors.scml animation scissors_walk2 walk fast
\ scissors.scml animation scissors_attack1 fast attack
\ scissors.scml animation scissors_attack2 stabbing
\ scissors.scml animation scissors_attack3 sideways chop

absent %l1door ?fload l1door

%actor ~> %scissors
   scissors_idle1
   editable on
   hitbox: -125.0 -125.0 250.0 250.0 ;
   C_HARMFUL C_SHOOTABLE or cflags !
   0.44 uscale!
   [i
   variable SSHOT
   -1 var: doornum
   ' noop var: dest
   1.0 var: atkfreq
   true var: canshoot
   var twitchscript
   : reveal
      twitchscript @ ?dup if delete twitchscript off then 
      2.0 animspeed!
      0 perform 1.5 + dup angle !
      dup 60.0 >= when 3.5 + dup angle !
      dup 135.0 >= when scissors_downward1 0 angle ! 0.5 animspeed!
      C_HARMFUL cflags ! 
      dest @ ['] noop <> if
         1.2 delay
         8.0 vy !
         2.5 animspeed!
         x @ 1152.0 at dest @ %l1door one { ondoor !
         -100 priority ! 0 0 dspt >scale 2! me } y @ act
            ( door y )
            y @ over - 781.0 p/ dup >r third >dspt >scale >x !   \ make that door "grow" as the scissors goes down
               r> 0.75 p* third >dspt >scale >y !
            y @ third >y ! 
      else
         0.35 delay 10.0 vy !
         act
      then
      y @ vh 1p >= when SSHOT ++
      \ kludgy
      cflags off me disable
      ; \ end ;
   :: hurt   drop canshoot @ -exit canshoot off reveal ;
   :: saveprops   savext: dest  savei: doornum  savep: atkfreq  savei: atk ;

   var origy
   : riseup 0 -6.0 vel 2! 0 perform y @ origy @ <= when origy @ y ! idle ;   
   : dropdown  canshoot off 0 6.0 vel 2! 0 perform y @ vh 100 - 1p >= when riseup ;   
   :: idle  canshoot on halt 0 perform 6 15 between s>p atkfreq @ p/ delay dropdown ;
   
   : twitch  0 [[ me owner @ >twitchscript ! begin 2 50 between pauses 360.0 rnd owner @ >dspt >rotation >z ! again ]] parallel ;
   
   start: y @ origy ! 1.0 rnd animpos! idle twitch ;
   ondelete:   twitchscript @ ?dup if delete then ;
   i]


   \ Shoot scissors one-by-one as they appear
   [i
   create s 10 stack,
   i]
   
   variable ordered-scissors-puzzle-retries
   : n/nw   ordered-scissors-puzzle-retries @ 1 < if north else nw then ordered-scissors-puzzle-retries ++ ;
   
   : ordered-scissors-puzzle
      \ sort in reverse order (note lack of 2nd SWAP) so that the topmost has doornum = #0
      s vacate
      %scissors allof s pushes [[ >doornum @ swap >doornum @ < ]] s sort [[ @ dup >doornum ? disable ]] s each
      0 SSHOT ! 
      0 [[
      begin s length while
         sshot @ 
         3 delay s pop dup enable dup >x 2@ third { 0 -1000 +put } 5.0 sendto
         \ can't attach any kind of event listener for "was shot" yet so... we're goin to use an internal counter SSHOT
         act dup sshot @ <> when
         drop
      repeat ]] parallel ;


endp