\ ==============================================================================
\ ForestLib
\ SDL Surface helper definitions
\ ========================= copyright 2014 Roger Levy ==========================



package sdltools

\ provide a temporary IL image for the duration of a quotation
: do-il    ( xt -- ) ( il-image -- )
   ilGenImage dup >r ilBindImage catch r> ilDeleteImage throw ;

\ SDL Surface
: >format   SDL_Surface format @ ;
: >palette   cell+ @ @ cell+ @ ;
: >pixels    5 cells + @ ;

: has-alpha?  SDL_Surface format @ SDL_PixelFormat amask @ 0<> ;
: sdl-components  has-alpha? if 4 else 3 then ;
: red-first?  SDL_Surface format @ SDL_PixelFormat rshift c@ 0= ;

: SDLSurface>TexFormat ( sdlsurface -- glformat )
   dup has-alpha?
      IF    red-first? IF GL_RGBA ELSE GL_BGRA THEN
      ELSE  red-first? IF GL_RGB ELSE GL_BGR THEN
   THEN ;

: sdl-surface-dims    dup SDL_Surface w @  swap  SDL_Surface h @ ;


: ?ilformat  ( surface -- numchannels format type )
   >format SDL_PixelFormat BytesPerPixel c@
   case
      1 of 1 IL_COLOR_INDEX IL_UNSIGNED_BYTE endof
      2 of -1 abort" 16 bit not supported by devIL" endof
      3 of 3 IL_BGR IL_UNSIGNED_BYTE endof
      4 of 4 IL_BGRA IL_UNSIGNED_BYTE endof
   endcase
;

: sdlsurface-il
   IL_ORIGIN_UPPER_LEFT ilOriginFunc drop
   dup >r sdl-surface-dims 1 r@ ?ilformat  r> SDL_Surface pixels @  ilTexImage
;
   \ iluFlipImage ;

: pixelstore   ( surface -- )
   >r GL_UNPACK_ROW_LENGTH
   r@ SDL_Surface pitch h@
   r> SDL_Surface format @ SDL_PixelFormat bytesperpixel c@   /  glPixelStorei ;

: apply-ck   ( color surface -- ) swap $ffffff and locals| color s |
   s SDL_Surface pixels @
   s sdl-surface-dims *  0 do dup @ dup $ffffff and color = if $ffffff and then !+ loop drop ;

: create-sdl-surface  ( w h bitdepth -- surface )
   8 =
   if   SDL_SWSURFACE -rot 8 0 0 0 0 SDL_CreateRGBSurface
   else SDL_SWSURFACE -rot 32 $ff0000 $ff00 $ff $ff000000  SDL_CreateRGBSurface
   then ;

: clear-sdl-surface ( surface color -- )
   0 swap SDL_FillRect ;

: blit-sdl-surface ( src rect dest rect -- )
   fourth 0 255 SDL_SetAlpha   over 0 255 SDL_SetAlpha   SDL_BlitSurface ;

: resize-sdl-surface  ( sdl-surface1 w h -- sdl-surface2 )
   third >r   r@ SDL_Surface format @ SDL_PixelFormat BitsPerPixel @   create-sdl-surface >r
   0 r@ over blit-sdl-surface  r>
   r> SDL_FreeSurface  ;

: clone-sdl-surface   ( surface1 -- surface2 )
   dup   SDL_Surface format @   over   SDL_Surface flags @   SDL_ConvertSurface ;

\ -- Load surfaces --
Variable sdl

: il-dims  IL_IMAGE_WIDTH ilGetInteger IL_IMAGE_HEIGHT ilGetInteger ;

\ : il-load-lump  ( -- )
\    2dup 2>r ilDetermineTypeL 2r> ilLoadL 0= abort" Error loading image from memory. (DevIL)" ;

: il-CreateSDLSurface  ( bitdepth -- sdlsurface )
   IL_PAL_RGBA32 ilConvertPal 0= abort" Error converting palette. (DevIL)"
   il-dims rot create-sdl-surface   dup sdl ! ;

: load-sdl-surface  ( filename count -- surface )
   z$ locals| filename |
   [[ filename cr dup zcount type ilLoadImage 0= abort" Error loading image from file. (DevIL)"
      32 il-CreateSDLSurface sdl !
      0  0  0  il-dims   1  IL_BGRA  IL_UNSIGNED_BYTE  sdl @ SDL_Surface pixels @ ilCopyPixels drop
   ]] do-il   sdl @ ;

: load-sdl-surface8 ( filename count palette -- surface )
    -rot z$ locals| filename palette |
    [[ filename ilLoadImage 0= abort" Error loading image from file. (DevIL)"
       8 il-CreateSDLSurface sdl !
       ilGetPalette  palette  256  cells  move
       0  0  0  il-dims   1  IL_COLOR_INDEX   IL_UNSIGNED_BYTE  sdl @ SDL_Surface pixels @ ilCopyPixels drop
    ]] do-il  sdl @ ;

: sdlvflip ( surface1 -- surface2 )
   \ $ff8040ff 0e 1e -1e SPG_TSLOW SPG_TSAFE or SPG_Transform
   ;

: save-sdl-surface ( surface bitdepth filename count -- )     \ Bit-depths 8 and 32 are supported
   z$ rot locals| surface filename bitdepth |
   [[ surface sdlsurface-il 0= abort" Error converting surface to image for saving. (DevIL)"
      bitdepth 8 = if
         IL_COLOR_INDEX IL_UNSIGNED_BYTE ilConvertImage 0= abort" Error converting image before saving. (DevIL)"
         IL_PAL_RGBA32 ilConvertPal 0= abort" Error converting palette. (DevIL)"
      else
         bitdepth 24 = If IL_RGB Else IL_RGBA Then
            IL_UNSIGNED_BYTE ilConvertImage 0= abort" Error converting image before saving. (DevIL)"
         iluFlipImage \ i dunno why this is needed but it seems to be needed so it's here
      then
      IL_USE_COMPRESSION IL_COMPRESSION_HINT ilHint
      filename zcount delete-file drop
      filename ilSaveImage 0= abort" Error saving image. Maybe the file is locked. (DevIL)"
   ]] do-il
   ;

: save-sdl-surface+pal ( pal surface filename count -- )     \ Bit-depths 8 and 32 are supported
   z$ locals| filename surface pal |
   [[ surface sdlsurface-il 0= abort" Error converting surface to image for saving. (DevIL)"
      pal 256 IL_PAL_RGBA32 ilRegisterPal
      IL_COLOR_INDEX IL_UNSIGNED_BYTE  ilConvertImage 0= abort" Error converting image before saving. (DevIL)"
      \ ilConvertPal( IL_PAL_RGBA32 ) 0= abort" Error converting palette. (DevIL)"
      IL_USE_COMPRESSION IL_COMPRESSION_HINT ilHint
      iluFlipImage
      filename zcount delete-file drop
      filename ilSaveImage 0= abort" Error saving image. Maybe the file is locked. (DevIL)"
   ]] do-il ;


: sdl-surface-pixel[]   ( x y sdlsurface -- addr )
   >r
      r@ SDL_Surface pitch h@ * swap  r@ SDL_Surface format @ SDL_PixelFormat BytesPerPixel @ * +  r@ SDL_Surface pixels @ +
   r>drop ;

end-package
