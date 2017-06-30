
image l1bg.image data/l1misc/l1bg.jpg
sample *hallucination* data/l1misc/lvl 1 hallucination.ogg
stream *l1bgm*   data/l1misc/Level 1.ogg
stream *l1scratch* data/l1misc/LVL 1 record scratch.ogg

0 value bighead

fload l1door
fload l1glass
fload l1baseroom

0 value l1bgm

: l1-defaultbgfg
   l1bg.image setbg
   yellowfilter50.image setfg
      FX_MULTIPLY fg >blendmode !
   0 0 at %darkcorners one drop
   *glassframe
   ;


: l1-defaultbgm
   looped *l1bgm* 1.0 sndvol! snd to l1bgm
   looped *l1scratch* 0.75 sndvol!
;
