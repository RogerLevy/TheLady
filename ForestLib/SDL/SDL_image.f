\ ==============================================================================
\ ForestLib
\ SDL_Image library bindings
\ ========================= copyright 2014 Roger Levy ==========================

Library sdl_image.dll
function: IMG_Init ( flags -- )
function: IMG_Quit ( -- )
function: IMG_Load ( zadr -- surface )
\ function: IMG_Load_RW ( zadr free-source-flag -- surface )


7 IMG_Init

:PRUNE  IMG_Quit ;
