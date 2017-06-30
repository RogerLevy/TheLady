\ ==============================================================================
\ ForestLib > GameBlocks
\ Rectangles
\ ========================= copyright 2014 Roger Levy ==========================


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
