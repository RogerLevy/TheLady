\ 12/12/13
\ relies on:
\  #levels



10 ?constant #levels  \ default is 10...

create levels #levels stack,

0 value inhabitant

0 value roomdef    \ when non-zero, this is the implied room, used instead of indirect indexing into the current level.

0 value prevroom

\ -----------------------------------------------------------------------------------------------------------

\ structure that defines current level, current room, and potentially other settings.
\   intended for switching between characters if needed.
pstruct %inhabitant
   [[ [[ create over , + does> @ inhabitant + ]] is create-ifield ]] fields
   var level  \ current level # - can be set freely, it's automatically constrained
   var room   \ current room # - can be set freely, it's automatically constrained
endp

\ -----------------------------------------------------------------------------------------------------------

create default-inhabitant %inhabitant instance,

    default-inhabitant to inhabitant


\ ability to target random rooms from different levels
: (m->).1   room @ >o room !  level @ >o level ! ;
: (m->).2   o> level ! o> room !  ;
: m->  ( level# room# -- )
   state @ if postpone (m->).1 bl parse evaluate postpone (m->).2
   else struct >o to struct bl parse evaluate o> to struct then
   ; immediate

\ -----------------------------------------------------------------------------------------------------------

: level>
   level @ 0 #levels 1 - clamp dup level ! levels [] @ ;   \ address of current level

pstruct %level
   [[ [[ create over , + does> @ level> + ]] is create-ifield ]] fields
   var levelw
   var levelh
   var levelid
   256 field levelpath
   2 cells field startloc
   /array field rooms

   %actor inline: levelent

   [[
      [[ create over , + does> @ level> + ]] is create-ifield
      prototype to roomdef prototype >levelent be
   ]] fields

endp

\ -----------------------------------------------------------------------------------------------------------

: room>
    roomdef ?dup ?exit
    room @ 0 rooms dup >r length 1 - clamp dup room ! r> [] @ ;   \ address of current room

pstruct %room
   [[ [[ create over , + does> @ room> + ]] is create-ifield ]] fields

   64 field roomname
   var roomw                \ int
   var roomh
   mark: startpos view 0.5 1.0 around 2^
   %actor  inline: rooment  \ entity that defines entrance, exit, onframe, rendering...
                            \ don't even THINK about making this a reference, or a superclass of %room.
                            \ the former is dangerous and the latter won't work!

   \ make the room entity be the current entity when we derive from this prototype.  (this is perfectly legal!)
   [[
      [[ create over , + does> @ room> + ]] is create-ifield
      prototype >rooment be
   ]] fields

endp

\ -----------------------------------------------------------------------------------------------------------

defer onroomswitch   ' noop is onroomswitch
defer onlevelload    ' noop is onlevelload

: location   room @ levelw @ /mod ;

: .room  report" Room: ( " location swap . ." , " . ." ) " roomname count type ;
: .level report" Level: #" level ?
         " locate " <$ level> body> >CODE C>NAME count $+ $> evaluate ;


: clean   [[ stays @ not if me actual-delete then ]] all  0 nextpri ! ;

: inhabit   to inhabitant ;

: room!   room @ to prevroom room ! ;

: atroom    ( col row ) levelw @ * + room! ;

: init-room   clean  rooment be> .room onroomswitch rooment >oninit @ execute ;
: loadroom ( n -- )   room! init-room  ;
: goto   ( col row -- ) atroom  init-room ;
: +room  ( n -- )  room @ + room! room> drop ( bounds-checks room ) init-room ;

: warp   ( level col row -- ) rot level ! goto ;
: loadlevel ( n -- )  level !  onlevelload  levelent >oninit @ execute  startloc 2@ goto ;
: reloadroom   room @ loadroom  ;


: north ( -- ) levelw @ negate +room ;
: south ( -- ) levelw @        +room ;
: east ( -- ) 1 +room ;
: west ( -- ) -1 +room ;

: ne ( -- ) levelw @ negate 1 + +room ;
: nw ( -- ) levelw @ negate 1 - +room ;
: se ( -- ) levelw @        1 + +room ;
: sw ( -- ) levelw @        1 - +room ;

\ -----------------------------------------------------------------------------------------------------------
\ level and room definition

: level:   ( w h id -- <name> )
   create   dup level !    0 to roomdef
   %level instantiate over levels [] !
   levelent be
   ( id ) levelid !
   ( w h ) 2dup levelw 2!
   including levelpath place
      * cell rooms init-array ;

: define  ( room -- )
   to roomdef rooment be ;

: room:   ( w. h. prototype -- <name> )   \ width and height given in screen units
   create instantiate define
   vres 2@ 2p* roomw 2!
   namespec dup if roomname place else 2drop then ;


: starting-location   startloc 2! ;


: roombox   0 0 roomw 2@ 2p ;
: #screens  roomw @ vw / ;

: backtrack   prevroom loadroom ;

\ -----------------------------------------------------------------------------------------------------------
\ Sandbox

2.0 1.0 %room room: sandboxroom

1 1 0 level: sandboxlevel
   sandboxroom ,

sandboxroom constant ----
 

: testroom    ( room -- ) 0 level ! 0 rooms [] ! 0 0 goto ;
: sandbox   sandboxroom testroom ;

sandbox
