image redhead.image data/retroboss/heads/l3boss64.png
sample *charge* data/retroboss/sfx/charge.ogg

%actor ~> %ponytail
   70.0 190.0 70.0 70.0 hitbox 4!
   C_SHOOTABLE C_HARMFUL or cflags !
   1 atk !
   :: hurt  owner @ { hurt } ;
   start:   0 perform owner @ ?dup -exit >x 2@ put ;

endp


\                                                                    20  19  18  17  16   15   14   13   12   11   10    9    8    7    6    5    4   3    2    1 
create red-speeds cell [array 2 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 , 18 ,  0 , 40 , 40 , 40 , 50 , array] 

%retroboss ~> %redboss
   cflags off
   red-speeds bgspeeds !
   30 hp !
   redhead.image bitmap!
   hitbox: redhead.image 1.0 scale @ p* center-bitmap-box 2 / ( 2swap 2 * 2swap )  ;
   
   :: die
      once *laser1* 0.5 sndspd!
      report" DEATH 4 ME"
      0 5.0 vel 2!
      invuln on cflags off -post
      script1 @ delete 
      0 perform
      5 for r>
         1.0 alpha !
         5.0 uscale!
         SINE EASE-IN-OUT alpha 0 30 tween
         SINE EASE-IN-OUT scale >x 10.0 30 tween
         SINE EASE-IN-OUT scale >y 10.0 30 tween
         SINE EASE-IN-OUT angle 360.0 rnd 30 tween
         0.5 delay
      >r next
      end complete ;
   
   
   [i
   var power

   [[ owner @ >r %ponytail morph r> owner ! ]] mind !

   :: special
      me 70 35 + 190 35 + from 45.0 8.0 2vec %spinnyfire one { negate vel 2! }
      me 70 35 + 190 35 + from 45.0 90.0 + 8.0 2vec %spinnyfire one { negate vel 2! }
      me 70 35 + 190 35 + from 45.0 8.0 2vec %spinnyfire one { vel 2! }
      me 70 35 + 190 35 + from 45.0 90.0 + 8.0 2vec %spinnyfire one { vel 2! }
      hp @ 11 < if
         me 70 35 + 190 35 + from 90.0 6.0 2vec %spinnyfire one { vel 2! }
         me 70 35 + 190 35 + from 270.0 6.0 2vec %spinnyfire one { vel 2! }      
      then
      ;

   : ?speed  hp @ 5 = if bgm to snd 0.3 sndspd! 5.0 else 10.0 30 hp @ - 1p + then ;

   :: walk
      ?speed forward 0 perform player >x @ x @ 30.0 - dup 60.0 + within if 2 rnd if -vx 0.5 delay idle then then ;
   
   :: idle
      0 perform 0.33 delay ?leftright walk ;

   : ?level   hp 20 < if 3 else 1 then ;

   var shaking
   var hits

   : ?special
      power ++ power @ ?level = if
         0 power ! special
         shaking @ not if halt 0.1 delay walk then
      then ;

   : charge
      hits ++
      hits @ 2 >= if exit then
      \ once *laser1* -1.0 sndspd! 40000 seek \ snd [[ dup snd! sndpos ]] parallel
      once *charge* 
      15 [[ pauses owner @ { ?special } end ]] parallel
      shaking on
      halt 0 perform -5 0 +put 8 for r> 10 0 +put 1 pauses hits off -10 0 +put 1 pauses >r next 5 +put
      shaking off
      walk ;
      
      \ shake
      \ halt 0 perform -5 0 +put 8 for r> 10 0 +put 1 pauses -10 0 +put 1 pauses >r next 5 +put 
      \ power ++ power @ ?level = if 0 power ! special 0.1 delay then walk ;

   : ?charge
      C_PLAYERPROJECTILE [[ me delete you { charge } ]] collides ;

   start:
      ?sky   !bgspeed
      me to boss   idle   /mind
      post /walls ?flash ?charge
   ;

   i]
   
   : redboss    bossbattle setup 1024.0 300.0 at %redboss one drop ;

endp