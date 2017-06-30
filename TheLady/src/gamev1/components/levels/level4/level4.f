

absent rain ?fload ame
absent %bladewall ?fload bladewall
absent %angel ?fload angel

image l4bg.image data\l4misc\l4bg.jpg
sample *l4bgm1*  data\l4misc\l4bgm1.ogg
\ sample *l4bgm2*  data\l4misc\l4bgm2.ogg
\ sample *l4bgm3*  data\l4misc\l4bgm3.ogg

\ sample *thunder* data/l4misc/thunderclap.ogg
sample *thunder* data/l4misc/thunder 1.ogg

: lightning
   once *thunder* 1.5 sndvol!
   2 0 do [[ FX_ADD blendmode !  =lightning priority !
      0.75 0.75 1.0  tint!
      0 perform
      1.0 alpha! 0.017 delay -0.3 0 .. fadeto
      0.07 delay
      1.0 alpha! 0.017 delay -0.2 0 .. fadeto
      4.0 6.0 between delay
      10 for r> 0.01 0.22 between alpha! -0.05 0 .. fadeto 0.03 0.1 between delay >r next
      2.0 delay end
   ]] %solidoverlay setoff loop
   0 [[ 0.5 delay
   [[ C_EXCITABLE cflags? ]] which [[ excite ]] execs
   end ]] parallel
;


\ ==================================================================================================
\ Crucifixion

animdata crucifixion.scml data/crucifixion/animdata/crucifixtion.scml
crucifixion.scml animation crucifixion_1 breathing crucifixtion
crucifixion.scml animation crucifixion_2 rapid heart beat

%actor ~> %crucifixion 
   999 priority !
   0.75 z !
   0.9 uscale!
   C_EXCITABLE cflags !
   editable on
hitbox: -200.0 -600.0 400.0 600.0 ;
   :: excited   crucifixion_2 0.75 animspeed!
      0 perform  10.0 delay crucifixion_1 0.5 animspeed! nod ;
   start:   crucifixion_1 0.5 animspeed!  ; \ vh 1p y ! ;
endp

\ ==================================================================================================
\ Stake head

animdata stakehead.scml data/stakehead/animdata/head on stake.scml
stakehead.scml animation stakehead_1 blowing in the wind

%actor ~> %stakehead 
   0.3 z !
   editable on
   hitbox: -100.0 -1000.0 200.0 1000.0 ;
   start: stakehead_1  %stakehead numberof negate priority +!  ; \ vh 400 rnd + 1p y ! ;
endp


\ ==================================================================================================
\ Purple stake head

image purplestakehead.image data/stakehead/Purple-Head-on-Stake.png


%billboard ~> %purplestakehead 
   =fg 1 - priority !
   2.5 z !
   2.3 uscale!
   0.5 1.0 pivot 2!
   purplestakehead.image bitmap!
   hitbox: -200.0 -600.0 400.0 600.0 ;
   editable on
   ; \ start: vh 400 rnd + 1p y ! ;
endp

\ ==================================================================================================
\ Bird

animdata bird.scml data/bird/animdata/birdy.scml
bird.scml animation bird_glide glide
bird.scml animation bird_fly fly

%actor ~> %bgbird 
   0.2 z !
   0.8 uscale!
   bird_fly
   
   start:
      0 perform  0.5 animspeed!   3 delay  post   screencull
   ;

endp


: leftof    -0.2 0.05 0.8 between around   ;
: rightof   1.2  0.05 0.8 between around   ;

variable birddir

: bird
   birddir @ 1 and if    %bgbird one { myview leftof put 30.0 vx ! 1 flip ! }
             else        %bgbird one { myview rightof put -30.0 vx ! }
   then
   birddir ++
   ;

\ ==================================================================================================

" l4layout" load-layout

4.0 constant BLADEWALL_SPEED
3.0 constant BLADEWALL_ANGEL_SPEED

: after-angel   whiteflash 5 [[ delay rain off complete-level ]] parallel ;

%room ~> %rainroom
   [i
   : inch   bladewall { x @ + cam @ 50.0 - min x ! } ;
   : track  cam +! ;
   : limscreen   cam @ dup bounds >x1 ! vw 1p + bounds >x2 ! ;
   : camrange   vw dup 2 * ;
   : ofsrange   200 vw 0.5 p* ;
   : lookahead   angel player xdist 1i camrange clamp camrange ofsrange rescale negate 1p  ;
   : angelcam   player to focus lookahead camofs !   roomw @ 2p bounds >x2 ! ;
   : post1   post BLADEWALL_SPEED dup inch track limscreen ;
   : post2   post BLADEWALL_ANGEL_SPEED inch ;
   : nearend?   cam angel xdist 1i vw 2 * <= ;
   var freed
   : freeher   ( angel { angel_idle } ) -post 1 [[ delay after-angel end ]] parallel ;
   : ?freedom
      player angel xdist 1200.0 > ?exit bladewall >atk off 
      freed @ ?exit
      \ player ( bladewall ) angel colliding?  if freed on freeher then ;
      player ( bladewall ) angel xdist 200.0 < if freed on freeher then ;
   : locked   player >x @ angel >x @ ( 750.0 ) 190.0 - min player >x ! ;
   : suck    l4suck:| player-emotion 0 [[ 3.5 player >vx ! ]] parallel ;
   : part1   bladewall { intro } post1 ;
   : part2   post2 angel { %angelboss morph } suck ;
   i]
   : level4-script   0 [[ part1 act nearend? when part2 0 perform angelcam locked ?freedom ]] parallel ;

   1024.0 1152.0 startpos 2!
   
   start:
      0 [[ 0.1 delay looping *l4bgm1* end ]] parallel
      0 [[ 0.1 delay rain on ]] parallel
      l4bg.image setbg
      bg {
         0.0 z ! -0.5 vx !
         [[ @ { 0.0 z ! -0.5 vx ! } ]] children @ each
      }
      yellowfilter50.image setfg FX_MULTIPLY fg >blendmode !
      0 0 at %darkcorners one drop
      l4layout
      0 [[ begin 10.0 delay lightning 30.0 rnd delay again ]] parallel
      l4:| player-emotion
      0 [[ begin 8.0 15.0 between delay bird again ]] parallel      
      10 [[ delay level4-script end ]] parallel
   ;

endp

12.0 1.0 %rainroom room: rainroom


\ ==================================================================================================
\ Map

1 1 4 level: level4
   rainroom ,
   0 0 startloc 2!
