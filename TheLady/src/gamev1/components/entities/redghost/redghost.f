\ animations
animdata redghost.scml data\redghost\animdata\lvl 3 boss.scml
redghost.scml animation redghost_damage damage dying
redghost.scml animation redghost_idle idle and walk
redghost.scml animation redghost_attacking attacking

sample *scream1* data\redghost\lvl 3 gohst damage 1.ogg
sample *scream2* data\redghost\lvl 3 gohst damage 2.ogg
sample *scream3* data\redghost\lvl 3 gohst damage 3.ogg

variable killcount

%actor ~> %harmfulzone
   C_HARMFUL cflags !
   vis off
   hitbox: -25.0 -25.0 50.0 50.0 ;
endp

%actor ~> %redghost
   5 atk !
   hitbox: -50.0 0 100.0 1000.0 ;
   redghost_idle
   C_HARMFUL C_SHOOTABLE or cflags !   
   0.85 uscale!
   editable on
   =lady 1 + priority !
   
   [i
   ' *scream1* var: hurtsound
   
   30.0 var: runspeed
   5.0 var: walkspeed
   : ?walkspeed   walkspeed @ ?neg ;
   : ?runspeed    runspeed @ ?neg ;

   : harmmotion    0.15 perform delay 70.0 ?neg vx ! 0.20 delay end ;
   var baby
   i]
   
   :: attack   ?face nip redghost_attacking halt perform ( power ) 0.25 delay me 0 500 from
      direction @ %harmfulzone one { dir! atk ! harmmotion me } baby ! 0.9 delay idle ;      
   
   :: walk    ?face redghost_idle ?walkspeed vx ! durr 1.0 animspeed! ;
   :: run     ?face redghost_idle ?runspeed vx ! durr  2.0 animspeed! ;
   
   [i
   : runaway  baby @ ?dup if delete then 0 hp ! player ?leftright left = if right else left then dir! invuln on 0 run ;
   : lbound   bounds >x1 @ 100.0 - ;
   : rbound   bounds >x2 @ 100.0 + ;
   : out?   x @ dup lbound <= swap rbound >= or ;
   : lbound   bounds >x1 @ ;
   : rbound   bounds >x2 @ ;
   : edge?  x @ dup lbound <= swap rbound >= or ;
   : /floor   hp @ 0 <= if y @ 1300.0 >= if die then then ;
   : /walls   vx @ -exit  hp @ 0 <= if out? if die then else edge? if -vx vx @ 2* x +! then then ;
   : ?hitlady    invuln @ player >invuln @ or ?exit   me player colliding? if runaway then ;
   : (hurt)   drop once hurtsound @ execute killcount ++ 30.0 runspeed ! runaway redghost_damage ;
   i]
   
   :: chase   ?leftright dir!  run ;
   :: hurt    (hurt) ;
   
   :: idle    player chase ;

   :: die    end ;

   start: 0 y ! idle post /walls /floor ?hitlady ; 

endp



%redghost ~> %redghostpopper
   
   :: chase   dup ?leftright dir! run
              perform dup >vx @ 0 = if idle then ;
   
   :: avoid   drop runaway ;   
   
   :: idle
            player ?leftright dir!
            redghost_idle halt 0 perform
            0.2 delay
            player 750 close? player approaching? and if player avoid then
            player retreating? if player chase then 
            player 750 close? if 60 every if 0 5 attack then then
            ;
   
endp

%redghost ~> %redghostbezerk
   ' *scream2* hurtsound !
   12.5 runspeed !
   1 atk !
endp

%redghost ~> %redghostmole
   ' *scream2* hurtsound !
   cflags off
   
   :: attack
      nip redghost_attacking halt 
      [[
         ( power ) 0.25 delay owner @ 0 500 from owner @ >direction @ %harmfulzone one { dir! atk ! harmmotion me } owner @ >baby !
      end ]] parallel ;      

   : mole-post   post /walls ;
   
   start:
      -1200.0 y ! 
      player ?leftright dir!
      mole-post
      0 perform
      me x @ -800.0 5.0 sendto
      1.0 15.0 between delay 
      begin
         redghost_idle cflags off me x @ 0 6.0 sendto
         act y @ 0 = when 
         C_HARMFUL C_SHOOTABLE OR cflags !  player ?leftright dir!
         0.5 delay 0 5 attack
         1 delay redghost_idle
         1 delay
         cflags off me x @ -800.0 6.0 sendto 
         act y @ -800.0 = when 
         4 delay 
      again
   ;
endp

%redghost ~> %redghostwanderer
   4.5 walkspeed !
   cflags off
   [i
   : ?walkdelay   1.0 4.0 between ;
   : freakout  0 hurt ;   
\   : ?agitate   owner @ player 600 closeby? if owner @ { freakout } end then ;
\   : /?agitate   0 [[ me owner @ >script1 ! act ?agitate ]] parallel ;
   : lbound   bounds >x1 @ 130.0 + ;
   : rbound   bounds >x2 @ 130.0 - ;
   : limit-x  x @ lbound rbound clamp x ! ;
   : wander   0 perform 3 rnd 0 = if 0.3 1.0 between then delay 2 rnd if walkl else walkr then ;
   : dropdown   halt 0 perform 1.0 vy +! post /floor ;
   : ?spook    player 600 close? if freakout then ;
   i]
   
   :: hurt   drop   0 hp !  killcount ++   cr killcount ? dropdown ;
   :: walk   redghost_idle ?walkspeed vx ! idle ;
   :: idle   redghost_idle halt wander ;
   start: 0 y ! idle post /walls ?spook ; 

endp

%redghostwanderer ~> %redghostflailer
   ' *scream3* hurtsound !
   4.5 walkspeed !
   C_HARMFUL C_SHOOTABLE or cflags !
   
   :: hurt  (hurt) ;
   [i
   : ?walkdelay   0.5 2.0 between ;
   : wander
      0 perform ?walkdelay delay
      4 rnd case
         0 of 0 10 attack endof
         1 of 0 10 attack endof
         2 of walkl endof
         3 of walkr endof
      endcase ;
   i]
   :: idle   redghost_idle halt wander ;
   start: 0 y ! idle post /walls /floor ?hitlady ; 
endp