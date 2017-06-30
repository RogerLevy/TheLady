0 value display
0 value eventq
0 value displaytimer
create e 256 allot
create res 100 , 100 ,
variable fps  60 fps !

ALLEGRO_WINDOWED 
ALLEGRO_RESIZABLE or
al_set_new_display_flags

: init
al_init not if " INIT-ALLEGRO: Couldn't initialize Allegro." alert -1 abort then
al_init_image_addon not if " Allegro: Couldn't initialize image addon." alert -1 abort then
al_init_primitives_addon not if " Allegro: Couldn't initialize primitives addon." alert -1 abort then
al_init_font_addon not if " Allegro: Couldn't initialize font addon." alert -1 abort then
al_install_mouse not if " Allegro: Couldn't initialize mouse." alert -1 abort then
al_install_keyboard not if " Allegro: Couldn't initialize keyboard." alert -1 abort then
al_install_joystick not if " Allegro: Couldn't initialize joystick." alert -1 abort then
; init

ALLEGRO_VSYNC 1 ALLEGRO_SUGGEST al_set_new_display_option
res 2@ al_create_display to display

al_create_event_queue to eventq

\ eventq displaytimer al_get_timer_event_source al_register_event_source
eventq display al_get_display_event_source al_register_event_source
eventq al_get_mouse_event_source al_register_event_source
eventq al_get_keyboard_event_source al_register_event_source
eventq al_get_joystick_event_source al_register_event_source

1e fps @ s>f f/ al_create_timer to displaytimer
eventq displaytimer al_get_timer_event_source al_register_event_source
displaytimer al_start_timer 

: etype   e @ ;

: process-event
   etype ALLEGRO_EVENT_TIMER <> if e 100 idump then ;   

: event-pump
   eventq e al_wait_for_event process-event ;

: ok
   begin event-pump pause again ;

   
ok