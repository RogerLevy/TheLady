
0 value blackoverlay

%solidoverlay ~> %blackoverlay
   stays on

   FX_SUBTRACT blendmode !

   : blackoverlay:fade
      perform   dup alpha+! alpha@ dup 0 = swap 1.0 = or when
         0< if end else nod then
   ;

   ondelete:  0 to blackoverlay ;

endp

: ?inst   blackoverlay 0= if %blackoverlay one to blackoverlay then ;

: fadeout   ?inst  blackoverlay { vis on 0 alpha!  0.0075 blackoverlay:fade } ;
: fadeout2   ?inst  blackoverlay { vis on 0 alpha!  0.003 blackoverlay:fade } ;
: fadein     ?inst  blackoverlay { 1.0 alpha!  -0.0075 blackoverlay:fade } ;
: unfade    blackoverlay delete ;
: fadeout3   ?inst  blackoverlay { FX_NORMAL blendmode ! vis on 0 alpha! 0 0 0 tint! 0.002 blackoverlay:fade } ;  

%blackoverlay ~> %darkness
   stays off
%darkness script
endp
