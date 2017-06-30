fload redghost

\ assets
image l3bg.image data/l3misc/Level 3 PRE blurred.jpg
sample *l3scratch* data/l3misc/LVL3 Record Scratch.ogg
stream *l3bgm* data/l3misc/Level 3 soundscape.ogg

\ fg glass
create glass %billboard instance,
glass { glass2.image bitmap! FX_SCREEN blendmode ! 0.5 0.5 0.5 dspt -> tint! }
: *glassframe glass dup fg addto { 0 0 0 x 3! 1.0 dspt -> uscale! vis on FX_MULTIPLY blendmode ! } ;


0 value kuro

%blackoverlay ~> %dark
   stays off
   =fg 1 + priority !
   FX_SUBTRACT blendmode !
   1.0 1.0 1.0 tint!
   0 alpha!
endp

: *l3fg
   yellowfilter25.image setfg FX_MULTIPLY fg >blendmode !
   0 0 at %darkcorners one drop
   *glassframe
   %dark one to kuro ;
   
0 value bgm

10 value target-killcount
variable s
\ KILLCOUNT is shared with redghost.f (sloppy quick solution since i don't have event listeners yet)
: wave
   10 to target-killcount 
   s @ delete 0 killcount ! 
   swap [[ me s ! dup execute ]] parallel 
   [[ killcount @ target-killcount >= if execute end then ]] parallel ;

variable c
: constrict-to
   >r SINE EASE-IN-OUT c r> 120 tween
   0 [[ c @ letterbox!   120 lifetime @ = when end ]] parallel ;

variable v
: change-bgm-volume
   >r SINE EASE-IN-OUT v r> 120 tween
   0 [[ bgm snd! v @ sndvol!   120 lifetime @ = when end ]] parallel
;

variable l
: change-lighting
   >r SINE EASE-IN-OUT l r> 60 tween
   0 [[ l @ kuro { alpha! }  60 lifetime @ = when end ]] parallel
;



\ spawning offscreen
: offscreenx   ( -- x. ) begin roomw @ rnd 1p dup cam @ 150.0 - dup vw 1p + 150.0 + within while drop repeat ;

0 value it
: wave4p2
   675.0 constrict-to
   0.33 change-lighting
   0.25 change-bgm-volume
   
   [[
      14 to target-killcount
      %redghostwanderer allof [[ { hp @ if 0 hurt then } ]] execs
      begin
         killcount @ 15 < while 
         2 delay
         %redghostflailer numberof 3 < if 
            offscreenx 0 at %redghostflailer one {
               me to it x 2@ 300 [[ %redghostflailer enttype @ = me it <> and ]] inradius countof if end then
            }
         then
      repeat
   ]] [[ whiteflash [[ ]] [[ ]] wave   5 [[ delay complete-level ]] parallel ]] wave
;


: wave4
   675.0 constrict-to
   [[
      23 to target-killcount
      begin
         0.5 delay
         %redghostwanderer numberof 10 < killcount @ target-killcount < and if
            offscreenx 0 at %redghostwanderer one {
               me to it x 2@ 300 [[ %redghostwanderer enttype @ = me it <> and ]] inradius countof if end then
            }
         then
      again
   ]] [[ wave4p2 ]] wave
;

fload l3r1w3layout
fload l3r1w3p2layout

: wave3
   800.0 constrict-to
   1.45 change-bgm-volume
   l3r1w3layout
   [[ killcount @ 5 = if l3r1w3p2layout nod then ]]
      [[
         %redghostmole allof [[ kill ]] execs
         wave4
      ]] wave
;


: wave2
   950.0 constrict-to
   1.0 change-bgm-volume
   [[
      begin
         1 delay %redghostbezerk numberof 1 <= killcount @ target-killcount < and if
            -200.0 player >x @ 1300.0 - between player >x @ 1300.0 + roomw @ 1p 200.0 + between either 0 roomw @ 1p clamp
            0 at %redghostbezerk one drop
         then
      again
   ]] [[ wave3 ]] wave
;


: wave1
   \ 1152.0 constrict-to
   0 change-lighting
   bgm snd! 0.5 dup v ! sndvol! 
  
   [[
      begin
         begin 1 delay
            %redghostpopper numberof 1 killcount @ target-killcount < and <=
            player >x 2@ 1200 [[ %redghostpopper enttype @ = ]] inradius countof 0= and until
         counter bud !
         player >x @ dup 1000.0 - swap 650.0 - between player >x @ dup 650.0 + swap 1000.0 + between either 0 roomw @ 1p clamp
         0 at %redghostpopper one drop
         1.0 3.0 between delay
      again
   ]] [[ wave2 ]] wave
;


%room ~> %l3room
   noop: layout
   
   : l3room-start
      0 s !
      l3:| player-emotion
      looping *l3bgm* snd to bgm 
      0.1 [[ delay looping *l3scratch* end ]] parallel
      l3bg.image setbg
      0 bud !
      counter bud !
      *l3fg
      0 nextpri ! layout @ execute
      0 player >y !
      wave1
      \ player { be-upside-down } 
;

   start: l3room-start  ;
endp

: start-in-center   roomw @ 1p 2 / roomh @ 1p startpos 2! ;
: start-at-left     vw 2 / 1p roomh @ 1p startpos 2! ;
: start-at-right    roomw @ vw 2 / - 1p roomh @ 1p startpos 2! ;
: @layout   roomname count load-layout roomname find 0= abort" Layout's name doesn't match its file's name" layout ! ;
: l3room    %l3room room: roomdef define @layout start-in-center ;


2.0 1.0 l3room l3r1 l3r1layout


\ ==================================================================================================
\ Map

1 1   3 level: level3
   l3r1 ,   
   0 0 startloc 2!
   start:  vh 1p c !    c p? ;
   