
clear-stage

pushpath cd ..
create lady.image " data/assets/placeholders/Characters/Main/LADY MAIN FILE.png" image,
create l1bg.image " data/assets/placeholders/Backgrounds/Lvl 1/l1.jpg" image,
create glass.image " data/assets/placeholders/Foregrounds/Placeholder Foreground Glass.png" image,
create phdoor.image " data/assets/placeholders/Door Etc/Placeholder Door.png" image,
poppath

%stageobj reopen
   var blendmode
endp


0
   var x1
   var y1
   var x2
   var y2
constant /rect


create temprgn  0 , 0 , 0 , 0 ,

\ supports tinting, scaling and rotation
: blitrgnex  ( bitmap bmprect displaytransform -- )
   =>   >r   >albmp @   r> 4@f   tint 4p@f  pivot 2@ 2p>f   pen 2@ 2p>f   scale 2@ 2p>f   rotation @ p>f   flipflags   
      al_draw_tinted_scaled_rotated_bitmap_region 
   ;

: blitex   >r  dup bitmap-size temprgn >x2 2!   temprgn  r>  blitrgnex ;

: billboard-render
   blendmode @ colorfx   x 3@ scrolled at   bmp @   dspt   blitex ;





%stageobj ~> %billboard
   be-prototype
      1.0 z !
      L1BG.image bmp !
      ' billboard-render ondraw !
endp

%billboard ~> %bg
   be-prototype
      L1BG.image bmp !
\      0.75 0.75 dspt >scale 2!
\      0.15 0.15 dspt >scale 2!
      1.5 1.5 dspt >scale 2!
      0.75 z !
endp
   
variable parallax?  

%billboard ~> %door
   be-prototype
      phdoor.image bmp !
      0.8 z !
      1.25 1.25 dspt >scale 2!
endp

%billboard ~> %glass
   be-prototype
      glass.image bmp !
      2048.0 1366.0 p/ dup dspt >scale 2!
      0 z !
endp

%billboard ~> %lady
   be-prototype
      lady.image bmp !
      0.33 0.33 dspt >scale 2!
      \  1 blendmode !
      [[
         left? if -2.5 x +! then
         right? if 2.5 x +! then
         up? if 0.25 z +! then
         down? if -0.25 z +! then
         
         mouse res 2@ 0.5 0.5 2p* 2- 2s>p cam 2!
         
      ]] onsim !
endp


res 2@ set-viewport

\ %bg one value bg2   
-500.0 -150.0 at
%bg one value bg   

0 200.0 at
%door one value door1
800.0 200.0 at
%door one value door2
1600.0 200.0 at
%door one value door3


150.0 250.0 at
%lady one value lady

0 0 at
%glass one value glass


lady be

cr
report( === PARALLAX TESTING PROGRAM === )
report( Move the mouse to see the parallax effect.  The background's "z" is set to 0.75 and the lady is 1.0 )
report( Press <Esc> to enter play with modes and tint and type OK to go back to the program. )
report( commands:  tint [ hex -- ]   multiply screen additive invert subtractive normal inverse )
cr

\ : tint   dspt >tint ! ;

: bmode  create , does> @ blendmode ! ;

FX_MULTIPLY bmode multiply
FX_SCREEN bmode screen
FX_ADD bmode additive
FX_INVERT bmode invert
FX_SUBTRACT bmode subtractive
FX_NORMAL bmode normal
FX_REVERSE bmode inverse

lady be \ multiply
glass be screen  $ffc0c0c0 tint 

ok