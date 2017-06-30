absent %scissors ?fload scissors
fload l2bigghost


variable crvisits

\ assets
image l2bg.image data/l2misc/Level 2 PRE blurred.jpg
sample *l2scratch* data/l2misc/LVL 2 Record Scratch.ogg
stream *l2bgm* data/l2misc/Level 2 soundscape.ogg
image comic.image data/maze/comic-lv2.png
image idr.image data/maze/idr.png
sample *l2idr* data/l2misc/IDR.ogg

animdata bigblacklady.scml data/bigblacklady/animdata/bigblacklady.scml

\ fg glass
create glass %billboard instance,
glass { glass1.image bitmap! FX_SCREEN blendmode ! 0.5 0.5 0.5 dspt -> tint! }
: *glassframe glass dup fg addto { 0 0 0 x 3! 1.0 dspt -> uscale! vis on } ;


: *l2fg
   yellowfilter50.image setfg FX_MULTIPLY fg >blendmode !
   0 0 at %darkcorners one drop
   *glassframe  ;


%room ~> %l2room
   noop: layout
   
   : l2room-start
      l2:| player-emotion
      0.1 [[ delay looping *l2bgm* looping *l2scratch* end ]] parallel
      l2bg.image setbg
      0 bud !
      counter bud !
      *l2fg
      0 nextpri ! layout @ execute ;

   start: l2room-start ;
endp

: start-in-center   roomw @ 1p 2 / roomh @ 1p startpos 2! ;
: start-at-left     vw 2 / 1p roomh @ 1p startpos 2! ;
: start-at-right    roomw @ vw 2 / - 1p roomh @ 1p startpos 2! ;
: @layout   roomname count load-layout roomname find 0= abort" Layout's name doesn't match its file's name" layout ! ;
: l2room    %l2room room: roomdef define @layout start-in-center ;

%billboard ~> %idrbg   idr.image bitmap!  endp

%blackoverlay ~> %flickering
   stays off
   =fg 1 + priority !
   FX_SUBTRACT blendmode !
   1.0 1.0 1.0 tint!
   
   editable on
   [i : light  0.08 alpha! glass { vis on } ; i]
   [i : dark   0.3 alpha! glass { vis off } ; i]
   [i : flick  r> dark 1 2 between pauses light 1 2 between pauses >r ; i]
   [i : flick2 r> dark 0.2 4.0 between delay light >r ; i]
   start:      
      0 perform
         dark 0.33 delay
         flick flick flick 
         begin
            light
            1 5 between delay
            flick flick flick2 flick flick2 flick flick
         again 
   ;
endp

%billboard ~> %darkceiling
   darkceiling.image bitmap! ?scale-bitmap-to-fit
   0 z !
   editable on
   =solidoverlay priority !
   FX_SUBTRACT blendmode !
   0.4 alpha!
endp



\ End (go to boss)
: goto-l2boss
   whiteflash
   0 perform 5 delay
   end
   complete-level
;




\ Shoebox room script
: bigblacklady
   0 
   [[ ]]
   [[
      >r
      $0000000 cls vw 2/ vh 2/ 2s>p 150.0 + at reset-characterinfo
      GL_GREATER 0e glAlphaFunc
      GL_ALPHA_TEST glEnable
      0 colorfx
      bigblacklady.scml to scml
      " surprised and runs away" find-animation r@ 10 + 16.6667 p* draw-spriter-animation
      
      FX_SUBTRACT colorfx
      -2e -2e vres 2@ 4 4 2+ 2s>f   tint@ 3p>f   1e r@ 10 + s>f 30e f/ f- al_draw_filled_rectangle
      r> 1 +
   ]]    2750.0 16.6667 / interlude ;
      
: shoebox-script
   0 perform <up> kpressed when 0.25 delay %soul genocide
   -60.0 cam >y +! 0.3 after
   bigblacklady
   0 perform 20.0 cam >y +! cam >y @ 0 >= when 0 cam >y ! nod 
;



2.0 1.0 l2room l2r1 l2layout_1
   start-at-left
5.0 1.0 l2room l2r2 l2layout_2
   start: l2room-start shoebox-script ;

1.0 1.0 l2room l2r3 l2layout_3
2.0 1.0 l2room l2r4 l2layout_4
5.0 1.0 l2room l2r5 l2layout_5
   start-at-left
   start: l2room-start 0 perform roomw @ rnd 1p -20.0 at 90.0 1 bloodjet ;

1.0 1.0 l2room l2r6 l2layout_6
   start: l2room-start ordered-scissors-puzzle ;
  
      
      
   

\ Instant Death Room
: jitter   0 perform begin 20 0 +put 1 4 between pauses -20 0 +put 1 4 between pauses again ;

1.0 1.0 l2room l2idr l2layout_idr
   start:
      idr.image setbg
      bg { 1.05 dspt -> uscale*! -20 -20 +put jitter }
      lady/
      5 [[ delay /lady level @ loadlevel ]] parallel
      *l2fg
      once *l2idr* 1.0 sndspd!
   ;

0 value thing
: move-the-thing   roomw @ rnd 1p thing >x ! ;

: in&out   perform dup lifetime @ 1p p* pcos negate 1.1 p* 0.19 - 
   dup  0.9 >= if move-the-thing then  alpha! ;


\ Circle Room
" l2layout_cr2" load-layout 
" l2layout_cr3" load-layout

1.0 1.0 l2room l2cr l2layout_cr1
   start:
      crvisits @ 0 = if ['] l2layout_cr1 layout ! then
      crvisits @ 2 = if ['] l2layout_cr2 layout ! then
      crvisits @ 4 = if ['] l2layout_cr3 layout ! then
      l2room-start
      blackoverlay 0= if %blackoverlay one to blackoverlay then
      blackoverlay { stays off 2.0 crvisits @ 2 / 1p + in&out }
      10 crvisits @ 2 / 1 + 3 * + [[ delay backtrack end ]] parallel
      %l2bigghost one to thing 
      crvisits ++
\      *l2fg
   ;




\ ==================================================================================================
\ Map

5 6   2 level: level2
   l2idr ,  l2cr ,   ---- ,   ---- ,   ---- ,
   ---- ,   l2r6 ,   ---- ,   l2cr ,   ---- ,
   ---- ,   ---- ,   l2r5 ,   l2idr ,  ---- ,
   ---- ,   l2cr ,   l2r3 ,   l2r4 ,   ---- ,
   ---- ,   l2idr ,  l2r2 ,   l2cr ,   ---- ,
   ---- ,   ---- ,   l2r1 ,   ---- ,   ---- ,
   2 5 startloc 2!
   start:   0 crvisits !   0 ordered-scissors-puzzle-retries ! ;
   
