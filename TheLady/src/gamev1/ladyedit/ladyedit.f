0 value ui
0 value added
0 value picked

   
create picks max-entities stack,

0 value dragging

: ?along
   dragging ?dup if
      { z @ p* x +! }
   else
      drop
   then ;

: drag  ( entity -- )
   dup to dragging dup to picked dup >enttype @ to added 
   perform
      dragging not if idle exit then
      mdelta 2p viewfactor @ dup 2p/   
         shift? if   drop 0  then 
         third >x 2+!
      lb mstate 0= if 0 to dragging idle then
;

: explain   { .name } ;

: pickobj
   picks vacate 
   -1 [[ ( vis @ ) me ui <> ( and editable @ and ) if me picks push then ]] collides
   picks length 0= if 0 exit then
   picks >items picks length priority-sort
   picks top@ ;
   
: ?drag   pickobj ?dup if drag then ;

: ?explain  pickobj ?dup if explain then ;

: scr>view   viewfactor @ dup 2p/ ;

: viewmouse  mouse 2p topoffset @ -  scr>view ;

: scrmouse   viewmouse   cam 2@ 2+ ;

%actor ~> %ui
   vis off
   hitbox: 0 0 0 0 ;
   :: idle
      0 perform
      scrmouse   put
      lb mpressed if ?drag then
      rb mpressed if ?explain then
   ;
   start:  idle ;
endp


create zpath 256 /allot

: save-as
   -timer
   256 zpath GetCurrentDirectory drop zpath  z" Save layout" z" *.f"
      ALLEGRO_FILECHOOSER_SAVE
      al_create_native_file_dialog
   0 over al_show_native_file_dialog if
      dup 0 al_get_native_file_dialog_path zcount layoutfile place
      save-room
   then
   drop
   +timer >gfx \ really important
;

: load   
   -timer
   256 zpath GetCurrentDirectory drop zpath z" Open layout" z" *.f;*.layout"
      ALLEGRO_FILECHOOSER_FILE_MUST_EXIST
      al_create_native_file_dialog
   0 over al_show_native_file_dialog if
      dup 0 al_get_native_file_dialog_path zcount layoutfile place
      layoutfile count load-layout
      0 to added   \ important to help not cross-polinate prototypes willy nilly
   then
   drop
   +timer >gfx \ really important
;

: add  dup to added one { me to picked   viewmouse z @ unscrolled put } ;
: addagain   added ?dup if add then ;

: layoutedit-controls
   <s> kpressed ctrl? and shift? and if save-as then
   <s> kpressed ctrl? and shift? not and if save-room then
   <space> kpressed if addagain then
   <a> kstate if -80.0 shift? if 4 * then dup ?along cam +! then
   <d> kstate if  80.0 shift? if 4 * then dup ?along cam +! then
   <o> kpressed ctrl? and if load then
   
   picked if 
      <f> kpressed if picked { flip @ 1 xor flip ! } then
      <delete> kpressed if picked delete 0 to picked 0 to dragging idle then
   then
;

create tempk /ALLEGRO_KEYBOARD_STATE /allot

: draw-bounds
   cam 2@ 2negate   roomw 2@ 2p   xyxy    2swap 2p>f 2p>f  0e 1e 0e 1e 1/viewfactor  al_draw_rectangle ;

: layout-ui
   pauseall 
   ui restart
   show-hitboxes on
   [[
      kbstate tempk /ALLEGRO_KEYBOARD_STATE move
      kbstate /ALLEGRO_KEYBOARD_STATE erase
      stage:sim 
      tempk kbstate /ALLEGRO_KEYBOARD_STATE move
      ui { ?step ?post }
      layoutedit-controls
      debug-controls
   ]] is sim
   [[
      stage:render
      ?draw-hitboxes
      picked ?dup if
         { hitbox>  xyxy   2swap   ofs 2p>f  ofs 2p>f  0e 1e 0e 1e 1/viewfactor  al_draw_rectangle }
      then
      draw-bounds
   ]] is render
;

create the-ui   %ui instance,   the-ui to ui

: -sounds   mixer 0e 1sf al_set_mixer_gain drop ;
: +sounds   mixer 1e 1sf al_set_mixer_gain drop ; 

variable editing

: el       editing on -sounds   %ui ui init-entity   layout-ui   ?ok ;
: resume   editing off +sounds   show-hitboxes off   goto-ladystage    ( /lady )  resumeall   ?ok ;
: toggle-el   editing @ if resume else el then ;