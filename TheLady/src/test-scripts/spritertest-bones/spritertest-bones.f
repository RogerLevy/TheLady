


\ test
" data\lady.scml" spriter-schema value mainscml

create curpos   vres 2@ 2s>p 0.5 0.5 2p* swap , ,

mainscml use-scml
gfx-prompt
curpos 2@  at
0 0 0 draw-scml-animation

create animations #animations stack,   [[ animations push ]] each-animation

variable ccan   \ current cycling animation #
variable ca     \ current animation
fvariable apos 

: +ca ccan @ + 0 animations length wrap ccan ! ccan @ animations [] @ ca !
      0e apos f!   cr ccan @ . ;
0 +ca

\ 1e 100e f/ fvalue speed
1e fvalue speed



: testywesty-frame
   
   mouse 2s>p   1.0 viewfactor @ p/ dup 2p*
      \ vres 2@ 2s>p 0.5 0.5 2p* 2+ 
         curpos 2!
   0 cls
   curpos 2@ at
   <q> kstate if 1.0 characterinfo >rotation >z +! then
   <w> kstate if -1.0 characterinfo >rotation >z +! then
   <a> kstate if -0.05 dup characterinfo >scale 2+! then
   <s> kstate if 0.05 dup characterinfo >scale 2+! then
   <z> kpressed if -1 +ca  then
   <x> kpressed if 1 +ca then
   ca @ apos f@ f>s draw-spriter-animation
   show-frame
   poll-keyboard poll-mouse 
   ;


\ : animation-wrap   animation >duration @ s>p mod ;

: ok
   res 2@ set-viewport
   >gfx 
   begin
      ['] testywesty-frame exectime s>f 0.001e f* speed f* apos f+!
   <escape> kpressed until
   >ide ;

also ~spriter
: list
   0 0 locals| e a |
   [[ @
      0 to a
      [[ @ => report" '" e . a . ." anim' -> " name count type space  1 +to a ]] swap >animations each
      1 +to e
   ]] scml >entities each ;
previous


cr
report( === SPRITER + BONES TESTING PROGRAM === )
report( Use the following command to view other animations: )
report( <entity#> <animation#> anim )
cr
report( Use the mouse to move the current animation around. )
report( Use <q> and <w> keys to rotate. )
report( Use <a> and <s> keys to scale. )
report( use <z> and <x> keys to cycle animations. )
cr
report( Animations: [To see the list of animations again type "list".] )
list
cr


: anim   animation ca ! ok ;
: rld   " main.scml" spriter-schema dup to mainscml use-scml ; 

pushpath
500 ms
ok