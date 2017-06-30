\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ Vector structs
\ ========================= copyright 2014 Roger Levy ==========================

pstruct %vec2d
  var x
  var y
  
  macro: x   .x @ ;
  macro: x!  .x ! ;
  macro: +x  .x +! ;
  macro: y   .y @ ;
  macro: y!  .y ! ;
  macro: +y  .y +! ;
  macro: xy   2@ ;
  macro: xy!  2! ;
  macro: +xy  2+! ;
  : xy?  2p? ;
  
  : vec2d.scale   dup >r 2@ scale2d r> 2! ;
  macro: vec2d.clear   2 0 ifill ;
  macro: vec2d.copy    2 imove ;
endp


%vec2d ~> %vec3d
  var z
  
  macro: z   .z @ ;
  macro: z!  .z ! ;
  macro: +z  .z +! ;

  macro: xyz   3@ ;
  macro: xyz!  3! ;
  macro: +xyz  3+! ;

  : xyz?  3p? ;
  
\  : vec3d.scale   with x 3@ scale3d x 3! ;
  macro: vec3d.clear   3 0 ifill ;
  macro: vec3d.copy    3 imove ;
endp

