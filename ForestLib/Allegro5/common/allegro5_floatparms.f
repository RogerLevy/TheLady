\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 floating point handling
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/23/13

: al_clear_to_color  4sfparms al_clear_to_color ;
: al_draw_pixel  2sfparms 2>r 4sfparms 2r> al_draw_pixel  ;

: al_build_transform   2sfparms 2>r 3sfparms 2r> al_build_transform ;
: al_translate_transform   2sfparms al_translate_transform ;
: al_rotate_transform   1sfparms al_rotate_transform ;
: al_scale_transform  2sfparms al_scale_transform ;
: al_check_inverse  1sfparms al_check_inverse ;

\ since 5.1.3 
\ : al_translate_transform_3d   3sfparms al_translate_transform_3d ;
\ : al_rotate_transform_3d   4sfparms al_rotate_transform_3d ;
\ : al_scale_transform_3d  3sfparms al_scale_transform_3d ;


: al_convert_mask_to_alpha  4sfparms al_convert_mask_to_alpha ;

: al_draw_line   1sfparms >r 4sfparms 2>r 2>r 4sfparms 2r> 2r> r> al_draw_line ;
: al_draw_triangle   1sfparms >r 4sfparms 2>r 2>r 2sfparms 2>r 4sfparms 2r> 2r> 2r> r> al_draw_triangle ;
: al_draw_rectangle    1sfparms >r 4sfparms 2>r 2>r 4sfparms 2r> 2r> r> al_draw_rectangle  ;
: al_draw_rounded_rectangle    1sfparms >r 4sfparms 2>r 2>r 2sfparms 2>r 4sfparms 2r> 2r> 2r> r> al_draw_rounded_rectangle  ;
: al_calculate_arc   >r  4sfparms 2>r 2>r  3sfparms 2r> 2r> r> al_calculate_arc ;
: al_draw_circle   1sfparms >r 4sfparms 2>r 2>r 3sfparms 2r> 2r> r> al_draw_circle ;
: al_draw_ellipse  1sfparms >r 4sfparms 2>r 2>r 4sfparms 2r> 2r> r> al_draw_ellipse ;
: al_draw_arc  1sfparms >r 4sfparms 2>r 2>r 1sfparms >r 4sfparms r> 2r> 2r> r> al_draw_arc ;
: al_draw_elliptical_arc  1sfparms >r 4sfparms 2>r 2>r 2sfparms 2>r 4sfparms 2r> 2r> 2r> r> al_draw_elliptical_arc ;
: al_calculate_spline   >r 1sfparms r> al_calculate_spline ;
: al_draw_spline   1sfparms >r 4sfparms r> al_draw_spline ;
: al_calculate_ribbon   >r 1sfparms r> al_calculate_ribbon ;
: al_draw_ribbon   >r 1sfparms >r 4sfparms r> r> al_draw_ribbon ;
: al_draw_filled_triangle   4sfparms 2>r 2>r 3sfparms 2>r >r 3sfparms r> 2r> 2r> 2r> al_draw_filled_triangle ;
: al_draw_filled_rectangle    4sfparms 2>r 2>r 4sfparms 2r> 2r> al_draw_filled_rectangle ;
: al_draw_filled_ellipse  4sfparms 2>r 2>r 4sfparms 2r> 2r> al_draw_filled_ellipse ;
: al_draw_filled_circle   4sfparms 2>r 2>r 3sfparms 2r> 2r> al_draw_filled_circle ;
: al_draw_filled_rounded_rectangle    4sfparms 2>r 2>r 2sfparms 2>r 4sfparms 2r> 2r> 2r> al_draw_filled_rounded_rectangle  ;

: al_draw_ustr 2>r 2sfparms 2>r 4sfparms 2r> 2r> al_draw_ustr ;
: al_draw_text 2>r 2sfparms 2>r 4sfparms 2r> 2r> al_draw_text ;

: al_draw_justified_text  2>r 4sfparms 2>r 2>r 4sfparms 2r> 2r> 2r> al_draw_justified_text  ;
: al_draw_justified_ustr  2>r 4sfparms 2>r 2>r 4sfparms 2r> 2r> 2r> al_draw_justified_ustr  ;

: al_draw_bitmap >r 2sfparms r> al_draw_bitmap ; 
: al_draw_bitmap_region >r 2sfparms 2>r 4sfparms 2r> r> al_draw_bitmap_region ;
: al_draw_tinted_scaled_rotated_bitmap_region 
   >r 
      4sfparms 2>r 2>r 3sfparms 2>r >r
         4sfparms 2>r 2>r
            4sfparms
         2r> 2r>
      r> 2r> 2r> 2r>
   r>
   al_draw_tinted_scaled_rotated_bitmap_region ;

\ void function: al_draw_tinted_bitmap_region (  ALLEGRO_BITMAP-*bitmap float-sx float-sy float-sw float-sh float-r float-g float-b float-a float-dx, float-dy, int-flags -- )
: al_draw_tinted_bitmap_region  
   >r 
      4sfparms 2>r 2>r 
         4sfparms 2>r 2>r
            2sfparms
         2r> 2r>
      2r> 2r>
   r>
   al_draw_tinted_bitmap_region  ;
