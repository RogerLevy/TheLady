fload soul

absent bloodjet ?fload bloodjet

70.0 constant soulspeed

sample *soulshoot*   data\lady\soul test 2.ogg
sample *soulshootup*   data\lady\soul test 1.ogg
sample *damage1*   data\lady\Damage 1.ogg
sample *damage2*   data\lady\Damage 2.ogg
sample *damage3*   data\lady\Damage 3.ogg

animdata lady.scml   data\lady\animdata\lady.scml
lady.scml animation lady_calm_idle Idle Eyes Calm

lady.scml animation lady_calm_idle_closed Idle Eyes Calm eyes closed
lady.scml animation lady_damage_closed Damage Eyes Closed
lady.scml animation lady_sad_walk_closed Sad walk eyes closed

lady.scml animation lady_panic_idle Boss Room Level 1 Panicy
lady.scml animation lady_panic_idle_blinking Boss Room Level 1 Panicy blinking
lady.scml animation lady_anxious_idle_1 Idle Anxious Subtle
lady.scml animation lady_anxious_idle_2 Idle Anxious Rapid
lady.scml animation lady_sad_walk Sad Walk
lady.scml animation lady_shoot_2 shot_right
lady.scml animation lady_shoot_up shooting up
lady.scml animation lady_calm_damage Damage Calm
lady.scml animation lady_extreme_damage Extreme Damage
lady.scml animation lady_extreme_damage_up Extreme Damage From Above
lady.scml animation lady_damage_heartbeat damage wide eyed heart beating
lady.scml animation lady_damage_headache Damage Eyes Closed
lady.scml animation lady_floor_twitching twitching on the floor

%actor begets %lady

var weapon1
var #souls

%lady script

0.85 uscale!
C_PLAYER cflags !

: fixed_sadwalk   flipfix on lady_sad_walk ;
: fixed_closedwalk   flipfix on lady_sad_walk_closed ;

\ XT's are used so we can do more complex things besides just change the animation!  like start "compound animations" (TODO)
\                      calm                     l1r1                       l1r2                       l1r3                          l1boss
emotion lady_idle      ' lady_calm_idle ,       ' lady_calm_idle_closed ,  ' lady_calm_idle ,         ' lady_anxious_idle_2 ,       ' lady_anxious_idle_1 ,
emotion lady_walk      ' fixed_sadwalk ,        ' fixed_closedwalk ,   ' fixed_sadwalk ,          ' lady_panic_idle ,           ' lady_panic_idle_blinking ,
emotion lady_shoot     ' lady_shoot_2 ,         ' lady_shoot_2 ,           ' lady_shoot_2 ,           ' lady_shoot_2 ,              ' lady_shoot_2 ,
emotion lady_damage    ' lady_calm_damage ,     ' lady_damage_closed ,     ' lady_calm_damage ,       ' lady_damage_heartbeat ,     ' lady_extreme_damage ,
emotion lady_damage_up ' lady_extreme_damage ,  ' lady_damage_closed ,     ' lady_extreme_damage ,    ' lady_extreme_damage ,       ' lady_extreme_damage_up ,


default-hitbox: -80.0 -725.0 scale* 160.0 725.0 scale* ;
calm feeling !
lady_idle
stays on


: ?resume
   <d> kstate if walkr r> drop exit then
   <a> kstate if walkl r> drop exit then
;


create damage-sounds   3 cell array> ' *damage1* , ' *damage2* , ' *damage3* ,

: *damage*   damage-sounds rnditem drop @ execute ;



: ?bloodforce   0 > if 16.0 else 9.0 then ;
: ?lbloodpoint  direction @ left = if -95.0 else -80.0 then -250.0 ;
: ?rbloodpoint  direction @ left = if 75.0 else 90.0 then -250.0 ;

:: hurt
   dup >r ?lbloodpoint at 180.0 r@ ?bloodforce bloodjet
          ?rbloodpoint at 0.0   r> ?bloodforce bloodjet

   drop \ -hp
   once *damage*   lady_damage   halt   120 invuln !
   0 perform   0.95 delay  ?resume   idle
;

dvar tempv

: ?vflip  over 0< 1 and flip ! ;

: ?weakshot
   shooter @ >feeling @ calm <>
   \ shooter @ >feeling @ l1r1:| <> and
   shooter @ >feeling @ l1r2:| <> and if
      vx 2@ 0.75 dup 2p* vx 2!
      me ( soul ) [[
         dup { -0.08 dup dup tint+! red @ } 0 <= if delete end exit then
      ]] parallel
   then
;

: shootlr
   lady_shoot
   ( prototype ) perform
   0.4 delay
   once *soulshoot*
   0.1 delay

   me atop   0 -600.0 scale* me from

   me swap ( prototype )  one {
      dup >tempv 2@ vx 2! shooter !
      ?weakshot
      [[ shooter @ >#souls -- ]] ondelete !
   }

   #souls ++
   0.175 delay
   ?shoot   ?resume   0.26667 after   idle ;

: shootup
   lady_shoot_up
   ( prototype ) perform
   0.10 delay
   once *soulshootup*
   me atop   0 -600.0 scale* me from
   me swap ( prototype )  one {
      dup >tempv 2@ vx 2! shooter !
      [[ shooter @ >#souls -- ]] ondelete !
   }
   #souls ++
   0.625 delay
   ?shoot   ?resume   0.26667 after   idle
;

:: shoot  ( prototype vx. vy. -- )
   ?vflip   tempv 2!   halt
   tempv >y @ 0= if shootlr exit then
   shootup
;

:: ?shoot
   weapon1 @ -exit  #souls @ 0= -exit
   <left> kpressed if  weapon1 @ soulspeed negate 0 shoot then
   <right> kpressed if  weapon1 @ soulspeed 0 shoot then
   <up> kpressed if  weapon1 @ 0 soulspeed 0.8 p* negate shoot then
;

: ?face   direction @ left = 1 and flip ! ;

:: walk
   lady_walk ?face
   direction @ left = if
      -5.5 vx !
      0 perform
      <a> kreleased if idle exit then
      <d> kstate if walkr exit then
   else
      5.5 vx !
      0 perform
      <d> kreleased if idle exit then
      <a> kstate if walkl exit then
   then
   ?shoot
;

:: idle
   lady_idle  halt  ?face
   0 perform
   <a> kstate if walkl exit then
   <d> kstate if walkr exit then
   <up> kpressed <w> kpressed or if ?door ?dup if use-door then then
   ?shoot
;

: lbound   bounds >x1 @ 130.0 + ;
: rbound   bounds >x2 @ 130.0 - ;
: limit-x  x @ lbound rbound clamp x ! ;

: blowback
   -30.0 vx !  0 perform  0.4 delay idle ;

: you:blowback
   ( enemy repels you backward ) you be> blowback
   \ [[ dup { -30.0 vx ! } 0.6 after { idle } end ]] parallel
;

: you:gethurt
   ( you are hurt by enemy! ) atk @ you { hurt }
;

: lady:hurtyou
   ( enemy is hurt by you! ) C_WEAK cflags? if you >atk @ hurt then
;

: lady:collisions
   me to you
   \ for now, both harmful and illusion objects do fake damage
   [[ [ C_HARMFUL C_ILLUSION or ]# cflags? if
      you colliding? if
         you:gethurt
         lady:hurtyou
         [ C_REPEL ]# cflags? if
            you:blowback
         then
      then

   then ]] all ;

: lady:start
   idle
   post
      invuln @ 0< if lady:collisions then   invuln --
      limit-x ;

start:
   lady:start ;

endp
