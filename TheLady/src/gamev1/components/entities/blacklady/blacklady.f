absent %l1door ?fload l1door

\ animations
animdata blacklady.scml data\blacklady\animdata\lvl 5 boss.scml
blacklady.scml animation blacklady_attacking attacking
blacklady.scml animation blacklady_openeyes open eye after walking by
blacklady.scml animation blacklady_still idle statue like
blacklady.scml animation blacklady_breath door hidden behind me

defer blacklady:revert

%actor ~> %blacklady
   C_BLACKLADY cflags ! 
   [i var hasdoor i]
   1 hp !
   blacklady_still
   editable on
   hitbox: -100.0 -1300.0 200.0 1300.0 ;
   [[
      C_PLAYERPROJECTILE [[ me [[ 1 pauses kill end ]] parallel ]] collides
   ]] 'post !
   [i
   : *door
      player beneath me 10 0 from
      %l1door one { y @ roomh @ 1p min y ! [[ north ]] ondoor ! 1.4 0.6 dspt >scale 2! } ;
   i]
   :: die
      hasdoor @ if *door then
      cflags off halt blacklady_still
      2.0 vy ! 
      0 perform  y @ vh 3 * 1p >= when  end ;
endp

%blacklady ~> %blackladywatcher
   blacklady_still
   start: 0 perform
      begin
         player 100 close? when 
         player 350 close? not when blacklady_openeyes
         1 delay blacklady_still
         6 delay
      again ;
endp

%blackladywatcher ~> %blackladychaser
   blacklady_still
   1 0 action chase
         
   [i
   : bounce   vx @ -1.2 p* vx ! ;
   : ?bounce   x @ 0 roomw @ 1p within not if bounce then ;
   : ?hitlady  player >invuln @ ?exit me player colliding? if bounce then ;
   i]
   
   :: chase
      blacklady_attacking C_SHOOTABLE C_HARMFUL or cflags !
      >x @ x @ < if -7.5 else 7.5 then vx ! 0 perform ?bounce ?hitlady ;

   start: 0 perform
      player 100 close? when
      player 500 close? not when blacklady_openeyes
      1 delay player chase ;
endp

%blackladychaser ~> %blackladybreathing
   hasdoor on
   C_SHOOTABLE cflags !
         
   start:   0 perform begin blacklady_breath 0.5 animspeed! 2 delay blacklady_still 4 delay again ;
endp

[[
   2 rnd case
      0 of %blacklady endof
      1 of %blackladywatcher endof
   endcase morph ;
]] is blacklady:revert

fload blackladyrnd