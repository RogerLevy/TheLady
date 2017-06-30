\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ Optional Allegro bitmap helpers
\ ========================= copyright 2014 Roger Levy ==========================

ALLEGRO_LOCK_READWRITE                 value allegro-lock-mode
ALLEGRO_PIXEL_FORMAT_ANY_16_WITH_ALPHA value allegro-lock-format

: al-bitmap-lockpixel0 ( allegro-bitmap -- allegro-bitmap addr )
   dup 0 0 1 1 allegro-lock-format ( ALLEGRO_PIXEL_FORMAT_ANY ) ALLEGRO_LOCK_READONLY al_lock_bitmap_region
   .ALLEGRO_LOCKED_REGION-data @ ;

: al-bitmap-size     al_bitmap_size ;

: al-bitmap-lock ( allegro-bitmap -- allegro-bitmap pitch addr )
   dup allegro-lock-format ( ALLEGRO_PIXEL_FORMAT_ANY ) allegro-lock-mode al_lock_bitmap
   dup .ALLEGRO_LOCKED_REGION-pitch @ swap .ALLEGRO_LOCKED_REGION-data @ ;

: al-bitmap-unlock   ( allegro-bitmap -- )
   al_unlock_bitmap ;

: al-pixel0  ( allegro-bitmap -- n )
   al-bitmap-lockpixel0 h@ swap al-bitmap-unlock ;
