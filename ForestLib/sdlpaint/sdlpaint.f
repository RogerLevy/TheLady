\ expects the following to be defined: (Yeah, this could be a lot better.)
\   : mousecur   ( -- x y ) \ cursor position derived from mouse - this "cursor" is in pixel coords
\   : cancel     ( -- )     \ revert the "working" surface to the "real" one - example: cancel drawing a line
\   : work       ( -- sdl_surface ) \ working surface
\   : commit     ( -- )     \ commit the working surface to the real one
\   : curcolor   ( -- addr ) \ variable containing 32-bit RGB color
\   : selection  ( -- addr ) \ 4 integers (x,y,w,h) describing the section of the surface we are focusing on.
\   : curxy      ( -- addr ) \ 2 integers (x,y) for the cursor position within the surface, in pixels
\   : pixel@     ( x y -- n ) \ fetch a pixel from the real surface
\   : .info      ( -- ) \ update console help
\   : +xy        ( x y -- ) \ update the cursor position
\   : keycur     ( -- x y ) \ get current cursor position, in pixels within the surface
\   : show       ( -- ) \ copy work surface to real one


dvariable strokestart
dvariable lastcur
variable shifting

: ?samewh    alt? if max dup then ;
: mouserad   mousecur strokestart 2@ 2- ?samewh 2s>f ;
: ?square   2over 2- ?samewh area ;

: ?stroketool
   <r> kstate shift? and         if cancel work strokestart 2@ mousecur ?square curcolor @ SPG_Rect exit then
   <r> kstate shift? not and     if cancel work strokestart 2@ mousecur ?square curcolor @ SPG_RectFilled exit then
   <e> kstate shift? and         if cancel work strokestart 2@ mouserad curcolor @ SPG_Ellipse exit then
   <e> kstate shift? not and     if cancel
      work strokestart 2@ mouserad curcolor @ SPG_Ellipse
      work strokestart 2@ mouserad curcolor @ SPG_EllipseFilled exit then
   <l> kstate if cancel work strokestart 2@ mousecur curcolor @ SPG_Line exit then
   alt? if
      work mousecur curcolor @ SPG_Pixel
   else
      work lastcur 2@ mousecur curcolor @ SPG_Line
   then
   mousecur lastcur 2! ;

: mouse/sel   mousecur selection 2@ 2- ;

: stroke
   mousecur 2dup strokestart 2! lastcur 2!
   0 perform
   ?stroketool
   mousecur 2dup selection 4@ area overlap? if  mouse/sel curxy 2!  then
   1 mreleased if commit idle then
;

: floodfill   work mousecur curcolor @ SPG_FloodFill ;

: eyedrop   mousecur pixel@ curcolor ! .info ;
: eyedrop2   curxy 2@ pixel@ curcolor ! .info ;

: ?cur/shift
   shift? not if
      <up> kpressed if 0 -1 +xy then
      <down> kpressed if 0 1 +xy then
      <left> kpressed if -1 0 +xy then
      <right> kpressed if 1 0 +xy then
   else
      <up> kpressed if 0 -1 shift shifting on then
      <down> kpressed if 0 1 shift shifting on then
      <left> kpressed if -1 0 shift shifting on then
      <right> kpressed if 1 0 shift shifting on then
   then
   shifting @ if <lshift> kreleased <rshift> kreleased or if shifting off commit then then ;
   
: keypaint
   <space> kstate if work keycur curcolor @ SPG_Pixel show then
   <space> kreleased if commit then ;
