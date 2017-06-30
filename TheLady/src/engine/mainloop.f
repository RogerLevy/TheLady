\ --------------------------------------------------------------------------------
\ main loop

variable rendertime
variable simtime
defer dev?
defer ok
0e fvalue framedelta   \ time of last frame in seconds
1e 60e f/ fvalue 60hz
variable gameage


: (render)   ['] render exectime rendertime ! ;
: (sim)      ['] sim exectime simtime ! ;

: poll   poll-mouse poll-joysticks poll-keyboard ; \ poll-generic-inputs ;

: fs?   display al_get_display_flags ALLEGRO_FULLSCREEN_WINDOW and 0<> ;

: displaywh   display al_get_display_width display al_get_display_height ;

: w/f
   display ALLEGRO_FULLSCREEN_WINDOW fs? if 0 else 1 then al_toggle_display_flag
      0= abort" could not switch to fullscreen"
;
   
: ?w/f   <enter> kpressed alt? and if w/f then ;

: ?f
   <f> kpressed -exit
   display al_get_display_flags ALLEGRO_NOFRAME and 0<> not
   display ALLEGRO_NOFRAME rot al_toggle_display_flag drop
   display 0 0 al_set_window_position
   ;


\ : frame   [[ poll sim render frames ++ ]] exectime drop
\    16.66666e fto framedelta ; \ dup . s>f 0.001e f*   fto framedelta ;

16.66666e fto framedelta

\ : frame(s)   frame show-frame update-sounds ?w/f ?f ;

variable allowinput allowinput on

: ?pause   dev? -exit pause ;
: ?poll  allowinput @ if poll ?w/f then ;
: tick   gameage ++ ?pause ?poll (sim) ;


create e 256 allot

variable needredraw
variable editor



: get-loop   ['] sim >body @    ['] render >body @ ;
: set-loop   is render is sim ;


: frame(s)
   eventq e al_wait_for_event
   editor @ if
      e @ ALLEGRO_EVENT_DISPLAY_CLOSE = if bye then
      e @ ALLEGRO_EVENT_TIMER <> if
         \ update on any other event besides the timer
         (sim) (render) show-frame
      else
         ?poll update-sounds
      then
   else
      e @ case
         ALLEGRO_EVENT_TIMER of tick needredraw ++ update-sounds endof
      endcase
      needredraw @ if
         eventq al_is_event_queue_empty needredraw @ 4 >= or if   
            (render) show-frame needredraw off
         then
      then
   then
   
   e @ ALLEGRO_EVENT_DISPLAY_RESIZE = if
      display al_acknowledge_resize
      e >ALLEGRO_DISPLAY_EVENT-width 2@ res 2!
   then
   
   e @ ALLEGRO_EVENT_DISPLAY_CLOSE = if
      0 ExitProcess
   then
;

: gofor   +timer gameage @ + >r begin frame(s) gameage @ r@ >= until r> drop -timer ;

: interlude   ( simxt renderxt frames )
   -rot get-loop 2>r set-loop gofor 2r> set-loop ;


variable running

\ this is the main loop
: dev-ok
   poll-keyboard \ important to fix escape key bug
   \ [[
      running on
      >gfx +timer begin   
         .stack frame(s) <escape> kreleased
      until
   \ ]] catch
         -timer >ide
         running off
         ;
         \ throw ;

[[ ['] ok >body @ ['] dev-ok = ]] is dev?


\ this is for the runtime - different exit key combo (alt-f4)
: release-ok
   poll-keyboard \ important to fix escape key bug
   [[
      running on
      >gfx +timer begin
         frame(s) <f4> kpressed alt? and
      until
   ]] catch      -timer >ide running off    throw ;

' dev-ok is ok


: ?ok  running @ ?exit ok ;

: ?bye    dev? not if 0 ExitProcess else -timer -1 abort" Intentional program termination." then ;
