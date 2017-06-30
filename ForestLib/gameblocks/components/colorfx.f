\ ==============================================================================
\ ForestLib > GameBlocks
\ RGB blending and bitwise blending
\ ========================= copyright 2014 Roger Levy ==========================

create blendfx
      
      ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_INVERSE_ALPHA , \ normal (alt)
      ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_ONE ,  \ add
      ALLEGRO_DEST_MINUS_SRC , ALLEGRO_ALPHA , ALLEGRO_ONE , \ subtract
      ALLEGRO_ADD , ALLEGRO_DEST_COLOR , ALLEGRO_INVERSE_ALPHA , \ multiply
      ALLEGRO_ADD , ALLEGRO_ONE , ALLEGRO_INVERSE_SRC_COLOR , \ screen
      ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_INVERSE_ALPHA , \ normal (alt)
      ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_INVERSE_ALPHA , \ normal (alt)
      ALLEGRO_ADD , ALLEGRO_ALPHA , ALLEGRO_INVERSE_ALPHA , \ normal (alt)


create logicfx
      GL_XOR ,
      GL_CLEAR ,
      GL_INVERT ,
      GL_SET ,
      GL_COPY_INVERTED ,
      GL_COPY ,
      GL_COPY ,
      GL_COPY ,

0 constant FX_NORMAL
1 constant FX_XOR
2 constant FX_ADD
3 constant FX_BLACK
4 constant FX_SUBTRACT
5 constant FX_INVERT
6 constant FX_MULTIPLY
7 constant FX_WHITE
8 constant FX_SCREEN
9 constant FX_INVERSE

11 constant FX_OPAQUE

: colorfx   ( n -- )
   dup 1 >> 7 and swap 1 and if
      GL_COLOR_LOGIC_OP glEnable
      cells logicfx + @ glLogicOp
   else
      GL_COLOR_LOGIC_OP glDisable
      3 cells * blendfx + 3@
      ALLEGRO_ADD ALLEGRO_ZERO ALLEGRO_ONE al_set_separate_blender
   then ;
