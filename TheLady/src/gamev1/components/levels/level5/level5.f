\ includes rising glass
absent "glassfalling" ?fload glassfalling
absent %blacklady ?fload blacklady

\ assets
image l5bg.image data/l5misc/Level 5 PRE blurred.jpg
sample *l5scratch* data/l5misc/LVL 5 Record Scratch.ogg
stream *l5bgm* data/l5misc/lvl 5 soundscape.ogg

\ fg glass
create glass %billboard instance,
glass { glass3.image bitmap! FX_SCREEN blendmode ! 0.5 0.5 0.5 dspt -> tint! }
: *glassframe glass dup fg addto { 0 0 0 x 3! 1.0 dspt -> uscale! } ;


\ layouts
" l5r1layout" load-layout

\ : brokenz   0.4 0.8 between z ! ;

: quake-script   0 [[ perform begin 5.0 camofs +! 1 pauses -5.0 camofs +! 1 pauses again ]] parallel ;

%room ~> %l5room
   noop: layout
   start:
      0.1 [[ delay looping *l5bgm* looping *l5scratch* end ]] parallel
      l5bg.image setbg
      0 bud !
      \ bg { brokenz [[ @ { brokenz } ]] children @ each }
      counter bud !
      yellowfilter75.image setfg FX_MULTIPLY fg >blendmode !
      0 0 at %darkcorners one drop
      *glassframe
      layout @ execute
      l5:| player-emotion
      make-glass-start-rising
      randomize-ladies
      doorlady-script
      quake-script
   ;
endp

: start-in-center   roomw @ 1p 2 / roomh @ 1p startpos 2! ;
: @layout   roomname count load-layout roomname find 0= abort" Layout's name doesn't match its file's name" layout ! ;
: l5room    %l5room room: roomdef define @layout start-in-center ;

3.0 1.0 l5room l5r1 l5r1layout
5.0 1.0 l5room l5r2 l5r2layout
7.0 1.0 l5room l5r3 l5r3layout

1.0 1.0 %l5room room: l5end 
   start: complete-level ;



\ ==================================================================================================
\ Map

1 4 5 level: level5
   l5end ,
   l5r3 ,
   l5r2 ,
   l5r1 ,
   0 3 startloc 2!
