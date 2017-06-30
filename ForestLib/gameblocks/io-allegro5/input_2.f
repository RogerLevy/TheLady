\ ==============================================================================
\ ForestLib > GameBlocks [2] > Allegro5 I/O [2]
\ Keyboard, mouse, and joystick polling and state [2]
\ ========================= copyright 2014 Roger Levy ==========================


16 constant MAX_JOYSTICKS
create joyhandles MAX_JOYSTICKS stack,

: init-input
  al_get_num_joysticks 0 ?do i al_get_joystick joyhandles push loop ;


\ mouse 4/25/13
create mouse-state /ALLEGRO_MOUSE_STATE /allot
create mickey-state /ALLEGRO_MOUSE_STATE /allot
: mouse   mouse-state 2@ ;
: mickey  mickey-state 2@ ;
: mdelta  mouse mickey 2- ;
: poll-mouse
   mouse-state dup mickey-state /ALLEGRO_MOUSE_STATE move al_get_mouse_state ;
: mstate   mouse-state swap al_mouse_button_down  0<> ;
: mlast    mickey-state swap al_mouse_button_down 0<> ;
: mbdelta  >r   r@ mlast   r> mstate  - ;
: mpressed    mbdelta 1 = ;
: mreleased   mbdelta -1 = ;


\ joystick 4/27/13
\  currently doesn't handle connecting/disconnecting devices in-game, but Allegro 5 /does/ support this (via an event)
create joysticks 16 /ALLEGRO_JOYSTICK_STATE array,

: joy ( joy# stick# -- vector ) /ALLEGRO_JOYSTICK_STATE_STICK * swap joysticks [] .ALLEGRO_JOYSTICK_STATE-sticks + ;
: joybtn ( joy# button# -- 0-32767 ) cells swap joysticks [] .ALLEGRO_JOYSTICK_STATE-buttons + @ ;

: a@f>p+   a@ sf@ f>p !+ ;

: poll-joysticks
  a@
  al_get_num_joysticks 0 ?do
    i joyhandles [] @ i joysticks [] al_get_joystick_state
    _AL_MAX_JOYSTICK_STICKS 0 do j i joy a! a@f>p+ a@f>p+ a@f>p+ loop
  loop
  a! ;


\ keyboard 4/27/13
create kbstate /ALLEGRO_KEYBOARD_STATE /allot
create kblast /ALLEGRO_KEYBOARD_STATE /allot

: poll-keyboard
  kbstate kblast /ALLEGRO_KEYBOARD_STATE move
  kbstate al_get_keyboard_state ;

: bit?  ( bit val -- flag )  swap 1 swap << and 0<> ;
: set?   ( bit addr -- flag )  cell+ >r 32 /mod cells r> + @ bit? ;

: klast   kblast set? ;
: kstate   kbstate set? ;
: kdelta  >r   r@ klast   r> kstate  - ;
: kpressed    kdelta 1 = ;
: kreleased   kdelta -1 = ;

: alt?    <alt> kstate <altgr> kstate or ;
: ctrl?   <lctrl> kstate <rctrl> kstate or ;
: shift?  <lshift> kstate <rshift> kstate or ;


1 constant lb
2 constant rb
3 constant mb
