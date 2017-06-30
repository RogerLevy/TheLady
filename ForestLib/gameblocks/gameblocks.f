\ ==============================================================================
\ ForestLib > GameBlocks
\ GameBlocks library loader
\ ========================= copyright 2014 Roger Levy ==========================

\ 11/18/13

\ vector structure
pstruct %vector   var x   var y   var z   endp

fload stackvecs
fload rectangles
fload assets
fload files
fload pool
fload 2array
fload vtable

fload io-allegro5\gfx-helpers
fload io-allegro5\audio-helpers
fload io-allegro5\input
fload io-allegro5\window

fload gameutils
fload sound
fload windowtools
fload tweening
fload plane
fload intersections

report( Loaded GameBlocks )
