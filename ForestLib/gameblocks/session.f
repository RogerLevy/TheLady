\ ==============================================================================
\ ========================= copyright 2014 Roger Levy ==========================

[undefined] ~session [if]

  +opt
  \ -opt
  
  : _poppath poppath ;
  pushpath
  cd ..\rlevy-toolbelt
    include rlevy-toolbelt_2
  _poppath
  
  !home pushpath  

  session ~session

  512 constant /entslot
  1024 constant max-entities
  8 constant #levels

\ -----------------------------------------------------------------------------------------
  \ put files and definitions that should only ever be loaded once per session here.

  old-structs
  fload opengl-lite
  fload sdl
  fload allegro5-1-nofloatparams
  new-structs
  
  \ : empty  /bal clear-assets close-sound close-allegro empty report" Empty, reset Allegro" ;
  
\ -----------------------------------------------------------------------------------------

gild 

[then]

\ -----------------------------------------------------------------------------------------


fload gameblocks_2

