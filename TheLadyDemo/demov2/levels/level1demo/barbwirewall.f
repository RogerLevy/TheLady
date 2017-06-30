absent %barbwire ?fload barbwire

%barbwire begets %barbwirewall

%barbwirewall script

0 atk !
C_ILLUSION C_WEAK or C_SHOOTABLE or cflags !

sample *damage2*   data\lady\Damage 2.ogg

\ megakludge to stop the sound early ... change when ability to set sound length is added
: stopsoon
   perform 0.15 delay stopsound nod ;

: comedown
   90.0 vy !
   post   y @ ground >= if ground y ! vy off once *damage1* 0.3 sndspd! 1.5 sndvol! snd stopsoon post noop exit then ;

:: die
   slowfade
;

:: hurt
   drop
   you >cflags @ C_PLAYER = if
      die
   else
      \ assume projectile ... make bounce
      you >vx @ negate you >vx !
      C_HARMFUL you >cflags or!
   then
;

start:
   -200.0 y !
   0 perform
   y @ -200.0 = if
      player >x 2@ x @ ground 470.0 proximal? if
         comedown
      then
   else
      y @ ground = if
         outofsight? if -200.0 y ! then
      then
   then
   ;

endp
