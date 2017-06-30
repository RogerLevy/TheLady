\ relies on:
\  pen %displaytransform



create sprbuf   %spritetimelinekey instance,
0 value scml
\ create CHARACTERINFO    %spatialinfo instance,
create absinfo          %spatialinfo instance,
create bonekeys         513 %bonetimelinekey sizeof array,
0 bonekeys [] >info constant CHARACTERINFO
%spatialinfo CHARACTERINFO initialize

0 value bki  \ bonekey index   
0 value playhead  \ int

\ implement a pool-stack of bonetimelinekeys, pretty painless.
: boneinfo[]   1 + bonekeys [] >info ;
: bonekey>   bki bonekeys []    %bonetimelinekey over initialize    1 +to bki ;
: clear-bonekeys   1 to bki ;

: time>mainlinekey ( struct=animation time -- mainlinekey )
   duration @ mod
   0 locals| k t |
   [[ @ =>   time @ t <= if  struct to k   then   ]] mainlinekeys each   k ;
;

: looping?   looptype @ ; 

: interpolate:keys   ( keya keyb time nexttime )
   3drop 
;

: ref>key ( ref -- timelinekey )   
   playhead   over >timeline @ timelines [] @   
   third >key @ over >keys [] @   0 dup   locals| keybtime keyb keya tl t r |
   tl >keys length 1 = if keya exit then
   r >key @ 1 + ( nextindex )   
   dup tl >keys length >= if   looping?  if  drop 0  else  keya exit   then   then   
   ( nextindex ) tl >keys [] @ to keyb   
   keyb >time @ to keybtime
   keybtime keya >time @ < if   duration @ +to keybtime   then
   keya keyb t keybtime   interpolate:keys
;

: bitmap>   ( struct = timelinekey ) skfile @ skfolder @ scml >folders [] @ >files [] @ >bmp @ ;
: entity    scml >entities [] @ ;
: ANIMATION  ( entity# animation# -- animation ) swap entity >animations [] @ ;


\ ----------------------------------------------------------------------------------

: unmapFromParent   ( struct = spacialinfo ; parentinfo destinfo -- )
   locals| dest parent |
   
   angle @ 
      parent >scale 2@  p*  0< if  360.0 swap -  then
      parent >angle @   +   dest >angle !
 
   scale 2@   parent >scale 2@   2p*   dest >scale 2!
   
   ( a @ parent >a @ p* dest >a ! )

   parent >px 2@ 
   px 2@ or if
      px 2@   parent >scale 2@  2p*
      parent >angle @ 2rotate    2+
   then
   dest >px 2!

  \ pivot 2@ dest >pivot 2!
   ;

( no tweening )
: parented ( objectref -- timelinekey spacialinfo )
   dup ref>key locals| key ref |
   ref >parent @ boneinfo[]  ( info ) absinfo   key >info -> unmapFromParent 
   key absinfo ;

\ TODO: support charactermap 
: ?usedefaultpivot  ( struct = spritetimelinekey ; spacialinfo -- )
   usedefaultpivot @ if
      skfolder @ scml >folders [] @ skfile @ swap >files [] @ >pivotx 2@
         rot ( info ) >pivot 2!
   else drop then 
;

: +bonekey   ( spacialinfo -- ) bonekey> >info %spatialinfo clone ;

: transform-bones  ( struct = animation ; mainlinekey -- )
   clear-bonekeys   [[ @   parented +bonekey drop  ]] swap >bonerefs each ;

\ test .... result: it sucks (but don't get rid of just yet)
variable ALTFLIP

: draw-objectref ( struct = animation ; objectref -- )
   ( objectref ) parented ( absinfo ) >r 
   r@ >px 2@  negate at
   
   altflip @ if characterinfo >scale 2@ p* 0< if r@ >scale >y dup @ negate swap ! then then
   
   ( key ) r@  over -> ?usedefaultpivot
   ( key ) -> bitmap> pentire r> blitrgnexp ;

: draw-objects ( struct = animation ; mainlinekey time -- )
   [[ @ draw-objectref ]] swap >objectrefs each ;

\ ----------------------------------------------------------------------------------

: DRAW-SPRITER-ANIMATION  ( animation time -- )
   to playhead    pen 2@ negate characterinfo >px 2!
   => playhead time>mainlinekey ( key ) dup transform-bones draw-objects ;
      
: DRAW-SCML-ANIMATION  ( entity# animation# time -- )
   >r animation r> draw-spriter-animation
;

: USE-SCML   ( scmlobject -- ) to scml ;

\ ----------------------------------------------------------------------------------

: FREE-SPRITER-ASSETS  ( scmlobject -- )
   [[ @ [[ @ >bmp @ destroy-asset ]] swap >files each ]] swap >folders each ;
   
   
: ANIMATION-EXISTS?  ( entity# animation# -- flag )
   locals| a e |
   e scml >entities length < if
      a e scml >entities [] @ >animations length < exit
   else false then ;

0 value xt
: EACH-ANIMATION ( xt -- ) ( animation -- )
   xt >r to xt
   [[ @ [[ @ xt execute ]] swap >animations each ]] scml >entities each
   r> to xt
;

: FIND-ANIMATION ( addr c -- animation | 0 )
   2dup upcase 0 locals| res c addr |
   [[ dup count 2dup upcase addr c  compare 0= if to res else drop then ]] each-animation res
   dup 0= if cr addr c type -1 space space abort" <-- Animation not found." then ;
   

: #ANIMATIONS   0 [[ drop 1 + ]] each-animation ;

: RESET-CHARACTERINFO  %spatialinfo CHARACTERINFO initialize ;