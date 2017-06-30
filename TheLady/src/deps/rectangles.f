
\ Rectangles

0  var x1  var y1   var width var height  constant /rect

aka width size
aka >width >size
aka width x2
aka height y2
aka >width >x2
aka >height >y2


\ : 4@   dup @ swap cell+ dup @ swap cell+ dup @ swap cell+ @ ;
: 4@   a!> @+ @+ @+ @+ ;
: 4!   a!> 2swap swap !+ !+ swap !+ !+ ;
: 4?   a!> @+ . @+ . @+ . @+ . ;


: around  ( x y w h xf. yf. -- x y )
   2p* 2+ ;

: middle   ( x y w h -- x y )
   0.5 0.5 around ;

: somewhere  ( x y w h -- x y )
   2rnd 2+ ;

: overlap? ( xyxy xyxy -- flag ) 2swap 2rot rot swap > -rot > or >r rot < -rot swap < or r> or not ;
