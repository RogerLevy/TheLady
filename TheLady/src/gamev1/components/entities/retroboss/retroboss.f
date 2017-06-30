defer retry-boss   ' noop is retry-boss

absent %starrysky ?fload starrysky
absent %arcadelady ?fload arcadelady
absent %arcadefire ?fload arcadefire
fload bossfire

sample *bosshurt* data\retroboss\sfx\boss impact.ogg
sample *laser1* data\retroboss\sfx\shooting 1.ogg
sample *laser3* data\retroboss\sfx\shooting 3.ogg
sample *laser4* data\retroboss\sfx\shooting 4.ogg
sample *laser3b* data\retroboss\sfx\shooting 3.ogg

0 value sky
0 value boss
0 value bgm

: ?sky   sky 0= if 0 0 at> %starrysky one dup to bg to sky [[ 0 to sky ]] sky >ondelete ! then ;

create default-speeds cell [array 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , array]

%billboard ~> %retroboss
   1 atk !
   FX_ADDITIVE blendmode !
   5.0 uscale!
   C_SHOOTABLE C_HARMFUL or cflags !
   0.5 0.5 pivot 2!


   default-speeds var: bgspeeds

   [i
   var spd
   noop: mind

   :: die   end 0 [[ 2 delay end complete ]] parallel ;

   : !bgspeed   spd @ bgspeeds @ []clamp @ ?ps sky >vy ! ;

   : retroboss:hurt   once *bosshurt* -hp 60 invuln ! spd ++ !bgspeed ;

   :: hurt   retroboss:hurt ;

   :: idle    0 perform  60 every if  0 10.0 %bossfire  shoot  then ;

   : lbound   bounds >x1 @ hitbox >width @ 2 / + ;
   : rbound   bounds >x2 @ hitbox >width @ 2 / - ;
   : edge?  x @ dup lbound < swap rbound > or ;
   : ?fixx   vx @ 0 < if rbound else lbound then x ! ;
   : /walls   vx @ -exit  edge? if -vx ?fixx then ;

   : /mind   0 [[ me owner @ >script1 ! owner @ >mind @ execute ]] parallel ;

   i]

   start:
      ?sky   !bgspeed
      me to boss   idle   /mind
      post /walls ?flash
   ;

   [i
   : bossbattle   r> code> is retry-boss  retry-boss ;

   : setup
      stage:deletions
      0 0 cam 2!  1152.0 letterbox!
      0.75 mastervol!
      clean clear-sounds player/    1024.0 960.0 at %arcadelady one drop    looping *laser3b* 0.1 sndspd! snd to bgm
      2048 dup roomw ! 1p bounds >width ! ;
   i]

   ondelete: script1 @ delete ;

   0 0 action special
   0 0 action trick
   0 0 action decide


endp


fload purpleboss
fload redboss
fload blackboss


\\

   [i
   var foresight   \ ability to anticipate the player's actions and near-future circumstances
   var dexterity   \ ability to dodge player's lasers
   i]

   : tracking-likelihood ;
   : tracking-accuracy ;

   : dodge-lag ;
   : dodge-likelihood ;
   : dodge-?boost ;
