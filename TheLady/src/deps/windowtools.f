create windowtitle 256 allot

: !windowtitle   display windowtitle count z$ al_set_window_title ;
: titlebar  windowtitle place !windowtitle ;
" Dev" titlebar

: init-events
   eventq al_get_mouse_event_source al_register_event_source
   eventq al_get_keyboard_event_source al_register_event_source
   eventq al_get_joystick_event_source al_register_event_source
   eventq display al_get_display_event_source al_register_event_source

   ;

: init-other-stuff   !windowtitle   init-input   init-generic-input   init-sound   init-events ;

: init-game-window   init-allegro   init-other-stuff ;
: init-game-fullscreen   init-allegro-fullscreen   init-other-stuff ;
