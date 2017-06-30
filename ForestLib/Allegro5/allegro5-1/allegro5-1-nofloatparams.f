\ ==============================================================================
\ ForestLib > Allegro5
\ Allegro 5.1 bindings
\ ========================= copyright 2014 Roger Levy ==========================

\ 5.1.9

#define ALLEGRO_VERSION          5
#define ALLEGRO_SUB_VERSION      1
#define ALLEGRO_WIP_VERSION      9

library allegro-5.1.dll
library allegro_main-5.1.dll
\ library allegro_video-5.1.dll
library allegro_audio-5.1.dll
library allegro_acodec-5.1.dll
library allegro_color-5.1.dll
library allegro_dialog-5.1.dll
library allegro_font-5.1.dll
library allegro_image-5.1.dll
library allegro_memfile-5.1.dll
library allegro_physfs-5.1.dll
library allegro_primitives-5.1.dll
library allegro_ttf-5.1.dll

pushpath cd ..\common
include allegro5_bindings-nofloatparms
poppath

report( Loaded Allegro 5.1 bindings )
