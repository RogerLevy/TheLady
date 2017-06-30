image arcadelady.image data/retroboss/heads/ladyhead64_b.png
image life.image data/retroboss/heads/lives64.png
image ladylaser.image data/retroboss/laser.png
sample *headhurt* data\retroboss\sfx\lady head impact.ogg

absent %arcadefire ?fload arcadefire


%billboard ~> %arcadelady
   C_PLAYER cflags !
   FX_ADD blendmode !
   arcadelady.image bitmap!
   0.5 0.5 pivot 2!
   3.5 uscale!
   hitbox: arcadelady.image 0.6 scale @ p* center-bitmap-box ;
   5 hp !
   
   [i
   : draw-hp
      dspt =>
      screen 0.015 1.0 around life.image bitmap-size nip 1p - at
      scale 2@ 2.0 uscale!
         alpha@ 0.6667 alpha!
            hp @ for
               life.image entire dspt blitrgnexp
               life.image bitmap-size drop 1p 2.5 p* 0 +at
            next
         alpha!
      scale 2!
      ;
   i]
   
   [[ ?nodraw 0= if billboard-render then draw-hp ]] ondraw !
   
   : (death)
      [[ death retry-boss ]] btw ;

   
   :: die  end lives -- lives @ -1 > if (death) else ['] gameover btw then ;
   
   :: hurt  once *headhurt* 60 invuln ! -hp ;
   
   :: idle
      vis on 0 perform
      <a> kstate <left> kstate or if -9.0 x +! then
      <d> kstate <right> kstate or if 9.0 x +! then
      %arcadefire numberof 0 = if
         <space> kpressed <up> kpressed or if
            me -45 -80 from %arcadefire one drop
            me 40 -80 from %arcadefire one drop
         then
      then
   ;

   : lbound   bounds >x1 @ 100.0 + ;
   : rbound   bounds >x2 @ 100.0 - ;
   : limitx   x @ lbound rbound clamp x ! ;
   
   : ?gethurt   C_HARMFUL [[ you >invuln @ ?exit  atk @ you { hurt } ]] collides ;   
   : ?hurtweaks C_WEAK [[ you >atk @ hurt ]] collides ;   
   
   start: me to player idle post limitx ?flash ?gethurt ?hurtweaks ;
   

endp