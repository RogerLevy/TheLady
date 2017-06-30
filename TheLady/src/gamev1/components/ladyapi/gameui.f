
\ COMPLETE / NEXTUP
\ Simple way for different "parts" of the game to signal to proceed to the next part
\ without having to be coupled to each other

variable 'complete  ' noop 'complete !
variable completed
: ?complete  completed @ dup if completed off 'complete @  ['] noop 'complete ! execute then ;
: complete   completed on report" Segment completed." ;
: nextup     'complete ! completed off ;


\ misc stuff to do end of frame that we can't do within entity scripts
create misc 10 stack,
: btw   misc push ;
: do-misc   [[ dup @ swap off execute ]] misc each misc vacate ;



: camx!   bounds >x1 @ bounds >x2 @ vres @ 1p - clamp cam >x ! ;

: follow-focus
   focus -exit
   \ just horizontal movement
   level> if
      focus >x @ camofs @ + camx!
   else
      0 cam >x !
   then
;

: control  dup to player  to focus  follow-focus ;


[[
   shift? if stage:sim then
   <h> kpressed if show-hitboxes toggle then
   <up> kpressed ctrl? and if north then
   <down> kpressed ctrl? and if south then
   <left> kpressed ctrl? and if west then
   <right> kpressed ctrl? and if east then
   <r> kpressed ctrl? and if .room then
   <l> kpressed ctrl? and if .level then
\   <f> kpressed ctrl? and if altflip toggle then
   \ <f5> kpressed if reload-level then
   <f5> kpressed if reload-level-restart then
   <e> kpressed if toggle-el then
   <1> kpressed ctrl? and if 1 loadlevel then
   <2> kpressed ctrl? and if 2 loadlevel then
   <3> kpressed ctrl? and if 3 loadlevel then
   <4> kpressed ctrl? and if 4 loadlevel then
   <5> kpressed ctrl? and if 5 loadlevel then
   <0> kpressed ctrl? and if 0 loadlevel then
   <6> kpressed ctrl? and if 6 loadlevel then
   <i> kpressed if invincibility toggle then
   <u> kpressed if picked update then
]] is debug-controls


[[ 
   [[
      ?complete drop
      follow-focus
      stage:sim
      dev? if debug-controls then
      follow-focus
      room-step
      level-step
      do-misc
   ]] is sim
   [[
      clear-viewport
      0 cls \ for the letterbox
      update-viewport
      \ backdrop @ cls
      stage:render
      ?draw-hitboxes 
   ]] is render
]] is goto-ladystage

goto-ladystage
