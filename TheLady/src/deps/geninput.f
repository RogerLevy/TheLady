
\ wordset for setting up generic inputs ... i.e. "action", "cancel", "up"...
\ you set up "mappings" which tell the event handler where to route various inputs to in your struct.
\ mapping cells contain indexes that map to vars in a state struct.
\ additionally, because different joysticks should be distinguished, and the keyboard and the mouse could
\  potentially be used as their own "joysticks" the mapping counts each input device separately (including joysticks)
\  this way, you can set up an array of structs and the devices can route to each struct individually, 
\   or you could combine any number of devices and they would control the same state struct.
\ you can also setup generic input event handlers, which is important for making sure that no event is missed.


\ for now, keepin' it basic.  but later it will get more sophisticated.
\  ability to have more than one concurrent mapping and copy/erase them easily
\  mapping thumbsticks and the mouse's movement 
\  ability to map joysticks separately - for now, treat them all the same.

\ mapping sources currently supported:
\  keys
\  joystick buttons
\  mouse buttons


\ mapping struct
\  each source is a button or a key, and the routing destination is an address to an input-event state


\ input state/event struct
\  value
\  device
\  delta  ( for detecting if pressed, released, increased, decreased... )
\  timestamp
\  callback  ( struct -> statestruct )

plugin exposed

pstruct %input-mapping
   256 cells field keymap
   _AL_MAX_JOYSTICK_BUTTONS cells 16 * field joymap
   32 cells field mousemap
endp

create mapping   %input-mapping instance, 


\ devices
0
enum dvc-joystick
enum dvc-keyboard
enum dvc-mouse
drop

pstruct %input-event
   var val   var device   var trigger#   var delta   dvar timestamp   noop: callback   
endp

0 value giq

protected
create event   256 allot
exposed


: init-generic-input
   al_create_event_queue to giq 
   giq al_get_mouse_event_source al_register_event_source
   giq al_get_keyboard_event_source al_register_event_source
   giq al_get_joystick_event_source al_register_event_source ;

\ for each event type,
\  determine value, device, delta, and timestamp
\  from device, find offset into mapping
\  if joystick, also add to offset based on joystick # - 
\   unfortunately this involves searching the joyhandles stack to find the index.

: type>   event >ALLEGRO_EVENT_TYPE-type @ ;


create deltas   
   0 , 0 , 1 , -1 , 0 , 0 , 0 , 0 , 0 , 0 ,
   1 , 0 , -1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
   0 , 1 , -1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,

: delta>   type> cells deltas + @ ;


\ #define   ALLEGRO_EVENT_JOYSTICK_AXIS                 1
\ #define   ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN          2
\ #define   ALLEGRO_EVENT_JOYSTICK_BUTTON_UP            3
\ #define   ALLEGRO_EVENT_JOYSTICK_CONFIGURATION        4
\ #define   ALLEGRO_EVENT_KEY_DOWN                     10
\ #define   ALLEGRO_EVENT_KEY_CHAR                     11
\ #define   ALLEGRO_EVENT_KEY_UP                       12
\ #define   ALLEGRO_EVENT_MOUSE_AXES                   20
\ #define   ALLEGRO_EVENT_MOUSE_BUTTON_DOWN            21
\ #define   ALLEGRO_EVENT_MOUSE_BUTTON_UP              22


create maplocs   0 >joymap , 0 >keymap , 0 >mousemap ,

: joyindex>  ( -- n )
   -1 0 event >ALLEGRO_JOYSTICK_EVENT-*id @ locals| needle index found |
   [[ @ needle = if index to found then 1 +to index ]] joyhandles each found ;

: allegro-device-category   type> 10 / ;

: joystick?   allegro-device-category 0= ;

: th   cells + ;

: device>  ( -- device# ) \ see above
   allegro-device-category joystick? if joyindex> + then ;

: mapping>  ( -- addr )
   mapping maplocs allegro-device-category th @ + ;
   \ allegro-device-category joystick? if 
   \    joyindex> [ _AL_MAX_JOYSTICK_BUTTONS cells ]# * +
   \ then ;

: timestamp>  ( -- d )
   event >ALLEGRO_EVENT_TYPE-timestamp d@ ;

create mapping-offsets   0 >ALLEGRO_JOYSTICK_EVENT-button , 0 >ALLEGRO_KEYBOARD_EVENT-keycode , 0 >ALLEGRO_MOUSE_EVENT-button ,

: trigger> ( -- n ) mapping-offsets allegro-device-category th @ event + @ ; 

: retrigger   ( input-event -- ) => callback @ execute ;

0 value ievt

: trigger   ( device trigger# delta input-event -- )
   => dup val +! delta ! trigger# ! device ! struct to ievt callback @ execute ;
   
: filter
   type> >r 
   r@ ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN = 
   r@ ALLEGRO_EVENT_JOYSTICK_BUTTON_UP = or
   r@ ALLEGRO_EVENT_KEY_DOWN = or
   r@ ALLEGRO_EVENT_KEY_UP = or
   r@ ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = or
   r> ALLEGRO_EVENT_MOUSE_BUTTON_UP = or ;
   
: poll-generic-inputs
   giq al_is_event_queue_empty not if
      begin giq event al_get_next_event while
         filter if         
            mapping> trigger> th @  ?dup if 
               >r device> trigger> delta> r@ trigger
               timestamp> r> >timestamp d!
            then 
         then
      repeat
   then ;

\ defining the mapping - routines:
\  * create an input event aka "action", "cancel", "up", "down"
\  * assign trigger for mouse, keyboard, and all joysticks at once
\  * assign trigger for a specific device ( joystick = all joysticks )
\  * clear the mapping
\  * callback: check if pressed or released

: pressed   >delta @ 0 > ;   
: released  >delta @ 0 < ;
: pressed?  ievt pressed ;
: released? ievt released ;
: ival   >val @ ;

: unassign  ( input-event -- )
   ['] noop swap >callback ! ;

: assign   ( xt input-event -- )
   >callback ! ;

create input-events 256 stack,

: input-event:   ( -- <name> )
   here =>  %input-event instance,   :noname struct assign    struct input-events push ;

: map    ( input-event n addr ) swap th ! ;
: unmap  ( input-event n addr ) swap th off ;

: [key]     mapping ;
: [mouse]   mapping >mousemap ;   \ not for mouse buttons it starts at 1 (lb=1,rb=2,mb=3)
: [joy]     mapping >joymap ;

: 2map   ( input-event key joy -- )
   locals| joy key evt |
   evt key [key] map 
   evt joy [joy] map ;

: 3map   ( input-event key joy mouse -- )
   locals| mouse joy key evt |
   evt mouse [mouse] map 
   evt key [key] map 
   evt joy [joy] map ;
     
: clear-mapping   mapping [ %input-mapping sizeof ]# erase ;

