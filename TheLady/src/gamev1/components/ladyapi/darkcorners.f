%billboard ~> %darkcorners
   $DEADBEEF priority !
   FX_SUBTRACT blendmode !
   darkcorners.image bitmap!
   0 z !
   start:
      0 perform
      begin
         0.14 0.2 ~ alpha!
         0.04 delay
      again
   ;
endp
