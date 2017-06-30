\ ==============================================================================
\ ForestLib > GameBlocks
\ DisplayTransform object
\ ========================= copyright 2014 Roger Levy ==========================

pstruct %displaytransform
  mark: position  0 ^ 0 ^ 0 ^
  mark: scale
  1.0 var: scalex
  1.0 var: scaley
  1.0 var: scalez
  mark: rotation  0.0 ^ 0.0 ^ 0.0 ^
  mark: pivot     0.0 ^ 0.0 ^ 0.0 ^
  mark: tint
  1.0 var: red
  1.0 var: green
  1.0 var: blue  
  1.0 var: alpha
  1.0 var: worldalpha


  \ 2d transforms

  [i
    var tx var ty
    1.0 var: a
    var b
    var c
    1.0 var: d
    
    0 value rc
    0 value sr
    0 value a00
    0 value a01
    0 value a10
    0 value a11
    0 value a02
    0 value a12
    0 value b00
    0 value b01
    0 value b10
    0 value b11
    0 value pivotx
    0 value pivoty
  i]
  
  : >angle  " >rotation >z " evaluate ; immediate
  : angle  " rotation >z" evaluate ; immediate

  \ Note that PIVOT is used differently by this function and, for example, sprites.
  \ Sprites and billboards might use it as a proportional value, this treats it as in pixels.

  : (localtransform)
    angle @ dup psin to sr pcos to rc
    pivot 2@ to pivoty to pivotx
    scale >x 2@ 2dup  
      sr p* negate to a01
      rc p* to a00
      rc p* to a11
      sr p* to a10
    position 2@ 
      a11 pivoty p* - pivotx a10 p* - to a12
      a00 pivotx p* - pivoty a01 p* - to a02 ;

  : update-displaytransform ( parenttransform displaytransform -- )
    swap locals| parent | 
    =>
    (localtransform)
    
    parent >a 2@ to b01 to b00
    parent >c 2@ to b11 to b10
    
    b00 a00 p* b01 a10 p* + 
    b00 a01 p* b01 a11 p* +
      a 2!
    b00 a02 p* b01 a12 p* + parent >tx @ + 
    b10 a00 p* b11 a10 p* + 
    b10 a01 p* b11 a11 p* +
      c 2!
    b10 a02 p* b11 a12 p* + parent >ty @ +
      tx 2!
    alpha @ parent >alpha @ p* worldalpha !
  ;
  
  \ only updates transform based on local transform info and parent's position
  \ does inherit alpha
  : update-displaytransform-upright ( parenttransform displaytransform -- )
    swap locals| parent | 
    =>
    (localtransform)
    a00 a01 a 2!
    a02 parent >tx @ + 
    a10 a11 c 2!
    a12 parent >ty @ +
      tx 2!
    alpha @ parent >alpha @ p* worldalpha !
  ;
    
  : >worldpos@  >tx 2@ ;

endp

