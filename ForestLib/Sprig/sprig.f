\ ==============================================================================
\ ForestLib
\ Sprig (SDL software graphics library) bindings (selected)
\ ========================= copyright 2014 Roger Levy ==========================

warning off

Library Sprig

\ typedef struct SPG_Point
\     float-x;
\     float-y;



\ /*-A table of dirtyrects for one display page-*/
\ typedef struct SPG_DirtyTable
\    Uint16      size; /*-Table size-*/
\    SDL_Rect *rects;  /*-Table of rects-*/
\    Uint16      count;   /*-# of rects currently used-*/
\    Uint16      best; /*-Merge testing starts here!-*/
\  SPG_DirtyTable;

\ #define SPG_bool-Uint8

\ default = 0
#define SPG_DEST_ALPHA 0
#define SPG_SRC_ALPHA 1
#define SPG_COMBINE_ALPHA 2
#define SPG_COPY_NO_ALPHA 3
#define SPG_COPY_SRC_ALPHA 4
#define SPG_COPY_DEST_ALPHA 5
#define SPG_COPY_COMBINE_ALPHA 6
#define SPG_COPY_ALPHA_ONLY 7
#define SPG_COMBINE_ALPHA_ONLY 8
#define SPG_REPLACE_COLORKEY 9

\ Alternate names:
#define SPG_SRC_MASK 4
#define SPG_DEST_MASK 5


\ /*-Transformation flags-*/
#define SPG_NONE 1
#define SPG_TAA 2
#define SPG_TSAFE 4
#define SPG_TTMAP 8
#define SPG_TSLOW 16
#define SPG_TCOLORKEY 32
#define SPG_TBLEND 64
#define SPG_TSURFACE_ALPHA 128


function: SPG_InitSDL ( Uint16-w,  Uint16-h,  Uint8-bitsperpixel,  Uint32-systemFlags,  Uint32-screenFlags -- SDL_Surface* )
function: SPG_EnableAutolock ( SPG_bool-enable -- )
function: SPG_GetAutolock (  -- SPG_bool )
function: SPG_EnableRadians ( SPG_bool-enable -- )
function: SPG_GetRadians (  --  SPG_bool )
function: SPG_Error ( const-char*-err -- )
function: SPG_EnableErrors ( SPG_bool-enable -- )
function: SPG_GetError (  -- char* )
function: SPG_NumErrors (  -- Uint16 )
function: SPG_PushThickness ( Uint16-state -- )
function: SPG_PopThickness (  -- Uint16 )
function: SPG_GetThickness (  -- Uint16 )
function: SPG_PushBlend ( Uint8-state -- )
function: SPG_PopBlend (  -- Uint8 )
function: SPG_GetBlend (  -- Uint8 )
function: SPG_PushAA ( SPG_bool-state -- )
function: SPG_PopAA (  -- SPG_bool )
function: SPG_GetAA (  -- SPG_bool )
function: SPG_PushSurfaceAlpha ( SPG_bool-state -- )
function: SPG_PopSurfaceAlpha (  -- SPG_bool )
function: SPG_GetSurfaceAlpha (  -- SPG_bool )
function: SPG_RectOR ( const-SDL_Rect-rect1,  const-SDL_Rect-rect2,  SDL_Rect*-dst_rect -- )
function: SPG_RectAND ( const-SDL_Rect-A,  const-SDL_Rect-B,  SDL_Rect*-intersection -- SPG_bool )

\ DIRTY RECT
\  Important stuff
function: SPG_EnableDirty ( SPG_bool-enable -- )
function: SPG_DirtyInit ( Uint16-maxsize -- )
function: SPG_DirtyAdd ( SDL_Rect*-rect -- )
function: SPG_DirtyUpdate ( SDL_Surface*-screen -- SPG_DirtyTable* )
function: SPG_DirtySwap (  -- )
\  Other stuff
function: SPG_DirtyEnabled (  -- SPG_bool )
function: SPG_DirtyMake ( Uint16-maxsize -- SPG_DirtyTable* )
function: SPG_DirtyAddTo ( SPG_DirtyTable*-table,  SDL_Rect*-rect -- )
function: SPG_DirtyFree ( SPG_DirtyTable*-table -- )
function: SPG_DirtyGet (  -- SPG_DirtyTable* )
function: SPG_DirtyClear ( SPG_DirtyTable*-table -- )
function: SPG_DirtyLevel ( Uint16-optimizationLevel -- )
function: SPG_DirtyClip ( SDL_Surface*-screen,  SDL_Rect*-rect -- )

\ PALETTE
function: SPG_ColorPalette (  -- SDL_Color* )
function: SPG_GrayPalette (  -- SDL_Color* )
function: SPG_FindPaletteColor ( SDL_Palette*-palette,  Uint8-r,  Uint8-g,  Uint8-b -- Uint32 )
function: SPG_PalettizeSurface ( SDL_Surface*-surface,  SDL_Palette*-palette -- SDL_Surface* )
function: SPG_FadedPalette32 ( SDL_PixelFormat*-format,  Uint32-color1,  Uint32-color2,  Uint32*-colorArray,  Uint16-startIndex,  Uint16-stoppindex -- )
function: SPG_FadedPalette32Alpha ( SDL_PixelFormat*-format,  Uint32-color1,  Uint8-alpha1,  Uint32-color2,  Uint8-alpha2,  Uint32*-colorArray,  Uint16-start,  Uint16-stop -- )
function: SPG_RainbowPalette32 ( SDL_PixelFormat*-format,  Uint32-*colorArray,  Uint8-intensity,  Uint16-startIndex,  Uint16-stoppindex -- )
function: SPG_GrayPalette32 ( SDL_PixelFormat*-format,  Uint32-*colorArray,  Uint16-startIndex,  Uint16-stoppindex -- )

\ SURFACE

function: SPG_CreateSurface8 ( Uint32-flags,  Uint16-width,  Uint16-height -- SDL_Surface* )
function: SPG_GetPixel ( SDL_Surface-*surface,  Sint16-x,  Sint16-y -- Uint32 )
function: SPG_SetClip ( SDL_Surface-*surface,  const-SDL_Rect-rect -- )
\ function: SPG_TransformX ( SDL_Surface-*src,  SDL_Surface-*dst,  float-angle,  float-xscale,  float-yscale,  Uint16-ppivotX,  Uint16-ppivotY,  Uint16-destX,  Uint16-destY,  Uint8-flags -- SDL_Rect )
function: SPG_Transform ( SDL_Surface-*src,  Uint32-bgColor,  float-angle,  float-xscale,  float-yscale,  Uint8-flags -- SDL_Surface* )
: SPG_Transform  >R 3sfparms R> SPG_Transform ;
\ function: SPG_Scale ( SDL_Surface-*src,  float-xscale,  float-yscale, Uint32-bgColor,   -- SDL_Surface* )
\ : SPG_Scale   >r 2sfparms r> SPG_Scale ;
function: SPG_Rotate ( SDL_Surface-*src,  float-angle,  Uint32-bgColor -- SDL_Surface* )
function: SPG_RotateAA ( SDL_Surface-*src,  float-angle,  Uint32-bgColor -- SDL_Surface* )
function: SPG_ReplaceColor ( SDL_Surface*-src,  SDL_Rect*-srcrect,  SDL_Surface*-dest,  SDL_Rect*-destrect,  Uint32-color -- SDL_Surface* )



\ DRAWING

function: SPG_Blit ( SDL_Surface-*Src,  SDL_Rect*-srcRect,  SDL_Surface-*Dest,  SDL_Rect*-destRect -- )


: SPG_DrawBlit  ( src dest x y )
   pad 2h!
   pad 4 + off
   0 swap pad SPG_Blit ;

\ : SPG_Draw  ( src dest x y )
\    pad 2h!
\    pad 4 + off
\    0 swap pad sdl-blit ;


\ function: SPG_DrawBlit ( SDL_Surface-*Src,  SDL_Surface-*Dest,  x y  -- )
\ function: SPG_SetBlit ( void  (-*blitfn-- ) ( SDL_Surface*,  SDL_Rect*,  SDL_Surface*,  SDL_Rect*-- ) -- )
\ function:  ( *SPG_GetBlit () ) ( SDL_Surface*,  SDL_Rect*,  SDL_Surface*,  SDL_Rect*--- )

function: SPG_FloodFill ( SDL_Surface-*dst,  Sint16-x,  Sint16-y,  Uint32-color -- )


\ PRIMITIVES

function: SPG_Pixel ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  Uint32-color -- )
function: SPG_PixelBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  Uint32-color,  Uint8-alpha -- )
function: SPG_PixelPattern ( SDL_Surface-*surface,  SDL_Rect target,  SPG_bool*-pattern,  Uint32*-colors -- )
function: SPG_PixelPatternBlend ( SDL_Surface-*surface,  SDL_Rect target,  SPG_bool*-pattern,  Uint32*-colors,  Uint8*-pixelAlpha -- )
function: SPG_LineH ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y,  Sint16-x2,  Uint32-Color -- )
function: SPG_LineHBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y,  Sint16-x2,  Uint32-color,  Uint8-alpha -- )
function: SPG_LineHFade ( SDL_Surface-*dest, Sint16-x1, Sint16-y, Sint16-x2, Uint32-color1,  Uint32-color2 -- )
function: SPG_LineHTex ( SDL_Surface-*dest, Sint16-x1, Sint16-y, Sint16-x2, SDL_Surface-*source, Sint16-sx1, Sint16-sy1, Sint16-sx2, Sint16-sy2 -- )
function: SPG_LineV ( SDL_Surface-*surface,  Sint16-x,  Sint16-y1,  Sint16-y2,  Uint32-Color -- )
function: SPG_LineVBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y1,  Sint16-y2,  Uint32-color,  Uint8-alpha -- )
function: SPG_LineFn ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-Color,  callback -- ) ( SDL_Surface-*Surf,  Sint16-X,  Sint16-Y,  Uint32-Color-- )
function: SPG_Line ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-Color -- )
function: SPG_LineBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color,  Uint8-alpha -- )
function: SPG_LineFadeFn ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color1,  Uint32-color2,  callback -- ) ( SDL_Surface-*Surf,  Sint16-X,  Sint16-Y,  Uint32-Color-- )
function: SPG_LineFade ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color1,  Uint32-color2 -- )
function: SPG_LineFadeBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color1,  Uint8-alpha1,  Uint32-color2,  Uint8-alpha2 -- )
function: SPG_Rect ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color -- )
function: SPG_RectBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color,  Uint8-alpha -- )
function: SPG_RectFilled ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color -- )
function: SPG_RectFilledBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  Uint32-color,  Uint8-alpha -- )
function: SPG_RectRound ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  float-r,  Uint32-color -- )
: SPG_RectRound  >r 1sfparms r> SPG_RectRound ;
function: SPG_RectRoundBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  float-r,  Uint32-color,  Uint8-alpha -- )
: SPG_RectRoundBlend  2>r 1sfparms 2r> SPG_RectRoundBlend  ;
function: SPG_RectRoundFilled ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  float-r,  Uint32-color -- )
: SPG_RectRoundFilled >r 1sfparms r> SPG_RectRoundFilled ;
function: SPG_RectRoundFilledBlend ( SDL_Surface-*surface,  Sint16-x1,  Sint16-y1,  Sint16-x2,  Sint16-y2,  float-r,  Uint32-color,  Uint8-alpha -- )
: SPG_RectRoundFilledBlend 2>r 1sfparms 2r> SPG_RectRoundFilledBlend ;
function: SPG_EllipseFn ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  Uint32-color,  callback -- )  ( SDL_Surface-*Surf,  Sint16-X,  Sint16-Y,  Uint32-Color-- )
: SPG_EllipseFn 2>r 2sfparms 2r> SPG_EllipseFn ;
function: SPG_Ellipse ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  Uint32-color -- )
: SPG_Ellipse >r 2sfparms r> SPG_Ellipse ;
function: SPG_EllipseBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  Uint32-color,  Uint8-alpha -- )
: SPG_EllipseBlend 2>r 2sfparms 2r> SPG_EllipseBlend ;
function: SPG_EllipseFilled ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  Uint32-color -- )
: SPG_EllipseFilled >r 2sfparms r> SPG_EllipseFilled ;
function: SPG_EllipseFilledBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  Uint32-color,  Uint8-alpha -- )
: SPG_EllipseFilledBlend 2>r 2sfparms 2r> SPG_EllipseFilledBlend ;
\ function: SPG_EllipseArb ( SDL_Surface-*Surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  float-angle,  Uint32-color -- )
\ function: SPG_EllipseBlendArb ( SDL_Surface-*Surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  float-angle,  Uint32-color,  Uint8-alpha -- )
\ function: SPG_EllipseFilledArb ( SDL_Surface-*Surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  float-angle,  Uint32-color -- )
\ function: SPG_EllipseFilledBlendArb ( SDL_Surface-*Surface,  Sint16-x,  Sint16-y,  float-rx,  float-ry,  float-angle,  Uint32-color,  Uint8-alpha -- )
function: SPG_CircleFn ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-r,  Uint32-color,  callback -- ) ( SDL_Surface-*Surf,  Sint16-X,  Sint16-Y,  Uint32-Color-- )
: SPG_CircleFn 2>r 1sfparms 2r> SPG_CircleFn ;
function: SPG_Circle ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-r,  Uint32-color -- )
: SPG_Circle >r 1sfparms r> SPG_Circle ;
function: SPG_CircleBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-r,  Uint32-color,  Uint8-alpha -- )
: SPG_CircleBlend 2>r 1sfparms 2r> SPG_CircleBlend ;
function: SPG_CircleFilled ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-r,  Uint32-color -- )
: SPG_CircleFilled >r 1sfparms r> SPG_CircleFilled ;
function: SPG_CircleFilledBlend ( SDL_Surface-*surface,  Sint16-x,  Sint16-y,  float-r,  Uint32-color,  Uint8-alpha -- )
: SPG_CircleFilledBlend 2>r 1sfparms 2r> SPG_CircleFilledBlend ;
\ function: SPG_ArcFn ( SDL_Surface*-surface,  Sint16-cx,  Sint16-cy,  float-radius,  float-startAngle,  float-endAngle,  Uint32-color,  void Callback ( SDL_Surface-*Surf,  Sint16-X,  Sint16-Y,  Uint32-Color-- ) -- )
\ function: SPG_Arc ( SDL_Surface*-surface,  Sint16-x,  Sint16-y,  float-radius,  float-startAngle,  float-endAngle,  Uint32-color -- )
\ function: SPG_ArcBlend ( SDL_Surface*-surface,  Sint16-x,  Sint16-y,  float-radius,  float-startAngle,  float-endAngle,  Uint32-color,  Uint8-alpha -- )
\ function: SPG_ArcFilled ( SDL_Surface*-surface,  Sint16-cx,  Sint16-cy,  float-radius,  float-startAngle,  float-endAngle,  Uint32-color -- )
\ function: SPG_ArcFilledBlend ( SDL_Surface*-surface,  Sint16-cx,  Sint16-cy,  float-radius,  float-startAngle,  float-endAngle,  Uint32-color,  Uint8-alpha -- )
function: SPG_Bezier ( SDL_Surface-*surface,  Sint16-startX,  Sint16-startY,  Sint16-cx1,  Sint16-cy1,  Sint16-cx2,  Sint16-cy2,  Sint16-endX,  Sint16-endY,  Uint8-quality,  Uint32-color -- )
function: SPG_BezierBlend ( SDL_Surface-*surface,  Sint16-startX,  Sint16-startY,  Sint16-cx1,  Sint16-cy1,  Sint16-cx2,  Sint16-cy2,  Sint16-endX,  Sint16-endY,  Uint8-quality,  Uint32-color,  Uint8-alpha -- )


\ POLYGONS

function: SPG_Trigon ( SDL_Surface-*surface, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, Uint32-color -- )
function: SPG_TrigonBlend ( SDL_Surface-*surface, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, Uint32-color,  Uint8-alpha -- )
function: SPG_TrigonFilled ( SDL_Surface-*surface, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, Uint32-color -- )
function: SPG_TrigonFilledBlend ( SDL_Surface-*surface, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, Uint32-color,  Uint8-alpha -- )
function: SPG_TrigonFade ( SDL_Surface-*surface, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, Uint32-color1, Uint32-color2, Uint32-color3 -- )
function: SPG_TrigonTex ( SDL_Surface-*dest, Sint16-x1, Sint16-y1, Sint16-x2, Sint16-y2, Sint16-x3, Sint16-y3, SDL_Surface-*source, Sint16-sx1, Sint16-sy1, Sint16-sx2, Sint16-sy2, Sint16-sx3, Sint16-sy3 -- )
function: SPG_QuadTex ( SDL_Surface*-dest,  Sint16-destULx,  Sint16-destULy,  Sint16-destDLx,  Sint16-destDLy,  Sint16-destDRx,  Sint16-destDRy,  Sint16-destURx,  Sint16-destURy,  SDL_Surface*-source,  Sint16-srcULx,  Sint16-srcULy,  Sint16-srcDLx,  Sint16-srcDLy,  Sint16-srcDRx,  Sint16-srcDRy,  Sint16-srcURx,  Sint16-srcURy -- )
function: SPG_Polygon ( SDL_Surface-*dest,  Uint16-n,  SPG_Point*-points,  Uint32-color -- )
function: SPG_PolygonBlend ( SDL_Surface-*dest,  Uint16-n,  SPG_Point*-points,  Uint32-color,  Uint8-alpha -- )
function: SPG_PolygonFilled ( SDL_Surface-*surface,  Uint16-n,  SPG_Point*-points,  Uint32-color -- )
function: SPG_PolygonFilledBlend ( SDL_Surface-*surface,  Uint16-n,  SPG_Point*-points,  Uint32-color,  Uint8-alpha -- )
function: SPG_PolygonFade ( SDL_Surface-*surface,  Uint16-n,  SPG_Point*-points,  Uint32*-colors -- )
function: SPG_PolygonFadeBlend ( SDL_Surface-*surface,  Uint16-n,  SPG_Point*-points,  Uint32*-colors,  Uint8-alpha -- )
function: SPG_CopyPoints ( Uint16-n,  SPG_Point*-points,  SPG_Point*-buffer -- )
function: SPG_RotatePointsXY ( Uint16-n,  SPG_Point*-points,  float-cx,  float-cy,  float-angle -- )
: SPG_RotatePointsXY  3sfparms SPG_RotatePointsXY ;
function: SPG_ScalePointsXY ( Uint16-n,  SPG_Point*-points,  float-cx,  float-cy,  float-xscale,  float-yscale -- )
: SPG_ScalePointsXY  4sfparms SPG_ScalePointsXY ;
function: SPG_SkewPointsXY ( Uint16-n,  SPG_Point*-points,  float-cx,  float-cy,  float-xskew,  float-yskew -- )
: SPG_SkewPointsXY  4sfparms SPG_SkewPointsXY ;
function: SPG_TranslatePoints ( Uint16-n,  SPG_Point*-points,  float-x,  float-y -- )
: SPG_TranslatePoints  2sfparms SPG_TranslatePoints ;

warning on