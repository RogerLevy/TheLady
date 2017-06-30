
%blip ~> %redblip
   1.0 0.0 0.0 tint!
endp

%blip ~> %greenblip
   0.0 1.0 0.0 tint!
endp

%blip ~> %blueblip
   0.0 0.0 1.0 tint!
endp

: sprinkle ( n prototype -- ) 
   swap 0 do view somewhere at   dup one drop loop  drop ;
   
clear-stage

6 %redblip sprinkle 
6 %greenblip sprinkle 
6 %blueblip sprinkle 