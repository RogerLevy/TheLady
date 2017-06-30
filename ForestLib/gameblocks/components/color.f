pstruct %color
  1.0 var: rc
  1.0 var: gc
  1.0 var: bc  
  1.0 var: ac
  
  macro: red@  .rc @ ;
  macro: red!  .rc ! ;
  macro: +red  .rc +! ;
  
  macro: green@  .gc @ ;
  macro: green!  .gc ! ;
  macro: +green  .gc +! ;

  macro: blue@  .bc @ ;
  macro: blue!  .bc ! ;
  macro: +blue  .bc +! ;

  macro: alpha@  .ac @ ;
  macro: alpha!  .ac ! ;
  macro: +alpha  .ac +! ;

  \ darken, lighten
  \ macro: color.scale  dup >r 2@ scale2d r> 2! ;
  
  \ macro: blend
  
  macro: rgba  4@ ;
  macro: color! ( r. g. b. a. color -- ) 4! ;
  
  macro: color.clear  4 0 ifill ;
  macro: color.copy   4 imove ;
  
  : color,  ( r. g. b. a. ) 2swap swap , , swap , , ;
  
endp

