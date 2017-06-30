\ ==============================================================================
\ ForestLib > GameBlocks > Allegro5 I/O
\ Basic graphics and bitmaps words
\ ========================= copyright 2014 Roger Levy ==========================

\ vector structure
pstruct %vector   var x   var y   var z   endp

\ pen
%vector ~> %pen
   $ffffffff var: fgcolor
endp

create pen %pen instance,
: at   pen 2! ;
: +at  pen 2+! ;
: at>  r> pen 2@ 2>r pen 2! rot call 2r> pen 2! ;
: pen2@f  pen 2@ 2s>f ;
: colored   ( rgba -- ) fgcolor ! ;


variable (rgba)
: rgba ( n-f:nnnn ) (rgba) ! (rgba) 4c@f ;
: cls  ( color ) rgba al_clear_to_color ;


: pcomp   0.45e f+ fswap 0.45e f+ fswap ;


\ ------------------------------------------------------------------------------
\ bitmap processing

ALLEGRO_LOCK_READWRITE                 value allegro-lock-mode
ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA value allegro-lock-format

: al-bitmap-lockpixel0 ( allegro-bitmap -- allegro-bitmap addr )
   dup 0 0 1 1 allegro-lock-format ( ALLEGRO_PIXEL_FORMAT_ANY ) ALLEGRO_LOCK_READONLY al_lock_bitmap_region
   >ALLEGRO_LOCKED_REGION-data @ ;

: al-bitmap-size     al_bitmap_size ;

: al-bitmap-lock ( allegro-bitmap -- allegro-bitmap pitch addr )
   dup allegro-lock-format ( ALLEGRO_PIXEL_FORMAT_ANY ) allegro-lock-mode al_lock_bitmap
   dup >ALLEGRO_LOCKED_REGION-pitch @ swap >ALLEGRO_LOCKED_REGION-data @ ;

: al-bitmap-unlock   ( allegro-bitmap -- )
   al_unlock_bitmap ;

: al-pixel0  ( allegro-bitmap -- n )
   al-bitmap-lockpixel0 h@ swap al-bitmap-unlock ;

variable smooth-textures

: ?smooth
   al_get_new_bitmap_flags
   smooth-textures @ if ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or al_set_new_bitmap_flags
   else [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or invert ]# and al_set_new_bitmap_flags then ;

%asset begets %bitmap
   var albmp

   : bitmap:onload
      2dup z$ ?smooth al_load_bitmap
         ?dup 0= if  cr type true abort" Error in BITMAP:ONLOAD : There was a problem loading a bitmap."  then
         albmp !   2drop ;

   ' bitmap:onload prototype >onload !
endp

: bitmap, ( ac- ) %bitmap build> asset^ ;

: bitmap-size   >albmp @ al-bitmap-size ;

variable temp
: colorkey  ( rgba bitmap -- )   \ replace color with transparent (destructive)
   >albmp @   swap temp ! temp 4c@f al_convert_mask_to_alpha ;

\ : auto-colorkey  ( x y bitmap -- )  \ use color from given pixel as colorkey (destructive)
\    >albmp @ dup >r -rot .s al_get_pixel r> swap .s al_convert_mask_to_alpha ;

: topleft-pixel  ( bitmap -- n bitmap )
   dup >albmp @ al-bitmap-lockpixel0 @ swap al-bitmap-unlock swap ;



: rectwh*   2 cells + 2@ 2s>p 2p* ;
: rectwh*p   2 cells + 2@ 2p* ;

: bmpwh*p   bitmap-size 2s>p 2p* ;

variable flipflags

\ the blit commands in this file are meant to be replaced by many apps. there are merely here
\ to get started quickly.

: blit
   >albmp @   pen2@f   flipflags @   al_draw_bitmap ;

: blitrgn  ( bitmap bmprect -- )    \ bmprect is 4 cells: x,y,w,h
   >r  >albmp @   r> 4@f   pen2@f   flipflags @   al_draw_bitmap_region ;


fload displaytransform


\ supports tinting, scaling and rotation
: blitrgnex  ( bitmap bmprect displaytransform -- )
   =>   >r   >albmp @   r> 4@f    tint 4p@f  0e 0e   pen2@f   scale 2@ 2p>f   rotation @ p>f  d>r  flipflags
   al_draw_tinted_scaled_rotated_bitmap_region
   ;

\ supports pivot
: blitrgnexp  ( bitmap bmprect displaytransform -- )
   =>   >r   >albmp @   r@ 4p@f  tint 4p@f  pivot 2@ r> rectwh*p   2p>f
      pen 2@ 2p>f
      scale 2@ 2p>f   rotation >z @  p>f  d>r fnegate   flipflags @
      al_draw_tinted_scaled_rotated_bitmap_region
   ;

