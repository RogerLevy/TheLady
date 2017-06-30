\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 floating point handling - "easy" version
\ NOT source-compatible with the "regular" version or the Allegro API

\ x, y, color, scale, pivot, angle, thickness and region are passed in float variables, defined below.

\ triangle drawing and arc calculation have been removed

\ also i highly recommend customizing a copy of this file to best suit the app
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/23/13

create allegro-pen      0e sf, 0e sf,
create allegro-pivot   0e sf, 0e sf,
create allegro-angle   0e sf,                            \ radians, clockwise
create allegro-color   1e sf, 1e sf, 1e sf, 1e sf,
create allegro-thickness  -1e sf, 
create allegro-scale   1e sf, 1e sf,
create allegro-region  0e sf, 0e sf, 16e sf, 16e sf, 

macro: xy>   allegro-pen 2@ ;
macro: color>   allegro-color 4@ ;
macro: thickness>   allegro-thickness @ ;
macro: scale>   allegro-scale 2@ ;
macro: pivot>   allegro-pivot 2@ ;
macro: angle>   allegro-angle @ ; 
macro: region>  allegro-region 4@ ;

: al-clear-to-color  ( -- ) color> al_clear_to_color ;
: al-draw-pixel  ( -- ) xy> color> al_draw_pixel  ;
                        
: al-build-transform     2sfparms 2>r 3sfparms 2r> al_build_transform ;
: al-translate-transform   2sfparms al_translate_transform ;
: al-rotate-transform   1sfparms al_rotate_transform ;
: al-scale-transform  2sfparms al_scale_transform ;
: al-check-inverse  1sfparms al_check_inverse ;

\ since 5.1.3 
\ : al_translate_transform_3d   3sfparms al_translate_transform_3d ;
\ : al_rotate_transform_3d   4sfparms al_rotate_transform_3d ;
\ : al_scale_transform_3d  3sfparms al_scale_transform_3d ;
                                   
                                   
: al-convert-mask-to-alpha  4sfparms al_convert_mask_to_alpha ;
                                   
: al-draw-line     ( f: dx dy )  xy> 2sfparms color> thickness> al_draw_line ;
\ : al-draw-triangle   1sfparms >r 4sfparms 2>r 2>r 2sfparms 2>r 4sfparms 2r> 2r> 2r> r> al_draw_triangle ;
: al-draw-rectangle         ( f: x2 y2 ) xy> 2sfparms color> thickness> al_draw_rectangle ;
: al-draw-filled-rectangle  ( f: x2 y2 ) xy> 2sfparms color>            al_draw_filled_rectangle ;


: al-draw-rounded-rectangle   ( f: x2 y2 radiusx radiusy ) xy> 4sfparms color> thickness> al_draw_rounded_rectangle ;
\ : al-calculate-arc   >r  4sfparms 2>r 2>r  3sfparms 2r> 2r> r> al_calculate_arc ;
: al-draw-circle   ( f: radius ) xy> 1sfparms color> thickness> al_draw_circle ;
: al-draw-ellipse  ( f: radiusx radiusy ) xy> 2sfparms color> thickness> al_draw_ellipse ;
: al-draw-arc      ( f: radius a1 a2 ) xy> 3sfparms color> thickness> al_draw_arc ;
: al-draw-elliptical-arc  ( f: radiusx radiusy a1 a2 ) xy> 4sfparms color> thickness>  al_draw_elliptical_arc ;
: al-calculate-spline   thickness> swap al_calculate_spline ;  \ just leave out thickness
: al-draw-spline        color> thickness> al_draw_spline ;     \ just leave out color and thickness
: al-calculate-ribbon   thickness> swap al_calculate_ribbon ;  \ just leave out thickness
: al-draw-ribbon        color> thickness> al_draw_ribbon ;     \ just leave out color and thickness
\ : al-draw-filled-triangle   4sfparms 2>r 2>r 3sfparms 2>r >r 3sfparms r> 2r> 2r> 2r> al_draw_filled_triangle ;
                                   
: al-draw-filled-rounded-rectangle    ( f: x2 y2 radiusx radiusy )  xy> 4sfparms color> thickness> al_draw_filled_rounded_rectangle  ;
: al-draw-filled-circle   ( f: radius ) xy> 1sfparms color> thickness> al_draw_filled_circle ;
: al-draw-filled-ellipse  ( f: radiusx radiusy ) xy> 2sfparms color> thickness> al_draw_filled_ellipse ;
                                   
: al-draw-ustr ( font flags zstr ) 2>r color> xy> 2r> al_draw_ustr ;
: al-draw-text ( font flags zstr ) 2>r color> xy> 2r> al_draw_text ;
                                   
: al-draw-justified-text  ( font flags str f: diff ) 2>r color> xy> 1sfparms 2r> al_draw_justified_text  ;
: al-draw-justified-ustr  ( font flags str f: diff ) 2>r color> xy> 1sfparms 2r> al_draw_justified_ustr  ;
                                   
: al-draw-bitmap          ( bitmap flags ) >r xy> r> al_draw_bitmap ; 
: al-draw-bitmap-region   ( bitmap flags ) >r region> xy> r> al_draw_bitmap_region ;

\ void function: al_draw_tinted_scaled_rotated_bitmap_region (
\  ALLEGRO_BITMAP-*bitmap
\  float-sx float-sy float-sw float-sh
\  float-r float-g float-b float-a
\  float-cx float-cy
\  float-dx float-dy
\  float-xscale float-yscale
\  float-angle
\  int-flags -- )
: al-draw-tinted-scaled-rotated-bitmap-region  ( bitmap flags -- )
   >r
   region> 
   color>
   pivot>
   xy>
   scale>
   angle>
   r>
   al_draw_tinted_scaled_rotated_bitmap_region ;

: al-draw-tinted-bitmap-region ( bitmap flags -- )
   >r color> region> xy> r> al_draw_bitmap_region al_draw_tinted_bitmap_region ;

create tempxy 0 , 0 , 
: al-transform-xy ( x y matrix - x y )
   >r 2s>f 2sfparms tempxy 2! r> tempxy dup cell+ al_transform_coordinates tempxy sf@ f>s  tempxy cell+ sf@ f>s ;

