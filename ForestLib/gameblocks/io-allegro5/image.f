\ ==============================================================================
\ ForestLib > GameBlocks [2] > Allegro5 I/O [2]
\ Image struct
\ ========================= copyright 2014 Roger Levy ==========================

variable smooth-textures

: ?smooth
   al_get_new_bitmap_flags
   smooth-textures @ if
      ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or 
   else
      [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or invert ]# and 
   then
   al_set_new_bitmap_flags ;

%asset ~> %image
   [i var albmp i]
   
   : load-image ( addr c image -- )
      with 2dup path place z$ ?smooth al_load_bitmap albmp ! ;

   : save-image ( image -- )
      with path count cr 2dup type z$ albmp @ al_save_bitmap 0= abort" There was a problem saving an image" ;
   
   : save-image-as ( addr c image -- )
      with path place s@ save-image ;
   
   
   : image:onload
      2dup s@ load-image
      albmp @ 0= if cr type true abort" Error in BITMAP:ONLOAD : There was a problem loading an image." then
      2drop ;  

   ' image:onload onload !

   : image.size      .albmp @ al-bitmap-size ;
   : image.w         image.size drop ;
   : image.h         image.size nip ;
   
   : allegro-bitmap   .albmp @ ;

   : entire ( image -- image ) 0e 0e dup image.size 2s>f 4sfparms allegro-region 4! ;

   : image ( -- <name> <filespec> )
      ?create namespec %image instance with asset^ ;

\ ------------------------------------------------------------------------------

   : blit   ( image -- ) allegro-bitmap 0 al-draw-bitmap ;
   : blitflip ( image flip -- ) >r allegro-bitmap r> al-draw-bitmap ;
   
   : 2sf!   dup >r cell+ sf! r> sf! ;
   : p2sf!  >r p>f r@ cell+ sf! p>f r> sf! ;
   
   \ call these before BLITPART etc
   : partxy! 2s>f allegro-region 2sf! ;
   : partwh! 2s>f allegro-region cell+ cell+ 2sf! ;
   : part!   ( x y w h ) partwh! partxy! ;
   
   \ call PART! etc first
   : blitpart ( image -- ) allegro-bitmap 0 al-draw-bitmap-region ;
   : blitpartflip ( image flip -- ) >r allegro-bitmap r> al-draw-bitmap-region ;

   \ srt = Scale Rotate Tint
   \ call PART! etc and TRANSFORMED first
   : blitsrt ( image -- ) entire allegro-bitmap 0 al-draw-tinted-scaled-rotated-bitmap-region ;
   : blitsrtflip ( image flip -- ) >r entire allegro-bitmap r> al-draw-tinted-scaled-rotated-bitmap-region ;
   : blitpartsrt ( image -- ) allegro-bitmap 0 al-draw-tinted-scaled-rotated-bitmap-region ;
   : blitpartsrtflip ( image flip -- ) >r allegro-bitmap r> al-draw-tinted-scaled-rotated-bitmap-region ;
   
endp