animdata bigtwitch.scml   data/l2bigghost/animdata/bigtwitchghost.scml
bigtwitch.scml animation big_twitch NewAnimation_001

\ sufferin' soul
%actor ~> %l2bigghost
   big_twitch
   =fg 100 + priority !
   0 z !
   FX_SUBTRACT blendmode !
   [i var s i]
   start:
      0 0 vw vh middle put
      post
         lifetime @ 1p 1.4 p* psin 0.1 p* 0.05 + 
         lifetime @ 50 + 1p 1.4 p* psin 0.05 p*  
         s 2@ 2+ 0.82 0.82 2+ scale 2!
   ;

endp