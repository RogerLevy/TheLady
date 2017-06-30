image l1bigghost.image  data/l1bigghost/Lvl-1-ghost-sumitest.png
image l1birdshock.image  data/l1bigghost/birdcloseup2.jpg

\ animdata bigtwitch.scml   data/l1bigghost/animdata/bigtwitchghost.scml

\ bigtwitch.scml animation big_twitch NewAnimation_001



(
%actor ~> %bigtwitch
%bigtwitch script
   0 z !
   big_twitch 2.0 animspeed!
   FX_SCREEN blendmode !
   0.06 0.06 0.06 tint!
endp
)

%billboard ~> %bigghost
   dvar s

%bigghost script
   0 z !
   l1bigghost.image bitmap!
   bmp @ bitmap-size drop vres @ 2p p/ dup s 2!
   FX_SCREEN blendmode !
start:
   =fg 100 + priority !
   0.5 0.4 pivot 2!
   0 0 vw vh middle put


   post
      lifetime @ 1p 2.0 p* psin 0.1 p* 0.05 + 
      lifetime @ 50 + 1p 2.0 p* psin 0.05 p*  
      s 2@ 2+ 1.0 1.0 2+ scale 2!
;
endp

%bigghost ~> %bigbird
   l1birdshock.image bitmap!
   fillscreen
   scale 2@ s 2!
   FX_ADD blendmode !
start:
   =fg 100 + priority !
   0.5 0.5 pivot 2!
   0 0 vw vh middle put
   post
      lifetime @ 1p 2.0 p* psin 0.1 p* 0.05 +
      lifetime @ 50 + 1p 2.0 p* psin 0.05 p*
      s 2@ 2+ 1.0 1.0 2+ scale 2!
;
endp
