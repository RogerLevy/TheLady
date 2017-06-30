\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ Box data structure
\ ========================= copyright 2014 Roger Levy ==========================

: 4@  a!> @+ @+ @+ @+ ;
: 4!  a!> 2swap swap !+ !+ swap !+ !+ ;
: 4?  a!> @+ . @+ . @+ . @+ . ;

%vec2d ~> %box
  [i  var width  var height  i]
  
  aka .width .width
  aka .height .height
  
  macro: width  .width @ ;
  macro: width!  .width ! ;
  macro: +width  .width +! ;
  
  macro: height  .height @ ;
  macro: height! .height ! ;
  macro: +height .height +! ;
  
  macro: dims  .width 2@ ;
  macro: dims!  .width 2! ;
  macro: +dims  .width 2+! ;
  
  macro: box@  4@ ;
  macro: box!  4! ;
  macro: box?  4? ;
  
  : box.copy   4 imove ;
  : box.add    >r 4@ r@ +dims r> +xy ;
  : box.clear  4 0 ifill ;

endp