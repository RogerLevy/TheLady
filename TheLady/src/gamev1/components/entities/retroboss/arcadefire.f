sample *arcadefire* data\retroboss\sfx\shooting 2 fixed.ogg

%billboard ~> %arcadefire
   FX_ADD blendmode !
   ladylaser.image bitmap!
   C_PLAYERPROJECTILE cflags !
   1 atk !
   0 hp !
   0.5 0.5 pivot 2!
   \ $ff40ff60 tint !
   1.0 0.25 1.0 0.33 tint 4!
   0.825 uscale!
   hitbox: ladylaser.image 0.25 scale @ p* center-bitmap-box ;
   start:
      once *arcadefire* 
      -30.0 vy ! idle
      post
      C_SHOOTABLE [[
         invuln @ ?exit 1 hurt ( you actual-delete ) %arcadefire allof [[ actual-delete ]] execs
      ]] collides
      screencull ;   
endp
