
defer render   ' noop is render
defer warmup   ' noop is warmup
defer autoexec ' noop is autoexec
defer sim      ' noop is sim
defer loader   [[ load-assets ]] is loader


\ extend prompt to update the display when enter is pressed (for testing graphics)
' prompt >body @ value (prompt)
:prune    ?prune if (prompt) is prompt report" Old Prompt restored" then ;

: green 7 attribute ;
: magenta 5 attribute ;

: (game-prompt)  .stack  state @ 0= if >gfx struct ['] render catch drop to struct show-frame >ide magenta ."  ok" normal then cr ;
: (gfx-prompt)  .stack  state @ 0= if >gfx show-frame >ide green ."  ok" normal then cr ;
: game-prompt  ['] (game-prompt) is prompt report" Set Game Prompt " ;
: gfx-prompt   ['] (gfx-prompt) is prompt  report" Set Graphics Prompt " ;
game-prompt 


: commandline  [[ 0 0 al_set_new_window_position   init-game-window ]] is warmup ;
: windowed     [[ init-game-window ]] is warmup ;
: fullscreen   [[ init-game-fullscreen   display al_hide_mouse_cursor ]] is warmup ;

[defined] program [if]

   : (program)   " program " 2swap strjoin evaluate ;

   \ : iconpath  zhome zcount " \ico\appicon.ico" strjoin ;

   : debug ( -- <optional-name> )
      ['] development 'main !
      [[ !home !root warmup load-assets autoexec   cr interactive ]] 'starter !
      0 parse ?dup 0= if drop including -ext -path then +root
         cr 2dup type (program) ;
      
   : deploy ( -- <optional-name> )   
      [[ !home !root warmup loader +timer autoexec   0 ExitProcess ]] 'main !
      0 parse ?dup 0= if drop including -ext -path then +root 
         cr 2dup type (program) ;

[then]



create autoexec$   256 allot

: test-script
   autoexec$ place
   [[ autoexec$ count $fload ]] is autoexec
   commandline   debug   ['] noop is autoexec ;
