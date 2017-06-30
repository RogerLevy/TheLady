\ module ~stage

\ this version doesn't use a "free list" instead using roundrobin allocation, which
\  is better the stability of the engine when things are deleted and
\  then immediately instatiated, or referenced ... though, it's kind of an easy band-aid

create entities     max-entities /entslot array,
create sortlist     max-entities cell array,
create everything   max-entities stack,   [[ everything push ]] entities each
create deletions    max-entities stack,
variable #actives
variable nextent  \ offset

: stageobj:delete     #actives -- ;
: stageobj:instance
   #actives @ max-entities = abort" Error in STAGEOBJ:INSTANCE : Entity pool exhausted."

   begin
      nextent @ entities >items + dup >active @ while
      drop    nextent @ /entslot + [ max-entities /entslot * 1 - ]# and nextent !
   repeat
   #actives ++
;

%entity ~> %stageobj
   prototype be
   ' stageobj:delete (delete) !
   [[ stageobj:instance dup >r init-entity r> ]] (instance) !
endp



\ --------------------------------------------------------------------------------
\ scripting words


: one  ( prototype -- entity )
   dup >proto @ >(instance) @ execute ;


: all ( xt -- )
   me >r struct >r
   entities >items be
   entities length 0 do
      active @ ( en @ and ) if dup >r execute r> then
      /entslot +to me
   loop
   drop
   r> s! r> be ;

\ "each and every object" ... dumb name
: eaeo ( xt -- )
   me >r struct >r
   entities >items be
   entities length 0 do
      active @ if dup >r execute r> then
      /entslot +to me
   loop
   drop
   r> s! r> be ;



: actual-delete
   be>  active @ -exit   ( deleted @ -exit )  ondelete @ execute   (delete) @ execute   active off   en off  deleted off ;

: stage:deletions
   [[ @ actual-delete ]] deletions each   deletions vacate ;

: delete   ( entity )
   ?dup -exit   be>  deleted @ ?exit   deleted on   me deletions push
   deletions length max-entities = if stage:deletions then ;

\ : delete
\    be>  active @ -exit   ondelete @ execute   (delete) @ execute   en off  active off  ;

: clear-stage
   [[ me delete ]] all  0 nextpri ! ;

: copy   locals| a2 a1 |
   0 a1 [] 0 a2 [] a1 length a1 >itemsize @ * a2 length a2 >itemsize @ * min cell/ imove ;

\ --------------------------------------------------------------------------------
\ Processing stage entities

: ?post   en @ if  onpost @ execute  then ;

: stage:sim
   me
      [[ be ?step ]] entities each
      process-tweens
      stage:deletions
      [[ be ?post ]] entities each
      stage:deletions
   be ;

: priority-sort   ( addr len )
   [[ >priority @ swap >priority @ > ]] cellsort ;

variable backdrop

: stage:render
   me
      GL_GREATER 0e glAlphaFunc
      GL_ALPHA_TEST glEnable
      everything sortlist copy
      0 sortlist []  max-entities  priority-sort
      [[ @ be ?draw ]] sortlist each
   be ;

: goto-stage
   ['] stage:sim is sim
   [[ 0 cls stage:render ]] is render
   ;

goto-stage

: .cast   [[ cr .name ]] all ;

