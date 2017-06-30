%billboard begets %bgpart
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

%bgpart begets %bg
%bg script
   bgchildren children !
endp

%billboard begets %fg
%fg script
   0 z !   fgchildren children !
   start:  fgchildren vacate ;
endp


: scale-bitmap-to-fit
   vres 2@   bmp @ bitmap-size ( 2 2 2+ ) 2p/  dspt >scale 2! ;

: ?scale-bitmap-to-fit
   bmp @ bitmap-size  vh < swap vw < or if scale-bitmap-to-fit then ;

: fillscreen
   ( -2.0 -2.0 x 2! ) 0 0 x 2! ?scale-bitmap-to-fit 0 z ! ;

: setbg   ( image/bitmap -- )   0 0 at  %bg one dup to bg { bitmap! ?scale-bitmap-to-fit *tilebg } ;
: setfg   ( image/bitmap -- )   0 0 at  %fg one dup to fg { bitmap! ?scale-bitmap-to-fit } ;
