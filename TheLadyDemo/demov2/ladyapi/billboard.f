
%actor begets %billboard

false var: drawportion
init: portion  0 ^ 0 ^ 1.0 ^ 1.0 ^   \ normalized coordinates


create rgn 0 , 0 , 0 , 0 ,
: portion>
   drawportion @ if
      bmp @ dup >r portion 4@ r@ bmpwh*p 2swap r> bmpwh*p 2swap rgn 4!
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
