sdltools +order

%asset ~> %tilemap
  [i
  var ss  \ sdlsurface
  %array inline planearr   0 cell planearr init-array
  i]
  
  : !tilemaparray
     ss @ dup >pixels planearr items!
        sdl-surface-dims 
        2dup planearr .cols 2!   *   planearr with   dup maxitems !   #items ! ;
  
  : tilemap.size   .ss @ sdl-surface-dims ;
  : tilemap.w      .ss @ SDL_Surface w @ ;
  : tilemap.h      .ss @ SDL_Surface h @ ;
  : tilemap.surface  .ss @ ;
  : tilemap.surface!  with ss ! !tilemaparray ;
  : tilemap.array   .planearr ;

  : new-tilemap ( w h tilemap -- )
     with 32 create-sdl-surface ss ! !tilemaparray ;
  
  : free-tilemap ( tilemap -- ) 
     .ss dup @ SDL_FreeSurface off ;
  
  : load-tilemap ( addr c tilemap -- )
     dup free-tilemap with    2dup load-sdl-surface ss !   path place   !tilemaparray ;

  : tilemap:onload ( addr c -- ) \ image file
     2dup s@ ['] load-tilemap catch
     if cr type true abort" Error in TILEMAP:ONLOAD : There was a problem loading an image." then
     2drop ;  

  ' tilemap:onload onload !
  
  : resize-tilemap ( w h tilemap -- )
     with ss @ -rot resize-sdl-surface ss ! !tilemaparray ;

  \ declare a tilemap
  : tilemap ( -- <name> <filespec> )
     ?create namespec %tilemap instance with asset^ ;
  
  : copy-tilemap ( src dest -- )
     >r .ss @ clone-sdl-surface r> tilemap.surface! ;
     
endp

