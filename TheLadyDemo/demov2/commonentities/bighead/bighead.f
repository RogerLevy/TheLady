\ BIG HEAD BOSS (level 1)
\ the other files can't be loaded alone anymore 1/13/14

\ Animation data
animdata bighead.scml data\bighead\animdata\lv1boss.scml
bighead.scml animation bighead_base head_base
bighead.scml animation bighead_gethit head_gethit
bighead.scml animation bighead_barbcomingout head_barbcomingout
bighead.scml animation bighead_idle head_idle
bighead.scml animation bighead_attack head_attack

\ Sounds
sample *barbstem1* data\bighead\barbwire 1.ogg
sample *barbstem2* data\bighead\barbwire 2.ogg
sample *bigheadimpact* data\bighead\Boss Head impact MORE TAIL.ogg

stream *bigheadbgm*  data\bighead\Lvl 1 Boss Soundscape.ogg

\ Images
image bighead.image data\bighead\bighead.png
\ image bighead.image data\bighead\bighead_alt.jpg
\ image bighead.image data\bighead\bighead_alt2.jpg

\ ----------------------------------------------------------------------

\ distinguish from BILLBOARD{ , this creates a prototype , that creates an instance.
: billboard   >r %billboard begets over script r> bitmap! endp ;

veinyred.image billboard %redflash

: redflash
   [[ 0 z ! fillscreen 0 alpha! 0.06 0.98 [[ 0 perform 0.4 delay -0.005 0 .. fadeto nod ]] fadeto
   ]] %redflash setoff 
;


\ %billboard begets %bighead
%actor begets %bighead
   var red1
   var red2

%bighead script
   0.49 0.49 pivot 2!

: removered
   red1 @ delete
   red2 @ delete
;

: in&out
   0 perform
   lifetime @ 1p psin 0.1 p* 0.9 + alpha!
;

: addred
   veinyred.image billboard{
      fillscreen
      0 z !
      =fg 1000 + priority !
      0.0 alpha! 0.003 0.15 .. fadeto
   me } red1 !
   veiny.image billboard{
      fillscreen
      0 z !
      =redflash priority !
      FX_MULTIPLY blendmode !
      in&out
   me } red2 !
;

endp


\ ----------------------------------------------------------------------

fload bigheadboss
fload bigheadintro

\ ----------------------------------------------------------------------



%bighead script
\ bighead.image bitmap!
bighead_idle 0 animspeed!

0 cflags !
FX_MULTIPLY blendmode !

\ default-hitbox: bighead.image 0.7 center-bitmap-box ;

   0.5 0.5 pivot 2!
   bighead-cflags cflags !
   
   :: wake  0 0 me from %bigheadintro oneslave drop vis off nod ;
   start:
      0 perform
      x @ player >x @ - 750.0 <= if wake then
   ;
