\ integrates spriter
\  relies on: ~spriter framedelta

variable pause-animations

module ~scmlanimator

pstruct %scmlanimator
protected
   var obj
   var anm
   1e fvar: spd  \ float
   0e fvar: pos  \ float
   noop: onloop  ( -- )
exposed
endp

: scml:draw   
   obj @ to scml
   anm @ pos f@ f>s draw-spriter-animation ;

: ?flip
   swap flip @ 1 and if negate then
   swap flip @ 2 and if negate then ;

: scml:entdraw   ( me = displayobject, struct = scmlanimator ; -- )
   \ note we don't say "at" here because needs to be open to being controlled by parallax
   dspt >scale 2@ ?flip characterinfo >scale 2!
   dspt >pivot 2@ characterinfo >pivot 2!
   dspt >rotation >z @ characterinfo >rotation >z !
   \ TODO: copy alpha/tint etc
   scml:draw
   ;

: fduration   anm @ >duration @ s>f ;

: scml:step
   pause-animations @ ?exit
   pos f@ spd f@ framedelta f* f+
      fdup fduration f> fdup fduration f= or if
         fduration f-
         onloop @ execute
      then
   pos f!
   ;


: scml:animate!  ( animation  -- )
   anm !   0e pos f! ;

: scml:animate  ( entity# animation# -- )
   obj @ to scml   animation  scml:animate! ;

: scml:scml!    obj ! ;

: scml:speed!   p>f spd f! ;
: scml:speed@   spd f@ f>p ;

%entity reopen
   %scmlanimator inline: scmlanm
endp