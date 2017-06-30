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

create shardbmps 5 cell ARRAY> shard1-1.image , shard2-1.image , shard3-1.image , shard4-1.image , shard5-1.image ,
create shardbmps2 5 cell ARRAY> shard1-2.image , shard2-2.image , shard3-2.image , shard4-2.image , shard5-2.image ,



\ [] fix hitbox
\ [] implement all the other shard images

%billboard begets %shard
   var bmp#
endp

%shard script

shard1-1.image bitmap!
0.5 0.4 pivot 2!
default-hitbox: -80.0 dup 160.0 dup ;
1.1 dup scale 2!
8.0 vy !
C_WEAK C_HARMFUL or C_SHOOTABLE or cflags !
FX_SCREEN blendmode !
1 hp !
start:
   shardbmps rnditem bmp# ! @ bitmap!
   300.0 rnd angle !
   [[ screencull ]] 'post !   0 perform 1.0 angle +!  ;


%shard begets %shatterpiece
endp

%shatterpiece script

shard1-2.image bitmap!
cflags off
start:
   post noop ;

%shard script
: shatter
   ( TODO: could pass in shard variety #)
   once *glass3*
   dspt =>  bmp# @ angle @ %shatterpiece morph angle ! bmp# !
   bmp# @ shardbmps2 [] @ bitmap!
   halt
   0 perform 0.4 delay
   5 for r> vis off 0.05 delay vis on 0.05 delay >r next
   end
;
:: hurt   drop shatter ;

: shard{   heavens at %shard one { ;

: shards   ?dup -exit [[ for r> shard{ } 0.06 delay >r next end ]] parallel ;

variable glassfalling   glassfalling on
variable glassfreq      1.0 glassfreq !

: make-glass-start-falling
   glassfalling on
   0 [[
      begin
         3.0 5.0 between glassfreq @ p/ delay
         glassfalling @ abs shards
      again
   ]] parallel ;

make-glass-start-falling
