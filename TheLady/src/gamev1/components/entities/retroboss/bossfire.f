sample *laser4* data\retroboss\sfx\shooting 4.ogg


%arcadefire ~> %bossfire
   C_HARMFUL C_WEAK or cflags !
   \ var hitty
   : ?playerhit   ; \ player >invuln @ ?exit  me player colliding? if me delete then ;
   start:
      once *laser4* 0.667 sndvol!
      10.0 vy ! idle
      post ?playerhit screencull ;
endp

%bossfire ~> %spinnyfire
   0.66 uscale!
   : ?bounce
      x @ 0 < x @ vw 1p > or if vx @ negate vx ! vx @ x +! then
      y @ 0 < if vy @ negate vy ! vy @ y +! then ;
      
   :: idle 360.0 rnd angle ! 0 perform -20.0 angle +!
      post ?bounce ?playerhit screencull ;
endp
