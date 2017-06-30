\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 dev session loader
\ ========================= copyright 2014 Roger Levy ==========================

: _poppath poppath ;

pushpath
   \ cd ..\rlevy-toolbelt   include rlevy-toolbelt
   cd ..\rlevy-toolbelt\rlevy-toolbelt_2   include rlevy-toolbelt_2
_poppath

!home

fload allegro5-0-nofloatparms