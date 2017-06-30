image kill1.frame data/killscreen/killscreen__000.jpg
image kill2.frame data/killscreen/killscreen__001.jpg
image kill3.frame data/killscreen/killscreen__002.jpg
image kill4.frame data/killscreen/killscreen__003.jpg
image kill5.frame data/killscreen/killscreen__004.jpg
image kill6.frame data/killscreen/killscreen__005.jpg
image kill7.frame data/killscreen/killscreen__006.jpg
image kill8.frame data/killscreen/killscreen__007.jpg
image kill9.frame data/killscreen/killscreen__008.jpg
image kill10.frame data/killscreen/killscreen__009.jpg
image kill11.frame data/killscreen/killscreen__010.jpg
image kill12.frame data/killscreen/killscreen__011.jpg
image kill13.frame data/killscreen/killscreen__012.jpg
image kill14.frame data/killscreen/killscreen__013.jpg
image kill15.frame data/killscreen/killscreen__014.jpg
image kill16.frame data/killscreen/killscreen__015.jpg
image kill17.frame data/killscreen/killscreen__016.jpg
image kill18.frame data/killscreen/killscreen__017.jpg
image kill19.frame data/killscreen/killscreen__018.jpg
image kill20.frame data/killscreen/killscreen__019.jpg
image kill21.frame data/killscreen/killscreen__020.jpg
image kill22.frame data/killscreen/killscreen__021.jpg
image kill23.frame data/killscreen/killscreen__022.jpg
image kill24.frame data/killscreen/killscreen__023.jpg
image kill25.frame data/killscreen/killscreen__024.jpg
image kill26.frame data/killscreen/killscreen__025.jpg
image kill27.frame data/killscreen/killscreen__026.jpg
image kill28.frame data/killscreen/killscreen__027.jpg
image kill29.frame data/killscreen/killscreen__028.jpg
image kill30.frame data/killscreen/killscreen__029.jpg
image kill31.frame data/killscreen/killscreen__030.jpg
image kill32.frame data/killscreen/killscreen__031.jpg

create killframes  cell [array
   kill1.frame    ,
   kill2.frame    ,
   kill3.frame    ,
   kill4.frame    ,
   kill5.frame    ,
   kill6.frame    ,
   kill7.frame    ,
   kill8.frame    ,
   kill9.frame    ,
   kill10.frame   ,
   kill11.frame   ,
   kill12.frame   ,
   kill13.frame   ,
   kill14.frame   ,
   kill15.frame   ,
   kill16.frame   ,
   kill17.frame   ,
   kill18.frame   ,
   kill19.frame   ,
   kill20.frame   ,
   kill21.frame   ,
   kill22.frame   ,
   kill23.frame   ,
   kill24.frame   ,
   kill25.frame   ,
   kill26.frame   ,
   kill27.frame   ,
   kill28.frame   ,
   kill29.frame   ,
   kill30.frame   ,
   kill31.frame   ,
   kill32.frame   ,
array]



image killb1.frame data/killscreen/frames_0006_Layer-3.jpg
image killb2.frame data/killscreen/frames_0005_Layer-4.jpg
image killb3.frame data/killscreen/frames_0004_Layer-5.jpg
image killb4.frame data/killscreen/frames_0003_Layer-6.jpg
image killb5.frame data/killscreen/frames_0002_Layer-7.jpg
image killb6.frame data/killscreen/frames_0001_Layer-8.jpg
image killb7.frame data/killscreen/frames_0000_Layer-9.jpg

create killframesb   cell [array
   killb1.frame , 
   killb2.frame , 
   killb3.frame , 
   killb4.frame , 
   killb5.frame , 
   killb6.frame , 
   killb7.frame , 
array]


%billboard ~> %gameover
   0 z !
   -1 priority !
   
: shake
   scale 2@ 1.05 dup 2p* scale 2!
   post   lifetime @ 1 and if -10.0 vx ! else 10.0 vx ! then
;

: (otherthing)   killframesb rnditem drop @ bitmap! fillscreen shake ;
: otherthing   (otherthing)  0.15 0.4 between delay idle ;
   
   
:: idle
   ['] noop 'post !  halt
   0 perform
   lifetime @ 2 / killframes []wrap @ bitmap!
   60 rnd 0 = if otherthing then
   <esc> kpressed <f4> kpressed or <enter> kpressed or <space> kpressed or
      if dev? if -1 throw else 0 ExitProcess then then
;
start:
   idle
   post
   fillscreen
;
endp




\ image lloyd.image data/misc_images/fuckinlloyd.png
stream *killscreen* data/misc_sfx/killscreen Audio.ogg

\ %billboard ~> %lloyd
\    0 priority !
\   4.5 uscale!
\   lloyd.image bitmap!
\   0.5 1.0 pivot 2!
\ endp

: creep
   -1 rnd perform
   begin
   dup 60 mod 2 max pauses
   dup hilo 20.0 mod dup 1 and if negate then swap 20.0 mod dup 1 and if negate then x 2+!
   again ;

: glitchout
   counter bud ! 
   [[
      enttype @ %gameover = ?exit
      0.5 2.0 between scale >x @ p* scale >x !
      0.5 2.0 between scale >y @ p* scale >x !
      6 rnd case
         0 of 100.0 vy ! endof
         1 of 0.1 vx ! endof
         2 of 30.0 animspeed! endof
         3 of dspt >scale 2@ 2negate dspt >scale 2! endof
         4 of view somewhere put endof
         5 of creep endof
      endcase
   ]] all
   
   counter bud ! 
   \ 10 rnd 4 = if player { %lloyd morph } then
;


: sample?
   onload @ ['] sample:onload = ;

create smps 100 stack,

: anysound
   counter bud !
   smps vacate
   [[ @ s! sample? if struct smps push then ]] assets each
   smps length -exit
   smps rnditem drop @ once playsample
   0.5 2.0 between sndspd!
   \ 0.2 0.4 between 
   ;


0 value gmov

: (forever)  0 perform noop ;

: freeze/quit
   gofor
\   for 1 gofor

\   next
;

: gameover
   bg ?dup if delete then
   fg ?dup if delete then
   can-pause off 
   counter bud !
   haltall clear-sounds
   [[
      40 60 between freeze/quit
      %gameover one to gmov
         looping *killscreen*   
         1 60 * 2 60 * between freeze/quit
         glitchout
         4 60 * 5 60 * freeze/quit
         anysound snd 15 freeze/quit stopsound
         3 60 * freeze/quit
         anysound snd 15 freeze/quit stopsound
         glitchout
         3 60 * freeze/quit
      clear-sounds clear-blood haltall gmov { (otherthing) }
   
      60 5 * gofor 0 ExitProcess 
   ]] catch throw
;

