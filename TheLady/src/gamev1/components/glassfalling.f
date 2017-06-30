\ [x] fix hitbox
\ [x] implement all the other shard images
remember "glassfalling"

image shard1-1.image  data/glassfalling/chunk 1.png
image shard2-1.image  data/glassfalling/chunk 2.png
image shard3-1.image  data/glassfalling/chunk 3.png
image shard4-1.image  data/glassfalling/chunk 4.png
image shard5-1.image  data/glassfalling/chunk 5.png
image shard1-2.image  data/glassfalling/pieces 1.png
image shard2-2.image  data/glassfalling/pieces 2.png
image shard3-2.image  data/glassfalling/pieces 3.png
image shard4-2.image  data/glassfalling/pieces 4.png
image shard5-2.image  data/glassfalling/pieces 5.png

create shardbmps cell [ARRAY shard1-1.image , shard2-1.image , shard3-1.image , shard4-1.image , shard5-1.image , array]
create shardbmps2 cell [ARRAY shard1-2.image , shard2-2.image , shard3-2.image , shard4-2.image , shard5-2.image , array]

variable glassfalling   \ glassfalling off
variable glassrising    \ glassrising off
variable glassfreq      1.0 glassfreq !
variable shotglass      \ shots shots shots

%billboard ~> %shard
   var bmp#
   shard1-1.image bitmap!
   0.5 0.4 pivot 2!
   hitbox: -80.0 dup 160.0 dup ;
   1.1 uscale!
   8.0 vy !
   C_WEAK C_HARMFUL or C_SHOOTABLE or cflags !
   FX_SCREEN blendmode !
   1 hp !
   start:
      shardbmps rnditem bmp# ! @ bitmap!
      360.0 rnd angle !
      0 perform 1.0 angle +! post screencull ;
endp

%shard ~> %shatterpiece 
   shard1-2.image bitmap!
   cflags off
   start: post noop ;
endp




variable c


: ?makeitrain
   shotglass @ 15 >= if 1 [[ delay 10.0 glassfreq ! 4 glassfalling ! end ]] parallel then
   
   ;

%shard script

   : shatter
      shotglass ++ ?makeitrain 
      once *glass3*
      dspt =>  bmp# @ angle @ %shatterpiece morph angle ! bmp# !
      bmp# @ shardbmps2 [] @ bitmap!
      halt
      0 perform 0.4 delay
      5 for r> vis off 0.05 delay vis on 0.05 delay >r next
      end
   ;
   
   :: hurt   drop shatter ;
   


: shard{   heavens at %shard one { ; \ }

: shards   ?dup -exit [[ for r> shard{ } 0.06 delay >r next end ]] parallel ;

: make-glass-start-falling
   glassfalling on
   1.0 glassfreq !
   0 shotglass !
   0 [[
      begin
         3.0 5.0 between glassfreq @ p/ delay
         glassfalling @ abs shards
      again
   ]] parallel ;

\ make-glass-start-falling


%shard ~> %risingshard
   =fg 1 + priority !
   cflags off
   1.8 uscale!
   2.5 z !
   0.5 0.5 0.5 tint!
   [i
   var av
   i]
   start:
      x 3@ 1.0 2p* x 2!
      -0.1 0.1 between av !
      4 rnd 0 = if -1.5 -3.0 else -20.0 -50.0 then between vy !
      shardbmps rnditem bmp# ! @ bitmap!
      360.0 rnd angle ! 0 perform av @ angle +! post y @ -300.0 <= if end then ;
   
endp

: ?floor     roombox 0 1.0 between 1.2 around ;
: ?room       roombox 0 1.0 between 0 1.0 between around ;
: rshard{    %risingshard one { ; \ }
: rshards    ?dup -exit [[ for r> ?floor at rshard{ } 0.1 0.3 between delay >r next end ]] parallel ;

: make-glass-start-rising
   20 #screens * for ?room at rshard{ } next    \ have some on screen already
   glassrising on
   1.0 glassfreq !
   0 shotglass !
   0 [[ begin
         0.25 0.5 between glassfreq @ p/ delay
         glassrising @ abs #screens * rshards
      again
   ]] parallel ;
