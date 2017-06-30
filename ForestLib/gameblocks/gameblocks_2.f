\ ==============================================================================
\ ForestLib > GameBlocks [2]
\ GameBlocks library loader [2]
\ ========================= copyright 2014 Roger Levy ==========================

\ compatibility with old code
aka with =>

\ ------------------------------------------------------------------------------
\ low level stuff
fload stackvecs-2d
fload vec
fload box
fload pool
fload color
fload transform
fload 2array_2
fload vtable_2
\ ------------------------------------------------------------------------------

fload assets
fload allegro5_floatparms_ez
fload turtlegfx

\ ------------------------------------------------------------------------------
\ allegro dependent stuff
fload allegro-helpers
fload image
fload audio-helpers
fload input_2
fload window
fload colorfx
\ ------------------------------------------------------------------------------

fload gameutils_2
fload tweening_2
fload plane_2

report( Loaded GameBlocks [2] )
