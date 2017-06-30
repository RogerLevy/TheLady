\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5.0 bindings
\ ========================= copyright 2014 Roger Levy ==========================

\ 5.0.10

#define ALLEGRO_VERSION          5
#define ALLEGRO_SUB_VERSION      0
#define ALLEGRO_WIP_VERSION      10

library allegro-5.0.10-monolith-mt.dll


pushpath cd ..\common
include allegro5_bindings
poppath

report( Loaded Allegro 5.0 bindings )
