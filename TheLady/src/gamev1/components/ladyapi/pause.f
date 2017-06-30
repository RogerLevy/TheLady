
: resumegame 
   resume-sounds
   \ kbstate /ALLEGRO_KEYBOARD_STATE erase
   goto-ladystage
;

[[ resumegame ]] menuopt pause-play data/pause/Return to Game.png
[[ ( ?bye ) 0 ExitProcess ]] menuopt pause-quit data/pause/Pause Quit Game.png

here cell [array pause-play , pause-quit , array] menu pausemenu 

pausemenu {
   1024.0 x !
   400.0 y !
}

: pausegame
   pause-sounds
   pausemenu restart
   [[
      <esc> kpressed if resumegame exit then
      pausemenu { step }
   ]] is sim
   [[
      stage:render
      FX_MULTIPLY colorfx
      -2e -2e vres 2@ 4 4 2+ 2s>f   0.5e 0.5e 0.5e 1e al_draw_filled_rectangle
      pausemenu {
         \ 400.0 y !
         vh 2 / 200 - 1p y !
         draw }
   ]] is render
   ;

: ?pause   can-pause @ -exit dev? if <p> else <escape> then kpressed if pausegame then ;
