\ ==============================================================================
\ ForestLib
\ SDL Bindings
\ ========================= copyright 2014 Roger Levy ==========================

\ 1.2.14
\  Surfaces

fload cbinding

cdefines +order

library sdl

function: SDL_Init ( flags -- n )
function: SDL_Quit ( -- )
function: SDL_GetError ( -- zstr )

function: SDL_MapRGB  ( format,  r, g, b -- n )
function: SDL_MapRGBA  ( format,  r, g, b, a --  n )
function: SDL_GetRGB ( pixel, *fmt, *r, *g, *b -- n )
function: SDL_GetRGBA ( pixel, *fmt, *r, *g, *b, *a -- n )

function: SDL_CreateRGBSurface  ( flags, width, height, depth,  Rmask, Gmask, Bmask, Amask -- s )
function: SDL_CreateRGBSurfaceFrom ( *pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask -- s )
function: SDL_FreeSurface (  *surface -- )

function: SDL_RWFromFile  (  char-*file char-*mode -- rw )
function: SDL_RWFromFP  (  FILE-*fp int-autoclose -- rw )
function: SDL_RWFromMem  (  void-*mem int-size -- rw )
function: SDL_RWFromConstMem  (  void-*mem int-size -- rw )
function: SDL_AllocRW  (  -- addr )
function: SDL_FreeRW  (  SDL_RWops-*area -- )

function: SDL_SetColorKey  (  *surface, flag, key -- )
function: SDL_SetAlpha (  *surface, flag, alpha -- )

function: SDL_ConvertSurface  (  *src, *fmt, flags -- s )

function: SDL_UpperBlit  (  *src, *srcrect,  *dst, *dstrect -- )
function: SDL_LowerBlit  (  *src, *srcrect,  *dst, *dstrect -- )
function: SDL_FillRect  (  *dst, *dstrect, color -- )

function: SDL_LockSurface  (  surface -- )
function: SDL_UnlockSurface  (  surface -- )

\ ---------------
\    Constants
\ ---------------

\ Transparency definitions: These define alpha as the opacity of a surface
#define SDL_ALPHA_OPAQUE 255
#define SDL_ALPHA_TRANSPARENT 0


#define SDL_SWSURFACE    0
#define SDL_SRCCOLORKEY $00001000  \ /**< Blit uses a source color key */
#define SDL_RLEACCELOK  $00002000  \ /**< Private flag */
#define SDL_RLEACCEL $00004000  \ /**< Surface is RLE encoded */
#define SDL_SRCALPHA $00010000  \ /**< Blit uses source alpha blending */


\ flags for SDL_SetPalette()
#define SDL_LOGPAL $01
#define SDL_PHYSPAL $02


\ flags for SDL_Init()
#define SDL_INIT_TIMER          $00000001
#define SDL_INIT_AUDIO          $00000010
#define SDL_INIT_VIDEO          $00000020
#define SDL_INIT_CDROM          $00000100
#define SDL_INIT_JOYSTICK       $00000200
#define SDL_INIT_NOPARACHUTE    $00100000      \ Don't catch fatal signals
#define SDL_INIT_EVENTTHREAD    $01000000      \ Not supported on all OS's
#define SDL_INIT_EVERYTHING     $0000FFFF



#define SDL_QUERY -1
#define SDL_IGNORE    0
#define SDL_DISABLE   0
#define SDL_ENABLE    1



function: SDL_SetClipRect  ( surface rect -- )
function: SDL_SetPalette ( surface flags colors start count -- )


: SDL_BlitSurface   \ (SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect);
   SDL_UpperBlit ;

: sdl-blit
   fourth 0 255 sdl_setalpha   SDL_BlitSurface ;


\ ---------------
\    Structs
\ ---------------

CStruct SDL_Rect
   short X
   short Y
   ushort W
   ushort H
End-CStruct

CStruct SDL_PixelFormat
   void* Palette
   uint8 BitsPerPixel
   uint8 BytesPerPixel
   uint8 Rloss
   uint8 Gloss
   uint8 Bloss
   uint8 Aloss
   uint8 Rshift
   uint8 Gshift
   uint8 Bshift
   uint8 Ashift
   uint32 Rmask
   uint32 Gmask
   uint32 Bmask
   uint32 Amask
   uint32 colorkey
   uint8 alpha
End-CStruct

Cstruct SDL_Surface
   Uint32 flags           ( < Read-only )
   void* format      ( < Read-only )
   int w            ( < Read-only )
   int h
   Uint16 pitch           ( < Read-only )
   void* pixels           ( < Read-write )
   int offset          ( < Private )

   (  Hardware-specific surface info )
   void* hwdata

   (  clipping information )
   structfield SDL_Rect clip_rect        ( < Read-only )
   Uint32 unused1            ( < for binary compatibility )

   (  Allow recursive locks )
   Uint32 locked          ( < Private )

   (  info for fast blit mapping to other surfaces )
   void* map      ( < Private )

   (  format version, bumped at every change to invalidate blit maps )
   uint format_version     ( < Private )

   (  Reference count -- used when freeing surface )
   int refcount           ( < Read-mostly )
End-CStruct

Function: SDL_CreateRGBSurfaceFrom ( void-*pixels, int-width, int-height, int-depth, int-pitch, Uint32-Rmask, Uint32-Gmask, Uint32-Bmask, Uint32-Amask -- surface )


cdefines -order
