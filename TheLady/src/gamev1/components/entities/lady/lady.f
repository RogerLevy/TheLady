fload soul

absent bloodjet ?fload bloodjet

70.0 constant soulspeed

sample *soulshoot*   data\lady\soul test 2.ogg
sample *soulshootup*   data\lady\soul test 1.ogg
sample *damage1*   data\lady\Damage 1.ogg
sample *damage2*   data\lady\Damage 2.ogg
sample *damage3*   data\lady\Damage 3.ogg

animdata lady.scml   data\lady\animdata\lady.scml
animdata lady4.scml   data\lady\animdata\Lady Lvl 4.scml
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

lady.scml animation lady_l2_walk lvl 2 main walk

lady.scml animation lady_l3_walk lvl 3 walking
lady.scml animation lady_l3_idle lvl 3 idle
lady.scml animation lady_l3_damage lvl 3 damage
lady.scml animation lady_l3_shoot lvl 3 shooting


lady4.scml animation lady4_walking walking
: lady4_walking  lady4_walking flip off ;
lady4.scml animation lady4_idle idle
: lady4_idle     lady4_idle flip off ;
lady4.scml animation lady4_damage damage from blades
: lady4_damage   lady4_damage flip off ;

\ special level 4 animations:
lady4.scml animation lady4_walking2 walking looking backwards
: lady4_walking2  lady4_walking2 flip off ;
lady4.scml animation lady4_idle2 looking at boss
: lady4_idle2     lady4_idle2 flip off ;
lady4.scml animation lady4_suck being sucked in
: lady4_suck     lady4_suck flip off ;


%actor ~> %lady

   var weapon1
   [i
   var #souls
   var anmstate   
   i]

   0.85 uscale!
   C_PLAYER cflags !

   : fixed_sadwalk   flipfix on lady_sad_walk ;
   : fixed_closedwalk   flipfix on lady_sad_walk_closed ;

   0
   enum SHOT_NONE
   enum SHOT_WEAK
   enum SHOT_NORMAL
   drop

\ XT's are used so we can do more complex things besides just change the animation!  like start "compound animations" (TODO)
\                      calm                     l1r1                       l1r2                       l1r3                          l1boss                        l4                   l4boss               l4scared             l4suck             l5                           l2                         l3
emotion lady_idle      ' lady_calm_idle ,       ' lady_calm_idle_closed ,  ' lady_calm_idle ,         ' lady_anxious_idle_2 ,       ' lady_anxious_idle_1 ,       ' lady4_idle ,       ' lady4_idle2 ,      ' lady4_idle2 ,      ' lady4_suck ,     ' lady_anxious_idle_1 ,      ' lady_l2_walk ,           ' lady_l3_idle ,
emotion lady_walk      ' fixed_sadwalk ,        ' fixed_closedwalk ,       ' fixed_sadwalk ,          ' lady_panic_idle ,           ' lady_panic_idle_blinking ,  ' lady4_walking ,    ' lady4_walking2 ,   ' lady4_walking2 ,   ' lady4_suck ,     ' lady_panic_idle_blinking , ' lady_l2_walk ,           ' lady_l3_walk ,
emotion lady_shoot     ' lady_shoot_2 ,         ' lady_shoot_2 ,           ' lady_shoot_2 ,           ' lady_shoot_2 ,              ' lady_shoot_2 ,              ' lady_shoot_2 ,     ' lady_shoot_2 ,     ' lady_shoot_2 ,     ' lady_shoot_2 ,   ' lady_shoot_2 ,             ' lady_shoot_2 ,           ' lady_l3_shoot ,
emotion lady_damage    ' lady_calm_damage ,     ' lady_damage_closed ,     ' lady_calm_damage ,       ' lady_damage_heartbeat ,     ' lady_extreme_damage ,       ' lady4_damage ,     ' lady4_damage ,     ' lady4_damage ,     ' lady4_damage ,   ' lady_extreme_damage ,      ' lady_damage_heartbeat ,  ' lady_l3_damage ,
emotion lady_damage_up ' lady_extreme_damage ,  ' lady_damage_closed ,     ' lady_extreme_damage ,    ' lady_extreme_damage ,       ' lady_extreme_damage_up ,    ' lady4_damage ,     ' lady4_damage ,     ' lady4_damage ,     ' lady4_damage ,   ' lady_extreme_damage_up ,   ' lady_extreme_damage_up , ' lady_l3_damage ,
create walkspeeds cell [array  5.5 ,                    5.5 ,                      5.5 ,                      5.5 ,                         6.0 ,                         4.05 ,                3.0 ,                4.25 ,        0.05 ,           5.5 ,                        6.0 ,                      6.0 , array]
create shotlevels cell [array SHOT_NORMAL ,            SHOT_WEAK ,                SHOT_NORMAL ,              SHOT_WEAK ,                   SHOT_WEAK ,                 SHOT_NONE ,          SHOT_NONE ,          SHOT_WEAK ,     SHOT_NONE ,      SHOT_WEAK ,                    SHOT_NORMAL ,              SHOT_WEAK , array]

( create ladyanims 20 vtable,
[[ @ anmstate @ ]] ladyanims set-vtable-fetcher
0 0 action lady_idle
0 0 action lady_walk
0 0 action lady_shoot
0 0 action lady_damage
0 0 action lady_damage_up

: animstate   vbegets create , does> @ anmstate ! ;

ladyanims animstate lady:calm
' lady_calm_idle >:: lady_idle
)

   : lady-hitbox   -80.0 -725.0 scale* 160.0 725.0 scale* drop 9999.0 ;

   hitbox: lady-hitbox ;
   calm feeling !
    lady_idle
   stays on

   [i
   : ?resume
      <d> kstate if walkr r> drop exit then
      <a> kstate if walkl r> drop exit then ;

   create damage-sounds   cell [array ' *damage1* , ' *damage2* , ' *damage3* , array]
   
   : *damage*   damage-sounds rnditem drop @ execute ;
   
   : ?bloodforce   0 > if 16.0 else 9.0 then ;
   : ?lbloodpoint  direction @ left = if -95.0 else -80.0 then -250.0 ;
   : ?rbloodpoint  direction @ left = if 75.0 else 90.0 then -250.0 ;

   : spurt   ( force -- )
      \ drop exit
      
      >r ?lbloodpoint at 180.0 r@ ?bloodforce bloodjet
         ?rbloodpoint at 0.0   r> ?bloodforce bloodjet ;
      
   :: hurt
      120 invuln !
      invincibility @ 0 = if dup -hp then
      spurt 
      once *damage*   lady_damage   halt
      hp @ 0 <= ?exit
      0 perform   0.95 delay  ?resume   idle ;
   
   var abouttodie
   
   : (death)    [[ death   level @ loadlevel ]] btw   ;
  
   : dienow   abouttodie off lives -- lives @ -1 > if (death) else ['] gameover btw then nod ;
   
   :: die   abouttodie @ ?exit abouttodie on -post 0 perform 1 delay dienow ;
   
   dvar tempv
   
   : ?flip  over 0< 1 and flip ! ;
   
   \ implements the weak shot
   : ?fadeshot
      shooter @ >feeling @  shotlevels [] @ SHOT_WEAK = if
         vx 2@ 0.75 dup 2p* vx 2!
         me ( soul ) [[
            dup { -0.08 dup dup tint+! red @ } 0 <= if delete end exit then
         ]] parallel
      then
   ;
   
   : ?shoty   0 -600.0 feeling @ l3:| = if negate then ;
   
   : shootlr
      lady_shoot  ( prototype ) perform
      0.4 delay  once *soulshoot*
      0.1 delay
      #souls ++   me atop   me ?shoty scale* from
      me swap ( prototype )  one {
         dup >tempv 2@ vx 2! shooter !
         ?fadeshot
         [[ shooter @ >#souls -- ]] ondelete !
      }
      0.175 delay ?shoot ?resume 0.26667 after idle ;
   
   : shootup
      lady_shoot_up
      ( prototype ) perform
      0.10 delay
      once *soulshootup*
      me atop   me 0 -600.0 scale* from
      me swap ( prototype )  one {
         dup >tempv 2@ vx 2! shooter !
         [[ shooter @ >#souls -- ]] ondelete !
      }
      #souls ++
      0.625 delay
      ?shoot   ?resume   0.26667 after   idle
   ;
   
   :: shoot  ( prototype vx. vy. -- )
      ?flip   tempv 2!   halt
      tempv >y @ 0= if shootlr exit then
      level @ 3 <> if shootup then
   ;
         
   : ?walkspeed   feeling @ walkspeeds [] @ ;
   
   :: walk
      ?face lady_walk 
      direction @ left = if
         ?walkspeed negate vx !
         0 perform
         <a> kreleased if idle exit then
         <d> kpressed if walkr exit then
      else
         ?walkspeed vx !
         0 perform
         <d> kreleased if idle exit then
         <a> kpressed if walkl exit then
      then
      ?shoot
   ;
   
   : walklr   <a> kpressed if walkl exit then <d> kpressed if walkr exit then ;
   : ?use     <w> kpressed if ?door ?dup if use-door then then ;
   
   :: idle   ?face lady_idle halt 0 perform walklr ?use ?shoot ;
   
   : lbound   bounds >x1 @ 130.0 + ;
   : rbound   bounds >x2 @ 130.0 - ;
   : limitx   x @ lbound rbound clamp x ! ;
   : blowback   -30.0 vx !  0 perform  0.4 delay idle ;
   : gethurt  ( you are hurt by enemy! ) atk @ you { hurt } ;
   : ?hurtyou ( enemy is hurt by you! ) C_WEAK cflags? if you >atk @ hurt then ;
   : ?blowback   C_REPEL cflags? if you { blowback } then ;
   : ?harmcheck
      C_HARMFUL C_ILLUSION or [[
         you >invuln @ ?exit
         gethurt ?hurtyou ?blowback
      ]] collides          exit

   
      me to you
      [[
         you >invuln @ ?exit
         [ C_HARMFUL C_ILLUSION or ]# cflags? if
         me you colliding? if gethurt ?hurtyou ?blowback then
      then ]] all ;
      
      
   : ?hurt   invuln @ 0= if ?harmcheck then ;
   : init   report" souls off" #souls off ;
   i]
   \ order
   start:  init idle post ?hurt limitx ;

   : bladewall-hurt ( bladewall -- )
      lady4_damage 1 spurt
      cr ." OUCH!"
      me over attach >atk @ -exit 4 timebomb
      cflags off nod post limitx ;

   : hitbox!
      dup 0< if swap >r dup >r + r> abs r> swap then hitbox 4! ;

   : be-upside-down
      dspt =>
      scale >y @ dup 0> if negate then scale >y ! 
      lady-hitbox hitbox!
   ;
   
   : be-rightside-up
      dspt =>
      scale >y @ dup 0< if negate then scale >y ! 
      lady-hitbox hitbox!
   ;

   :: ?shoot 
      weapon1 @ -exit  #souls @ ?exit   feeling @ shotlevels [] @ SHOT_NONE = ?exit
      <left> kpressed if  weapon1 @ soulspeed negate 0 shoot then
      <right> kpressed if  weapon1 @ soulspeed 0 shoot then
      <up> kpressed if  weapon1 @ 0 soulspeed -0.8 p* shoot then
   ;

endp



