stream title.stream data/title/Title Screen Track.ogg

" ending.png" file> 2constant source-file

create ending.image   %bitmap instance,

%solidoverlay ~> %flashy
   0 priority !
   var mytint

   [[
      FX_NORMAL colorfx
      -2e -2e vres 2@ 4 4 2+ 2s>f   mytint 4c@f al_draw_filled_rectangle   
   ]] ondraw !
   
   start:
      0 perform
      10 [[ delay fadeout3 10 delay end complete ]] parallel
      begin
         $ffeaffff mytint !
         0.15 delay
         $ff97f9fc mytint !
         0.15 delay
         $ffdcdbf7 mytint !
         0.15 delay
         \ $ffe2fcd5 mytint !
         \ 0.15 delay
      again ;
endp


%billboard ~> %ending
   =bloodrenderer 1 + priority !
   ending.image bitmap!
   start:
      source-file 0 z" r" al_open_memfile >r
      r@ z" .png" al_load_bitmap_f ending.image >albmp !
      r> al_fclose
      
      0 perform
         30 every if 1364.0 745.0 at  0 0 gravity blooddrop then
         650.0 802.0 at
            lifetime @ 4 * 1p psin >r r@ 0 < if
               r@ abs 4 * 1i rnd if r> drop exit then then
            15.0 6.0 10.0 r@ 4 * + between
            r> 5 * + 2vec gravity blooddrop  
   ;
endp


1.0 1.0 %room room: endingroom
   start:
      0 0 at
      %flashy one drop
      %ending one drop
      lady disable
      looping title.stream
   ;


1 1   6 level: endinglevel
   endingroom ,
   0 0 startloc 2!

: ending      6 loadlevel can-pause off ;
