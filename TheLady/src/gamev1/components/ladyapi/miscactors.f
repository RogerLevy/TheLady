
\ ----------------------------------------------------------------------
\ General purpose actors

: drawblip   pen 2@ 2p>f s>f tint 4p@f al_draw_filled_circle ;

%actor ~> %blip
   10 var: blipsize
   [[ x 3@ scrolled at blipsize @ dspt -> drawblip ]] ondraw !
endp

%actor ~> %solidoverlay
   0 z !
   [[ blendmode @ colorfx
      -2e -2e vres 2@ 4 4 2+ 2s>f   tint@ 3p>f alpha@ p>f al_draw_filled_rectangle ]] ondraw !
endp


: whiteflash
   [[ FX_ADD blendmode ! 0 alpha! 0.004 1.0 .. fadeto
      0 perform 5.0 delay 1 pauses end
   ]] %solidoverlay setoff ;
