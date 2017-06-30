\ generic plane/tilemap renderer
\ relies on:
\  2array.f pen res


\ maps are 32-bit but the format is user dependent



absent [][] ?fload 2array

package ~plane

\ Tilemap params format:
/rect   var tilearray  var (rendertile)  var tilew   var tileh      drop

aka width cols
aka height rows

public


: /scroll  ( x y planeparams -- col row planeparams )
   => 2dup tileh @ mod negate swap tilew @ mod negate swap +at
        tileh @ / swap tilew @ / swap   struct ;
        
        
\ speed is acceptable
\  2.2ghz i7 800x600 screen, 16x16 tiles = ~1.5ms


\ draw a plane (e.g. tilemap) 
\ source is a 2d array, each tile = 1 cell
defer rendertile
: plane ( pen=xy; col row tileparams -- ) ( pen=xy; tile -- )
   =>
   x1 2@ 2+
   batch[  (rendertile) @ is rendertile
   a@ >r   pen 2@ 2>r
   rows @ bounds do
      dup i tilearray @ [][] a!
      pen 2@
      cols @ 0 do   @+ rendertile   tilew @ 0 +at   loop
      tileh @ + at
   loop   drop
   2r> at   r> a!   ]batch ;

\ calculate rendering dimensions for given width/height in pixels
: fitplane  ( w h planeparams -- )
   =>    1 tileh @ u*/ 1 + rows !    1 tilew @ u*/ 1 + cols ! ;

\ draw a plane that fills the screen using given scroll
: screenplane  ( pen=xy; scrollx scrolly planeparams -- pen=?? )
   res 2@ third fitplane   /scroll plane ;

: scrollplane  ( pen=xy; scrollx scrolly planeparams -- pen=?? )
   /scroll plane ;


end-package