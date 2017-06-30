\ ==============================================================================
\ ForestLib
\ Standard toolbelt loader
\ ========================= copyright 2014 Roger Levy ==========================

[undefined] x86 [if] true constant x86 [then]

: _poppath poppath ;
pushpath cd base
  include base     
_poppath

pushpath cd ..\.. !root poppath
pushpath          !home poppath

\ include components\misc\misc.f
\ quit
fload misc       \ FFI utilities, for/next, extended load/store words, extended arithmetic, performance measurement, psuedo-closures ( [[ ]] )
fload rnd        \ Random numbers
fload fpext      \ Floating point extensions (for FFI)
fload a
fload fixedp     \ Fixed-point operators etc 
fload float-tools 
fload prototype
fload regions

report( Loaded Roger's toolbelt [1] )
