\ ---------------------------------------------------------------------------
\ Starting room


\ camera script 1

\ track camera position - when it goes past a left or right threshold, set a flag
\ when both flags are set, track the camera til it passes the middle,
\ then, silently reveal the doors (stagnated so they're out of sync)

300.0 constant threshl
4096.0 300.0 - constant threshr
2048.0 constant midthresh


absent %bigghost ?fload l1bigghost
absent "glassfalling" ?fload glassfalling

3.0 1.0 %l1baseroom room: l1r1     L1 Starting Room


: biggie    [[ 0.2 0.2 0.2 dspt -> tint! 0 perform 1.4 delay end ]] swap setoff ;


variable shockvol  1.2 shockvol !
variable shockspd  1.0 shockspd !
: shocksound   once *hallucination* shockspd @ sndspd! shockvol @ sndvol!  ;

: big-ghost-shock
   [[
      2.2 delay
      4 for r> over biggie 0.1 delay >r next
      end
   ]] parallel  shocksound ;

%script ~> %l1r1camscript
   var broken
endp

%l1r1camscript script


: see-freedom
   0.7 shockspd !
   %bigbird big-ghost-shock reveal-doors end
;


start:
   0 broken !  hide-doors  0.9 shockvol ! 1.0 shockspd !
   post
   cam @ threshl <= if
      broken @ 1 and 0= if %bigghost big-ghost-shock 0.4 shockvol +! then
      1 broken or!
      broken @ 3 = if
         post
         cam @ midthresh >= if see-freedom then
         exit
      then
   then

   cam @ threshr >= if
      broken @ 2 and 0= if %bigghost big-ghost-shock 0.4 shockvol +! then
      2 broken or!

      broken @ 3 = if
         post
         cam @ midthresh <= if see-freedom then
         exit
      then
   then

;

roomdef define
2944.0 1152.0 startpos 2!
start:

   \ ambience
   l1-defaultbgm
   \ looping *l1scratch* 0.85 sndvol!
   l1bgm snd! 0 sndvol!
   0 [[
      0.001 +
      l1bgm snd! dup sndvol!
      dup 1.0 >= when
      end
   ]] parallel
   
   \ bg/fg
   l1-defaultbgfg

   \ objects
   0 0 vw vh 0.25 1.0 around 2dup at   [[ north ]] 3 *doors
                             boundaries 0.7 1.0 around 2+ at   [[ north ]] 3 *doors

   \ scripts
   %l1r1camscript one script1 !
   make-glass-start-falling
   l1r1:| player-emotion
;
