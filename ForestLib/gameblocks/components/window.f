\ ==============================================================================
\ ForestLib > GameBlocks > Allegro5 I/O
\ Graphics window
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/23/13

0 value display
0 value eventq
0 value displaytimer

0 value default-font
variable (rgba) \ temporary variable

: gotowin   dup 1 ShowWindow drop dup BringWindowToTop drop  SetForegroundWindow drop ;

\ these ensure that allegro's internal keyboard and mouse states are reset.
: /kb    ; \ al_uninstall_keyboard al_install_keyboard drop ;
: /mouse ; \ al_uninstall_mouse al_install_mouse drop ;


variable (timer)  \ nesting

: +timer   (timer) ++ displaytimer al_start_timer ;
: -timer   (timer) -- (timer) @ 0 = if displaytimer al_stop_timer then ;

: >gfx     ( -- ) /kb /mouse  display al_get_win_window_handle  gotowin   ;
: >ide     ( -- ) HWND gotowin   ;

create res  640 , 480 ,

variable fps  60 fps !

\ general allegro
: (init-allegro)
   al_init not if " INIT-ALLEGRO: Couldn't initialize Allegro." alert -1 abort then
   al_init_image_addon not if " Allegro: Couldn't initialize image addon." alert -1 abort then
   al_init_primitives_addon not if " Allegro: Couldn't initialize primitives addon." alert -1 abort then
   al_init_font_addon not if " Allegro: Couldn't initialize font addon." alert -1 abort then
   al_install_mouse not if " Allegro: Couldn't initialize mouse." alert -1 abort then
   al_install_keyboard not if " Allegro: Couldn't initialize keyboard." alert -1 abort then
   al_install_joystick not if " Allegro: Couldn't initialize joystick." alert -1 abort then
   
   ALLEGRO_VSYNC 1 ALLEGRO_SUGGEST al_set_new_display_option
   res 2@ al_create_display to display
   
   al_create_builtin_font to default-font
         
   \ initialize timer and event queue
   al_create_event_queue to eventq
   1e fps @ s>f f/ al_create_timer to displaytimer
   
   \ attach event sources
   eventq displaytimer al_get_timer_event_source al_register_event_source
   eventq display al_get_display_event_source al_register_event_source
   eventq al_get_mouse_event_source al_register_event_source
   eventq al_get_keyboard_event_source al_register_event_source
   eventq al_get_joystick_event_source al_register_event_source
   
   report" Allegro window and subsystems initialized"
   
   >ide
   
;


\ selecting 3.0 fixes the fullscreen switching bug that once hounded me.
ALLEGRO_OPENGL_3_0 constant common-allegro-flags


: init-allegro
   common-allegro-flags
   ALLEGRO_WINDOWED or
   ALLEGRO_RESIZABLE or
   al_set_new_display_flags   (init-allegro) ;


: init-allegro-fullscreen
   common-allegro-flags
   ALLEGRO_FULLSCREEN_WINDOW or
   al_set_new_display_flags   (init-allegro)
   ;

: show-frame     al_flip_display ; \ al_wait_for_vsync ;

: close-allegro
   display -exit
   displaytimer al_destroy_timer
   eventq al_destroy_event_queue
   display al_destroy_display
   al_uninstall_system
   0 to display ;

:onexit close-allegro ;

0 40 al_set_new_window_position
