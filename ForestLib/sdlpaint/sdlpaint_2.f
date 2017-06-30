\ expects the following to be defined: (Yeah, this could be a lot better.)
\   mousecur   ( -- x y ) \ cursor position derived from mouse - this "cursor" is in pixel coords
\   keycur     ( -- x y ) \ get current cursor position, in pixels within the surface
\   cancel     ( -- )     \ revert the "working" surface to the "real" one - example: cancel drawing a line
\   work       ( -- sdl_surface ) \ working surface
\   commit     ( -- )     \ commit the working surface to the real one
\   show       ( -- )     \ copy work surface to real one
\   curcolor   ( -- addr ) \ variable containing 32-bit RGB color
\   selection  ( -- box )  \ section of the surface we are focusing on.
\   cursor     ( -- vec2d ) \ cursor position within the surface, in pixels
\   perform    ( n -- <code> ) \ change current state
\   idle       ( -- ) \ default editor state
\   shift      ( x y -- )

: pixel@   work -rot SPG_GetPixel ;

dvariable strokestart
dvariable lastcur
variable shifting

: ?samewh    alt? if max dup then ;
: mouserad   mousecur strokestart xy 2- ?samewh 2s>f ;
: ?square   2over 2- ?samewh xyxy ;

: ?stroketool
   <r> kstate shift? and         if cancel work strokestart xy mousecur ?square curcolor @ SPG_Rect exit then
   <r> kstate shift? not and     if cancel work strokestart xy mousecur ?square curcolor @ SPG_RectFilled exit then
   <e> kstate shift? and         if cancel work strokestart xy mouserad curcolor @ SPG_Ellipse exit then
   <e> kstate shift? not and     if cancel
      work strokestart xy mouserad curcolor @ SPG_Ellipse
      work strokestart xy mouserad curcolor @ SPG_EllipseFilled exit then
   <l> kstate if cancel work strokestart xy mousecur curcolor @ SPG_Line exit then
   alt? if work mousecur curcolor @ SPG_Pixel
   else    work lastcur xy mousecur curcolor @ SPG_Line
   then
   mousecur lastcur xy! ;

: mouse/sel   mousecur selection xy 2- ;

: stroke ( -- )
   mousecur 2dup strokestart xy! lastcur xy!
   0 perform
   ?stroketool
   mousecur 2dup selection box@ xyxy overlap? if  mouse/sel cursor xy!  then
   1 mreleased if commit idle then ;

: floodfill   work mousecur curcolor @ SPG_FloodFill ;

: eyedrop   mousecur pixel@ curcolor ! ;
: eyedrop2   cursor xy pixel@ curcolor ! ;

: ?cur/shift
   shift? not if
      <up> kpressed if 0 -1 cursor +xy then
      <down> kpressed if 0 1 cursor +xy then
      <left> kpressed if -1 0 cursor +xy then
      <right> kpressed if 1 0 cursor +xy then
   else
      <up> kpressed if 0 -1 shift shifting on then
      <down> kpressed if 0 1 shift shifting on then
      <left> kpressed if -1 0 shift shifting on then
      <right> kpressed if 1 0 shift shifting on then
   then
   shifting @ if <lshift> kreleased <rshift> kreleased or if shifting off commit then then ;
   
: paint
   <f> kstate 1 mpressed and if floodfill commit exit then
   <d> kpressed ctrl? not and if eyedrop2 then
   <space> kstate if work keycur curcolor @ SPG_Pixel show then
   <space> kreleased if commit then ;

: paintmouse
   lb mpressed if stroke then
   rb mpressed if eyedrop then ;
