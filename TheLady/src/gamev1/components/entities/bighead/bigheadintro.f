\ to bring the barbwires out we've added the ability to draw them "cut off"

absent %barbwire ?fload barbwire

: d-l 0.14 0.6 between ;

: barbstem{
   %barbwire one {
      cflags off
      0 0 0 0 hitbox 4!
      d-l dup dup tint!
      0.8 uscale!
      drawportion on
      0.0 portion >y2 !
      4 rnd flip !
; \ }

: comeout   
   perform dup portion >y2 +!
   portion >y2 @ 1.0 >= when
   1.0 portion >y2 ! nod ;

dvariable stemxy
variable stemp
: stems ( n -- )
   nextpri @ stemp ! pen 2@ stemxy 2!
   [[
      for r>
         stemp @ nextpri ! stemxy 2@ at
         \ 300.0 rnd 140.0 - ( angle. )
         360.0 rnd ( angle. )
         barbstem{
            dspt -> angle !
            0.16 0.22 between comeout
         }
         0 10 between 0= if 1 pauses then
      >r next end
   ]] parallel
;

%boss ~> %bigheadintro
%bigheadintro script
C_REPEL C_HARMFUL or cflags !
bighead_idle 1 animspeed!
hitbox: -200.0 -200.0 400.0 400.0 ;


: sprout   me 0 0 from me beneath stems  ;

: introrainglass   once *glass1*  2 for [[ 10 for r> shard{ } 0.05 delay >r next end ]] parallel next ;

variable temp

: *barbdeco*  once *barbstem1* 1.1 sndspd! ;

start:
   glassfalling on
   l1boss:| player emote
   
   0 perform
   once *damage2*

   1.0 delay
   *barbdeco* 4 6 between sprout    bighead_barbcomingout 2.0 animspeed! 0.2 delay
   bighead_idle 1 animspeed!  1.0 delay
   
   *barbdeco* 4 6 between sprout    bighead_barbcomingout 2.0 animspeed! 0.2 delay
   bighead_idle 1 animspeed!  0.5 delay
   
   *barbdeco* bighead_barbcomingout 2.0 animspeed!
   4 6 between sprout 0.33 delay ( 3 4 between sprout )
   1.0 animspeed!  1.0 delay
   0.6667 animspeed!  0.6 delay
   0.4444 animspeed!  1.0 delay
   
   once *barbstem2* redflash introrainglass
   glass >vis off
   owner @ ?dup if { addred } then
   30 sprout 2.5 animspeed! 0.3 delay
   ( 4 5 between sprout ) 2.0 animspeed! 0.3 delay
   ( 2 3 between sprout ) 1.25 animspeed! 0.3 delay
   ( 3 4 between sprout ) 0.66 animspeed! 0.3 delay
   ( 3 4 between sprout ) 0.33 animspeed! 0.5 delay  0.125 animspeed! 0.25 delay
      
   bighead_idle 1 animspeed! 
   owner @ dup temp ! %bigheadboss morph temp @ owner ! 
;

endp
