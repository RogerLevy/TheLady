image blackhead.image data/retroboss/heads/l5boss64.png

\ ideas
\  you have to hit the eyes

%actor ~> %othereye
   55.0 -15.0 70.0 80.0 hitbox 4!
   C_SHOOTABLE C_HARMFUL or cflags !
   1 atk !
   
   :: hurt  owner @ { hurt } 120 invuln ! ;
   
   start:   0 perform owner @ ?dup -exit >x 2@ put ;

endp

create blackies 3 stack,

%retroboss ~> %blackboss
   15 hp !
   5 atk !
   blackhead.image bitmap!
   4.5 uscale!
   hitbox: -150.0 -15.0 70.0 80.0 ;

   :: die
      %blackboss numberof 1 = if sky delete then
      report" DEATH 4 ME"
      once *laser1* 0.5 sndspd!
      invuln on
      script1 @ delete 
      cflags off
      0 perform
      5 for
      r>
      1.0 alpha !
      5.0 uscale!
      SINE EASE-IN-OUT alpha 0 30 tween
      SINE EASE-IN-OUT scale >x 10.0 30 tween
      SINE EASE-IN-OUT scale >y 10.0 30 tween
      SINE EASE-IN-OUT angle 360.0 rnd 30 tween
      0.5 delay
      >r next
      end ;

   [i
   
   : fire
      me -120 120 from %bossfire one drop 
      0.1 [[ delay owner @ 80 120 from %bossfire one drop end ]] parallel
   ;
   
   
   [[ owner @ >r %othereye morph r> owner ! ]] mind !
 
   var cnt
   
   : /others   cnt -- cnt @ 0> ?exit [[ @ dup me = over >active @ 0= or if drop exit then me colliding? if -vx vx @ x +! 3 cnt ! then ]] blackies each ;
   
   : jitter   20.0 rnd 10.0 - x +! ;


   \ this is my little homage to the fight with ganon in zelda 1
   : ?flash
      invuln @ 0= if lifetime @ 1p psin 2 / 0.5 + alpha!
      else hp @ if 1.0 alpha ! then then
      ;

   : !bgspeed
      15 rnd negate 2 + 1p sky >vy !
   ;

   i]
      
   :: hurt
      once *bosshurt* 0.8 sndspd!
      halt -hp
      spd ++ !bgspeed 
      hp @ -exit
      127 invuln ! 0 perform
      jitter 0.5 after fire 1 pauses
      jitter 0.5 after fire 1 pauses
      jitter 0.5 after fire 1 pauses
      jitter 0.5 after fire 1 pauses
\      jitter 0.25 after fire 1 pauses
\      jitter 0.25 after fire 1 pauses
      90 lifetime !
      idle ;
   
   :: idle   ?leftright 10.0 forward 0 perform begin 5.0 10.0 between delay fire halt 0.5 delay 10.0 forward again ;

   start:
      ?sky   !bgspeed
      me to boss   idle   /mind
      post /walls ?flash /others 0.05 y +!
   ;

   variable v
   : blackboss
      bossbattle setup 512.0 250.0 at blackies vacate 3 for %blackboss one blackies push 512.0 0 +at next
      0 [[ %blackboss numberof
         dup 1 = if bgm to snd 0.3 sndspd! then 
         0= when
         whiteflash
            SINE EASE-IN-OUT v 0 180 tween
            0 [[ bgm snd! v @ sndvol!   180 lifetime @ = when end ]] parallel
         5 delay
         end complete ]] parallel ;
endp
