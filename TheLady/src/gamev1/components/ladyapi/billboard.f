
%actor ~> %billboard

false var: drawportion
0 field portion  0 ^ 0 ^ 1.0 ^ 1.0 ^   \ normalized coordinates


create rgn 0 , 0 , 0 , 0 ,
: portion>
   drawportion @ if
      bmp @ dup >r 4@ r@ bmpwh*p 2swap r> bmpwh*p 2swap rgn 4!
         rgn      ( bitmap rgn )
   else bmp @ pentire then ;

: billboard-render
   bmp @ -exit
   flipflags @
      flip @ flipflags ! 
      blendmode @ colorfx   x 3@ scrolled at   portion>   dspt   blitrgnexp
   flipflags ! ;

[[ ?nodraw ?exit  billboard-render  ?drawchildren ]] ondraw !

endp


: bitmap!   bmp ! ;

: billboard{   %billboard one { bitmap! dspt s! ; \ }


: scale-bitmap-to-fit
   vres 2@   bmp @ bitmap-size ( 2 2 2+ ) 2p/  dspt >scale 2! ;

: ?scale-bitmap-to-fit
   bmp @ bitmap-size  vh < swap vw < or if scale-bitmap-to-fit then ;

: fillscreen
   ( -2.0 -2.0 x 2! ) 0 0 x 2! ?scale-bitmap-to-fit 0 z ! ;
