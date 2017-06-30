sample *menu* data/misc_sfx/UI 1.ogg

: menuopt   ( xt -- <name> <imagepath> )   create , here 0 , here namespec bitmap, swap ! ;

pstruct %menuopt
   var optaction
   var optimg
endp

: draw-menuopt   optimg @ entire   dspt   blitrgnexp  ;

\ : center   ( container-w centeree-w  -- x )
\    2 / swap 2 / - ;
   

%actor ~> %menu
   FX_SCREEN blendmode !
   
   [i
   var options
   i]
   var option
   
   [i
   : ?hilite+   dup option @ = if 1.0 1.0 1.0 1.0 else 1.0 0.6 0.6 0.7 then dspt >tint 4! 1 + ;
   : centered   optimg @ bitmap-size drop 1p -0.5 p* 0 +at ;
   : nl         0 optimg @ bitmap-size nip 1p 85.0 + +at ;

   [[
      x 2@ at
      blendmode @ colorfx
      0 [[ @ => pen 2@ 2>r centered ?hilite+ draw-menuopt 2r> at nl ]] options @ each drop
   ]] ondraw !

   : -option    once *menu* option @ 1 - 0 options @ length wrap option ! ;
   : +option    once *menu* option @ 1 + 0 options @ length wrap option ! ;
   : select     ( once *menu* ) option @ options @ []wrap @ >optaction @ execute ;
   i]
   
   
   start:
      0 option !
      0 perform
      <up> kpressed <w> kpressed or if -option then
      <down> kpressed <s> kpressed or if +option then
      <enter> kpressed <space> kpressed or if select then ;

   : menu    create %menu instantiate { options ! } ;
   
endp



