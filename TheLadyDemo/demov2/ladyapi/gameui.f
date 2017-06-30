
: follow-focus
   focus -exit
   \ just horizontal movement
   level> if
      focus >x @ camofs @ + bounds >x1 @ bounds >width @ vres @ 1p - clamp cam >x !
   else
      0 cam >x !
   then
;

: control  dup to player  to focus  follow-focus ;


: ?draw-hitboxes
   show-hitboxes @ -exit  0 colorfx   [[ draw-hitbox ]] all ;

: debug-controls
   shift? if stage:sim then
   <h> kpressed if show-hitboxes toggle then
   <up> kpressed ctrl? and if north then
   <down> kpressed ctrl? and if south then
   <left> kpressed ctrl? and if west then
   <right> kpressed ctrl? and if east then
   <r> kpressed ctrl? and if .room then
   <l> kpressed ctrl? and if .level then
   <f> kpressed ctrl? and if altflip toggle then
   <f5> kpressed if reload-level then
   <f5> kpressed shift? and if reload-level-restart then
;

: goto-stage
   [[
      [[
         follow-focus
         stage:sim
\      scripts-sim
         utils @ if debug-controls then
         follow-focus
         room-step
         level-step ]] exectime simtime !
   ]] is sim
   [[
      [[ displaywh set-viewport
         stage:render
         ?draw-hitboxes ]] exectime rendertime !
   ]] is render
;

goto-stage
