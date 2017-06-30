\ animations
animdata babyghost.scml data\babyghost\animdata\ghost.scml
babyghost.scml animation baby_calm_idle calm_idle
babyghost.scml animation baby_calm_moving calm_moving
babyghost.scml animation baby_agitated_idle agitated_idle
babyghost.scml animation baby_agitated_moving agitated_moving
babyghost.scml animation baby_death death

\ sounds
sample *babyimpact* data/babyghost/baby ghost death 1.ogg
sample *bigbabyimpact* data/babyghost/baby ghost death 2.ogg


\                   calm                     agitated
emotion baby_idle   ' baby_calm_idle ,       ' baby_agitated_idle ,
emotion baby_walk   ' baby_calm_moving ,     ' baby_agitated_moving ,


\ variable #babies

%actor begets %baby
%baby script

\ TODO: render ghosts as a layer (to a separate texture) to remove the eye-whites rectangle showing through
\ FX_SCREEN blendmode !

default-hitbox: -50.0 -4000.0 100.0 8000.0 ;

\ C_HARMFUL C_SHOOTABLE or cflags !
C_SHOOTABLE  cflags !

: ?babyspeed   feeling @ calm = if 1.5 else 2.0 then  direction @ left = if negate then ;
: ?babydelay   feeling @ calm = if 3.0 5.0 else 2.0 6.0 then between ;


:: die

   script1 @ delete
   cflags off   halt   baby_death
   once dspt >scale @ 1.0 < if *babyimpact* 1.1 sndspd! 0.8 animspeed! else *bigbabyimpact* 1.75 sndspd! 0.5 animspeed! then 0.9 sndvol!

   [[
      fdrop 0.99e \ return new animation position at end
      0 animspeed!   0 perform   2.0 delay
      1.0 vy !   5.0 delay
      \ #babies -- #babies @ 0= if calm player emote then
      end
   \ -0.0001 0 [[ end ]] fadeto \ not supported with spriter animations yet 1/16      
   ]] onanimloop!
   nod

;

:: hurt   drop die ;

:: walk
   baby_walk   ?babyspeed vx !   0 perform  ?babydelay delay idle
;

:: idle
   baby_idle   halt   0 perform  ?babydelay delay 2 rnd if walkl else walkr then
;

: agitate-script
   0 perform     owner @ >x 2@ player >x 2@ 650.0 proximal? if
      owner @ { agitated feeling ! idle } end then
;

create sizes   10 cell array> 0.15 , 0.16 , 0.17 , 0.18 , 0.19 , 0.19 , 0.2 , 0.23 , 0.33 , 1.0 ,

: lbound   bounds >x1 @ 130.0 + ;
: rbound   bounds >x2 @ 130.0 - ;
: limit-x  x @ lbound rbound clamp x ! ;

start:
\   #babies ++
   calm feeling !
   ground 50.0 + y !
   sizes rnditem drop @ uscale!
   %script oneslave dup script1 ! { agitate-script }
   idle
   post  limit-x
;
endp
