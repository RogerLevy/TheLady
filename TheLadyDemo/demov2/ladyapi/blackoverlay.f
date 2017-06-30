


0 value blackoverlay

%solidoverlay begets %blackoverlay

%blackoverlay script
FX_SUBTRACT blendmode !

: blackoverlay:fade
   perform   dup alpha+! alpha@ dup 0 = swap 1.0 = or when
      0< if end else nod then
;

ondelete:  0 to blackoverlay ;

endp




: fadeout
   blackoverlay 0= if %blackoverlay one to blackoverlay then
   blackoverlay {
      0 alpha!  0.0075 blackoverlay:fade
   }
;

: fadein
   blackoverlay 0= if %blackoverlay one to blackoverlay then
   blackoverlay {
      1.0 alpha!  -0.0075 blackoverlay:fade
   }
;


%blackoverlay begets %darkness
%darkness script

endp
