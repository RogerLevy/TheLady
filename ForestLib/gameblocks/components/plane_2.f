\ ==============================================================================
\ ForestLib > GameBlocks
\ Generic tilemap renderer
\ ========================= copyright 2014 Roger Levy ==========================

\ ==============================================================================
\ maps are 32-bit but the format is user dependent
\ ==============================================================================

\ char ` comment   
\   Speed:
\   Previous: 2.2ghz i7 800x600 screen, 16x16 tiles = ~1.5ms 
\ `

absent [][] ?fload 2array_2

fload tileset
fload tilemap

pstruct %plane
   [i
   %box inline srcbox
   var tilearray
   var tm \ tilemap
   var ts \ tileset
   %vec2d inline tilestride 
   i]
   
   %vec2d inline scroll   

   : plane.tilemap   .tm @ ;
   : plane.tilemap!  .tm ! ;
   : plane.tileset   .ts @ ;
   : plane.tileset! ( tileset plane -- )
      with  ts !   ts @ .tile dims   tilestride xy! ;

   : plane.srcbox    .srcbox ;


   : init-plane ( tilemap tileset plane -- )
      with s@ plane.tileset! s@ plane.tilemap!  tm @ tilemap.size srcbox dims! ;

   
   \ defer rendertile ( pen=xy; tile -- )

   [i
   \ plane cell format:   %?????yyy yyyyyyyy ?????xxx xxxxxxxx   -1 = blank
   \ max tileset image size is 2048x2048
   : tile ( n -- )
      $7ff07ff and lohi draw-another-tile ;
   i]

   : draw-plane ( pen=xy; plane -- ) 
      with
      srcbox box@  tilestride xy   tm @ tilemap.array  locals| ta sh sw rows cols |
      cols rows or 0=  if 2drop exit then
      \ ts @ .'rendertile @ is rendertile
      \ ['] draw-tile is rendertile
      ts @ .tile dims partwh!   
      batch[
         a@ >r   at@ 2>r
         rows bounds do
            dup i ta [][] a!
            at@
               cols 0 do   @+ tile   sw 0 +at   loop
            sh + at
         loop   drop
         2r> at   r> a! 
      ]batch  ;
   
   \ calculate rendering dimensions for given width/height in pixels
   : fitplane  ( w h plane -- )
      with    1 tilestride y u*/ 1 +   srcbox height!    1 tilestride x u*/ 1 +   srcbox width! ;
   
   \ adjust the drawing pen for scrolling and return the col and row
   \ according to given scroll coordinates
   : tilescroll   ( scrollx scrolly planeparams -- col row )
      tilestride x 1 max tilestride x!   tilestride y 1 max tilestride y!
      with 2dup tilestride y mod negate swap tilestride x mod negate swap +at
           tilestride y / swap tilestride x / swap   ;

   : plane.tilestride!   .tilestride xy! ;

   : draw-plane-scrolling  ( plane -- )
      with scroll xy s@ tilescroll srcbox xy! s@ draw-plane ;
      
endp

