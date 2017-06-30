clear-stage
pushpath cd ..
create lady.image " data/assets/placeholders/Characters/Main/LADY MAIN FILE.png" image,
create l1bg.image " data/assets/placeholders/Backgrounds/Lvl 1/l1.jpg" image,
poppath

%stageobj reopen
   var blendmode
endp

: fit   ( h. h2. -- n. n. )
   swap p/ dup ;

0
   var x1
   var y1
   var x2
   var y2
constant /rect




\ supports tinting, scaling and rotation
: blitrgnex  ( bitmap bmprect displaytransform -- )
   =>   >r   >albmp @   r> 4@f   tint 4p@f  pivot 2@ 2p>f   pen 2@ 2p>f   scale 2@ 2p>f   rotation @ p>f   flipflags   
      al_draw_tinted_scaled_rotated_bitmap_region 
   ;

create temprgn  0 , 0 , 0 , 0 ,

: blitex   >r  dup bitmap-size temprgn >x2 2!   temprgn  r>  blitrgnex ;

: billboard-render
   blendmode @ colorfx   x 2@ at   bmp @   dspt   blitex ;


%stageobj ~> %billboard
   be-prototype
      L1BG.image bmp !
      ' billboard-render ondraw !
endp

%billboard ~> %bg
   be-prototype
      L1BG.image bmp !
      0.5 0.5 dspt >scale 2!
\      0.15 0.15 dspt >scale 2!

endp

%billboard ~> %lady
   be-prototype
      lady.image bmp !
      0.15 0.15 dspt >scale 2!
      \  1 blendmode !
      [[
         left? if -2.5 x +! then
         right? if 2.5 x +! then
      ]] onsim !
endp



\ %bg one value bg2   
%bg one value bg   
%lady one value lady

lady be

cr
report( === BLENDING MODE TESTING PROGRAM === )
report( commands:  tint [ hex -- ]   multiply screen additive invert subtractive normal inverse )
report( example:   $8000ff00 tint     \ display in green, half transparent )
report( type 'ok' to move the lady around with <Left> and <Right> keys)
cr

\: tint   dspt >tint ! ;

: bmode  create , does> @ blendmode ! ;

FX_MULTIPLY bmode multiply
FX_SCREEN bmode screen
FX_ADD bmode additive
FX_INVERT bmode invert
FX_SUBTRACT bmode subtractive
FX_NORMAL bmode normal
FX_REVERSE bmode inverse

render show-frame