\ alternate version of entity-spriter

\ integrates spriter
\  relies on: ~spriter framedelta

variable pause-animations

spriter open-package

\ module ~scmlanimator
public package scmlanimator

private

pstruct %scmlanimator
   var OBJ
   var ANM
   1e fvar: SPD  \ float
   0e fvar: POS  \ float  0.0 ... 1.0
   noop: ONLOOP  ( -- )
endp


: fduration   anm @ >duration @ s>f ;

: draw
   obj @ anm @ and -exit
   obj @ to scml
   anm @
      fduration pos f@ f* f>s draw-spriter-animation ;

: ?flip
   swap flip @ 1 and if negate then
   swap flip @ 2 and if negate then ;

: TDRAW   ( scmlanimator displaytransform -- )
   =>
   \ note we don't say "at" here because needs to be open to being controlled by parallax
   scale 2@ ?flip characterinfo >scale 2!
   pivot 2@ characterinfo >pivot 2!
   rotation >z @ characterinfo >rotation >z !
   \ TODO: copy alpha/tint etc
   -> draw
   ;

: STEP
   pause-animations @ ?exit
   anm @ -exit
   pos f@ fduration f*
      spd f@ framedelta f* f+
      fdup fduration f> fdup fduration f= or if
         fduration f-
         fduration f/
         onloop @ execute \ drop recurse ( ??? ) exit
      else
         fduration f/ 
      then
      pos f!
   ;


: ANIMATE!  ( animation  -- )
   obj @ to scml   anm !   0e pos f! ;

: ANIMATE  ( entity# animation# -- )
   obj @ to scml   animation  animate! ;

: SPEED!   => p>f spd f! ;
: SPEED@   >spd f@ f>p ;
: POS!     => s>f pos f! ;
: POS@     >pos f@ f>s ;

end-package
end-package