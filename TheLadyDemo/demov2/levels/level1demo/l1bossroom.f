\ ---------------------------------------------------------------------------
\ Level 1 "Big Head" boss room

absent %bighead ?fload bighead

variable glassa
0 value darkness

: prebighead
   %darkness one to darkness
   darkness { 0.4 alpha! }
   0.2 glassa ! glass { glassa @ dup dup tint! 1 flip ! }
   *bossglassframe
   bighead { 0.6 0.6 0.75 tint! }

   0 [[
      player >x @ roomw @ 1500 - 1p >= if
         roomw @ 1p vres @ 1p - bounds !
         darkness { -0.012 0 .. fadeto }
         0 perform
               glass { glassa @ 0.006 + 0.35 min glassa !  glassa @ dup dup dup tint! } 0.35 >=
                  when end
      then
   ]] parallel
;


3.25 1.0 %l1baseroom room: l1boss Boss room

roomdef defineroom
400.0 1152.0 startpos 2!
construct:
   \ ambience
   looped *l1scratch* 0.85 sndvol!

   \ bg/fg
   l1bg.image setbg
   yellowfilter50.image setfg      \ necessary for glass frame to work
      FX_MULTIPLY fg >blendmode !
   *bossglassframe
   bg {
      0.8 0.9 1.0 tint!
      [[ @ { 0.8 0.9 1.0 tint! } ]] children @ each
   }

   \ objects
   roomw @ 600 - vh 2 / at %bighead one to bighead

   \ scripts
   -400.0 camofs !
   prebighead
   make-glass-start-falling
   glassfalling off
   player { right direction ! idle }
   calm player emote
;
