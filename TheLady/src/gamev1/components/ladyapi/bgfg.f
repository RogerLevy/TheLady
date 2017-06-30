%billboard ~> %bgpart
   =bg priority !   zbg z !
endp

: *tilebg
   level> -exit
   bgchildren vacate
   bg atop
   bmp @ bitmap-size drop 1p
   roomw @ vres @ / 1 - 0 max 0 ?do
      dup   bmp @   %bgpart one dup bg addto { bitmap! x ! }
      bmp @ bitmap-size drop 1p + 
   loop drop ;

%bgpart ~> %bg
%bg script
   bgchildren children !
endp

%billboard ~> %fg
%fg script
   0 z !   fgchildren children !
   start:  fgchildren vacate ;
endp


: setbg   ( image/bitmap -- )   0 0 at  %bg one dup to bg { vis on bitmap! ?scale-bitmap-to-fit *tilebg } ;
: setfg   ( image/bitmap -- )   0 0 at  %fg one dup to fg { vis on bitmap! ?scale-bitmap-to-fit } ;
