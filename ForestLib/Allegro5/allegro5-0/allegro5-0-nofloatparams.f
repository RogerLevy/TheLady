\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5.0 bindings ( excludes allegro5_floatparms.f )
\ ========================= copyright 2014 Roger Levy ==========================

\ 5.0.10

#define ALLEGRO_VERSION          5
#define ALLEGRO_SUB_VERSION      0
#define ALLEGRO_WIP_VERSION      10

library allegro-5.0.10-monolith-mt.dll

pushpath cd ..\common
include allegro5_bindings-nofloatparms
poppath

report( Loaded Allegro 5.0 bindings )
