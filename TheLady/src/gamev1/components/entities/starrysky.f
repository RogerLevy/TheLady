image starbg.image data/retroboss/Boss Battle Background.png

%billboard ~> %starrysky
   starbg.image bmp !
   
   [[
      bmp @ -exit
      y @ 0 bmph wrap y !
      FX_NORMAL colorfx
      x 2@ at          bmp @ pentire   dspt   blitrgnexp
      x 2@ bmph - at   bmp @ pentire   dspt   blitrgnexp
      x 2@ bmph + at   bmp @ pentire   dspt   blitrgnexp
   ]] ondraw !
endp