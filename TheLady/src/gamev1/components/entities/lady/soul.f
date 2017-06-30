image soul.image data/lady/Soul-Shoots-from-Head2.png

%billboard ~> %soul 

   soul.image bitmap!
   hitbox: soul.image 0.25 center-bitmap-box ;
   FX_SCREEN blendmode !
   0.5 0.5 pivot 2!
   0.5 dup scale 2!
   \ $ffff80ff tint !
   1.0 1.0 0.5 1.0 tint 4!
   C_PLAYERPROJECTILE cflags !
   1 atk !
   
   start: post C_SHOOTABLE [[ invuln @ ?exit 1 hurt ]] collides screencull ;

endp