\ TODO:
\  distinguish between "allocated" and "active" ("on the stage")

module ~stage

create entities     max-entities /entslot array,

create sortlist     max-entities cell array,
create freelist     max-entities stack,   [[ freelist push ]] entities each
create everything   max-entities stack,   [[ everything push ]] entities each

create deletions    max-entities stack,



: stageobj:delete   me freelist push ;
: stageobj:instance freelist dup length 0= abort" Error in STAGEOBJ:INSTANCE : Entity pool exhausted." pop ;

%entity ~> %stageobj
   prototype be
   0 var: deleted
   ' stageobj:delete (delete) !
   ' stageobj:instance (instance) !
endp


\ --------------------------------------------------------------------------------
\ scripting words


: entity-instance
   >proto @ >(instance) @ execute ;

: one   ( prototype -- entity )
   dup entity-instance dup >r init-entity r> ;


: /every   ( array -- me=item ) >items be ;
: every/   ( -- ) ;
: +ent   /entslot +to me ;

: ALL ( xt -- )
   me >r struct >r
   entities /every
   entities length 0 do
      active @ deleted @ not and if dspt to struct dup >r execute r> then +ent
   loop
   every/ drop
   r> s! r> be ;


: actual-delete
   be>  active @ -exit   deleted @ -exit  ondelete @ execute   (delete) @ execute   active off   en off  deleted off ;

: stage:deletions
   [[ @ actual-delete ]] deletions each
   deletions vacate ;

: delete   ( entity )
   ?dup -exit   be>  deleted @ ?exit   deleted on   me deletions push
   deletions length max-entities = if stage:deletions then ;


: clear-stage
   [[ me actual-delete ]] all  0 nextpri ! ;

: copy   locals| a2 a1 |
   0 a1 [] 0 a2 [] a1 length a1 >itemsize @ * a2 length a2 >itemsize @ * min cell/ imove ;

\ --------------------------------------------------------------------------------
\ Processing stage entities

: ?post   en @ if onpost @ execute then ;


: stage:sim
   me
      [[ be ?step ]] entities each
      stage:deletions
      [[ be ?post ]] entities each
      stage:deletions
   be ;

: stage:render
   me
      stage:deletions
      0 cls
      GL_GREATER 0e glAlphaFunc
      GL_ALPHA_TEST glEnable
      everything sortlist copy
      0 sortlist []  max-entities  [[ >priority @ swap >priority @ > ]] cellsort
      [[ @ be ?draw ]] sortlist each
   be ;

: goto-stage
   ['] stage:sim is sim
   ['] stage:render is render
   ;

goto-stage
