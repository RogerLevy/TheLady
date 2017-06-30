C_SHOOTABLE C_REPEL or C_HARMFUL or value bighead-cflags

absent "glassfalling" ?fload glassfalling

%actor ~> %harmfulzone
   C_HARMFUL C_REPEL or cflags !
   vis off
   0 atk !
   hitbox: -250.0 -250.0 500.0 500.0 ;
endp

%boss ~> %bigheadboss

   var bgm

   bighead-cflags cflags !
   bighead_idle
   hitbox: -150.0 -150.0 300.0 300.0 ;
   
   : ?*glass*  once 2 rnd if *glass1* else *glass2* then ;
   
   :: die
      glassfalling off
      bgm @ snd! 1.3 sndvol! 0.5 sndspd!
      whiteflash
   
      0 perform
   
      5 delay
      
      bgm @ stopsound
      owner @ ?dup if { removered end } then
   
      \ player appears laying on the floor
      calm player emote
      player { right direction ! 0 flip ! cam @ 300.0 + x ! lady_floor_twitching halt }
   
      \ FOR DEMO: no player control, fade out and return to title
   
      player { nod }
      clear-blood
      end
      8 [[ delay end complete-level ]] parallel
   ;
   
   : harmmotion   -18.5 vx ! 0 perform 0.45 delay halt 0.6 delay end ;
   
   : hairwhip   bighead_attack me 0 0 from %harmfulzone one perform { harmmotion } 3.0 delay idle ;
   
   : faster      10 hp @ - 0.2 * 1.0 + animspeed! ;
   
   :: idle      bighead_idle faster 0 perform  3.0 4.0 between delay   hairwhip ;
   
   : rainglass   ?*glass*  15 hp @ - 1 max shards ;
      
   :: hurt
      negate hp +! cflags off 
      redflash once *bigheadimpact* 0.89 sndvol!  bighead_gethit faster
      0 perform
      0.04 delay  rainglass
      hp @ 5 <= if bgm @ snd! 1.2 sndvol! 1.02 sndspd! then
      hp @ 0 = if die exit then
      3.0 delay   bighead-cflags cflags !  hairwhip
   ;
   
   start:
      10 hp !
      looping *bigheadbgm* snd bgm ! 1.1 sndvol!
      3 glassfalling !  1.25 glassfreq !
      hairwhip
   ;

endp
