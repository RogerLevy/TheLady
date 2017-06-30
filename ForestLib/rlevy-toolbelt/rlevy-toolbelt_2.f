\ ==============================================================================
\ ForestLib
\ Standard toolbelt loader
\ ========================= copyright 2014 Roger Levy ==========================

[undefined] x86 [if] true constant x86 [then]

: _poppath poppath ;
pushpath cd base
  include base_2   \ includes non standard words, floating point, and fixed-point interpreter extension
_poppath

pushpath cd ..\.. !root poppath
pushpath          !home poppath

fload rnd        \ Random numbers
fload misc       \ FFI utilities, for/next, extended load/store words, extended arithmetic, performance measurement, psuedo-closures ( [[ ]] )
fload fpext      \ Floating point extensions (for FFI)
fload a
fload fixedp     \ Fixed-point operators etc
fload float-tools
fload prototype_2
fload regions_2
\ fload dynarray

report( Loaded Roger's toolbelt [2] )
