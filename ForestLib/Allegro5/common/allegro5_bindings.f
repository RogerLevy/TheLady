\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5 bindings 
\ ========================= copyright 2014 Roger Levy ==========================

warning off

ALLEGRO_VERSION 24 <<
ALLEGRO_SUB_VERSION 16 << or
ALLEGRO_WIP_VERSION 8 << or
\ ALLEGRO_RELEASE_NUMBER or
constant ALLEGRO_VERSION_INT

: void ;
aka \ /*

fload allegro5_general
fload allegro5_events
fload allegro5_keys
fload allegro5_audio
fload allegro5_graphics
fload allegro5_floatparms

warning on