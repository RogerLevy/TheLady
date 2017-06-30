scmlanimator open-package
public

\ direction
0 constant up
1 constant down
2 constant left
3 constant right

defer actor:draw   ' noop is actor:draw


%stageobj ~> %actor

   %scmlanimator inline: scmlanm

   var lx   \ local position
   var ly

   var editable

   right var: direction
   1.0 var: speed

   var script1
   var script2

   var excitation

   var shooter   \ for remembering the originator of a projectile
   var invuln    \ invulnerability counter
   var flipfix   \ compensation
   \ ----------------------
   10 var: atk
   \ ----------------------
   var timer
   var lifetime
   \ ----------------------
   ' noop >code var: 'act
   ' noop var: 'post
   \ ----------------------
   1 var: tempdepth
   8 cells field tempdata
   \ ----------------------
   \ Vtable stuff
   create actorvt-root 100 vtable,
   actorvt-root var: actorvt
   [[ @ actorvt @ ]] actorvt-root set-vtable-fetcher
   fload actor-actions
   : actor:begetting  ( class - class )
      prototype >actorvt @ vbeget prototype >actorvt !  \ derive vtable from parent
      dup prototype >enttype !
      prototype { autoprio }
   ;
   ' actor:begetting begetting

   : actor:define    dspt s!  actorvt @ to vt ;
   [[ displayobject-fields  prototype be  actor:define ]] fields

   \ Scripting stuff
   : (act)  code> 'act ! 0 timer ! ;
   : act    r> (act)  ;   \ i think this should only be used within PERFORM scripts, if at all.

0 value whom   \ who (what actor) is calling ACTOR:STEP at the moment.
0 value osp

   : perform  ( n )
      >r
      whom me = if
         osp sp! r>
      else
         1 tempdepth ! r> tempdata !
      then
      0 timer !   r> code> 'act ! ;

   : post   r> code> 'post ! ;
   : post/  ['] noop 'post ! ; aka post/ -post
   : (after) r> swap fps @ p* timer @ <= if 0 timer ! (act) else drop then ;
   : after   ?ps r> swap fps @ p* timer @ <= if 0 timer ! (act) else drop then ;
   : frames   [ 1.0 fps @ / ]# * ;

   : when   r> swap if (act) else drop then ;

   : durr   perform noop ;
   : nod    post/ 0 perform noop ;
   : stop   0 vel 2!  nod ;
   : end    en @ -exit   me delete nod ;

   : every  lifetime @ 1 + swap mod 0= ;

   \ DELAY relies on stack preservation...
   : delay ( secs. -- ) ?dup -exit ?ps r> swap act dup (after) drop (act) ;
   : pauses   ?dup -exit [ 1.0 fps @ / ]# * ?ps r> swap act dup (after) drop (act) ;


\ Up to 8 items can be left on the stack when an actor's behavior returns.
\ They will be restored on the next frame.

   : ?sprange
      dup -1 9 within not  if report" WARNING: Actor's local stack exceeded. " .name then
      \ dup 8 > if .s true abort" Actor local stack exceeded." then
      8 min 0 max ;

   : actor:step
      whom >r
      me to whom

      a@ >r
      sp@ to osp

      sp@ tempdepth @ cells - sp!
      sp@ tempdata swap tempdepth @ imove


         dspt s! 'act @ execute


      osp sp@ cell+ - cell/ ?sprange tempdepth !

      sp@ tempdata tempdepth @ imove

      osp sp!
      r> a!

      r> to whom
      ;

   : actor:post     dspt s!   vx 2@  px 2+!    'post @ execute   timer ++  lifetime ++   invuln @ if invuln -- then ;


   be-prototype

      ' actor:step onstep !
      ' actor:post onpost !
      ' actor:draw ondraw !
      [[ act ]] execute
      1.0 z !

   : behavior:     :noname oninit ! ;
   : ondelete:     :noname ondelete ! ;

endp


\ ------------------------------------------------------------------------------------------
\ Parenting

\ Temporary!!!

\ for now, NO provisions for nested local transformations are made.
\ right now it's just a way of intuitively altering stacking order

variable nestlevel

%actor reopen
   var children
   var parent

   : ?drawchildren  children @ ?dup if nestlevel ++ [[ @ { ?draw } ]] swap each nestlevel -- then ;

   : ?nodraw   parent @ 0<> nestlevel @ 0= and vis @ 0= or ;

   : actor:?childdraw
      ?nodraw  ?exit
      actor:draw   ?drawchildren  ;

   be-prototype
      ' actor:?childdraw ondraw !

   \ another form of parenting ... just a way to have multiple objects have access to the same central "knowledge"
   var owner
   \ master calls these
   : oneslave  ( prototype -- actor ) one me over >owner ! ;

endp

: addto  ( child parent ) 2dup >children @ push swap >parent ! ;

end-package

: excite  ( actor -- ) { excitation ++ excited } ;


\ ------------------------------------------------------------------------------------------
\ dynamic scripts

%actor ~> %script
   vis off
endp

: parallel  ( value xt -- )  \ can pass a single value to the dynamic script
   me %script one { owner ! swap tempdata ! 1 tempdepth ! 'act ! } ;

: setoff ( ... xt prototype -- ) \ more flexible, need to execute PERFORM inside
   me swap one { owner ! execute } ;

: setoff{
   me swap one { owner ! execute ; \ }


\ Misc


: myview     ( -- xywh ) cam 2@ z @ dup 2p* vres 2@ 2p ;
