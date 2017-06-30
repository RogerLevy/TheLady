%image ~> %font
  var alfnt
  var alfnth
   
  : font:onload  ( #ranges addr filename count )
    image:onload 
    albmp @ -rot al_grab_font_from_bitmap alfnt !
    alfnt @ al_get_font_line_height alfnth ! ;
  
  ' font:onload prototype .onload !
  
endp

: font, ( ac- ) %font instance with asset^ ;

: font  ?create namespec font, ;

create a4ranges
  $0020 , $007F ,  \ ASCII 
  $00A1 , $00FF ,  \ Latin 1 
  $0100 , $017F ,  \ Extended-A 
  $20AC , $20AC ,  \ Euro 

4 a4ranges font a4.font a4_font.png

a4.font value fnt

: font>  fnt .alfnt @ ;

: text ( ac- ) batch[ z$ font> ALLEGRO_ALIGN_LEFT rot al-draw-text ]batch ;

: strwidth  z$ font> swap al_get_text_width ;

macro: fontheight  fnt .alfnth @ ;